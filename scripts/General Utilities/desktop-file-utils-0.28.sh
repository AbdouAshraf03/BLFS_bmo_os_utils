#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://www.freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-0.28.tar.xz
    echo "✅ the package downloaded successfully"

    mkdir build &&
    cd    build 


   echo "🔧 Running configure..."
    if ! meson setup --prefix=/usr --buildtype=release ..; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! ninja; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! ninja install; then
        echo "❌ Error: ninja-install failed!"
        exit 1
    fi

    install -vdm755 /usr/share/applications &&
    update-desktop-database /usr/share/applications

fi


echo "🎉 FINISHED :)"
