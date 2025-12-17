# 图片转Base64转换器
# 使用方法: powershell -ExecutionPolicy Bypass -File convert_to_base64.ps1 "E:\lyl-Ollamawebui\logo\logo.jpg"

$ImagePath = $args[0]

# 检查文件是否存在
if (-not (Test-Path $ImagePath)) {
    Write-Error "文件不存在: $ImagePath"
    Exit 1
}

# 获取文件扩展名
$extension = [System.IO.Path]::GetExtension($ImagePath).ToLower()

# 映射文件扩展名到MIME类型
$mimeTypes = @{
    ".jpg" = "image/jpeg"
    ".jpeg" = "image/jpeg"
    ".png" = "image/png"
    ".gif" = "image/gif"
    ".bmp" = "image/bmp"
    ".webp" = "image/webp"
}

if (-not $mimeTypes.ContainsKey($extension)) {
    Write-Error "不支持的图片格式: $extension"
    Exit 1
}

$mimeType = $mimeTypes[$extension]

# 读取文件并转换为Base64
$bytes = [System.IO.File]::ReadAllBytes($ImagePath)
$base64String = [System.Convert]::ToBase64String($bytes)

# 构建完整的Base64数据URI
$base64Uri = "data:$mimeType;base64,$base64String"

# 输出结果
Write-Host "图片路径: $ImagePath"
Write-Host "MIME类型: $mimeType"
Write-Host "Base64数据URI:"
Write-Host $base64Uri

# 保存到文件
$outputFile = "$([System.IO.Path]::GetDirectoryName($ImagePath))\$([System.IO.Path]::GetFileNameWithoutExtension($ImagePath))_base64.txt"
$base64Uri | Out-File -FilePath $outputFile -Encoding UTF8
Write-Host "结果已保存到: $outputFile"
