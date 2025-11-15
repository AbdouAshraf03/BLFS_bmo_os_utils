#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else

    wget https://www.linuxfromscratch.org/patches/blfs/12.4/libportal-0.9.1-qt6.9_fixes-1.patch --no-check-certificate

    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/flatpak/libportal/releases/download/0.9.1/libportal-0.9.1.tar.xz
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>

    patch -Np1 -i ../libportal-0.9.1-qt6.9_fixes-1.patch

    mkdir build &&
    cd    build

    echo "🔧 Running configure..."
    if ! meson setup --prefix=/usr       \
            --buildtype=release \
            -D vapi=false       \
            -D docs=false       \
            .. ; then
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
