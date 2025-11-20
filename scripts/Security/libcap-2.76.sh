#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.76.tar.xz


    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>



    echo "⚙️  Running make..."
    if ! make -C pam_cap; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! <MAKE_INSTALL>; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    install -v -m755 pam_cap/pam_cap.so      /usr/lib/security &&
    install -v -m644 pam_cap/capability.conf /etc/security
   # <ETC>

fi


echo "🎉 FINISHED :)"
