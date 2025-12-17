import base64
import sys

# 检查命令行参数
if len(sys.argv) != 2:
    print("用法: python convert_to_base64.py <图片文件路径>")
    sys.exit(1)

# 获取图片文件路径
image_path = sys.argv[1]

# 获取文件扩展名
extension = image_path.split('.')[-1].lower()
if extension == 'jpg':
    extension = 'jpeg'  # MIME类型使用jpeg而不是jpg

# 转换为base64
with open(image_path, 'rb') as image_file:
    base64_bytes = base64.b64encode(image_file.read())
    base64_string = base64_bytes.decode('utf-8')

# 生成data URI
data_uri = f"data:image/{extension};base64,{base64_string}"

# 输出结果
print("=== Base64 Data URI ===")
print(data_uri)
print("\n=== HTML Img Tag ===")
print(f'<img src="{data_uri}" alt="Image">')
print("\n=== CSS Background ===")
print(f'background-image: url("{data_uri}");')

# 保存到文件
output_file = image_path.replace(f'.{extension}', '_base64.txt')
with open(output_file, 'w', encoding='utf-8') as f:
    f.write("=== Base64 Data URI ===\n")
    f.write(data_uri)
    f.write("\n\n=== HTML Img Tag ===\n")
    f.write(f'<img src="{data_uri}" alt="Image">\n')
    f.write("\n=== CSS Background ===\n")
    f.write(f'background-image: url("{data_uri}");\n')

print(f"\n结果已保存到: {output_file}")