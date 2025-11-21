#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://www.kernel.org/pub/linux/utils/nfs-utils/2.8.3/nfs-utils-2.8.3.tar.xz
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr       \
            --sysconfdir=/etc   \
            --sbindir=/usr/sbin \
            --disable-nfsv4     \
            --disable-gss       \
            LIBS="-lsqlite3 -levent_core" ; then
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
   chmod u+w,go+r /usr/sbin/mount.nfs 
   chown nobody:nogroup /var/lib/nfs
   cat >> /etc/exports << EOF /home 192.168.0.0/24(rw,subtree_check,anonuid=99,anongid=99) EOF
   make install-nfsv4-server
   make install-nfs-server
   <server-name>:/home  /home nfs   rw,_netdev 0 0
   <server-name>:/usr   /usr  nfs   ro,_netdev 0 0

fi


echo "🎉 FINISHED :)"
