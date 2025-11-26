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

     wget https://www.linuxfromscratch.org/patches/blfs/12.4/pm-utils-1.4.1-bugfixes-1.patch --no-check-certificate  

    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://pm-utils.freedesktop.org/releases/pm-utils-1.4.1.tar.gz
    echo "✅ the package downloaded successfully"

   

   patch -Np1 -i ../pm-utils-1.4.1-bugfixes-1.patch
   
   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/pm-utils-1.4.1; then
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
    if ! install -v -m644 man/*.1 /usr/share/man/man1; then
        echo "❌ Error: installing failed!"
        exit 1
    fi

      echo "⚙️ installing..."
    if ! install -v -m644 man/*.8 /usr/share/man/man8; then
        echo "❌ Error: installing failed!"
        exit 1
    fi

    ln -sv pm-action.8 /usr/share/man/man8/pm-suspend.8 &&
    ln -sv pm-action.8 /usr/share/man/man8/pm-hibernate.8 &&
    ln -sv pm-action.8 /usr/share/man/man8/pm-suspend-hybrid.8

fi


echo "🎉 FINISHED :)"
