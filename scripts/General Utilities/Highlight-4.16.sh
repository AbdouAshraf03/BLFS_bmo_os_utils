#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh http://www.andre-simon.de/zip/highlight-4.16.tar.bz2
    echo "✅ the package downloaded successfully"

    sed -i '/GZIP/s/^/#/' makefile

    echo "⚙️  Running make..."
    if ! make; then
        echo "❌ Error: make failed!"
        exit 1
    fi

     echo "⚙️  building make..."
    if ! make doc_dir=/usr/share/doc/highlight-4.16/ gui; then
        echo "❌ Error: building failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! make doc_dir=/usr/share/doc/highlight-4.16/ install; then
        echo "❌ Error: install failed!"
        exit 1
    fi


    echo "⚙️  installing..."
    if ! make install-gui; then
        echo "❌ Error: make-install failed!"
        exit 1
    fi


fi


echo "🎉 FINISHED :)"
