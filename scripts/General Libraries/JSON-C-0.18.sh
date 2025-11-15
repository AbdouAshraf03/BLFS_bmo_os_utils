#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://s3.amazonaws.com/json-c_releases/releases/json-c-0.18.tar.gz
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>
    sed -i 's/VERSION 2.8/VERSION 4.0/' apps/CMakeLists.txt  &&
    sed -i 's/VERSION 3.9/VERSION 4.0/' tests/CMakeLists.txt
  
    mkdir build &&
    cd    build
      
    echo "🔧 Running configure..."
    if ! cmake -D CMAKE_INSTALL_PREFIX=/usr \
      -D CMAKE_BUILD_TYPE=Release  \
      -D BUILD_STATIC_LIBS=OFF     \
      .. ; then
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
