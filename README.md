由于 [GitHub Gist](https://gist.github.com/) 的浏览视图不太好用, 所以干脆用一个普通 Repo 当作 Public Gists。

**应注意文件的 EOL 是 CRLF 还是 LF, 尤其对于脚本而言。**

```
.
├── README.md
├── Rule
│   └── Clash
│       └── downloader.yaml
├── Script
│   ├── Bash
│   │   ├── Aria2-UpdateTracker.sh      # 更新 BT Tracker 地址到 aria2.conf 中
│   │   ├── Git-Batch.sh                # 批量操作当前目录下的 Git 仓库
│   │   ├── Git-Reinitialize.sh         # 重新初始化 Git 仓库
│   │   ├── Output-Recursively.sh       # 递归输出文件夹名称和文件路径到指定文件
│   ├── CMD
│   │   ├── IAS.cmd                     # https://github.com/WindowsAddict/IDM-Activation-Script
│   │   ├── MAS_AIO.cmd                 # https://github.com/massgravel/Microsoft-Activation-Scripts/
│   │   └── Refresh-Windows-Icon.cmd    # 刷新 Windows 系统缩略图缓存
│   ├── PowerShell
│   │   ├── Change-Edge-Region.ps1      # 修改 Edge 浏览器的地区以使用 Copilot
│   │   ├── Git-Reinitialize.ps1        # 重新初始化 Git 仓库
│   │   └── HashCheck.ps1               # 列出一个文件夹或两个文件夹中所有文件的哈希值, 并高亮显示相同的哈希值
│   └── Python
│       └── LyricsConvert               # 两种歌词格式的相互转换, https://senzyo.net/2023-8/
│           ├── A2B.py
│           └── B2A.py
└── Website
    ├── FreeVideoAPI        # 几个尚且能用的解析国内 VIP 视频的 API
    ├── SiteBuilding.html   # “网站正在建设”页面
    └── SiteProxy
        └── worker.js       # 代理任何网站, https://senzyo.net/2024-6
```