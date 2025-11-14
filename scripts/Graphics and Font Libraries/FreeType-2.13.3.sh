#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
     wget https://downloads.sourceforge.net/freetype/freetype-doc-2.13.3.tar.xz --no-check-certificate
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://downloads.sourceforge.net/freetype/freetype-2.13.3.tar.xz
    echo "✅ the package downloaded successfully"

tar -xf ../freetype-doc-2.13.3.tar.xz --strip-components=2 -C docs

sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg &&

sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
    -i include/freetype/config/ftoption.h 

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr --enable-freetype-config --disable-static; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! make; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! make install; then
        echo "❌ Error: make failed!"
        exit 1
    fi

   # <ETC>

fi


echo "🎉 FINISHED :)"