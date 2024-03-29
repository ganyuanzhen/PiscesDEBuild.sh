#!/bin/bash
set -e

echo '欢迎使用灵墨OS自动编译脚本!'
echo '提示: 使用前请确认已经安装了所有必要的依赖。'

if test -e ~/LingmoOS
then
  echo '存在同名的LingmoOS文件夹，正在删除...'
  rm -rf ~/LingmoOS
fi
echo '创建新的LingmoOS文件夹...'
mkdir ~/LingmoOS

# 定义一个函数来编译项目
function Compile() {
    repo_name=$1
    echo "开始编译 $repo_name ..."
    cd ~/LingmoOS
    if test -d $repo_name; then
        echo "已存在 $repo_name 目录，更新中..."
        cd $repo_name && git pull
    else
        echo "正在克隆 $repo_name ..."
        git clone https://github.com/LingmoOS/$repo_name.git
        cd $repo_name
    fi
    echo "正在安装 $repo_name 依赖..."
    # 在这里添加项目的依赖安装代码
    mk-build-deps -i -t "apt-get --yes" -r
    echo "构建 $repo_name ..."
    dpkg-buildpackage -b -uc -us -tc -j$(nproc)
    # 在这里添加项目构建和编译命令
    echo "$repo_name 编译完成"
}

echo '开始安装依赖'
apt install git  devscripts equivs
git clone https://github.com/LingmoOS/LingmoOSBuildDeps.git
cd LingmoOSBuildDeps
mk-build-deps -i -t "apt-get -y" -r

REPOS="lingmo-screenlocker lingmo-settings lingmo-screenshots lingmo-cursor-themes lingmo-sddm-theme lingmo-appmotor lingmo-neofetch lingmo-daemon lingmo-ocr lingmo-terminal lingmo-gtk-themes LingmoUI lingmo-systemicons lingmo-wallpapers lingmo-debinstaller lingmo-calculator lingmo-system-build lingmo-windows-plugins lingmo-launcher lingmo-kwin lingmo-kernel lingmo-statusbar lingmo-qt-plugins lingmo-dock lingmo-system-core liblingmo lingmo-filemanager lingmo-core lingmo-texteditor lingmo-kwin-plugins lingmo-videoplayer"

# 列出所有项目供用户选择
select project in \
lingmo-screenlocker \
lingmo-settings \
lingmo-screenshots \
lingmo-cursor-themes \
lingmo-sddm-theme \
lingmo-appmotor \
lingmo-neofetch \
lingmo-daemon \
lingmo-ocr \
lingmo-terminal \
lingmo-gtk-themes \
LingmoUI \
lingmo-systemicons \
lingmo-wallpapers \
lingmo-debinstaller \
lingmo-calculator \
lingmo-system-build \
lingmo-windows-plugins \
lingmo-launcher \
lingmo-kwin \
lingmo-kernel \
lingmo-statusbar \
lingmo-qt-plugins \
lingmo-dock \
lingmo-system-core \
liblingmo \
lingmo-filemanager \
lingmo-core \
lingmo-texteditor \
lingmo-kwin-plugins \
lingmo-videoplayer \
all \
quit

do
    if [[ $project == "all" ]]; then
        for repo in $REPOS; do
            Compile $repo
        done
    elif [[ $project == "quit" ]]; then
        break
    else
        Compile $project
    fi
done
