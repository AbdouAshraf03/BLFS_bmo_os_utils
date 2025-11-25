#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://ftp.isc.org/isc/bind9/9.20.12/bind-9.20.12.tar.xz
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr ; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! make -C lib/isc      &&
    make -C lib/dns      &&
    make -C lib/ns       &&
    make -C lib/isccfg   &&
    make -C lib/isccc    &&
    make -C bin/dig      &&
    make -C bin/nsupdate &&
    make -C bin/rndc     &&
    make -C doc; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! make -C lib/isc      install &&
    make -C lib/dns      install &&
    make -C lib/ns       install &&
    make -C lib/isccfg   install &&
    make -C lib/isccc    install &&
    make -C bin/dig      install &&
    make -C bin/nsupdate install &&
    make -C bin/rndc     install &&; then
        echo "❌ Error: make failed!"
        exit 1
    fi

   # <ETC>
   cp -v doc/man/{dig.1,host.1,nslookup.1,nsupdate.1} /usr/share/man/man1 &&
   cp -v doc/man/rndc.8 /usr/share/man/man8

fi


echo "🎉 FINISHED :)"
