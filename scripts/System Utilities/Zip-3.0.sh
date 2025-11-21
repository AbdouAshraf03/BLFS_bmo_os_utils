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
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://downloads.sourceforge.net/infozip/zip30.tar.gz
    echo "✅ the package downloaded successfully"


    echo "⚙️  Running make..."
    if ! make -f unix/Makefile generic CC="gcc -std=gnu89"; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! make prefix=/usr MANDIR=/usr/share/man/man1 -f unix/Makefile install; then
        echo "❌ Error: make failed!"
        exit 1
    fi
fi


echo "🎉 FINISHED :)"
