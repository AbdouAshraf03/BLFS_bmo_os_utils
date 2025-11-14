#!/bin/bash 

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
     
    
    # wget <LINK> --no-check-certificate

    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://downloads.sourceforge.net/gmerlin/gavl-1.4.0.tar.gz
    echo "✅ the package downloaded successfully"

   sed -i "/stdio/a #include <string.h>" src/fill_test.c

   echo "🔧 Running configure..."
    if ! LIBS=-lm                         \
         ./configure --prefix=/usr        \
            --without-doxygen    \
            --with-cpuflags=none \
            --docdir=/usr/share/doc/gavl-1.4.0; then
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
