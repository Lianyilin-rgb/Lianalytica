@echo off
chcp 65001 >nul
@echo on
setlocal enabledelayedexpansion

REM 配置参数
set "DEBUG_MODE=0"  REM 调试模式开关：0=关闭，1=开启

set "OLLAMA_URL_EXE=https://ollama.com/download/windows"
set "OLLAMA_URL_ZIP=https://github.com/ollama/ollama/releases/latest/download/ollama-windows-amd64.zip"
echo ===========================================
echo Ollama安装脚本 v1.3
echo 支持自动依赖安装、Ollama下载与安装、大模型下载
echo 自动检测网络状况并切换镜像源
echo 支持全球用户的网络环境
echo 支持用户选择模型和基于显卡配置的量化
echo ===========================================

REM 调试信息
call :debug_output "脚本开始执行"
echo 脚本开始执行
set "SCRIPT_DIR=%~dp0"
echo 脚本目录：%SCRIPT_DIR%
echo 当前目录：%CD%

REM 配置参数
set "DEBUG_MODE=0"  REM 调试模式开关：0=关闭，1=开启
REM 增强的调试输出
set "OLLAMA_URL_EXE=https://ollama.com/download/windows"
set "OLLAMA_URL_ZIP=https://github.com/ollama/ollama/releases/latest/download/ollama-windows-amd64.zip"
set "OLLAMA_MIRRORS_EXE=https://github.com/ollama/ollama/releases/latest/download/OllamaSetup.exe https://cdn.jsdelivr.net/gh/ollama/ollama@main/download/windows/OllamaSetup.exe"
set "OLLAMA_MIRRORS_ZIP=https://github.com/ollama/ollama/releases/latest/download/ollama-windows-amd64.zip https://cdn.jsdelivr.net/gh/ollama/ollama@main/download/windows/ollama-windows-amd64.zip https://mirror.ghproxy.com/https://github.com/ollama/ollama/releases/latest/download/ollama-windows-amd64.zip https://cdn.jsdelivr.net/gh/ollama/ollama@main/download/windows/ollama-windows-amd64.zip https://gh.api.99988866.xyz/https://github.com/ollama/ollama/releases/latest/download/ollama-windows-amd64.zip"
set "DEFAULT_MODEL=llama3"
set "TEMP_DIR=%TEMP%\ollama_install"
set "OLLAMA_INSTALL_DIR=%USERPROFILE%\Ollama"
set "OLLAMA_EXE=%OLLAMA_INSTALL_DIR%\ollama.exe"
set "OLLAMA_SERVICE_NAME=OllamaService"

REM 根据用户所在地区自动选择镜像
set "REGION_MIRRORS_EXE_CN=https://github.com/ollama/ollama/releases/latest/download/OllamaSetup.exe https://mirror.ghproxy.com/https://github.com/ollama/ollama/releases/latest/download/OllamaSetup.exe https://cdn.jsdelivr.net/gh/ollama/ollama@main/download/windows/OllamaSetup.exe"
set "REGION_MIRRORS_ZIP_CN=https://cdn.jsdelivr.net/gh/ollama/ollama@main/download/windows/ollama-windows-amd64.zip https://gh.api.99988866.xyz/https://github.com/ollama/ollama/releases/latest/download/ollama-windows-amd64.zip https://fastly.jsdelivr.net/gh/ollama/ollama@main/download/windows/ollama-windows-amd64.zip https://mirror.ghproxy.com/https://github.com/ollama/ollama/releases/latest/download/ollama-windows-amd64.zip https://gcore.jsdelivr.net/gh/ollama/ollama@main/download/windows/ollama-windows-amd64.zip https://github.com/ollama/ollama/releases/latest/download/ollama-windows-amd64.zip"
set "REGION_MIRRORS_EXE_GLOBAL=https://github.com/ollama/ollama/releases/latest/download/OllamaSetup.exe https://cdn.jsdelivr.net/gh/ollama/ollama@main/download/windows/OllamaSetup.exe"
set "REGION_MIRRORS_ZIP_GLOBAL=https://github.com/ollama/ollama/releases/latest/download/ollama-windows-amd64.zip https://fastly.jsdelivr.net/gh/ollama/ollama@main/download/windows/ollama-windows-amd64.zip https://cdn.jsdelivr.net/gh/ollama/ollama@main/download/windows/ollama-windows-amd64.zip"

