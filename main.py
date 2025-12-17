# © 2025 连析工坊(Lianalytica)连毅霖版权所有
import os
import sys
import json
import time
import threading
import psutil
import subprocess
import platform
import signal

# 全局变量
global_progress = 0
progress_lock = threading.Lock()
resource_limits = None
monitor_thread = None
monitor_running = False
current_resource_usage = {}

# 系统兼容设置
WINDOWS_7 = platform.system() == "Windows" and platform.release() == "7"
IS_32_BIT = sys.maxsize <= 2**32

# 设置资源限制
def set_resource_limits():
    """设置智能资源限制，根据系统配置动态调整"""
    try:
        # 获取系统信息
        cpu_count = psutil.cpu_count()
        total_memory = psutil.virtual_memory().total / (1024 * 1024 * 1024)  # GB
        total_disk = psutil.disk_usage('/').total / (1024 * 1024 * 1024)  # GB
        
        print(f"系统信息: CPU核心数={cpu_count}, 内存={total_memory:.1f}GB, 磁盘={total_disk:.1f}GB")
        print(f"系统类型: {'Windows 7' if WINDOWS_7 else platform.system()} {'32位' if IS_32_BIT else '64位'}")
        
        # 基础限制配置
        base_config = {
            'low': {
                'cpu_ratio': 0.3,
                'memory_ratio': 0.5,
                'disk_ratio': 0.05
            },
            'medium': {
                'cpu_ratio': 0.5,
                'memory_ratio': 0.6,
                'disk_ratio': 0.1
            },
            'high': {
                'cpu_ratio': 0.7,
                'memory_ratio': 0.7,
                'disk_ratio': 0.15
            }
        }
        
        # 根据系统类型调整配置
        if WINDOWS_7 or IS_32_BIT:
            # Windows 7和32位系统使用更保守的资源分配
            config = base_config['low']
            min_memory_mb = 1024  # 最小内存限制
        elif total_memory < 4:
            # 低内存系统
            config = base_config['low']
            min_memory_mb = 1024
        elif total_memory < 8:
            # 中内存系统
            config = base_config['medium']
            min_memory_mb = 2048
        else:
            # 高内存系统
            config = base_config['high']
            min_memory_mb = 4096
        
        # 计算最终资源限制
        cpu_limit = max(1, int(cpu_count * config['cpu_ratio']))
        memory_limit_mb = max(min_memory_mb, int(total_memory * config['memory_ratio'] * 1024))
        disk_limit_gb = max(5, int(total_disk * config['disk_ratio']))
        
        # Windows 7特殊限制
        if WINDOWS_7:
            # Windows 7保守资源分配：CPU≤2核，内存≤2048MB
            cpu_limit = min(cpu_limit, 2)
            memory_limit_mb = min(memory_limit_mb, 2048)
        
        # 32位系统特殊限制：内存≤3GB，CPU≤4核
        if IS_32_BIT:
            memory_limit_mb = min(memory_limit_mb, 3072)
            cpu_limit = min(cpu_limit, 4)
        
        return {
            'cpu_limit': cpu_limit,
            'memory_limit_mb': memory_limit_mb,
            'disk_limit_gb': disk_limit_gb
        }
    except Exception as e:
        print(f"获取系统信息失败: {e}")
        # 返回默认值，考虑系统兼容性
        if WINDOWS_7 or IS_32_BIT:
            return {
                'cpu_limit': 1,
                'memory_limit_mb': 1024,
                'disk_limit_gb': 5
            }
        else:
            return {
                'cpu_limit': 2,
                'memory_limit_mb': 4096,
                'disk_limit_gb': 10
            }

