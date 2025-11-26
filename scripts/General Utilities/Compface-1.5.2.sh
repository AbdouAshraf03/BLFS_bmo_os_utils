#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://anduin.linuxfromscratch.org/BLFS/compface/compface-1.5.2.tar.gz
    echo "✅ the package downloaded successfully"

   echo "🔧 first test..."
    if ! autoreconf; then
        echo "❌ Error: first-test failed!"
        exit 1
    fi


     echo "🔧 next test..."
    if ! sed -e '/compface.h/a #include <unistd.h>' \
        -i cmain.c                             \
        -i uncmain.c; then
        echo "❌ Error:  next-test failed!"
        exit 1
    fi


    echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr --mandir=/usr/share/man; then
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

    install -m755 -v xbm2xface.pl /usr/bin

fi


echo "🎉 FINISHED :)"
