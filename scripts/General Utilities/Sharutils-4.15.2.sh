#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else

    wget https://www.linuxfromscratch.org/patches/blfs/12.4/sharutils-4.15.2-consolidated-1.patch --no-check-certificate

    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://ftp.gnu.org/gnu/sharutils/sharutils-4.15.2.tar.xz
    echo "✅ the package downloaded successfully"

    echo "🔧 fixing..."
    if ! patch -Np1 -i ../sharutils-4.15.2-consolidated-1.patch; then
        echo "❌ Error: fix failed!"
        exit 1
    fi

    autoreconf -fiv

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr --disable-dependency-tracking; then
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
        echo "❌ Error: make-install failed!"
        exit 1
    fi


fi


echo "🎉 FINISHED :)"
