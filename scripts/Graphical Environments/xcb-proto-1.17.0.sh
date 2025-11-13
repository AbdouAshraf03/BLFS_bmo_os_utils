#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://xorg.freedesktop.org/archive/individual/proto/xcb-proto-1.17.0.tar.xz
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>

   echo "🔧 Running configure..."
    if ! PYTHON=python3 ./configure $XORG_CONFIG; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    # echo "⚙️  Running make..."
    # if ! <MAKE>; then
    #     echo "❌ Error: make failed!"
    #     exit 1
    # fi
    
    echo "⚙️ installing..."
    if ! make install; then
        echo "❌ Error: make failed!"
        exit 1
    fi

   

fi


echo "🎉 FINISHED :)"
