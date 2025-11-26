#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    wget https://github.com/fltk/fltk/releases/download/release-1.4.4/fltk-1.4.4-docs-html.tar.gz --no-check-certificate
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/fltk/fltk/releases/download/release-1.4.4/fltk-1.4.4-source.tar.gz
    echo "✅ the package downloaded successfully"

   sed -i -e '/cat./d' documentation/Makefile &&

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr --enable-shared; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! make; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! make docdir=/usr/share/doc/fltk-1.4.4 install; then
        echo "❌ Error: make failed!"
        exit 1
    fi

    rm -vf /usr/lib/libfltk*.a
q
    tar -C /usr/share/doc/fltk-1.4.4 --strip-components=4 -xf ../fltk-1.4.4-docs-html.tar.gz

fi


echo "🎉 FINISHED :)"