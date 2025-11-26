#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/flatpak/xdg-dbus-proxy/releases/download/0.1.6/xdg-dbus-proxy-0.1.6.tar.xz
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
        echo "❌ Error: ninja failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! ninja install; then
        echo "❌ Error: ninja-install failed!"
        exit 1
    fi


fi


echo "🎉 FINISHED :)"
