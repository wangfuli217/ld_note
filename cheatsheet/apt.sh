apt-get()
{
apt-get(8) 用于所有的命令行操作，包含软件包的安装、移除和升级。

apt                 高级软件包工具(APT), dpkg 的前端，提供了 “http” 、“ftp” 和 “file” 的档案库访问方式
                    (包含apt-get 和 apt-cache 命令)
aptitude            基于终端的交互式软件包管理工具 
tasksel             Debian 系统上对安装进行选择的工具（APT 的前端）
unattended-upgrades 用于 APT 的增强软件包，会自动安装安全更新
dpkg                用于 Debian 的软件包管理系统
synaptic            图像化的软件包管理工具（GNOME 的 APT 前段）
apt-listchanges     软件包历史更改提醒工具
apt-listbugs        在每次 APT 安装前列出严重的 bug
apt-file            APT 软件包搜索工具 —— 命令行界面
apt-rdepends        递归列出软件包依赖

apt-get 和 apt-cache 只提供命令行用户界面。
apt-get 是进行跨版本的主系统升级等操作的最合适工具。
apt-get 提供了一个强大的软件包依赖解析器。
apt-get 对硬件资源的要求不高。它消耗更少的内存并且运行速度更快。
apt-cache 提供了一个 标准的正则表达式来搜索软件包名称和描述。
apt-get 和 apt-cache 可以使用 etc/apt/preferences 来管理软件包的多个版本，但这非常繁琐。

}
aptitude()
{
aptitude(8) 使用一个交互式的文本界面来管理已安装的软件包和搜索可用的软件包。
aptitude 命令是最通用的基于 APT 的软件包管理工具。
aptitude 提供了一个全屏的交互式文本用户界面。
aptitude 同样也提供了一个命令用户界面。
aptitude 是用于日常软件包管理（例如检查已安装的软件包和搜索可用的软件包）的最合适工具。
aptitude 对硬件资源的要求更高。它消耗更多的内存并且运行速度更慢。
aptitude 提供一个增强的正则表达式来搜索所有的软件包元数据。
aptitude 可以管理软件包的多个版本，并且不使用 /etc/apt/preferences，这会十分直观。
}

aptitude 语法              apt-get / apt-cache 语法          说明
aptitude update            apt-get update              更新软件包档案库元数据
aptitude install foo       apt-get install foo         安装 “foo” 软件包的候选版本以及它的依赖
aptitude safe-upgrade      apt-get upgrade             安装已安装的软件包的候选版本并且不移除任何其它的软件包
aptitude full-upgrade      apt-get dist-upgrade        安装已安装的软件包的候选版本，并且需要的话会移除其它的软件包
aptitude remove foo        apt-get remove foo          移除 “foo” 软件包，但留下配置文件
N/A                        apt-get autoremove          移除不再需要的自动安装的软件包
aptitude purge foo         apt-get purge foo           清除 “foo” 软件包的配置文件
aptitude clean             apt-get clean               完全清除本地仓库的软件包检索文件
aptitude autoclean         apt-get autoclean           清除本地仓库中过时软件包的软件包检索文件
aptitude show foo          apt-cache show foo          显示 “foo” 软件包的详细信息
aptitude search <regex>    apt-cache search <regex>    搜索匹配 <regex> 的软件包
aptitude why <regex>        N/A                        解释匹配 <regex> 的软件包必须被安装的原因
aptitude why-not <regex>    N/A                        解释匹配 <regex> 的软件包不必安装的原因
aptitude search 'i!M'      apt-mark showmanual         列出手动安装的软件包

apt-file search <file_name_pattern> 	列出档案库中匹配文件名的软件包
apt-file list <package_name_pattern> 	列出档案库中匹配的软件包的内容

dpkg(查看软件xxx安装内容){dpkg -L xxx}

aptitude(查找软件库中的软件)
{
apt-cache search 正则表达式
或
aptitude search 软件包
}


apt(软件包维护)
{
apt-get update - 在你更改了/etc/apt/sources.list 或 /etc/apt/preferences 后，需要运行这个命令以令改动生效。同时也要定期运行该命令，以确保你的源列表是最新的。该命令等价于新立得软件包管理器中的“刷新”，或者是 Windows和OS X 下的 Adept 软件包管理器的 “check for updates”。
apt-get upgrade - 更新所有已安装的软件包。类似一条命令完成了新立得软件包管理器中的“标记所有软件包以便升级”并且“应用”。
apt-get dist-upgrade - 更新整个系统到最新的发行版。等价于在新立得软件包管理器中“标记所有更新”，并在首选项里选择“智能升级” -- 这是告诉APT更新到最新包，甚至会删除其他包（注：不建议使用这种方式更新到新的发行版）。
apt-get -f install -- 等同于新立得软件包管理器中的“编辑->修正（依赖关系）损毁的软件包”再点击“应用。如果提示“unmet dependencies”的时候，可执行这行命令。
apt-get autoclean - 如果你的硬盘空间不大的话，可以定期运行这个程序，将已经删除了的软件包的.deb安装文件从硬盘中删除掉。如果你仍然需要硬盘空间的话，可以试试apt-get clean，这会把你已安装的软件包的安装包也删除掉，当然多数情况下这些包没什么用了，因此这是个为硬盘腾地方的好办法。
apt-get clean 类似上面的命令，但它删除包缓存中的所有包。这是个很好的做法，因为多数情况下这些包没有用了。但如果你是拨号上网的话，就得重新考虑了。
包缓存的路径为/var/cache/apt/archives，因此，du -sh /var/cache/apt/archives将告诉你包缓存所占用的硬盘空间。
dpkg-reconfigure foo - 重新配置“foo”包。这条命令很有用。当一次配置很多包的时候， 要回答很多问题，但有的问题事先并不知道。例如，dpkg-reconfigure fontconfig-config，在Ubuntu系统中显示字体配置向导。每次我安装完一个 Ubuntu 系统，我都会运行这行命令，因为我希望位图字体在我的所有应用程序上都有效。
echo "foo hold" | dpkg --set-selections - 设置包“foo”为hold，不更新这个包，保持当前的版本，当前的状态，当前的一切。类似新立得软件包管理器中的“软件包->锁定版本”。
注： apt-get dist-upgrade 会覆盖上面的设置，但会事先提示。 另外，你必须使用 sudo。输入命令echo "foo hold" | sudo dpkg --set-selections而不是sudo echo "foo hold" | dpkg --set-selections
echo "foo install" | sudo dpkg --set-selections
apt-show-versions -u apt-show-versions工具可以告诉你系统中哪些包可以更新以及其它 一些有用的信息。-u选项可以显示可更新软件包列表,这个工具默认没有安装，但是每次update完了以后，用这个工具看看非常方便，值得一装。

}

