由于 [GitHub Gist](https://gist.github.com/) 的浏览视图不太好用, 所以干脆用一个普通 Repo 当作 Public Gists。

**应注意文件的 EOL 是 CRLF 还是 LF, 尤其对于脚本而言。**

```
.
├── README.md
├── Rule
│   └── OpenAI
│       ├── OpenAI.list     # 用于 subconverter 的规则集
│       └── OpenAI.yaml     # 用于 clash 的规则集
├── Script
│   ├── Bash
│   │   ├── Git-Reinitialize.sh     # 重新初始化 Git 仓库
│   │   ├── Git-Batch.sh            # 批量操作当前目录下的 Git 仓库
│   │   └── UpdateTracker-Aria2.sh  # 更新 BT Tracker 地址到 aria2.conf 中。https://github.com/P3TERX/aria2.conf/blob/master/tracker.md
│   ├── CMD
│   │   └── MAS_AIO.cmd             # https://github.com/massgravel/Microsoft-Activation-Scripts/
│   ├── JavaScript
│   │   └── XiaomiCloudNotes        # 从网页版的小米便签中导出所有数据, https://www.zhihu.com/question/35329107/answer/2726573615
│   │       ├── ExtractData.js
│   │       └── GenerateHTML.js
│   ├── PowerShell
│   │   ├── Git-Reinitialize.ps1    # 重新初始化 Git 仓库
│   │   └── HashCheck.ps1           # 列出一个文件夹或两个文件夹中所有文件的哈希值, 并高亮显示相同的哈希值
│   └── Python
│       └── LyricsConvert   # 两种歌词格式的相互转换, https://senzyo.net/2023-8/
│           ├── A2B.py
│           └── B2A.py
└── Website
    ├── FreeVideoAPI        # 几个尚且能用的解析国内 VIP 视频的 API
    └── SiteBuilding.html   # “网站正在建设”页面
```