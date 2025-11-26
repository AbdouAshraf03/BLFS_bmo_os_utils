#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else

    wget https://www.linuxfromscratch.org/patches/blfs/12.4/avahi-0.8-ipv6_race_condition_fix-1.patch --no-check-certificate

    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/lathiat/avahi/releases/download/v0.8/avahi-0.8.tar.gz
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>
   groupadd -fg 84 avahi 
   useradd -c "Avahi Daemon Owner" -d /run/avahi-daemon -u 84 \
           -g avahi -s /bin/false avahi
   groupadd -fg 86 netdev
   patch -Np1 -i ../avahi-0.8-ipv6_race_condition_fix-1.patch
   sed -i '426a if (events & AVAHI_WATCH_HUP) { \
   client_free(c); \
   return; \
   }' avahi-daemon/simple-protocol.c

   echo "🔧 Running configure..."
    if ! ./configure \
    --prefix=/usr        \
    --sysconfdir=/etc    \
    --localstatedir=/var \
    --disable-static     \
    --disable-libevent   \
    --disable-mono       \
    --disable-monodoc    \
    --disable-python     \
    --disable-qt3        \
    --disable-qt4        \
    --disable-qt5        \
    --enable-core-docs   \
    --with-distro=none   \
    --with-dbus-system-address='unix:path=/run/dbus/system_bus_socket' ; then
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

  
fi

echo "Configuring avahi"
echo "🎉 FINISHED :)"
