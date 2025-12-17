# 连析工坊IDE平台安装与运行测试指南

## 概述

本指南提供了在五大平台（Windows、macOS、Android、iOS、HarmonyOS）的IDE环境中安装、配置和测试连析工坊项目的详细步骤。本指南重点关注开发环境的搭建和项目的运行测试，确保项目在各平台IDE中能够正常开发和调试。

## 系统架构与依赖

### 核心技术栈
- **后端**: Python 3.7+, Flask
- **前端**: HTML5, CSS3, JavaScript
- **依赖管理**: pip (Python包管理)

### 核心文件
- `main.py`: 项目主入口，负责启动服务器和处理全局异常
- `server.py`: Flask服务器实现，提供API接口
- `index.html`: WebUI主页面
- `requirements.txt`: 项目依赖列表

## 测试环境要求

### 通用要求
- 网络连接（仅用于初始依赖安装）
- Python 3.7或更高版本
- Git（用于代码管理）
- 各平台对应的IDE环境

### 平台特定要求
| 平台 | 最低配置 | IDE推荐 |
|------|----------|---------|
| Windows | Windows 10+, 8GB RAM | Visual Studio Code |
| macOS | macOS 10.14+, 8GB RAM | PyCharm, VS Code |
| Android | Android 10+, 4GB RAM | Android Studio |
| iOS | iOS 14+, 4GB RAM | Xcode |
| HarmonyOS | HarmonyOS 2.0+, 4GB RAM | DevEco Studio |

---

## 1. Windows IDE环境安装与运行测试

### 1.1 IDE环境准备

