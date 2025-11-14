#!/bin/bash 

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
     
    
     wget https://www.nch.com.au/acm/sample.aac --no-check-certificate

    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/knik0/faad2/archive/2.11.2/faad2-2.11.2.tar.gz
    echo "✅ the package downloaded successfully"

   mkdir build
   cd    build

   echo "🔧 Running configure..."
    if ! cmake -D CMAKE_INSTALL_PREFIX=/usr \
      -D CMAKE_BUILD_TYPE=Release  \
      -D BUILD_SHARED_LIBS=ON      \
      ..  ; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! make; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    ./faad -o sample.wav ../../sample.aac
    aplay sample.wav 

    echo "⚙️ installing..."
    if ! make install; then
        echo "❌ Error: make failed!"
        exit 1
    fi

   # <ETC>

fi


echo "🎉 FINISHED :)"
