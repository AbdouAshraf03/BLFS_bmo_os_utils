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

    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://www.libsdl.org/release/SDL2-2.32.8.tar.gz
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr; then
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

    rm -v /usr/lib/libSDL2*.a
    install -v -m755 -d        /usr/share/doc/SDL2-2.32.8/html
    cp -Rv  docs/output/html/* /usr/share/doc/SDL2-2.32.8/html

fi


echo "🎉 FINISHED :)"
