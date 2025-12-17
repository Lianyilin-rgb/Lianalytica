# -*- mode: python ; coding: utf-8 -*-

import os
block_cipher = None

# 添加所有模型文件
model_files = [
    ('models/audio_processor_pro.gguf', 'models'),
    ('models/code_analyzer_pro.gguf', 'models'),
    ('models/deepseek_r1_671b.gguf', 'models'),
    ('models/image_processor_pro.gguf', 'models'),
    ('models/model_config.json', 'models'),
    ('models/text_processor_ultra.gguf', 'models')
]

# 添加所有本地化文件
locale_files = [
    ('locales/en.json', 'locales'),
    ('locales/zh-CN.json', 'locales')
]

# 添加其他资源文件
resource_files = [
    ('index.html', '.'),
    ('软件logo和启动logo.jpg', '.'),
    ('user_guides', 'user_guides'),
    ('install_ollama.bat', '.')
]

a = Analysis(['main.py'],
             pathex=['E:/Lianalytica/user/user2'],
             binaries=[],
             datas=model_files + locale_files + resource_files,
             hiddenimports=['flask', 'llama_cpp', 'i18n', 'threading', 'os', 'json', 'base64', 'time', 'psutil', 'platform', 'subprocess', 'signal'],
             hookspath=[],
             hooksconfig={},
             runtime_hooks=[],
             excludes=[],
             win_no_prefer_redirects=False,
             win_private_assemblies=False,
             cipher=block_cipher,
             noarchive=False)

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(pyz,
          a.scripts,
          [],
          exclude_binaries=True,
          name='audio_processor_pro',
          debug=False,
          bootloader_ignore_signals=False,
          strip=False,
          upx=True,
          upx_exclude=[],
          runtime_tmpdir=None,
          console=True,
          disable_windowed_traceback=False,
          target_arch=None,
          codesign_identity=None,
          entitlements_file=None )

coll = COLLECT(exe,
               a.binaries,
               a.zipfiles,
               a.datas,
               strip=False,
               upx=True,
               upx_exclude=[],
               name='audio_processor_pro')