REM 检测用户所在地区（通过IP）
call :debug_output "检测用户所在地区..."
set "USER_REGION=global"
set "SELECTED_MIRRORS_EXE=%OLLAMA_MIRRORS_EXE%"
set "SELECTED_MIRRORS_ZIP=%OLLAMA_MIRRORS_ZIP%"
powershell -Command "try { $region = (Invoke-WebRequest -Uri 'https://ipinfo.io/country' -UseBasicParsing).Content.Trim(); if ($region -eq 'CN') { exit 0 } else { exit 1 } } catch { exit 1 }"
if %errorlevel% equ 0 (
    set "USER_REGION=cn"
    set "SELECTED_MIRRORS_EXE=%REGION_MIRRORS_EXE_CN%"
    set "SELECTED_MIRRORS_ZIP=%REGION_MIRRORS_ZIP_CN%"
) else (
    set "SELECTED_MIRRORS_EXE=%REGION_MIRRORS_EXE_GLOBAL%"
    set "SELECTED_MIRRORS_ZIP=%REGION_MIRRORS_ZIP_GLOBAL%"
)

REM 检查并创建临时目录 - 带写入权限验证
call :debug_output "开始检查并创建临时目录..."
set "SAFE_TEMP_DIR="
set "TEMP_DIR_LIST=%USERPROFILE%\Downloads\ollama_install %USERPROFILE%\Documents\ollama_install "%CD%" "%SCRIPT_DIR%" %TEMP%\ollama_install %USERPROFILE%\Desktop\ollama_install %USERPROFILE%\ollama_install"

for %%d in (%TEMP_DIR_LIST%) do (
    echo 尝试使用临时目录：%%d
    mkdir "%%d" 2>nul
    if not errorlevel 1 (
        >"%%d\test.txt" echo test 2>nul
        if not errorlevel 1 (
            set "SAFE_TEMP_DIR=%%d"
            del "%%d\test.txt" 2>nul
            echo 成功找到可写入的临时目录：!SAFE_TEMP_DIR!
            goto :temp_dir_success
        )
        rmdir "%%d" 2>nul
    )
)

echo 错误：无法找到可写入的临时目录
echo 请尝试以下解决方案：
echo 1. 以管理员身份运行此脚本
echo 2. 确保您有足够的磁盘空间
echo 3. 检查杀毒软件是否阻止了脚本操作
call :debug_output "无法找到可写入的临时目录"
exit /b 5

:temp_dir_success
set "TEMP_DIR=%SAFE_TEMP_DIR%"
echo 临时目录设置为：%TEMP_DIR%

REM 主程序开始
call :debug_output "主程序开始执行..."
 echo ===========================================
 echo Ollama自动安装脚本 v1.3
 echo 支持自动依赖安装、Ollama下载与安装、大模型下载
 echo 自动检测网络状况并切换镜像源
 echo 支持全球用户的网络环境
 echo 支持用户选择模型和基于显卡配置的量化
 echo ===========================================

REM 1. 安装依赖
call :install_dependencies
if %errorlevel% neq 0 (
    echo 错误：依赖安装失败
    pause
    exit /b 1
)

REM 2. 安装Ollama
call :install_ollama
if %errorlevel% neq 0 (
    echo 错误：Ollama安装失败
    pause
    exit /b 1
)

REM 3. 下载安装模型（支持用户选择和显卡配置量化）
echo 检测显卡配置...
set "GPU_MEM=0"
powershell -Command "$gpu = Get-CimInstance -ClassName Win32_VideoController | Select-Object -First 1; $vram = [math]::Round($gpu.AdapterRAM / 1GB); exit $vram"
set "GPU_MEM=%errorlevel%"
echo 检测到显卡显存: %GPU_MEM%GB

