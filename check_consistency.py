import json
import os

def get_key_structure(data, prefix=''):
    """递归获取JSON数据的键结构"""
    structure = set()
    if isinstance(data, dict):
        for key, value in data.items():
            current_path = f"{prefix}.{key}" if prefix else key
            structure.add(current_path)
            structure.update(get_key_structure(value, current_path))
    elif isinstance(data, list):
        for i, item in enumerate(data):
            current_path = f"{prefix}[{i}]" if prefix else f"[{i}]"
            structure.add(current_path)
            structure.update(get_key_structure(item, current_path))
    return structure

def main():
    locales_dir = 'e:/Lianalytica/user/user2/locales'
    language_files = {}
    
    # 读取所有语言文件
    for filename in os.listdir(locales_dir):
        if filename.endswith('.json'):
            lang_code = filename.split('.')[0]
            file_path = os.path.join(locales_dir, filename)
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    language_files[lang_code] = json.load(f)
                print(f'✓ 成功读取 {filename}')
            except Exception as e:
                print(f'✗ 读取 {filename} 失败: {e}')
    
    if not language_files:
        print('没有找到有效的语言文件')
        return
    
    # 获取所有语言的键结构
    structures = {}
    for lang, data in language_files.items():
        structures[lang] = get_key_structure(data)
    
    # 找到所有语言共有的键
    all_keys = set()
    for keys in structures.values():
        all_keys.update(keys)
    
    print(f'\n所有语言文件中共有 {len(all_keys)} 个键')
    
    # 检查每个语言文件是否包含所有键
    print('\n检查每个语言文件的完整性:')
    for lang, keys in structures.items():
        missing_keys = all_keys - keys
        if missing_keys:
            print(f'✗ {lang}.json 缺失 {len(missing_keys)} 个键: {missing_keys}')
        else:
            print(f'✓ {lang}.json 包含所有键')
    
    # 检查是否有额外的键
    print('\n检查每个语言文件是否有额外的键:')
    for lang, keys in structures.items():
        extra_keys = keys - all_keys
        if extra_keys:
            print(f'⚠️  {lang}.json 有 {len(extra_keys)} 个额外的键: {extra_keys}')
        else:
            print(f'✓ {lang}.json 没有额外的键')

if __name__ == '__main__':
    main()
