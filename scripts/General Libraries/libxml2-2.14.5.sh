#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    wget https://www.w3.org/XML/Test/xmlts20130923.tar.gz --no-check-certificate
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://download.gnome.org/sources/libxml2/2.14/libxml2-2.14.5.tar.xz
    echo "✅ the package downloaded successfully"


   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --with-history    \
            --with-icu        \
            PYTHON=/usr/bin/python3 \
            --docdir=/usr/share/doc/libxml2-2.14.5; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! make; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    tar xf ../xmlts20130923.tar.gz
    systemctl stop httpd.service
    
    echo "⚙️ installing..."
    if ! make install; then
        echo "❌ Error: make failed!"
        exit 1
    fi

    rm -vf /usr/lib/libxml2.la 
    sed '/libs=/s/xml2.*/xml2"/' -i /usr/bin/xml2-config

fi


echo "🎉 FINISHED :)"
