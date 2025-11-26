#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://download.gnome.org/sources/gdk-pixbuf/2.42/gdk-pixbuf-2.42.12.tar.xz
    echo "✅ the package downloaded successfully"

   mkdir build &&
    cd    build

   echo "🔧 Running configure..."
    if !meson setup ..            \
              --prefix=/usr       \
              --buildtype=release \
              -D others=enabled   \
              --wrap-mode=nofallback; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! ninja; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    sed "/docs_dir =/s@\$@ / 'gdk-pixbuf-2.42.12'@" -i ../docs/meson.build
    
    echo "🔧 Running configure..."
    if !meson configure -D gtk_doc=true ; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

 echo "⚙️  Running make..."
    if ! ninja; then
        echo "❌ Error: make failed!"
        exit 1
    fi

    echo "⚙️ installing..."
    if ! ninja install; then
        echo "❌ Error: make failed!"
        exit 1
    fi

   # <ETC>

fi


echo "🎉 FINISHED :)"