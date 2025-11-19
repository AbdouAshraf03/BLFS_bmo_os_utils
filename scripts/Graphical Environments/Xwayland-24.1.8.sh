#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://www.x.org/pub/individual/xserver/xwayland-24.1.8.tar.xz
    echo "✅ the package downloaded successfully"

   sed -i '/install_man/,$d' meson.build &&

    mkdir build &&
    cd    build

   echo "🔧 Running configure..."
    if ! meson setup ..              \
            --prefix=$XORG_PREFIX \
            --buildtype=release   \
            -D xkb_output_dir=/var/lib/xkb; then
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

   install -vm755 hw/vfb/Xvfb /usr/bin

fi


echo "🎉 FINISHED :)"