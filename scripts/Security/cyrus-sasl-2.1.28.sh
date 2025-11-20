#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    wget https://www.linuxfromscratch.org/patches/blfs/12.4/cyrus-sasl-2.1.28-gcc15_fixes-1.patch --no-check-certificate

    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/cyrusimap/cyrus-sasl/releases/download/cyrus-sasl-2.1.28/cyrus-sasl-2.1.28.tar.gz
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>
    patch -Np1 -i ../cyrus-sasl-2.1.28-gcc15_fixes-1.patch &&
    autoreconf -fiv

    sed '/saslint/a #include <time.h>'       -i lib/saslutil.c &&
    sed '/plugin_common/a #include <time.h>' -i plugins/cram.c
    
    echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr                       \
            --sysconfdir=/etc                   \
            --enable-auth-sasldb                \
            --with-dblib=lmdb                   \
            --with-dbpath=/var/lib/sasl/sasldb2 \
            --with-sphinx-build=no              \
            --with-saslauthd=/var/run/saslauthd ; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! make -j1; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! make install; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    install -v -dm755                          /usr/share/doc/cyrus-sasl-2.1.28/html &&
    install -v -m644  saslauthd/LDAP_SASLAUTHD /usr/share/doc/cyrus-sasl-2.1.28      &&
    install -v -m644  doc/legacy/*.html        /usr/share/doc/cyrus-sasl-2.1.28/html &&
    install -v -dm700 /var/lib/sasl
   # <ETC>

fi


echo "🎉 FINISHED :)"
