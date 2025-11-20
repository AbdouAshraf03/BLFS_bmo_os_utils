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
    
    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://github.com/mltframework/mlt/releases/download/v7.32.0/mlt-7.32.0.tar.gz
    echo "✅ the package downloaded successfully"

    mkdir build 
    cd    build 

   echo "🔧 Running configure..."
    if ! cmake -D CMAKE_INSTALL_PREFIX=/usr \
               -D CMAKE_BUILD_TYPE=Release  \
               -D MOD_QT=OFF                \
               -D MOD_QT6=ON                \
               -W no-dev ..; then
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
        exit 1nstal
    fi

   # <ETC>

fi


echo "🎉 FINISHED :)"
