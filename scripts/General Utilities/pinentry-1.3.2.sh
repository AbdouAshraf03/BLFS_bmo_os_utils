#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-1.3.2.tar.bz2
    echo "✅ the package downloaded successfully"


   echo "🔧 make configure consistent with fltk-1.4.1..."
    if ! sed -i "/FLTK 1/s/3/4/" configure   &&
        sed -i '14456 s/1.3/1.4/' configure; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr          \
            --enable-pinentry-tty; then
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
