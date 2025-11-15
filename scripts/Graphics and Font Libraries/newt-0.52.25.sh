#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://releases.pagure.org/newt/newt-0.52.25.tar.gz
    echo "✅ the package downloaded successfully"


    echo "🔧 istalling..."
    if ! sed -e '/install -m 644 $(LIBNEWT)/ s/^/#/' \
        -e '/$(LIBNEWT):/,/rv/ s/^/#/'          \
        -e 's/$(LIBNEWT)/$(LIBNEWTSH)/g'        \
        -i Makefile.in; then
        echo "❌ Error: installing failed!"
        exit 1
    fi



   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr      \
            --with-gpm-support \
            --with-python=python3.13; then
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
        echo "❌ Error: make-install failed!"
        exit 1
    fi

fi


echo "🎉 FINISHED :)"
