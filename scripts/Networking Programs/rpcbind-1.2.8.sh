#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://downloads.sourceforge.net/rpcbind/rpcbind-1.2.8.tar.bz2
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>
   groupadd -g 28 rpc &&
   useradd -c "RPC Bind Daemon Owner" -d /dev/null -g rpc \
           -s /bin/false -u 28 rpc
   sed -i "/servname/s:rpcbind:sunrpc:" src/rpcbind.c

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr       \
            --bindir=/usr/sbin  \
            --enable-warmstarts \
            --with-rpcuser=rpc  ; then
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

   # <ETC>
   systemctl enable rpcbind

fi


echo "🎉 FINISHED :)"
