#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else

    wget https://www.linuxfromscratch.org/patches/blfs/12.4/tidy-html5-5.8.0-cmake4_fixes-1.patch --no-check-certificate

    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/htacg/tidy-html5/archive/5.8.0/tidy-html5-5.8.0.tar.gz
    echo "✅ the package downloaded successfully"

    echo "🔧 fixing..."
    if ! patch -Np1 -i ../tidy-html5-5.8.0-cmake4_fixes-1.patch; then
        echo "❌ Error: fix failed!"
        exit 1
    fi

    cd build/cmake

   echo "🔧 Running configure..."
    if ! cmake -D CMAKE_INSTALL_PREFIX=/usr \
        -D CMAKE_BUILD_TYPE=Release  \
        -D BUILD_TAB2SPACE=ON        \
        ../..; then
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
        echo "❌ Error: make-install failed!"
        exit 1
    fi

    rm -fv /usr/lib/libtidy.a &&
    install -v -m755 tab2space /usr/bin


fi


echo "🎉 FINISHED :)"
