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
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://www.kernel.org/pub/linux/daemons/autofs/v5/autofs-5.1.9.tar.xz
    echo "✅ the package downloaded successfully"


   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr             \
            --with-mapdir=/etc/autofs \
            --with-libtirpc           \
            --with-systemd            \
            --without-openldap        \
            --mandir=/usr/share/man; then
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
        echo "❌ Error: make failed!"
        exit 1
    fi

        echo "⚙️ installing..."
    if ! make install_samples; then
        echo "❌ Error: make failed!"
        exit 1
    fi

    mv /etc/autofs/auto.master /etc/autofs/auto.master.bak 

    cat > /etc/autofs/auto.master << "EOF"
# Begin /etc/autofs/auto.master

/media/auto  /etc/autofs/auto.misc  --ghost
#/home        /etc/autofs/auto.home

# End /etc/autofs/auto.master
EOF

cd   -fstype=iso9660,ro,nosuid,nodev :/dev/cdrom

joe  example.org:/export/home/joe

systemctl enable autofs

fi


echo "🎉 FINISHED :)"
