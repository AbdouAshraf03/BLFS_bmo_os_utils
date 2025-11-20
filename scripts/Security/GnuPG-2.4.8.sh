#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-2.4.8.tar.bz2
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>
    mkdir build &&
    cd    build 
    
    echo "🔧 Running configure..."
    if ! ../configure --prefix=/usr        \
             --localstatedir=/var \
             --sysconfdir=/etc    \
             --docdir=/usr/share/doc/gnupg-2.4.8 ; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! make ; then
        echo "❌ Error: make failed!"
        exit 1
    fi

    makeinfo --html --no-split -I doc -o doc/gnupg_nochunks.html ../doc/gnupg.texi &&
    makeinfo --plaintext       -I doc -o doc/gnupg.txt           ../doc/gnupg.texi &&
    make -C doc html

    echo "⚙️ installing..."
    if ! make install; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    install -v -m755 -d /usr/share/doc/gnupg-2.4.8/html            &&
    install -v -m644    doc/gnupg_nochunks.html \
                    /usr/share/doc/gnupg-2.4.8/html/gnupg.html &&
    install -v -m644    ../doc/*.texi doc/gnupg.txt \
                    /usr/share/doc/gnupg-2.4.8 &&
    install -v -m644    doc/gnupg.html/* \
                    /usr/share/doc/gnupg-2.4.8/html
   # <ETC>

fi


echo "🎉 FINISHED :)"
