#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://ftp.gnu.org/gnu/screen/screen-5.0.1.tar.gz
    echo "✅ the package downloaded successfully"

    echo "🔧 Fixing..."
    if ! sed 's/\([a-z]\)@opensuse/\1@@opensuse/' -i doc/screen.texinfo; then
        echo "❌ Error: Fix failed!"
        exit 1
    fi

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr                   \
            --infodir=/usr/share/info       \
            --mandir=/usr/share/man         \
            --disable-pam                   \
            --enable-socket-dir=/run/screen \
            --with-pty-group=5              \
            --with-system_screenrc=/etc/screenrc; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    sed -i -e "s%/usr/local/etc/screenrc%/etc/screenrc%" {etc,doc}/*

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

    install -m 644 etc/etcscreenrc /etc/screenrc

fi


echo "🎉 FINISHED :)"