echo 正在检查已安装的模型...
:: 使用Ollama命令行工具获取已安装模型列表
set "INSTALLED_MODELS="
powershell -Command "& '%OLLAMA_EXE%' list 2>$null | ForEach-Object { if ($_ -match '^\S+\s+\S+') { $_.Split()[0] } }" > installed_models.txt

:: 内置完整模型列表
set "ALL_MODELS=llama3 llama3:8b llama3:70b mistral mistral:7b gemma gemma:2b gemma:7b codellama codellama:7b phi3 phi3:3.8b phi3:7b deepseek-coder deepseek-coder:6.7b qwen:7b"

:: 显示所有未安装的模型
echo 未安装的模型列表:
set "COUNT=0"
set "MODEL_LIST="
for %%m in (%ALL_MODELS%) do (
    set "INSTALLED=0"
    for /f "delims=" %%i in (installed_models.txt) do (
        if "%%m"=="%%i" set "INSTALLED=1"
    )
    if "!INSTALLED!"=="0" (
        set /a "COUNT+=1"
        echo !COUNT!. %%m
        set "MODEL_LIST=!MODEL_LIST! %%m"
    )
)

del installed_models.txt >nul 2>&1

:: 如果没有未安装的模型
if "%COUNT%"=="0" (
    echo 所有模型都已安装！
    set "MODEL_CHOICE=llama3"
    goto :MODEL_SELECTED
)

:: 让用户选择模型
echo.
echo 请选择要安装的模型 (1-%COUNT%, 或直接输入自定义模型名称):
set /p "MODEL_CHOICE="

:MODEL_SELECTED

:: 处理用户选择
set "MODEL_INPUT="
if "%MODEL_CHOICE%"=="" (
    set "MODEL_INPUT=llama3"  :: 默认模型
) else (
    :: 检查是否为数字选择
    set "IS_NUMBER=1"
    for /f "delims=0123456789" %%i in ("%MODEL_CHOICE%") do set "IS_NUMBER=0"
    
    if "!IS_NUMBER!"=="1" (
        :: 数字选择，从MODEL_LIST中获取对应的模型
        set "INDEX=0"
        for %%m in (%MODEL_LIST%) do (
            set /a "INDEX+=1"
            if "!INDEX!"=="%MODEL_CHOICE%" (
                set "MODEL_INPUT=%%m"
                goto :MODEL_FOUND
            )
        )
        
        :MODEL_FOUND
        if not defined MODEL_INPUT (
            echo 无效的选择，使用默认模型
            set "MODEL_INPUT=llama3"
        )
    ) else (
        :: 直接输入的模型名称
        set "MODEL_INPUT=%MODEL_CHOICE%"
    )
)

if not defined MODEL_INPUT set "MODEL_INPUT=llama3"

REM 根据显存自动推荐量化级别
if %GPU_MEM% leq 4 (
    set "QUANT_LEVEL=q4_0"
) else if %GPU_MEM% leq 8 (
    set "QUANT_LEVEL=q4_1"
) else if %GPU_MEM% leq 12 (
    set "QUANT_LEVEL=q5_0"
) else (
    set "QUANT_LEVEL=q5_1"
)
echo 根据您的显卡配置（%GPU_MEM%GB显存），推荐量化级别：%QUANT_LEVEL%
set /p "QUANT_CONFIRM=是否使用推荐的量化级别？ (Y/n): "
if /i "%QUANT_CONFIRM%"=="" set "QUANT_CONFIRM=Y"
if /i not "%QUANT_CONFIRM%"=="n" set "MODEL_INPUT=%MODEL_INPUT%:%QUANT_LEVEL%"

call :download_model "%MODEL_INPUT%"
if %errorlevel% neq 0 (
    echo 警告：模型安装失败，但Ollama已成功安装
    call :debug_output "模型安装失败，但Ollama已成功安装"
    exit /b 4
)

