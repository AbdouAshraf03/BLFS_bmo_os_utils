#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/lurcher/unixODBC/releases/download/2.3.12/unixODBC-2.3.12.tar.gz
    echo "✅ the package downloaded successfully"


   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr \
            --sysconfdir=/etc/unixODBC; then
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
        echo "❌ Error: make-install failed!"
        exit 1
    fi

    find doc -name "Makefile*" -delete                &&
    chmod 644 doc/{lst,ProgrammerManual/Tutorial}/*   &&

    install -v -m755 -d /usr/share/doc/unixODBC-2.3.12 &&
    cp      -v -R doc/* /usr/share/doc/unixODBC-2.3.12


    #Config Files
    #/etc/unixODBC/*

fi


echo "🎉 FINISHED :)"
