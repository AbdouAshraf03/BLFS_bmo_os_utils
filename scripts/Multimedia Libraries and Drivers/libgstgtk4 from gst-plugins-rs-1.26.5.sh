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
    
    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/archive/gstreamer-1.26.5/gst-plugins-rs-gstreamer-1.26.5.tar.gz
    echo "✅ the package downloaded successfully"

    cd video/gtk4 
    cargo build --release

    echo "⚙️  Running install..."
    if ! install -vm755 ../../target/release/libgstgtk4.so /usr/lib/gstreamer-1.0; then
        echo "❌ Error: install failed!"
        exit 1
    fi
    
    
   # <ETC>

fi


echo "🎉 FINISHED :)"
