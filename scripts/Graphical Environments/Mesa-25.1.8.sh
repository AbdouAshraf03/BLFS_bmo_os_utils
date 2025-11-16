#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    wget https://www.linuxfromscratch.org/patches/blfs/12.4/mesa-add_xdemos-4.patch --no-check-certificate 
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://mesa.freedesktop.org/archive/mesa-25.1.8.tar.xz
    echo "✅ the package downloaded successfully"

    patch -Np1 -i ../mesa-add_xdemos-4.patch
    mkdir build &&
    cd    build

   echo "🔧 Running configure..."
    if ! meson setup ..                 \
      --prefix=$XORG_PREFIX    \
      --buildtype=release      \
      -D platforms=x11,wayland \
      -D gallium-drivers=auto  \
      -D vulkan-drivers=auto   \
      -D valgrind=disabled     \
      -D video-codecs=all      \
      -D libunwind=disabled    ; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! <MAKE>; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! <MAKE_INSTALL>; then
        echo "❌ Error: make failed!"
        exit 1
    fi

   # <ETC>

fi


echo "🎉 FINISHED :)"