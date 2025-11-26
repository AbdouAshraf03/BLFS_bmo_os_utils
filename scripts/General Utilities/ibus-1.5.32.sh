#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    wget https://www.unicode.org/Public/zipped/16.0.0/UCD.zip --no-check-certificate

    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/ibus/ibus/archive/1.5.32/ibus-1.5.32.tar.gz
    echo "✅ the package downloaded successfully"

    echo "🔧  install the Unicode ..."
    if ! mkdir -p               /usr/share/unicode/ucd &&
        unzip -o ../UCD.zip -d /usr/share/unicode/ucd; then
        echo "❌ Error:  install the Unicode  failed!"
        exit 1
    fi

    echo "🔧Fixing..."
    if ! sed -e 's@/desktop/ibus@/org/freedesktop/ibus@g' \
        -i data/dconf/org.freedesktop.ibus.gschema.xml; then
        echo "❌ Error: Fix failed!"
        exit 1
    fi

    SAVE_DIST_FILES=1 NOCONFIGURE=1 ./autogen.sh

   echo "🔧 Running configure..."
    if ! PYTHON=python3                     \ ./configure --prefix=/usr          \
                --sysconfdir=/etc      \
                --disable-python2      \
                --disable-appindicator \
                --disable-gtk2         \
                --disable-emoji-dict; then
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

    # If GTK+-3 is installed and --disable-gtk3 is not used, the ibus IM module for GTK+-3 will be installed. As the root user, update a cache file of GTK+-3 so the GTK-based applications can find the newly installed IM module and use ibus as an input method:
    gtk-query-immodules-3.0 --update-cache

fi


echo "🎉 FINISHED :)"
