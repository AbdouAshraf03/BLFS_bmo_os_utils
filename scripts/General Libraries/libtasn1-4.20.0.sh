#!/bin/bash
# set -E
# trap 'echo "❌ Error: command failed at line $LINENO"; exit 1' ERR

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.20.0.tar.gz
    echo "✅ the package downloaded successfully"
    
    ./configure --prefix=/usr --disable-static 
    echo "✅ the package configured successfully"
    
    make
    echo "✅ the package made successfully"
    
    make install
    echo "✅ the package installed successfully"
    
    make -C doc/reference install-data-local
fi

echo "🎉 FINISHED :)"
