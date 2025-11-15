#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    wget https://www.linuxfromscratch.org/patches/blfs/12.4/giflib-5.2.2-upstream_fixes-1.patch --no-check-certificate
    wget https://www.linuxfromscratch.org/patches/blfs/12.4/giflib-5.2.2-security_fixes-1.patch --no-check-certificate
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://sourceforge.net/projects/giflib/files/giflib-5.2.2.tar.gz
    echo "✅ the package downloaded successfully"

    patch -Np1 -i ../giflib-5.2.2-upstream_fixes-1.patch
    patch -Np1 -i ../giflib-5.2.2-security_fixes-1.patch
    cp pic/gifgrid.gif doc/giflib-logo.gif
    echo "⚙️  Running make..."
    if ! make; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! make PREFIX=/usr install; then
        echo "❌ Error: make failed!"
        exit 1
    fi

    rm -fv /usr/lib/libgif.a 

    find doc \( -name Makefile\* -o -name \*.1 \
         -o -name \*.xml \) -exec rm -v {} \; 

    install -v -dm755 /usr/share/doc/giflib-5.2.2 
    cp -v -R doc/* /usr/share/doc/giflib-5.2.2

fi


echo "🎉 FINISHED :)"