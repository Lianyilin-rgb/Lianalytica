// Node.js图片转Base64转换器
// 使用方法: node convert_to_base64.js "E:\lyl-Ollamawebui\logo\logo.jpg"

const fs = require('fs');
const path = require('path');

const imagePath = process.argv[2];

if (!imagePath) {
    console.error('请提供图片路径');
    console.error('使用方法: node convert_to_base64.js "图片路径"');
    process.exit(1);
}

// 检查文件是否存在
if (!fs.existsSync(imagePath)) {
    console.error(`文件不存在: ${imagePath}`);
    process.exit(1);
}

// 获取文件扩展名
const extension = path.extname(imagePath).toLowerCase();

// 映射文件扩展名到MIME类型
const mimeTypes = {
    '.jpg': 'image/jpeg',
    '.jpeg': 'image/jpeg',
    '.png': 'image/png',
    '.gif': 'image/gif',
    '.bmp': 'image/bmp',
    '.webp': 'image/webp'
};

if (!mimeTypes[extension]) {
    console.error(`不支持的图片格式: ${extension}`);
    process.exit(1);
}

const mimeType = mimeTypes[extension];

// 读取文件并转换为Base64
const buffer = fs.readFileSync(imagePath);
const base64String = buffer.toString('base64');

// 构建完整的Base64数据URI
const base64Uri = `data:${mimeType};base64,${base64String}`;

// 输出结果
console.log(`图片路径: ${imagePath}`);
console.log(`MIME类型: ${mimeType}`);
console.log('Base64数据URI:');
console.log(base64Uri);

// 保存到文件
const outputFile = path.join(path.dirname(imagePath), `${path.basename(imagePath, extension)}_base64.txt`);
fs.writeFileSync(outputFile, base64Uri, 'utf8');
console.log(`结果已保存到: ${outputFile}`);
