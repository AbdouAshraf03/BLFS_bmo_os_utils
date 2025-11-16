#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else

    wget https://poppler.freedesktop.org/poppler-data-0.4.12.tar.gz --no-check-certificate

    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://poppler.freedesktop.org/poppler-25.08.0.tar.xz
    echo "✅ the package downloaded successfully"

    mkdir build                         &&
    cd    build

   echo "🔧 Running configure..."
    if ! cmake -D CMAKE_BUILD_TYPE=Release   \
      -D CMAKE_INSTALL_PREFIX=/usr  \
      -D TESTDATADIR=$PWD/testfiles \
      -D ENABLE_QT5=OFF             \
      -D ENABLE_UNSTABLE_API_ABI_HEADERS=ON \
      -G Ninja ..; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running ninja..."
    if ! ninja; then
        echo "❌ Error: ninja failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! ninja install; then
        echo "❌ Error: ninja-install failed!"
        exit 1
    fi

    install -v -m755 -d           /usr/share/doc/poppler-25.08.0 &&
    cp -vr ../glib/reference/html /usr/share/doc/poppler-25.08.0

    # Poppler Data

    echo "⚙️ installing Poppler Data.."
    if ! tar -xf ../../poppler-data-0.4.12.tar.gz &&
        cd poppler-data-0.4.12; then
        echo "❌ Error: poppler data-install failed!"
        exit 1
    fi

    echo "⚙️ installing..."
    if ! make prefix=/usr install; then
        echo "❌ Error: make-install failed!"
        exit 1
    fi

fi


echo "🎉 FINISHED :)"
