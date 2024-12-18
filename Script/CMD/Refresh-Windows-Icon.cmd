@echo off

@REM 检查权限
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 请以管理员身份运行此脚本！
    pause
    exit /b
)

echo 正在结束 Explorer 进程...
taskkill /f /im explorer.exe
timeout /t 2 /nobreak >nul

echo 正在清理图标缓存...
@REM 清理旧式缓存
attrib -h -s -r "%LocalAppData%\IconCache.db" >nul 2>&1
del /f /q "%LocalAppData%\IconCache.db" >nul 2>&1

@REM 清理图标和缩略图缓存
attrib -h -s -r "%LocalAppData%\Microsoft\Windows\Explorer\*" >nul 2>&1
del /f /q "%LocalAppData%\Microsoft\Windows\Explorer\iconcache_*.db" >nul 2>&1
del /f /q "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1

@REM 清理托盘的图标缓存
reg delete "HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /v IconStreams /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /v PastIconsStream /f >nul 2>&1

@REM 清理“搜索”的图标缓存
del /f /s /q "%LocalAppData%\Packages\Microsoft.Windows.Search_cw5n1h2txyewy\LocalState\AppIconCache\*.*" >nul 2>&1

echo 正在重启 Explorer...
start explorer.exe

pause