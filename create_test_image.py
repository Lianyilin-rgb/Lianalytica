from PIL import Image, ImageDraw, ImageFont
import os

# 创建一个简单的测试图像
width, height = 400, 200
background_color = (255, 255, 255)
text_color = (0, 0, 0)

# 创建图像
image = Image.new('RGB', (width, height), background_color)
draw = ImageDraw.Draw(image)

# 设置字体（尝试使用系统默认字体或安装的字体）
try:
    font = ImageFont.truetype('arial.ttf', 24)
except:
    try:
        font = ImageFont.truetype('sans-serif.ttf', 24)
    except:
        font = ImageFont.load_default()

# 添加英文文本
text = "Hello World! This is a test image.\nOCR and translation test."
text_position = (20, 50)
draw.text(text_position, text, fill=text_color, font=font)

# 保存图像
test_image_path = "test_image.jpg"
image.save(test_image_path)

print(f"Test image created at: {os.path.abspath(test_image_path)}")