echo ===========================================
echo 安装完成！
echo 您可以通过以下命令使用Ollama：
echo   ollama run %MODEL_INPUT%
echo ===========================================

REM 清理临时文件 - 带错误处理
if exist "%TEMP_DIR%" (
    echo 清理临时文件...
    rmdir /s /q "%TEMP_DIR%" 2>nul
    if errorlevel 1 (
        echo 警告：无法完全清理临时目录 %TEMP_DIR%
        echo 您可以手动删除该目录
    ) else (
        echo 临时文件已清理
    )
)

pause
exit /b 0

REM ===============================
REM 以下是函数定义部分
REM ===============================

REM 函数：调试输出功能
:debug_output
set "MESSAGE=%~1"
if %DEBUG_MODE% equ 1 (
    echo [DEBUG] %MESSAGE%
)
EXIT /B

REM 函数：检查命令是否存在 - 增强版
:check_command
set "CMD_NAME=%~1"
echo 正在检查命令：%CMD_NAME%

REM 尝试多种方式检查命令是否存在
where "%CMD_NAME%" >nul 2>nul
if %errorlevel% equ 0 (
    echo 命令 %CMD_NAME% 检查通过
    exit /b 0
)

REM 尝试直接运行命令获取版本信息
"%CMD_NAME%" --version >nul 2>nul
if %errorlevel% equ 0 (
    echo 命令 %CMD_NAME% 检查通过
    exit /b 0
)

REM 检查系统目录
if exist "%SYSTEMROOT%\System32\%CMD_NAME%.exe" (
    echo 命令 %CMD_NAME% 检查通过
    exit /b 0
)

REM 检查PowerShell内置命令
powershell -Command "Get-Command %CMD_NAME% -ErrorAction SilentlyContinue" >nul 2>nul
if %errorlevel% equ 0 (
    echo 命令 %CMD_NAME% 检查通过
    exit /b 0
)

REM 检查PowerShell Core命令
powershell -Command "if (Get-Command pwsh -ErrorAction SilentlyContinue) { exit 0 } else { exit 1 }" >nul 2>nul
if %errorlevel% equ 0 (
    pwsh -Command "Get-Command %CMD_NAME% -ErrorAction SilentlyContinue" >nul 2>nul
    if %errorlevel% equ 0 (
        echo 命令 %CMD_NAME% 检查通过
        exit /b 0
    )
)

echo 警告：%CMD_NAME% 命令未找到，将尝试安装或提供替代方案...
exit /b 0

REM 函数：下载文件（支持多个URL和超时重试）
:download_file
set "URL_LIST=%~1"
set "OUTPUT_FILE=%~2"
set "TIMEOUT=%~3"
if "%TIMEOUT%"=="" set "TIMEOUT=15"
set "MAX_RETRIES=3"

REM 显示下载信息
set "OUTPUT_DIR=%~dp2"
set "OUTPUT_FILENAME=%~nx2"

echo 下载文件：%OUTPUT_FILENAME%
echo 原始目标路径：%OUTPUT_FILE%

REM 临时目录处理：使用用户可访问的目录，提供更多备选
set "SAFE_OUTPUT_DIR="
set "SAFE_OUTPUT_FILE="

REM 尝试多个备选目录 - 增加更多常用目录选项
set "TRY_DIRS=%USERPROFILE%\Downloads\ollama_temp %USERPROFILE%\Documents\ollama_temp "%CD%" "%SCRIPT_DIR%" %TEMP%\ollama_temp %USERPROFILE%\Desktop\ollama_temp %USERPROFILE%\ollama_temp"

