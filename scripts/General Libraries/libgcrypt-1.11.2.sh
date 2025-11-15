#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.11.2.tar.bz2
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! make; then
        echo "❌ Error: make failed!"
        exit 1
    fi

    make -C doc html                                                       &&
    makeinfo --html --no-split -o doc/gcrypt_nochunks.html doc/gcrypt.texi &&
    makeinfo --plaintext       -o doc/gcrypt.txt           doc/gcrypt.texi
    
    echo "⚙️ installing..."
    if ! make install ; then
        echo "❌ Error: make failed!"
        exit 1
    fi

    install -v -dm755   /usr/share/doc/libgcrypt-1.11.2 &&
    install -v -m644    README doc/{README.apichanges,fips*,libgcrypt*} \
                        /usr/share/doc/libgcrypt-1.11.2 &&
                        
    install -v -dm755   /usr/share/doc/libgcrypt-1.11.2/html &&
    install -v -m644 doc/gcrypt.html/* \
                        /usr/share/doc/libgcrypt-1.11.2/html &&
    install -v -m644 doc/gcrypt_nochunks.html \
                        /usr/share/doc/libgcrypt-1.11.2      &&
    install -v -m644 doc/gcrypt.{txt,texi} \
                        /usr/share/doc/libgcrypt-1.11.2
   # <ETC>

fi


echo "🎉 FINISHED :)"
