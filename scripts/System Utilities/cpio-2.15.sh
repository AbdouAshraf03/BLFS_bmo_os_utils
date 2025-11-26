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
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://ftp.gnu.org/gnu/cpio/cpio-2.15.tar.bz2
    echo "✅ the package downloaded successfully"

    sed -e "/^extern int (\*xstat)/s/()/(const char * restrict,  struct stat * restrict)/" \
    -i src/extern.h

    sed -e "/^int (\*xstat)/s/()/(const char * restrict,  struct stat * restrict)/" \
    -i src/global.c

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr \
            --enable-mt   \
            --with-rmt=/usr/libexec/rmt ; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! make ; then
        echo "❌ Error: make failed!"
        exit 1
    fi

    makeinfo --html            -o doc/html      doc/cpio.texi &&
    makeinfo --html --no-split -o doc/cpio.html doc/cpio.texi &&
    makeinfo --plaintext       -o doc/cpio.txt  doc/cpio.texi 

    
    echo "⚙️ installing..."
    if ! make install; then
        echo "❌ Error: make failed!"
        exit 1
    fi

    install -v -m755 -d /usr/share/doc/cpio-2.15/html &&
    install -v -m644    doc/html/* \
                        /usr/share/doc/cpio-2.15/html &&
    install -v -m644    doc/cpio.{html,txt} \
                        /usr/share/doc/cpio-2.15

    install -v -m644 doc/cpio.{pdf,ps,dvi} \
                 /usr/share/doc/cpio-2.15

fi


echo "🎉 FINISHED :)"