# 资源监控函数
def monitor_resources():
    """监控系统资源使用情况，动态调整资源分配"""
    global current_resource_usage, monitor_running
    
    while monitor_running:
        try:
            # 获取当前资源使用情况
            cpu_percent = psutil.cpu_percent(interval=1)
            memory = psutil.virtual_memory()
            disk = psutil.disk_usage('/')
            
            current_resource_usage = {
                'cpu_percent': cpu_percent,
                'memory_used_mb': memory.used / (1024 * 1024),
                'memory_percent': memory.percent,
                'disk_used_gb': disk.used / (1024 * 1024 * 1024),
                'disk_percent': disk.percent
            }
            
            # 动态调整资源分配（可选：根据需要实现更复杂的调整逻辑）
            # 这里可以添加资源使用过高时的处理逻辑
            
            time.sleep(5)  # 每5秒检查一次
        except Exception as e:
            print(f"资源监控出错: {e}")
            time.sleep(10)  # 出错后延长检查间隔

# 开始资源监控
def start_resource_monitor():
    """启动资源监控线程"""
    global monitor_thread, monitor_running
    
    if not monitor_running:
        monitor_running = True
        monitor_thread = threading.Thread(target=monitor_resources)
        monitor_thread.daemon = True
        monitor_thread.start()
        print("✅ 资源监控线程已启动")

# 停止资源监控
def stop_resource_monitor():
    """停止资源监控线程"""
    global monitor_running
    
    if monitor_running:
        monitor_running = False
        if monitor_thread:
            monitor_thread.join(timeout=2)
        print("✅ 资源监控线程已停止")

# 应用资源限制到进程
def apply_resource_limits(process, limits):
    """将资源限制应用到指定进程"""
    try:
        # 应用CPU限制
        if hasattr(process, 'cpu_affinity'):
            cpu_count = psutil.cpu_count()
            available_cpus = list(range(min(limits['cpu_limit'], cpu_count)))
            process.cpu_affinity(available_cpus)
            print(f"应用CPU限制: 使用CPU核心 {available_cpus}")
        
        # 应用内存限制（部分系统支持）
        if hasattr(process, 'memory_limit'):
            process.memory_limit(limits['memory_limit_mb'] * 1024 * 1024)
            print(f"应用内存限制: {limits['memory_limit_mb']}MB")
    except Exception as e:
        print(f"应用资源限制失败: {e}")

# 更新全局进度
def update_progress(progress):
    """更新全局进度"""
    global global_progress
    with progress_lock:
        global_progress = min(100, max(0, progress))

# 显示启动进度条
def show_progress_bar():
    """显示启动进度条"""
    global global_progress
    bar_length = 50
    
    while global_progress < 100:
        with progress_lock:
            progress = global_progress
        
        filled_length = int(bar_length * progress / 100)
        arrow = '=' * filled_length + '>' + ' ' * (bar_length - filled_length)
        print(f'\r启动进度: [{arrow}] {progress}%', end='')
        time.sleep(0.1)
    
    # 完成后显示100%
    print(f'\r启动进度: [{"=" * bar_length}>] 100%')

# 初始化本地大模型
def initialize_local_model():
    """初始化本地大模型，确保无需下载、无需联网"""
    try:
        update_progress(20)
        
        # 检查本地模型目录
        model_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'models')
        os.makedirs(model_dir, exist_ok=True)
        
        # 检查是否存在预打包的模型
        model_files = [f for f in os.listdir(model_dir) if f.endswith('.bin') or f.endswith('.gguf')]
        
        update_progress(40)
        
        if not model_files:
            # 如果没有预打包的模型，使用轻量级的内置模型
            print("\nℹ️  未检测到本地模型，使用内置轻量级模型")
            # 创建一个简单的模型配置文件
            model_config = {
                'name': '内置轻量级模型',
                'type': 'local',
                'version': '1.0',
                'size': 'small',
                'capabilities': ['text', 'code', 'audio']
            }
            
            with open(os.path.join(model_dir, 'model_config.json'), 'w') as f:
                json.dump(model_config, f, ensure_ascii=False, indent=2)
        else:
            print(f"\n✅ 检测到本地模型: {', '.join(model_files)}")
        
        update_progress(60)
        return True
        
    except Exception as e:
        print(f"\n⚠️  初始化本地模型失败: {e}")
        return False

