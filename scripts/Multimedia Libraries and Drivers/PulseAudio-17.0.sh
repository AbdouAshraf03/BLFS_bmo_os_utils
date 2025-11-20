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

    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-17.0.tar.xz
    echo "✅ the package downloaded successfully"

   mkdir build 
   cd    build 

   echo "🔧 Running configure..."
    if ! meson setup --prefix=/usr       \
                     --buildtype=release \
                     -D database=gdbm    \
                     -D doxygen=false    \
                     -D bluez5=disabled  \
                     -D tests=false      \
                     ..         ; then
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

    rm /usr/share/dbus-1/system.d/pulseaudio-system.conf

fi


echo "🎉 FINISHED :)"
