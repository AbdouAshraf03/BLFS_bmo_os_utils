#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/danvratil/qcoro/archive/v0.12.0/qcoro-0.12.0.tar.gz
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>
    mkdir build &&
    cd    build
    
    echo "🔧 Running configure..."
    if ! cmake -D CMAKE_INSTALL_PREFIX=$QT6DIR \
      -D CMAKE_BUILD_TYPE=Release     \
      -D BUILD_TESTING=OFF            \
      -D QCORO_BUILD_EXAMPLES=OFF     \
      -D BUILD_SHARED_LIBS=ON         \
       ..                        ; then
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
