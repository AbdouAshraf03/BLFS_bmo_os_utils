#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://download.gnome.org/sources/gtk-doc/1.34/gtk-doc-1.34.0.tar.xz
    echo "✅ the package downloaded successfully"

    mkdir -p build &&
    cd       build

   echo "🔧 Running configure..."
    if ! meson setup --prefix=/usr --buildtype=release ..; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running ninja..."
    if ! ninja; then
        echo "❌ Error: ninja failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! ninja install; then
        echo "❌ Error: ninja-install failed!"
        exit 1
    fi


fi


echo "🎉 FINISHED :)"
