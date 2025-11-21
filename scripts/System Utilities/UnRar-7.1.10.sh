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
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://www.rarlab.com/rar/unrarsrc-7.1.10.tar.gz
    echo "✅ the package downloaded successfully"


    echo "⚙️  Running make..."
    if ! make -f makefile; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    

    install -v -m755 unrar /usr/bin

fi


echo "🎉 FINISHED :)"
