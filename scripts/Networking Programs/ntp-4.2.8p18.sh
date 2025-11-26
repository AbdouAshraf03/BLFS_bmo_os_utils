#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/ntp-4.2.8p18.tar.gz
    echo "✅ the package downloaded successfully"
    sed -e "s;pthread_detach(NULL);pthread_detach(0);" \
    -i configure \
       sntp/configure

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>
   groupadd -g 87 ntp &&
   useradd -c "Network Time Protocol" -d /var/lib/ntp -u 87 \
           -g ntp -s /bin/false ntp
   sed -e "s;pthread_detach(NULL);pthread_detach(0);" \
    -i configure \
       sntp/configure

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr      \
            --bindir=/usr/sbin \
            --sysconfdir=/etc  \
            --enable-linuxcaps \
            --with-lineeditlibs=readline \
            --docdir=/usr/share/doc/ntp-4.2.8p18; then
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
   install -v -o ntp -g ntp -d /var/lib/ntp

fi

echo "Configuring ntp"
echo "🎉 FINISHED :)"
