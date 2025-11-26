#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    wget https://ftp.osuosl.org/pub/blfs/conglomeration/ImageMagick/ --no-check-certificate

    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://www.imagemagick.org/archive/releases/ImageMagick-7.1.2-1.tar.xz
    echo "✅ the package downloaded successfully"


   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --enable-hdri     \
            --with-modules    \
            --with-perl       \
            --disable-static; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! make; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! make DOCUMENTATION_PATH=/usr/share/doc/imagemagick-7.1.2 install; then
        echo "❌ Error: make-install failed!"
        exit 1
    fi

fi


echo "🎉 FINISHED :)"
