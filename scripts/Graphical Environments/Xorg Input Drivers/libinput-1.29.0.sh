#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://gitlab.freedesktop.org/libinput/libinput/-/archive/1.29.0/libinput-1.29.0.tar.gz
    echo "✅ the package downloaded successfully"

   mkdir build &&
    cd    build

   echo "🔧 Running configure..."
    if ! meson setup ..              \
            --prefix=$XORG_PREFIX \
            --buildtype=release   \
            -D debug-gui=false    \
            -D tests=false        \
            -D libwacom=false     \
            -D udev-dir=/usr/lib/udev; then
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
        echo "❌ Error: make failed!"
        exit 1
    fi

    install -v -dm755      /usr/share/doc/libinput-1.29.0/html &&
    cp -rv Documentation/* /usr/share/doc/libinput-1.29.0/html

fi


echo "🎉 FINISHED :)"