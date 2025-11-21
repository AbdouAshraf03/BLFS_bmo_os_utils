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

    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://www.linuxtv.org/downloads/v4l-utils/v4l-utils-1.30.1.tar.xz
    echo "✅ the package downloaded successfully"

    mkdir build 
    cd    build 


   echo "🔧 Running configure..."
    if ! meson setup ..            \
                --prefix=/usr       \
                --buildtype=release \
                -D gconv=disabled   \
                -D doxygen-doc=disabled; then
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
        exit 1nstal
    fi

    for prog in v4l2gl v4l2grab
    do
        cp -v contrib/test/$prog /usr/bin
    done

fi


echo "🎉 FINISHED :)"
