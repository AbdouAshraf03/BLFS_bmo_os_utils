#!/bin/bash    

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else

    # wget <LINK> --no-check-certificate
    
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://downloads.sourceforge.net/libdv/libdv-1.0.0.tar.gz
    echo "✅ the package downloaded successfully"

    # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr    \
            --disable-xv     \
            --disable-static; then
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

    install -v -m755 -d      /usr/share/doc/libdv-1.0.0
    install -v -m644 README* /usr/share/doc/libdv-1.0.0

fi


echo "🎉 FINISHED :)"