#### Visual Studio Code安装
1. 从[VS Code官网](https://code.visualstudio.com/)下载最新版本
2. 运行安装程序，选择以下组件：
   - 桌面快捷方式
   - 添加到PATH
   - 关联.py文件
3. 完成安装后启动VS Code

#### Python安装
1. 从[Python官网](https://www.python.org/)下载Python 3.7+安装包
2. 运行安装程序，确保勾选"Add Python to PATH"
3. 安装完成后验证：
   ```bash
   python --version
   pip --version
   ```

### 1.2 项目导入与配置

1. 克隆或复制项目代码到本地目录
2. 在VS Code中打开项目文件夹
3. 安装Python扩展：
   - 点击左侧扩展图标
   - 搜索"Python"并安装Microsoft官方Python扩展

4. 配置虚拟环境：
   ```bash
   # 创建虚拟环境
   python -m venv venv
   
   # 激活虚拟环境
   .\venv\Scripts\activate
   
   # 安装依赖
   pip install -r requirements.txt
   ```

### 1.3 项目运行测试

1. 在VS Code中打开`main.py`文件
2. 点击右上角的"Run"按钮或按F5启动项目
3. 观察控制台输出，确认项目启动成功
4. 打开浏览器访问`http://localhost:8001`
5. 测试核心功能：
   - 模型加载与推理
   - 对话功能
   - 音乐分析
   - 代码调试
   - 多语言切换

### 1.4 调试功能测试

1. 在`main.py`或`server.py`中设置断点
2. 按F5启动调试模式
3. 测试断点触发和变量查看功能
4. 验证单步执行和异常捕获功能

---

## 2. macOS IDE环境安装与运行测试

### 2.1 IDE环境准备

#### PyCharm安装
1. 从[JetBrains官网](https://www.jetbrains.com/pycharm/)下载PyCharm Community Edition
2. 打开下载的.dmg文件，将PyCharm拖入Applications文件夹
3. 首次启动时选择Do not import settings
4. 完成初始配置后进入主界面

#### Python安装
1. macOS通常预装Python，但建议安装最新版本
2. 使用Homebrew安装：
   ```bash
   brew install python
   ```
3. 验证安装：
   ```bash
   python3 --version
   pip3 --version
   ```

### 2.2 项目导入与配置

1. 在PyCharm中选择"Open"并导航到项目文件夹
2. 在右下角选择Python解释器：
   - 点击"Add Interpreter"
   - 选择"New Environment"
   - 选择"Virtualenv"并点击"OK"

3. 安装项目依赖：
   ```bash
   pip install -r requirements.txt
   ```

### 2.3 项目运行测试

1. 在PyCharm中打开`main.py`文件
2. 点击右上角的"Run"按钮或按Shift+F10启动项目
3. 观察控制台输出，确认项目启动成功
4. 打开Safari或Chrome访问`http://localhost:8001`
5. 测试所有核心功能，确认正常工作

### 2.4 调试功能测试

1. 在代码中设置断点
2. 按Shift+F9启动调试模式
3. 测试调试功能：
   - 断点触发
   - 变量查看
   - 单步执行
   - 表达式求值

---

## 3. Android IDE环境安装与运行测试

### 3.1 IDE环境准备

#### Android Studio安装
1. 从[Android Studio官网](https://developer.android.com/studio)下载最新版本
2. 运行安装程序，选择"Custom"安装类型
3. 确保选择以下组件：
   - Android SDK
   - Android SDK Platform
   - Android Virtual Device
4. 完成安装并启动Android Studio

### 3.2 Android虚拟设备(AVD)配置

1. 打开Android Studio，点击"More Actions" > "Virtual Device Manager"
2. 点击"Create Virtual Device"
3. 选择设备类型（如Pixel 6）
4. 选择最新的Android系统镜像并下载
5. 配置AVD参数：
   - 内存至少2GB
   - 存储至少16GB
   - 启用硬件加速

### 3.3 项目测试与访问

1. 在Windows/macOS上启动连析工坊服务
2. 确保Android虚拟设备与开发机处于同一网络
3. 在AVD中打开Chrome浏览器
4. 访问开发机的IP地址和端口（如`http://192.168.1.100:8001`）
5. 测试WebUI功能和PWA安装

### 3.4 调试功能

1. 在Chrome浏览器中按F12打开开发者工具
2. 使用Network面板监控网络请求
3. 使用Console面板查看JavaScript错误
4. 测试移动端适配和响应式布局

---

## 4. iOS IDE环境安装与运行测试

### 4.1 IDE环境准备

#### Xcode安装
1. 在macOS上打开App Store
2. 搜索"Xcode"并点击"Get"安装
3. 安装完成后，打开Xcode并接受许可协议
4. 安装Xcode Command Line Tools：
   ```bash
   xcode-select --install
   ```

### 4.2 iOS模拟器配置

1. 打开Xcode
2. 点击"Xcode"菜单 > "Open Developer Tool" > "Simulator"
3. 选择"File"菜单 > "Open Simulator" > 选择设备型号和iOS版本
4. 等待模拟器启动完成

### 4.3 项目测试与访问

1. 在macOS上启动连析工坊服务
2. 在iOS模拟器中打开Safari浏览器
3. 访问`http://localhost:8001`
4. 测试WebUI功能：
   - 模型加载
   - 对话功能
   - 界面响应式

### 4.4 调试功能

1. 在Safari中点击"Develop"菜单 > 选择模拟器设备
2. 选择当前网页进行调试
3. 使用Web Inspector工具：
   - Elements面板检查DOM结构
   - Network面板监控请求
   - Console面板查看错误

---

## 5. HarmonyOS IDE环境安装与运行测试

### 5.1 IDE环境准备

#### DevEco Studio安装
1. 从[华为开发者网站](https://developer.huawei.com/consumer/cn/deveco-studio/)下载DevEco Studio
2. 运行安装程序，选择"Full"安装类型
3. 确保选择以下组件：
   - HarmonyOS SDK
   - Node.js
   - Previewer
4. 完成安装并启动DevEco Studio

### 5.2 HarmonyOS虚拟设备配置

1. 打开DevEco Studio，点击"Tools"菜单 > "Device Manager"
2. 点击"New Device"
3. 选择设备类型（手机或平板）
4. 选择HarmonyOS版本并下载系统镜像
5. 配置虚拟设备参数：
   - 内存至少2GB
   - 存储至少16GB
   - 启用硬件加速

### 5.3 项目测试与访问

1. 在Windows/macOS上启动连析工坊服务
2. 确保HarmonyOS虚拟设备与开发机处于同一网络
3. 在虚拟设备中打开浏览器
4. 访问开发机的IP地址和端口（如`http://192.168.1.100:8001`）
5. 测试功能：
   - WebUI加载
   - 模型推理
   - 界面适配

### 5.4 调试功能

1. 在DevEco Studio中点击"Tools" > "Previewer"
2. 使用Previewer工具调试界面布局
3. 在浏览器中使用开发者工具调试JavaScript代码
4. 测试HarmonyOS特有功能适配

---

## 功能测试清单

| 测试项 | Windows | macOS | Android | iOS | HarmonyOS |
|--------|---------|-------|---------|-----|-----------|
| IDE安装配置 | □ | □ | □ | □ | □ |
| Python环境配置 | □ | □ | - | - | - |
| 依赖安装 | □ | □ | - | - | - |
| 项目启动 | □ | □ | □ | □ | □ |
| WebUI加载 | □ | □ | □ | □ | □ |
| 模型加载 | □ | □ | □ | □ | □ |
| 对话功能 | □ | □ | □ | □ | □ |
| 音乐分析 | □ | □ | □ | □ | □ |
| 代码调试 | □ | □ | □ | □ | □ |
| 多语言切换 | □ | □ | □ | □ | □ |
| PWA安装 | □ | □ | □ | □ | □ |

---

## 常见问题与解决方案

### Windows平台
- **问题**: Python环境变量配置错误
  **解决方案**: 重新安装Python并确保勾选"Add Python to PATH"

- **问题**: VS Code无法识别Python解释器
  **解决方案**: 在VS Code中手动选择Python解释器路径

### macOS平台
- **问题**: 权限错误导致依赖安装失败
  **解决方案**: 使用sudo权限安装或使用虚拟环境

- **问题**: 端口被占用
  **解决方案**: 查找并终止占用8001端口的进程
  ```bash
  lsof -i :8001
  kill <PID>
  ```

### Android平台
- **问题**: 无法连接到开发机
  **解决方案**: 确保AVD与开发机处于同一网络，关闭防火墙

- **问题**: WebUI加载缓慢
  **解决方案**: 启用硬件加速，增加AVD内存

### iOS平台
- **问题**: 模拟器无法访问localhost
  **解决方案**: 使用开发机的IP地址替代localhost

- **问题**: Safari不支持某些Web特性
  **解决方案**: 更新iOS模拟器版本，检查兼容性

### HarmonyOS平台
- **问题**: DevEco Studio安装失败
  **解决方案**: 确保系统满足最低要求，以管理员权限运行安装程序

- **问题**: 虚拟设备启动失败
  **解决方案**: 检查硬件加速是否启用，增加系统内存

---

## 性能优化建议

### 开发环境优化
- 使用SSD存储提高项目加载速度
- 增加IDE内存分配
- 定期清理IDE缓存

### 项目配置优化
- 使用生产环境配置运行Flask
- 启用gzip压缩
- 使用CDN加速静态资源

---

## 测试验证报告模板

### 测试环境信息
| 项目 | 详情 |
|------|------|
| 平台 | [Windows/macOS/Android/iOS/HarmonyOS] |
| IDE版本 | [IDE版本号] |
| Python版本 | [Python版本号] |
| 项目版本 | [Git提交哈希] |

### 测试结果
| 测试项 | 结果 | 备注 |
|--------|------|------|
| [测试项] | □ 通过 □ 失败 □ 未测试 | [问题描述或备注] |

### 问题记录
| 问题ID | 问题描述 | 严重程度 | 解决方案 |
|--------|----------|----------|----------|
| [ID] | [描述] | [高/中/低] | [解决方案] |

---

© 2025 连析工坊(Lianalytica)连毅霖版权所有