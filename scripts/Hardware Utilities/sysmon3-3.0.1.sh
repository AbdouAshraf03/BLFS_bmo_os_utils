#!/bin/bash
# set -E
# trap 'echo "❌ Error: command failed at line $LINENO"; exit 1' ERR

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/lfs-book/sysmon3/releases/download/sysmon3-3.0.1/sysmon3-3.0.1.tar.xz
    echo "✅ the package downloaded successfully"

        echo "⚙️  Running make..."
    if ! qmake sysmon3.pro; then
        echo "❌ Error: make failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! make; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    

install -vm755 sysmon3 /usr/bin

fi


echo "🎉 FINISHED :)"
