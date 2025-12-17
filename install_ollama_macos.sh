#!/bin/bash

echo "=================================================="
echo "连析工坊 - Ollama安装脚本"
echo "Lianalytica - Ollama Installation Script"
echo "=================================================="

# 检查是否安装了Homebrew
if ! command -v brew &> /dev/null; then
    echo "Homebrew未安装，正在安装Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # 添加Homebrew到PATH
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew已安装，正在更新..."
    brew update
fi

# 安装Ollama
echo "正在安装Ollama..."
brew install ollama

# 启动Ollama服务
echo "正在启动Ollama服务..."
brew services start ollama

# 检查Ollama服务状态
echo "正在检查Ollama服务状态..."
sleep 5
ollama --version

if [ $? -eq 0 ]; then
    echo "✅ Ollama安装成功！"
    echo "========================================"
    echo "推荐模型："
    echo "- llama3:8b (推荐8GB+内存)"
    echo "- llama3:70b (推荐32GB+内存)"
    echo "- mistral:7b (轻量级，推荐4GB+内存)"
    echo "========================================"
    
    read -p "是否下载推荐模型？(y/n): " download_choice
    if [ "$download_choice" = "y" ] || [ "$download_choice" = "Y" ]; then
        # 检测系统内存
        MEMORY=$(sysctl -n hw.memsize | awk '{print $1/1024/1024/1024}')
        MEMORY_INT=$(echo "$MEMORY" | cut -d. -f1)
        
        if [ $MEMORY_INT -lt 4 ]; then
            echo "⚠️  系统内存不足4GB，不建议下载模型"
        elif [ $MEMORY_INT -lt 8 ]; then
            echo "正在下载mistral:7b模型..."
            ollama pull mistral:7b
        elif [ $MEMORY_INT -lt 32 ]; then
            echo "正在下载llama3:8b模型..."
            ollama pull llama3:8b
        else
            echo "正在下载llama3:70b模型..."
            ollama pull llama3:70b
        fi
        
        echo "✅ 模型下载完成！"
    fi
    
echo "=================================================="
echo "安装完成！您现在可以运行连析工坊应用了。"
echo "Installation completed! You can now run Lianalytica Workshop."
echo "=================================================="
else
    echo "❌ Ollama安装失败，请检查错误信息"
    exit 1
fi