apt(软件包删除)
{
apt-get remove 软件包名称 - 删除已安装的软件包（保留配置文件）
apt-get --purge remove 软件包名称 - 删除已安装包（不保留配置文件）
特别技巧：如果你想在删除‘foo’包同时安装‘bar’： apt-get --purge remove foo bar+。
apt-get autoremove - 删除为了满足其他软件包的依赖而安装的，但现在不再需要的软件包。
}

apt(软件包搜索)
{
apt-cache search foo - 搜索和"foo"匹配的包。
apt-cache show foo - 显示"foo"包的相关信息，例如描述、版本、大小、依赖以及冲突。
dpkg --print-avail 软件包名称 - 与上面类似。
dpkg -l *foo* - 查找包含有"foo"字样的包。与apt-cache show foo类似，但是还会显示每个包是安装了还是没安装。
dpkg -l package-name-pattern - 列出名为package-name-pattern的软件包。除非你知道软件包的正确全称，否则可以使用“*package-name-pattern*”.
dpkg -L foo - 显示名为“foo”的包都安装了哪些文件以及它们的路径，很有用的命令。
dlocate foo - 在已安装的包中搜索“foo”的文件。对于回答“这个文件来源于哪个包”这个问题，是非常实用的。dlocate是一个软件包，必须安装它才能使用本命令。
dpkg -S foo - 和上面的命令一样，但相比更慢一些。他只能在Debian或Ubuntu系统下运行。另外，不需要安装dlocate包。
apt-file search foo - 类似dlocate和dpkg -S，但搜索所有有效软件包，不单单只是你系统上的已安装的软件包。-- 它所回答的问题是“哪些软件包提供这些文件”。你必须安装有apt-file软件包，并且确保apt-file数据库是最新的。
dpkg -c foo.deb - “foo.deb”包含有哪些文件？注：foo.deb是含路径的文件名。-- 这个是针对你自己下载的.deb包。
apt-cache dumpavail - 显示所有可用软件包，以及它们各自的详细信息（会产生很多输出）。
apt-cache show 软件包名称 - 显示软件包记录，类似dpkg --print-avail 软件包名称。
apt-cache pkgnames - 快速列出已安装的软件包名称。
apt-file search filename - 查找包含特定文件的软件包（不一定是已安装的），这些文件的文件名中含有指定的字符串。apt-file是一个独立的软件包。您必须先使用 apt-get install 来安装它，然后运行 apt-file update。如果 apt-file search filename 输出的内容太多，您可以尝试使用 apt-file search filename | grep -w filename（只显示指定字符串作为完整的单词出现在其中的那些文件名）或者类似方法，例如：apt-file search filename | grep /bin/（只显示位于诸如/bin或/usr/bin这些文件夹中的文件，如果您要查找的是某个特定的执行文件的话，这样做是有帮助的）。

}


apt-cache search # ------(package 搜索包)
apt-cache show #------(package 获取包的相关信息，如说明、大小、版本等)
sudo apt-get install # ------(package 安装包)
sudo apt-get install # -----(package - - reinstall 重新安装包)
sudo apt-get -f install # -----(强制安装?#"-f = --fix-missing"当是修复安装吧...)
sudo apt-get remove #-----(package 删除包)
sudo apt-get remove - - purge # ------(package 删除包，包括删除配置文件等)
sudo apt-get autoremove --purge # ----(package 删除包及其依赖的软件包+配置文件等（只对6.10有效，强烈推荐）)
sudo apt-get update #------更新源
sudo apt-get upgrade #------更新已安装的包
sudo apt-get dist-upgrade # ---------升级系统
sudo apt-get dselect-upgrade #------使用 dselect 升级
apt-cache depends #-------(package 了解使用依赖)
apt-cache rdepends # ------(package 了解某个具体的依赖?#当是查看该包被哪些包依赖吧...)
sudo apt-get build-dep # ------(package 安装相关的编译环境)
apt-get source #------(package 下载该包的源代码)
sudo apt-get clean && sudo apt-get autoclean # --------清理下载文件的存档 && 只清理过时的包
sudo apt-get check #-------检查是否有损坏的依赖
