#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://libopenraw.freedesktop.org/download/exempi-2.6.6.tar.xz
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>

    sed -i -r '/^\s?testadobesdk/d' exempi/Makefile.am &&
    autoreconf -fiv

    echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr --disable-static; then
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
