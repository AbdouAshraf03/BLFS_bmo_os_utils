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
    
    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://downloads.sourceforge.net/libcddb/libcddb-1.3.2.tar.bz2
    echo "✅ the package downloaded successfully"

    sed -e '/DEFAULT_SERVER/s/freedb.org/gnudb.gnudb.org/' \
    -e '/DEFAULT_PORT/s/888/&0/'                       \
    -i include/cddb/cddb_ni.h 

    sed '/^Genre:/s/Trip-Hop/Electronic/' -i tests/testdata/920ef00b.txt

    sed '/DISCID/i# Revision: 42'         -i tests/testcache/misc/12340000

    sed -i 's/size_t l;/socklen_t l;/' lib/cddb_net.c

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr --disable-static; then
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

fi


echo "🎉 FINISHED :)"
