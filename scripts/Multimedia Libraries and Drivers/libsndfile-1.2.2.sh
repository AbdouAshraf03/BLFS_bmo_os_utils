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
    
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/libsndfile/libsndfile/releases/download/1.2.2/libsndfile-1.2.2.tar.xz
    echo "✅ the package downloaded successfully"

    echo "⚙️  Running GCC-15..."
    if ! sed '/typedef enum/,/bool ;/d' -i \
            src/ALAC/alac_{en,de}coder.c; then
        echo "❌ Error: GCC-15 failed!"
        exit 1
    fi

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr    \
                     --docdir=/usr/share/doc/libsndfile-1.2.2; then
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
