#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    wget https://downloads.sourceforge.net/sourceforge/libpng-apng/libpng-1.6.47-apng.patch.gz --no-check-certificate 
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://downloads.sourceforge.net/libpng/libpng-1.6.50.tar.xz
    echo "✅ the package downloaded successfully"

    gzip -cd ../libpng-1.6.47-apng.patch.gz | patch -p1

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr --disable-static ; then
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

    mkdir -v /usr/share/doc/libpng-1.6.50 &&
    cp -v README libpng-manual.txt /usr/share/doc/libpng-1.6.50

fi


echo "🎉 FINISHED :)"