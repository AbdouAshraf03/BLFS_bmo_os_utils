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
    
    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://github.com/webmproject/libvpx/archive/v1.15.2/libvpx-1.15.2.tar.gz
    echo "✅ the package downloaded successfully"

    find -type f | xargs touch
    sed -i 's/cp -p/cp/' build/make/Makefile
    mkdir libvpx-build            
    cd    libvpx-build            


   echo "🔧 Running configure..."
    if ! ../configure --prefix=/usr    \
             --enable-shared  \
             --disable-static; then
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
