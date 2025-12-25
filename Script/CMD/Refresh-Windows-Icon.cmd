@echo off

taskkill /f /im explorer.exe

@REM 清理系统图标缓存数据库

attrib -h -s -r "%UserProfile%\AppData\Local\IconCache.db"

del /f/q "%UserProfile%\AppData\Local\IconCache.db"

attrib /s /d -h -s -r "%UserProfile%\AppData\Local\Microsoft\Windows\Explorer\*"

del /f/q "%UserProfile%\AppData\Local\Microsoft\Windows\Explorer\thumbcache_32.db"
del /f/q "%UserProfile%\AppData\Local\Microsoft\Windows\Explorer\thumbcache_96.db"
del /f/q "%UserProfile%\AppData\Local\Microsoft\Windows\Explorer\thumbcache_102.db"
del /f/q "%UserProfile%\AppData\Local\Microsoft\Windows\Explorer\thumbcache_256.db"
del /f/q "%UserProfile%\AppData\Local\Microsoft\Windows\Explorer\thumbcache_1024.db"
del /f/q "%UserProfile%\AppData\Local\Microsoft\Windows\Explorer\thumbcache_idx.db"
del /f/q "%UserProfile%\AppData\Local\Microsoft\Windows\Explorer\thumbcache_sr.db"

@REM 清理系统托盘记忆的图标

echo y | reg delete "HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /v IconStreams
echo y | reg delete "HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /v PastIconsStream

start explorer