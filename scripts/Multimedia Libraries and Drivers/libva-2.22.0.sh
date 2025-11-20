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
    
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/intel/libva/archive/2.22.0/libva-2.22.0.tar.gz
    echo "✅ the package downloaded successfully"

    cd build

   echo "🔧 Running configure..."
    if ! meson setup --prefix=$XORG_PREFIX --buildtype=release; then
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
        exit 1nstal
    fi

   # <ETC>

fi


echo "🎉 FINISHED :)"
