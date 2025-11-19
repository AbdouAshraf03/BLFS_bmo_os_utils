#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://download.gimp.org/pub/babl/0.1/babl-0.1.114.tar.xz
    echo "✅ the package downloaded successfully"

    mkdir bld 
    cd bld 
   echo "🔧 Running configure..."
    if ! meson setup --prefix=/usr --buildtype=release ..; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! ninja ; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! ninja install; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    install -v -m755 -d                         /usr/share/gtk-doc/html/babl/graphics 
    install -v -m644 docs/*.{css,html}          /usr/share/gtk-doc/html/babl          
    install -v -m644 docs/graphics/*.{html,svg} /usr/share/gtk-doc/html/babl/graphics

fi


echo "🎉 FINISHED :)"