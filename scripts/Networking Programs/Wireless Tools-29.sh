#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else

    wget https://www.linuxfromscratch.org/patches/blfs/12.4/wireless_tools-29-fix_iwlist_scanning-1.patch --no-check-certificate

    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://hewlettpackard.github.io/wireless-tools/wireless_tools.29.tar.gz
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>
   patch -Np1 -i ../wireless_tools-29-fix_iwlist_scanning-1.patch

   
    echo "⚙️  Running make..."
    if ! make; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! make PREFIX=/usr INSTALL_MAN=/usr/share/man install; then
        echo "❌ Error: make failed!"
        exit 1
    fi

   # <ETC>


fi


echo "🎉 FINISHED :)"
