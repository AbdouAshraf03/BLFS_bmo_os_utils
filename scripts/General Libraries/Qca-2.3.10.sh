#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://download.kde.org/stable/qca/2.3.10/qca-2.3.10.tar.xz
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>
    sed -i 's@cert.pem@certs/ca-bundle.crt@' CMakeLists.txt
    mkdir build &&
    cd    build
    
    echo "🔧 Running configure..."
    if ! cmake -D CMAKE_INSTALL_PREFIX=$QT6DIR            \
      -D CMAKE_BUILD_TYPE=Release                \
      -D QT6=ON                                  \
      -D QCA_INSTALL_IN_QT_PREFIX=ON             \
      -D QCA_MAN_INSTALL_DIR:PATH=/usr/share/man \
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
