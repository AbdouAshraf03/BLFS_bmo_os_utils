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
    
    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://github.com/i-rinat/libvdpau-va-gl/archive/v0.4.2/libvdpau-va-gl-0.4.2.tar.gz
    echo "✅ the package downloaded successfully"

    mkdir build 
    cd    build 

   echo "🔧 Running configure..."
    if ! cmake -D CMAKE_INSTALL_PREFIX=$XORG_PREFIX \
               -D CMAKE_POLICY_VERSION_MINIMUM=3.5  \
               -D CMAKE_BUILD_TYPE=Release          \
               -W no-dev ..; then
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

    echo "export VDPAU_DRIVER=va_gl" >> /etc/profile.d/xorg.sh

fi


echo "🎉 FINISHED :)"