for %%d in (%TRY_DIRS%) do (
    echo 尝试使用目录：%%d
    
    REM 检查目录是否存在且可写
    if exist "%%d" (
        echo 目录已存在，检查写入权限
        >"%%d\test.txt" echo test 2>nul
        if not errorlevel 1 (
            set "SAFE_OUTPUT_DIR=%%d"
            set "SAFE_OUTPUT_FILE=!SAFE_OUTPUT_DIR!\%OUTPUT_FILENAME%"
            echo 成功找到可写入目录：!SAFE_OUTPUT_DIR!
            del "%%d\test.txt" 2>nul
            goto :download_start
        )
    ) else (
        echo 目录不存在，尝试创建
        mkdir "%%d" 2>nul
        if not errorlevel 1 (
            >"%%d\test.txt" echo test 2>nul
            if not errorlevel 1 (
                set "SAFE_OUTPUT_DIR=%%d"
                set "SAFE_OUTPUT_FILE=!SAFE_OUTPUT_DIR!\%OUTPUT_FILENAME%"
                echo 成功创建并验证可写入目录：!SAFE_OUTPUT_DIR!
                del "%%d\test.txt" 2>nul
                goto :download_start
            )
            rmdir "%%d" 2>nul
        )
    )
)

REM 如果所有目录都无法写入，显示详细错误信息
if "%SAFE_OUTPUT_DIR%"=="" (
    echo 错误：无法写入到任何目录
    echo 请尝试以下解决方案：
    echo 1. 以管理员身份运行脚本
    echo 2. 确保目标驱动器有足够空间
    echo 3. 检查杀毒软件是否阻止了文件写入
    echo 4. 尝试手动创建一个可写目录并将脚本放入其中运行
    call :debug_output "无法写入到任何目录"
    exit /b 5
)

:download_start
REM 使用安全目录作为输出路径
echo 保存路径：%SAFE_OUTPUT_FILE%
echo 超时设置：%TIMEOUT%秒
set "OUTPUT_FILE=%SAFE_OUTPUT_FILE%"

for %%u in (%URL_LIST%) do (
    echo.
    echo ====== 尝试镜像 %%u ======
    set "RETRY_DELAY=3"
    for /l %%r in (1,1,!MAX_RETRIES!) do (
        echo 下载尝试 %%r/!MAX_RETRIES! - 开始下载...
        echo 当前时间：%time%
        
        REM 直接使用curl.exe下载，避免PowerShell的curl别名问题
        echo 使用curl下载...
        curl.exe -L -o "%OUTPUT_FILE%" "%%u" --connect-timeout %TIMEOUT% --retry 1 --retry-delay 5
        
        REM 如果curl下载失败，再尝试使用PowerShell下载
        if !errorlevel! neq 0 (
            echo curl下载失败，尝试使用PowerShell下载...
            powershell -Command "try { Invoke-WebRequest -Uri '%%u' -OutFile '%OUTPUT_FILE%' -TimeoutSec %TIMEOUT% -UseBasicParsing; exit 0 } catch { exit 1 }"
        )
        
        if !errorlevel! equ 0 (
            echo.
            echo 下载成功！
            exit /b 0
        )
        
        if %%r lss !MAX_RETRIES! (
            echo.
            echo 下载失败，!RETRY_DELAY!秒后重试...
            timeout /t !RETRY_DELAY! /nobreak >nul
            set /a "RETRY_DELAY=RETRY_DELAY*2"  REM 指数退避策略
        )
    )
    echo.
    echo 当前镜像下载失败，尝试下一个镜像...
)

echo.
echo ====== 下载失败 ======
echo 所有镜像源都无法下载文件！
echo 请检查：
1. 网络连接是否正常
2. 防火墙是否允许脚本访问网络
3. 是否需要设置代理

echo 下载的文件：!OUTPUT_FILENAME!
echo 目标路径：%OUTPUT_FILE%
exit /b 1

REM 函数：安装依赖
:install_dependencies
echo 正在检查并安装依赖...

REM 检查并安装必要的运行时库
set "VCRUNTIME_URL=https://aka.ms/vs/17/release/vc_redist.x64.exe"
set "VCRUNTIME_DOWNLOAD_URLS=%VCRUNTIME_URL%"

