#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/cjlin1/liblinear/archive/v249/liblinear-249.tar.gz
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>

    echo "⚙️  Running make..."
    if ! make lib; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    install -vm644 linear.h /usr/include &&
    install -vm755 liblinear.so.6 /usr/lib &&
    ln -sfv liblinear.so.6 /usr/lib/liblinear.so
    
   
   # <ETC>

fi


echo "🎉 FINISHED :)"
