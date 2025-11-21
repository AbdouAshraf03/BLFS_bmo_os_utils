#!/bin/bash
# set -E
# trap 'echo "❌ Error: command failed at line $LINENO"; exit 1' ERR

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://mj.ucw.cz/download/linux/pci/pciutils-3.14.0.tar.gz
    echo "✅ the package downloaded successfully"

    sed -r '/INSTALL/{/PCI_IDS|update-pciids /d; s/update-pciids.8//}' \
    -i Makefile

   echo "🔧 Running configure..."
    if ! <CONFIG>; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! make PREFIX=/usr                \
     SHAREDIR=/usr/share/hwdata \
     SHARED=yes; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! make PREFIX=/usr                \
    SHAREDIR=/usr/share/hwdata \
    SHARED=yes                 \
    install install-lib ; then
        echo "❌ Error: make failed!"
        exit 1
    fi

    chmod -v 755 /usr/lib/libpci.so

fi


echo "🎉 FINISHED :)"