REM 检查VC++运行时
where vcruntime140.dll >nul 2>nul || (
    echo 安装VC++运行时库...
    call :download_file "!VCRUNTIME_DOWNLOAD_URLS!" "%TEMP_DIR%\vc_redist.x64.exe" 20
    if !errorlevel! equ 0 (
        "%TEMP_DIR%\vc_redist.x64.exe" /install /quiet /norestart
        if !errorlevel! neq 0 (
            echo 警告：VC++运行时安装失败，可能影响Ollama运行
        )
    ) else (
        echo 警告：VC++运行时下载失败，可能影响Ollama运行
    )
)

REM 检查并安装chocolatey（如果需要）
where choco >nul 2>nul
if %errorlevel% neq 0 (
    echo 正在安装 Chocolatey 包管理器...
    powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; try { iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')); exit 0 } catch { Write-Host 'Chocolatey安装失败：' $_.Exception.Message; exit 1 }"
    if !errorlevel! neq 0 (
        echo 警告：Chocolatey安装失败，尝试使用winget...
        goto check_winget
    )
    echo Chocolatey安装成功
)

:check_winget
where winget >nul 2>nul
if %errorlevel% equ 0 (
    echo 正在使用winget安装必要依赖...
    winget install --accept-source-agreements --accept-package-agreements Microsoft.PowerShell
    if !errorlevel! neq 0 (
        echo 警告：PowerShell安装失败
    )
) else (
    echo 警告：未找到winget，某些依赖可能需要手动安装
)

REM 确保PowerShell可用
call :check_command powershell
if !errorlevel! neq 0 exit /b 1

REM 确保curl可用（Ollama可能需要）
call :check_command curl || (
    echo 正在安装curl...
    if exist "%SYSTEMROOT%\System32\curl.exe" (
        echo curl已存在于系统目录
    ) else (
        echo 下载curl...
        set "CURL_URL=https://curl.se/windows/latest.cgi?p=win64-mingw64.zip"
        set "CURL_DOWNLOAD_URLS=%CURL_URL%"
        call :download_file "!CURL_DOWNLOAD_URLS!" "%TEMP_DIR%\curl.zip" 20
        if !errorlevel! equ 0 (
            powershell -Command "Expand-Archive -Path '%TEMP_DIR%\curl.zip' -DestinationPath '%TEMP_DIR%\curl' -Force"
            copy "%TEMP_DIR%\curl\curl-*\bin\curl.exe" "%SYSTEMROOT%\System32\" >nul 2>&1
            if !errorlevel! equ 0 (
                echo curl安装成功
            ) else (
                echo 警告：curl安装失败
            )
        ) else (
            echo 警告：curl下载失败
        )
    )
)

EXIT /B 0

REM 函数：安装Ollama
:install_ollama
if exist "%OLLAMA_EXE%" (
    echo Ollama已存在，跳过安装
    exit /b 0
)

echo 正在安装Ollama...

REM 创建安装目录 - 带写入权限验证
set "SAFE_INSTALL_DIR=%OLLAMA_INSTALL_DIR%"

REM 先检查默认安装目录是否存在且可写
if exist "%SAFE_INSTALL_DIR%" (
    echo 检查默认安装目录：%SAFE_INSTALL_DIR%
    >"%SAFE_INSTALL_DIR%\test.txt" echo test 2>nul
    if not errorlevel 1 (
        del "%SAFE_INSTALL_DIR%\test.txt" 2>nul
        echo 默认安装目录可写入
        goto :install_dir_success
    )
    echo 警告：默认安装目录不可写入，尝试创建新目录
) else (
    echo 默认安装目录不存在，尝试创建
)

mkdir "%SAFE_INSTALL_DIR%" 2>nul
if not errorlevel 1 (
    >"%SAFE_INSTALL_DIR%\test.txt" echo test 2>nul
    if not errorlevel 1 (
        del "%SAFE_INSTALL_DIR%\test.txt" 2>nul
        echo 成功创建并验证默认安装目录
        goto :install_dir_success
    )
    rmdir "%SAFE_INSTALL_DIR%" 2>nul
)

echo 警告：默认安装目录无法写入，尝试使用其他目录
set "INSTALL_DIR_LIST=%USERPROFILE%\Ollama %USERPROFILE%\Downloads\Ollama %USERPROFILE%\Documents\Ollama "%CD%"\Ollama "%SCRIPT_DIR%"\Ollama %USERPROFILE%\Desktop\Ollama %USERPROFILE%\ollama"

for %%d in (%INSTALL_DIR_LIST%) do (
    echo 尝试使用安装目录：%%d
    if exist "%%d" (
        >"%%d\test.txt" echo test 2>nul
        if not errorlevel 1 (
            set "SAFE_INSTALL_DIR=%%d"
            del "%%d\test.txt" 2>nul
            echo 成功找到可写入的安装目录：!SAFE_INSTALL_DIR!
            goto :install_dir_success
        )
    ) else (
        mkdir "%%d" 2>nul
        if not errorlevel 1 (
            >"%%d\test.txt" echo test 2>nul
            if not errorlevel 1 (
                set "SAFE_INSTALL_DIR=%%d"
                del "%%d\test.txt" 2>nul
                echo 成功创建并验证安装目录：!SAFE_INSTALL_DIR!
                goto :install_dir_success
            )
            rmdir "%%d" 2>nul
        )
    )
)

echo 错误：无法找到可写入的安装目录
echo 请尝试以下解决方案：
echo 1. 以管理员身份运行此脚本
echo 2. 确保您有足够的磁盘空间
echo 3. 检查杀毒软件是否阻止了脚本操作
echo 4. 手动创建一个安装目录并赋予写入权限
echo 5. 尝试在其他磁盘分区创建安装目录
pause
exit /b 5

:install_dir_success
set "OLLAMA_INSTALL_DIR=%SAFE_INSTALL_DIR%"
set "OLLAMA_EXE=%SAFE_INSTALL_DIR%\ollama.exe"
echo 安装目录设置为：%OLLAMA_INSTALL_DIR%

REM 尝试使用.exe安装程序（更简单的安装方式）
echo 尝试使用.exe安装程序...
set "OLLAMA_DOWNLOAD_URLS=%OLLAMA_URL_EXE% %SELECTED_MIRRORS_EXE%"
echo 下载URL列表：%OLLAMA_DOWNLOAD_URLS%
call :download_file "!OLLAMA_DOWNLOAD_URLS!" "%TEMP_DIR%\ollama-installer.exe" 15
if !errorlevel! equ 0 (
    echo 运行Ollama安装程序...
    "%TEMP_DIR%\ollama-installer.exe" /S /D="%OLLAMA_INSTALL_DIR%"
    if !errorlevel! equ 0 (
        echo Ollama安装成功
        goto :ollama_install_success
    ) else (
        echo .exe安装程序失败，尝试使用.zip文件安装
    )
) else (
    echo .exe安装程序下载失败，尝试使用.zip文件安装
)

REM 尝试使用.zip文件安装
echo 尝试使用.zip文件安装...
set "OLLAMA_DOWNLOAD_URLS=%OLLAMA_URL_ZIP% %SELECTED_MIRRORS_ZIP%"
echo 下载URL列表：%OLLAMA_DOWNLOAD_URLS%
call :download_file "!OLLAMA_DOWNLOAD_URLS!" "%TEMP_DIR%\ollama.zip" 20
if !errorlevel! neq 0 (
    echo 错误：Ollama下载失败
    call :debug_output "Ollama下载失败"
    exit /b 2
)

REM 解压并安装Ollama
echo 解压Ollama...
powershell -Command "Expand-Archive -Path '%TEMP_DIR%\ollama.zip' -DestinationPath '%OLLAMA_INSTALL_DIR%' -Force"
if !errorlevel! neq 0 (
    echo 错误：Ollama解压失败
    call :debug_output "Ollama解压失败"
    exit /b 3
)

:ollama_install_success
REM 添加到系统PATH
setx PATH "%PATH%;%OLLAMA_INSTALL_DIR%" /M
if !errorlevel! neq 0 (
    echo 警告：无法将Ollama添加到系统PATH，请手动添加
)

EXIT /B 0

REM 函数：下载大模型
:download_model
set "MODEL_NAME=%~1"
if "%MODEL_NAME%"=="" set "MODEL_NAME=%DEFAULT_MODEL%"

REM 询问用户是否需要自定义模型存储路径
echo 正在配置模型存储路径...
echo 默认模型存储路径：%USERPROFILE%\.ollama\models
set /p "CUSTOM_MODEL_PATH=请输入自定义模型存储路径（直接回车使用默认路径）："

if not "%CUSTOM_MODEL_PATH%"=="" (
    REM 验证路径是否存在，不存在则创建
    if not exist "%CUSTOM_MODEL_PATH%" (
        echo 创建模型存储路径：%CUSTOM_MODEL_PATH%
        mkdir "%CUSTOM_MODEL_PATH%" >nul 2>&1
        if errorlevel 1 (
            echo 错误：无法创建自定义路径，将使用默认路径
            set "CUSTOM_MODEL_PATH="
        ) else (
            echo 已设置模型存储路径：%CUSTOM_MODEL_PATH%
            set "OLLAMA_MODELS=%CUSTOM_MODEL_PATH%"
        )
    ) else (
        echo 已设置模型存储路径：%CUSTOM_MODEL_PATH%
        set "OLLAMA_MODELS=%CUSTOM_MODEL_PATH%"
    )
)

echo 正在下载并安装模型：%MODEL_NAME%

REM 启动Ollama服务（如果未启动）
echo 检查Ollama服务状态...
set "SERVICE_RUNNING=0"
net start Ollama 2>nul && set "SERVICE_RUNNING=1"
if !SERVICE_RUNNING! equ 0 (
    sc query Ollama >nul 2>&1 && set "SERVICE_RUNNING=1"
)
if !SERVICE_RUNNING! equ 0 (
    echo 正在启动Ollama服务...
    start "Ollama Service" /MIN "%OLLAMA_EXE%" serve
    timeout /t 5 /nobreak >nul
    net start Ollama 2>nul
)

REM 尝试下载模型，支持超时重试
set "RETRY_COUNT=3"
set "RETRY_DELAY=5"
set "MAX_TIMEOUT=300"  REM 5分钟超时

for /l %%i in (1,1,!RETRY_COUNT!) do (
    echo 尝试下载模型（第 %%i 次）...
    echo 此过程可能需要较长时间，请耐心等待...
    
    REM 使用PowerShell执行模型下载并设置超时
    powershell -Command "$env:OLLAMA_MODELS='!OLLAMA_MODELS!'; $job = Start-Job -ScriptBlock { & '%OLLAMA_EXE%' pull '%MODEL_NAME%' }; if (Wait-Job -Job $job -Timeout !MAX_TIMEOUT!) { Receive-Job -Job $job; exit $LASTEXITCODE } else { Stop-Job -Job $job; Write-Host '下载超时'; exit 1 }"
    
    if !errorlevel! equ 0 (
        echo 模型 %MODEL_NAME% 下载安装成功！
        exit /b 0
    )
    
    if %%i lss !RETRY_COUNT! (
        echo 下载失败，!RETRY_DELAY!秒后重试...
        timeout /t !RETRY_DELAY! /nobreak >nul
        set /a "RETRY_DELAY*=2"  REM 指数退避
    )
)

echo 错误：模型 %MODEL_NAME% 下载失败，请检查网络连接或手动安装

echo 您可以手动运行以下命令安装模型：
if not "%CUSTOM_MODEL_PATH%"=="" (
    echo   set OLLAMA_MODELS=%CUSTOM_MODEL_PATH%
)
echo   %OLLAMA_EXE% pull %MODEL_NAME%

exit /b 4