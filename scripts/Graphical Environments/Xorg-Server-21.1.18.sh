#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    wget  https://www.linuxfromscratch.org/patches/blfs/12.4/xorg-server-21.1.18-tearfree_backport-1.patch --no-check-certificate
    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://www.x.org/pub/individual/xserver/xorg-server-21.1.18.tar.xz
    echo "✅ the package downloaded successfully"

   patch -Np1 -i ../xorg-server-21.1.18-tearfree_backport-1.patch

   mkdir build &&
    cd    build

   echo "🔧 Running configure..."
    if ! meson setup ..              \
            --prefix=$XORG_PREFIX \
            --localstatedir=/var  \
            -D glamor=true        \
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

   mkdir -pv /etc/X11/xorg.conf.d

fi


echo "🎉 FINISHED :)"