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

    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://github.com/lfs-book/faac/archive/v1.31.1/faac-1.31.1.tar.gz
    echo "✅ the package downloaded successfully"

   ./bootstrap

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr --disable-static>; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! make; then
        echo "❌ Error: make failed!"
        exit 1
    fi
     
    ./frontend/faac -o Front_Left.mp4 /usr/share/sounds/alsa/Front_Left.wav
    faad Front_Left.mp4
    aplay Front_Left.wav

    echo "⚙️ installing..."
    if ! make install; then
        echo "❌ Error: make failed!"
        exit 1
    fi

   # <ETC>

fi


echo "🎉 FINISHED :)"
