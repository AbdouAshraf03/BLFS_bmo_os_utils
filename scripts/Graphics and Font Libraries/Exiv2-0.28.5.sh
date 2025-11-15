#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/Exiv2/exiv2/archive/v0.28.5/exiv2-0.28.5.tar.gz
    echo "✅ the package downloaded successfully"

    mkdir build 
    cd build 
   echo "🔧 Running configure..."
    if ! cmake -D CMAKE_INSTALL_PREFIX=/usr   \
      -D CMAKE_BUILD_TYPE=Release    \
      -D EXIV2_ENABLE_VIDEO=yes      \
      -D EXIV2_ENABLE_WEBREADY=yes   \
      -D EXIV2_ENABLE_CURL=yes       \
      -D EXIV2_BUILD_SAMPLES=no      \
      -D CMAKE_SKIP_INSTALL_RPATH=ON \
      -G Ninja ..; then
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