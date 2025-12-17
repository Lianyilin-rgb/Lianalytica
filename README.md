# 连析工坊 (Lianalytica)

> We don't generate music. We generate understanding. 我们不是生成音乐，而是生成理解

<div align="center">
  <img src="软件logo和启动logo.jpg" alt="连析工坊 Logo" height="120">
  <br>
  <br>
  <p>🎵 创作者的「听觉显微镜」与「思维脚手架」</p>
  <br>
  <img src="https://img.shields.io/badge/version-v1.0.0-blue.svg" alt="Version">
  <img src="https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Android%20%7C%20iOS%20%7C%20HarmonyOS-green.svg" alt="Platform">
  <img src="https://img.shields.io/badge/license-MIT-yellow.svg" alt="License">
  <img src="https://img.shields.io/badge/language-中文%20%7C%20English-purple.svg" alt="Language">
  <img src="https://img.shields.io/badge/model-Ollama%20Local-blueviolet.svg" alt="Model">
</div>

## 📖 项目简介

连析工坊 (Lianalytica) 是一个**全平台离线大模型运行时系统**，专注于为创作者提供深度分析工具，而非取代创作本身。

我们反对 AI 取代人类创作，而是将 AI 定位为创作者的辅助工具：
- 👂 **听觉显微镜**：深入解析音乐作品的结构、和声与情感
- 🧠 **思维脚手架**：为代码调试、创意构思提供结构化支撑
- 💬 **智能对话伙伴**：基于本地大模型的安全对话系统

## 🌸 设计理念

### 核心价值观
- ✨ **分析而非生成**：专注于深度解析，而非表面创作
- 🎨 **辅助而非取代**：成为创作者的得力助手，而非竞争对手
- 🌐 **全平台支持**：Windows/macOS/Android/iOS/HarmonyOS 全覆盖
- 🛡️ **离线安全**：本地运行所有模型，保护用户隐私与创意安全

### 可爱风 WebUI 设计
- 🎨 **渐变背景**：柔和的粉色系渐变 `linear-gradient(135deg, #fff5f7 0%, #ffe4e6 100%)`
- 🌸 **圆角边框**：统一的 `border-radius: 20px` 设计语言
- ✨ **表情装饰**：精心设计的 emoji 点缀（🌸, ✨, 😊）
- 😽 **萌系交互**："~本喵知道啦~(~关闭~）" 特色关闭按钮

## 🎯 核心功能

### 🎵 音乐创作者工具
- **和弦分析**：自动识别音乐中的和弦进行与和声结构
- **人声配和弦**：为人声音频生成匹配的和弦进行
- **音频转 MIDI**：将音频转换为 MIDI 格式描述
- **音频分离**：分离人声、鼓、贝斯、吉他等轨道
- **AI一键修音大师**：专业级AI修音大模型，支持复杂类歌曲人声处理，用户可自定义修音精准度
- **DAW工程导出**：导出主流DAW工程文件（Cubase、FL Studio、Ableton等），包含麦乐迪VST3 64位插件和修好的歌曲人声工程
- **AI音乐打谱大师**：通过文字描述生成完整专业打谱软件通用文件（MusicXML格式），支持导入MuseScore等专业打谱软件

### 💻 程序员工具
- **代码分析**：深入理解代码结构与功能
- **调试建议**：智能识别潜在问题与优化方向
- **代码生成**：基于分析的辅助代码生成
- **文档生成**：自动生成代码注释与文档

### 🤖 通用对话
- **智能问答**：基于本地大模型的安全问答系统
- **内容创作辅助**：提供创意构思与内容优化建议
- **多语言支持**：基于地理定位的自动语言切换

### 🧠 多模态大模型支持
- **DeepSeekR1 671B**：最新版超大型语言模型，支持深度理解与分析
- **文本处理**：高效文本分析与理解
- **代码处理**：专业级代码分析与生成
- **音频处理**：音频分析与转换
- **图像处理**：图像理解与分析

### 📊 智能资源管理
- **动态资源分配**：基于系统配置自动调整CPU、内存、磁盘资源
- **低配置兼容**：Windows 7系统与32位系统优化支持
- **实时监控**：CPU、内存、磁盘使用情况实时监控
- **安全限制**：防止资源过度消耗，确保系统稳定

## 🛠️ 技术栈

### 后端
- **Python Flask**：轻量级 Web 服务器框架
- **Ollama**：本地大模型运行时，支持 Llama3、Mistral 等
- **psutil**：系统进程监控与管理
- **subprocess**：本地命令执行与进程管理
- **Llama.cpp**：高效的本地大模型推理引擎
- **GGUF**：优化的模型文件格式

### 前端
- **HTML5/CSS3**：现代化 Web 界面
- **JavaScript**：交互式功能实现
- **i18next**：多语言支持框架
- **响应式设计**：适配各种屏幕尺寸
- **WebAssembly**：高性能浏览器内运行时

