#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://archive.mozilla.org/pub/nspr/releases/v4.37/src/nspr-4.37.tar.gz
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>
    cd nspr &&

    sed -i '/^RELEASE/s|^|#|' pr/src/misc/Makefile.in &&
    sed -i 's|$(LIBRARY) ||'  config/rules.mk         &&

    echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr   \
            --with-mozilla  \
            --with-pthreads \
            $([ $(uname -m) = x86_64 ] && echo --enable-64bit); then
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
