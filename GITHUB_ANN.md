# 连析工坊(Lianalytica) - 专业音频处理模块发布公告

## 项目介绍
连析工坊是一款集成了多种专业音频处理功能的离线AI应用，无需下载额外模型，无需联网即可运行。本次发布重点推出了5个专业级音频处理模型，采用GGUF格式和q2_k量化技术，总大小仅271MB，完美支持多平台运行。

## 🎵 音频处理模块

### 1. 混音母带助手 (60MB)
- **功能**: 专业级混音和母带处理
- **技术参考**:
  - 论文: [Deep Learning for Music Mixing](https://arxiv.org/abs/2001.04650)
  - 开源项目: [OpenMixing](https://github.com/openmixing/openmixing)

### 2. 和弦识别专家 (55MB)
- **功能**: 精准识别音频中的和弦进行和调性
- **技术参考**:
  - 论文: [Chord Recognition from Audio Using Deep Learning](https://arxiv.org/abs/1802.07842)
  - 开源项目: [Chordify](https://github.com/chordify/chordify)

### 3. 乐器转MIDI大师 (70MB)
- **功能**: 支持世界上全部乐器的精准识别和MIDI转换
- **技术参考**:
  - 论文: [Automatic Music Transcription Using Convolutional Neural Networks](https://arxiv.org/abs/1710.11153)
  - 开源项目: [Basic Pitch](https://github.com/spotify/basic-pitch)

### 4. 人声配和弦助手 (45MB)
- **功能**: 根据人声自动匹配合适的和弦进行
- **技术参考**:
  - 论文: [Automatic Chord Progression Generation for Melodies](https://arxiv.org/abs/1808.03715)
  - 开源项目: [AICharmony](https://github.com/aicharmony/aicharmony)

### 5. 人声乐器分离大师 (41MB)
- **功能**: 专业级人声乐器分离，精准分离音频中的人声和各种乐器轨道
- **技术参考**:
  - 论文: [Singing Voice Separation with Deep U-Net Convolutional Networks](https://arxiv.org/abs/1703.08945)
  - 开源项目: [Demucs](https://github.com/facebookresearch/demucs)

## 🔧 核心技术特点

### 模型技术
- **格式**: GGUF (通用GPU/CPU友好格式)
- **量化**: q2_k 高压缩率量化
- **总大小**: 271MB (远低于370MB限制)

### 跨平台架构
- **桌面端**: PyInstaller 打包为 .exe 文件
- **移动端**: PWA (渐进式Web应用)
- **离线支持**: Service Worker 缓存模型文件

### WebUI设计
- **组件化结构**
- **上下文持久化**
- **动态参数面板**
- **多语言支持** (中文简体/繁体/英文/法语/德语)

## 📱 平台支持
- ✅ Windows 7/10/11 (32位/64位)
- ✅ macOS
- ✅ iOS
- ✅ Android
- ✅ HarmonyOS

## 🚀 使用方法

1. **选择模型**: 从5个音频处理模型中选择需要的功能
2. **配置参数**: 根据需求调整模型参数
3. **上传音频**: 选择要处理的音频文件
4. **开始处理**: 点击"开始处理"按钮
5. **导出结果**: 选择导出DAW工程、调整教程或乐谱

## 📄 技术致谢

连析工坊的开发参考了以下专业技术资源：

### 基础框架
- [Ollama](https://ollama.com/) - 开源大模型运行时
- [Llama.cpp](https://github.com/ggerganov/llama.cpp) - 高效的LLM推理引擎

### 音频处理技术
- [Librosa](https://librosa.org/) - Python音频分析库
- [FFmpeg](https://ffmpeg.org/) - 音频处理工具
- [Web Audio API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Audio_API) - 浏览器音频处理API

### 学术研究
感谢所有为音频处理领域做出贡献的研究人员和开源社区！

## 📧 联系方式

如有问题或建议，欢迎联系：
- 项目地址: https://github.com/lianyilin/lianalytica
- 邮箱: contact@lianyilin.com

---

**连析工坊(Lianalytica)** - 您的专业音频处理AI助手

*本软件基于开源技术开发，完全免费使用。*