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
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://www.freedesktop.org/software/colord/releases/colord-1.4.8.tar.xz
    echo "✅ the package downloaded successfully"

    groupadd -g 71 colord &&
    useradd -c "Color Daemon Owner" -d /var/lib/colord -u 71 \
        -g colord -s /bin/false colord
    
    mkdir build 
    cd    build  

   echo "🔧 Running configure..."
    if ! meson setup ..                  \
      --prefix=/usr             \
      --buildtype=release       \
      -D daemon_user=colord     \
      -D vapi=true              \
      -D systemd=true           \
      -D libcolordcompat=true   \
      -D argyllcms_sensor=false \
      -D bash_completion=false  \
      -D docs=false             \
      -D man=false    ; then
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

    

fi


echo "🎉 FINISHED :)"
