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
    
    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://storage.googleapis.com/aom-releases/libaom-3.12.1.tar.gz
    echo "✅ the package downloaded successfully"

    mkdir aom-build
    cd    aom-build

   echo "🔧 Running configure..."
    if ! cmake -D CMAKE_INSTALL_PREFIX=/usr \
      -D CMAKE_BUILD_TYPE=Release  \
      -D BUILD_SHARED_LIBS=1       \
      -D ENABLE_DOCS=no            \
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

    rm -v /usr/lib/libaom.a

fi


echo "🎉 FINISHED :)"
