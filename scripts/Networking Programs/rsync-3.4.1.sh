#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://www.samba.org/ftp/rsync/src/rsync-3.4.1.tar.gz
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>
   groupadd -g 48 rsyncd 
   useradd -c "rsyncd Daemon" -m -d /home/rsync -g rsyncd \
       -s /bin/false -u 48 rsyncd

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr    \
            --disable-xxhash \
            --without-included-zlib; then
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
   install -v -m755 -d          /usr/share/doc/rsync-3.4.1/api 
   install -v -m644 dox/html/*  /usr/share/doc/rsync-3.4.1/api
  # make install-rsyncd
  

fi

echo "Configuring rsync"
echo "🎉 FINISHED :)"
