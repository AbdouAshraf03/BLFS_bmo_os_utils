#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://gitlab.freedesktop.org/NetworkManager/NetworkManager/-/releases/1.54.0/downloads/NetworkManager-1.54.0.tar.xz
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>
   grep -rl '^#!.*python$' | xargs sed -i '1s/python/&3/'
   mkdir build 
   cd    build 

   echo "🔧 Running configure..."
    if ! meson setup ..                    \
      --prefix=/usr               \
      --buildtype=release         \
      -D libaudit=no              \
      -D nmtui=true               \
      -D ovs=false                \
      -D ppp=false                \
      -D nbft=false               \
      -D selinux=false            \
      -D qt=false                 \
      -D session_tracking=systemd \
      -D nm_cloud_setup=false     \
      -D modem_manager=false      ; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! ninja; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! ninja install; then
        echo "❌ Error: make failed!"
        exit 1
    fi

   # <ETC>
   mv -v /usr/share/doc/NetworkManager{,-1.54.0}
   for file in $(echo ../man/*.[1578]); do
        section=${file##*.} &&
        install -vdm 755 /usr/share/man/man$section
        install -vm 644 $file /usr/share/man/man$section/
   done
   cp -Rv ../docs/{api,libnm} /usr/share/doc/NetworkManager-1.54.0
   echo "There is missing config and Systemd Unit"

fi


echo "🎉 FINISHED :)"
