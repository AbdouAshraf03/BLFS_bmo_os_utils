#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/Tripwire/tripwire-open-source/releases/download/2.4.3.7/tripwire-open-source-2.4.3.7.tar.gz
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>
    sed -e '/^CLOBBER/s/false/true/'         \
    -e 's|TWDB="${prefix}|TWDB="/var|'   \
    -e '/TWMAN/ s|${prefix}|/usr/share|' \
    -e '/TWDOCS/s|${prefix}/doc/tripwire|/usr/share/doc/tripwire-2.4.3.7|' \
    -i installer/install.cfg                               &&

    find . -name Makefile.am | xargs                           \
        sed -i 's/^[[:alpha:]_]*_HEADERS.*=/noinst_HEADERS =/' &&

    sed '/dist/d' -i man/man?/Makefile.am                      &&
    autoreconf -fi                                             &&


   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr --sysconfdir=/etc/tripwire      ; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! make CPPFLAGS=-std=c++11; then
        echo "❌ Error: make failed!"
        exit 1
    fi

    sed '/-t 0/,+3d' -i installer/install.sh
    sed -i -e 's@installer/install.sh@& -n -s 123456 -l 123456@' Makefile
    
    echo "⚙️ installing..."
    if ! make install; then
        echo "❌ Error: make failed!"
        exit 1
    fi

    cp -v policy/*.txt /usr/share/doc/tripwire-2.4.3.7
   # <ETC>

    twadmin --create-polfile --site-keyfile /etc/tripwire/site.key \
    /etc/tripwire/twpol.txt &&
    tripwire --init

    tripwire --check > /etc/tripwire/report.txt

    twadmin --create-polfile /etc/tripwire/twpol.txt &&
    tripwire --init

fi


echo "🎉 FINISHED :)"