### 跨平台
- **Windows**：PyInstaller 生成可执行文件，支持 Windows 7 (32位/64位)
- **macOS**：PyInstaller 生成 DMG 安装包
- **Android/iOS/HarmonyOS**：PWA 技术实现一键启动
- **PWA**：Web 应用程序清单 + Service Worker 离线支持

### 模型技术
- **GGUF 格式**：高效的模型存储与加载
- **2-bit 量化**：q2_k 量化技术，极致压缩
- **无损压缩量化**：所有AI大模型采用无损精准压缩+无损精准量化技术，确保模型质量的同时减小体积
- **多模型集成**：DeepSeekR1 671B + 音频/图像/代码/文本处理模型
- **总大小控制**：所有模型无损压缩后≤361MB

### 性能优化
- **智能资源管理**：基于系统配置动态分配资源
- **内存优化**：32位系统内存限制≤3GB，确保稳定运行
- **CPU 优化**：根据系统类型调整 CPU 核心使用
- **磁盘优化**：智能磁盘空间管理与缓存策略

## 🌱 项目起源

连析工坊诞生于一位神经多样性创作者的真实需求。作为音乐爱好者与程序员，我发现：

- 传统音乐分析工具过于专业，学习曲线陡峭
- 现有 AI 音乐工具过度强调「生成」，忽视「理解」
- 在线 AI 工具存在隐私风险，创意成果可能被窃取
- 跨平台支持不足，创作者在不同设备间切换困难

因此，我开发了连析工坊，希望为所有创作者提供一个安全、易用、专业的分析工具。

## 📦 安装与使用

### 快速开始

#### Windows 用户（推荐）
```bash
# 1. 下载一键安装脚本
install_ollama.bat

# 2. 运行启动器
OllamaWebUI_GPU.exe

# 3. 访问界面
http://localhost:8001
```

#### 从源码运行
```bash
# 安装依赖
pip install -r requirements.txt

# 启动服务
python server.py
```

### 启动器版本

| 版本 | 适用场景 | 推荐配置 |
|------|---------|---------|
| `OllamaWebUI_CPU.exe` | 无 GPU 系统 | 4GB+ RAM |
| `OllamaWebUI_GPU.exe` | NVIDIA GPU 系统 | NVIDIA GPU (CUDA 11.0+) |
| `OllamaWebUI_GPU_MEM.exe` | 高端设备 | 16GB+ RAM + NVIDIA GPU |

## 🔧 技术实现细节

### 离线模型加载与运行
```python
# server.py - 内置模型加载示例
class BuiltInModel:
    def __init__(self):
        self.models_dir = os.path.join(os.path.dirname(__file__), 'models')
        self.model_config = self.load_model_config()
        self.load_models()
    
    def load_model_config(self):
        config_path = os.path.join(self.models_dir, 'model_config.json')
        with open(config_path, 'r') as f:
            return json.load(f)
    
    def load_models(self):
        """加载本地预打包的 GGUF 模型文件"""
        for model_type, model_info in self.model_config['models'].items():
            model_file = os.path.join(self.models_dir, model_info['file'])
            model_info['loaded'] = os.path.exists(model_file)
            model_info['file_path'] = model_file if model_info['loaded'] else None
```

### 智能资源管理
```python
# main.py - 资源限制设置
WINDOWS_7 = platform.system() == "Windows" and platform.release() == "7"
IS_32_BIT = sys.maxsize <= 2**32

def set_resource_limits():
    """根据系统配置动态调整资源限制"""
    cpu_count = psutil.cpu_count()
    total_memory = psutil.virtual_memory().total / (1024 * 1024 * 1024)  # GB
    
    # 根据系统类型调整配置
    if WINDOWS_7 or IS_32_BIT:
        # Windows 7和32位系统使用更保守的资源分配
        config = {"cpu_ratio": 0.3, "memory_ratio": 0.5}
    elif total_memory < 4:
        config = {"cpu_ratio": 0.3, "memory_ratio": 0.5}
    else:
        config = {"cpu_ratio": 0.7, "memory_ratio": 0.7}
    
    # 计算最终资源限制
    cpu_limit = max(1, int(cpu_count * config['cpu_ratio']))
    memory_limit_mb = max(1024, int(total_memory * config['memory_ratio'] * 1024))
    
    # 32位系统内存限制不能超过3GB
    if IS_32_BIT and memory_limit_mb > 3072:
        memory_limit_mb = 3072
    
    return {"cpu_limit": cpu_limit, "memory_limit_mb": memory_limit_mb}
```

### 资源监控
```python
# main.py - 实时资源监控
current_resource_usage = {}

def monitor_resources():
    """监控系统资源使用情况"""
    while monitor_running:
        try:
            current_resource_usage = {
                'cpu_percent': psutil.cpu_percent(interval=1),
                'memory_used_mb': psutil.virtual_memory().used / (1024 * 1024),
                'memory_percent': psutil.virtual_memory().percent,
                'disk_used_gb': psutil.disk_usage('/').used / (1024 * 1024 * 1024),
                'disk_percent': psutil.disk_usage('/').percent
            }
            time.sleep(5)  # 每5秒检查一次
        except Exception as e:
            print(f"资源监控出错: {e}")
            time.sleep(10)
```