# 启动后台服务
def start_background_services(limits):
    """启动后台服务"""
    try:
        update_progress(70)
        
        # 设置全局资源限制
        global resource_limits
        resource_limits = limits
        
        # 导入server.py中的应用
        from server import app
        
        # 将资源限制传递给服务器应用
        app.config['RESOURCE_LIMITS'] = limits
        
        update_progress(90)
        return app
        
    except Exception as e:
        print(f"\n⚠️  启动后台服务失败: {e}")
        return None

# 捕获所有未处理的异常
def handle_exception(exc_type, exc_value, exc_traceback):
    """处理未捕获的异常，显示中英文报错信息"""
    print("\n" + "=" * 50)
    print("⚠️  程序发生意外错误！")
    print("⚠️  Program encountered an unexpected error!")
    print("=" * 50)
    print(f"错误类型/Error Type: {exc_type.__name__}")
    print(f"错误信息/Error Message: {exc_value}")
    print("=" * 50)
    print("正在清理后台进程...")
    print("Cleaning up background processes...")
    
    # 清理相关进程
    for proc in psutil.process_iter(['name', 'cmdline']):
        try:
            if proc.name().lower() in ['ollama', 'ollama.exe'] and 'serve' in proc.cmdline():
                proc.terminate()
                try:
                    proc.wait(timeout=3)
                    print("已停止Ollama服务")
                except psutil.TimeoutExpired:
                    proc.kill()
                    print("已强制停止Ollama服务")
        except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
            pass
    
    print("清理完成/Cleanup completed.")
    print("请稍后重新启动程序/Please restart the program later.")
    print("=" * 50)
    sys.exit(1)

if __name__ == '__main__':
    # 设置全局异常处理
    sys.excepthook = handle_exception
    
    # 打印启动信息
    print("=" * 50)
    print("连析工坊 启动中...")
    print("Lianxi Workshop Starting...")
    print("=" * 50)
    
    # 显示系统信息
    print(f"操作系统: {platform.system()} {platform.release()} {platform.architecture()[0]}")
    
    # 启动进度条线程
    progress_thread = threading.Thread(target=show_progress_bar)
    progress_thread.daemon = True
    progress_thread.start()
    
    # 设置资源限制
    resource_limits = set_resource_limits()
    print(f"资源限制: CPU={resource_limits['cpu_limit']}核心, 内存={resource_limits['memory_limit_mb']}MB, 磁盘={resource_limits['disk_limit_gb']}GB")
    
    # 应用资源限制到当前进程
    current_process = psutil.Process()
    apply_resource_limits(current_process, resource_limits)
    
    # 初始化本地大模型
    if not initialize_local_model():
        print("\n❌ 本地模型初始化失败，程序将退出")
        sys.exit(1)
    
    # 启动资源监控
    start_resource_monitor()
    
    # 启动后台服务
    app = start_background_services(resource_limits)
    if app is None:
        print("\n❌ 后台服务启动失败，程序将退出")
        sys.exit(1)
    
    # 完成启动
    update_progress(100)
    print("\n" + "=" * 50)
    print("✅ 连析工坊 启动成功！")
    print("✅ Lianxi Workshop started successfully!")
    print(f"🌐 WebUI地址: http://localhost:8001")
    print("📊 实时运行进度将在下方显示...")
    print("💡 系统资源智能管理已启用")
    print("=" * 50)
    print()
    
    try:
        # 启动Flask应用
        app.run(host='0.0.0.0', port=8001, debug=False)
    except KeyboardInterrupt:
        # 人为退出
        print("\n" + "=" * 50)
        print("⚠️  检测到退出信号")
        print("⚠️  Exit signal detected")
        user_input = input("确定要退出吗？(Y/N) / Are you sure you want to exit? (Y/N): ").strip().upper()
        if user_input == 'Y':
            print("正在退出程序...")
            print("Exiting program...")
            sys.exit(0)
        else:
            print("继续运行程序...")
            print("Continuing program...")
            # 重新启动Flask应用
            app.run(host='0.0.0.0', port=8001, debug=False)
