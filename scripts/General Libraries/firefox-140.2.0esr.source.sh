#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://archive.mozilla.org/pub/firefox/releases/140.2.0esr/source/firefox-140.2.0esr.source.tar.xz
    echo "✅ the package downloaded successfully"

    cd ..
    mv firefox-140.2.0esr.tar.xz firefox-140.2.0
    cd firefox-140.2.0 
   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>
    mkdir obj &&
    cd    obj 

    echo "🔧 Running configure..."
    if ! ../js/src/configure --prefix=/usr            \
                    --disable-debug-symbols  \
                    --disable-jemalloc       \
                    --enable-readline        \
                    --enable-rust-simd       \
                    --with-intl-api          \
                    --with-system-icu        \
                    --with-system-zlib  ; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! make; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! make install ; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    # <ETC>
    rm -v /usr/lib/libjs_static.ajs &&
    sed -i '/@NSPR_CFLAGS@/d' /usr/bin/js140-config
   
    sed '$i#define XP_UNIX' -i /usr/include/mozjs-140/js-config.h

fi


echo "🎉 FINISHED :)"
