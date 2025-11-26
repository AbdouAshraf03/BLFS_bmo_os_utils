#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    
    wget https://anduin.linuxfromscratch.org/BLFS/xdgmime/xdgmime.tar.xz --no-check-certificate

    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/2.4/shared-mime-info-2.4.tar.gz
    echo "✅ the package downloaded successfully"


   echo "🔧 extracting..."
    if ! tar -xf ../xdgmime.tar.xz &&
        make -C xdgmime; then
        echo "❌ Error: extract failed!"
        exit 1
    fi
    mkdir build &&
    cd    build 

    echo "🔧 Running configure..."
    if ! meson setup --prefix=/usr --buildtype=release -D update-mimedb=true ..; then
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
