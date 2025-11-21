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
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/hramrach/lm-sensors/archive/V3-6-2/lm-sensors-3-6-2.tar.gz
    echo "✅ the package downloaded successfully"

echo "⚙️  Running make ..."
    if ! make PREFIX=/usr        \
     BUILD_STATIC_LIB=0 \
     MANDIR=/usr/share/man; then
        echo "❌ Error: makefailed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! make PREFIX=/usr        \
     BUILD_STATIC_LIB=0 \
     MANDIR=/usr/share/man install; then
        echo "❌ Error: make failed!"
        exit 1
    fi

    
    install -v -m755 -d /usr/share/doc/lm-sensors-3-6-2     
    cp -rv              README INSTALL doc/* \
                    /usr/share/doc/lm-sensors-3-6-2
fi


echo "🎉 FINISHED :)"