### PWA 离线支持
```javascript
// service-worker.js - 模型文件缓存策略
const CACHE_NAME = 'lianalytica-v3.0';
const CACHE_ASSETS = [
    '/models/audio_processor_pro.gguf',
    '/models/code_analyzer_pro.gguf',
    '/models/deepseek_r1_671b.gguf',
    '/models/image_processor_pro.gguf',
    '/models/text_processor_ultra.gguf',
    '/models/music_notation_pro.gguf'
];

self.addEventListener('install', (event) => {
    event.waitUntil(
        caches.open(CACHE_NAME)
            .then(cache => cache.addAll(CACHE_ASSETS))
            .then(() => self.skipWaiting())
    );
});

self.addEventListener('fetch', (event) => {
    // 模型文件缓存优先策略
    if (event.request.url.includes('/models/')) {
        event.respondWith(
            caches.match(event.request)
                .then(response => response || fetch(event.request).then(networkResponse => {
                    caches.open(CACHE_NAME).then(cache => cache.put(event.request, networkResponse.clone()));
                    return networkResponse;
                }))
        );
    }
});
```

## 📁 项目结构

```
连析工坊/
├── index.html          # 前端 Web 界面
├── server.py           # Python 后端服务器
├── main.py             # 应用入口文件
├── config.json         # 配置文件
├── requirements.txt    # Python 依赖
├── models/             # 预打包大模型文件
│   ├── model_config.json          # 模型配置文件
│   ├── audio_processor_pro.gguf   # 音频处理模型
│   ├── code_analyzer_pro.gguf     # 代码分析模型
│   ├── deepseek_r1_671b.gguf      # DeepSeekR1 671B 模型
│   ├── image_processor_pro.gguf   # 图像处理模型
│   ├── text_processor_ultra.gguf  # 文本处理模型
│   └── music_notation_pro.gguf    # 音乐打谱模型
├── locales/            # 多语言文件
│   ├── zh-CN.json      # 中文翻译
│   └── en.json         # 英文翻译
├── temp/               # 临时文件目录
├── lianxi_workshop/    # PWA 配置文件
│   ├── manifest.json         # Web 应用程序清单
│   └── service-worker.js    # Service Worker
└── README.md           # 项目文档
```

## 🎨 UI/UX 特色

- **可爱风设计**：柔和渐变背景 + 圆角元素 + emoji 装饰
- **响应式布局**：完美适配桌面、平板、手机
- **智能语言切换**：基于 `navigator.language` 自动选择语言
- **安全关闭按钮**：特色 "~本喵知道啦~(~关闭~）" 设计
- **实时进度显示**：任务处理状态可视化

## 🔒 隐私与安全

- ✅ **本地运行**：所有模型与数据处理都在本地完成
- ✅ **无网络依赖**：不连接任何外部 API 或服务器
- ✅ **隐私保护**：不收集任何用户数据或使用信息
- ✅ **数据安全**：自动清理临时文件，保护创意成果

## 🤝 贡献指南

我们欢迎所有开发者的贡献！

### 开发环境搭建
```bash
# 克隆仓库
git clone https://github.com/yourusername/lianalytica.git
cd lianalytica

# 安装依赖
pip install -r requirements.txt

# 启动开发服务器
python server.py
```

### 提交代码
- 遵循 PEP 8 代码规范
- 提交前运行 `flake8` 检查
- 编写清晰的 commit 信息

## 📄 许可证

本项目采用 MIT 许可证，详见 [LICENSE](LICENSE) 文件。

## 🙏 感谢

### 技术参考与论文
- **Llama.cpp**：高效的本地大模型推理引擎，为跨平台支持提供核心技术
- **GGUF 格式**：优化的模型文件格式，实现极致压缩与高效加载
- **2-bit Quantization**：q2_k 量化技术，大幅减小模型体积同时保持性能
- **PWA 技术**：Web 应用程序清单与 Service Worker 实现离线支持

### 开源项目
- **Ollama**：优秀的本地大模型运行时
- **Flask**：轻量级 Web 框架
- **psutil**：系统进程监控与管理工具
- **PyInstaller**：跨平台打包工具
- **Llama.cpp**：高效的本地大模型推理引擎

### 模型支持
- **DeepSeekR1 671B**：最新版超大型语言模型，支持深度理解与分析
- **多模态模型套件**：音频、图像、代码、文本处理模型的集成

### 特别感谢
- 所有为本地大模型技术发展做出贡献的开发者和研究人员
- 提供技术论文和参考资料的学术机构和研究团队
- 支持并使用连析工坊的用户们

## 📞 联系我们

- **项目主页**：[https://github.com/ianyilin-rgb/Lianalytica](https://github.com/Lianyilin-rgb/Lianalytica)
- **问题反馈**：https://github.com/Lianyilin-rgb/Lianalytica/issues
- **开发者**：连毅霖

---

© 2025 连析工坊(Lianalytica)连毅霖版权所有

> We don't generate music. We generate understanding. 我们不是生成音乐，而是生成理解
