#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://download.samba.org/pub/samba/stable/samba-4.22.4.tar.gz
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>
   python3 -m venv --system-site-packages pyvenv         
   ./pyvenv/bin/pip3 install cryptography pyasn1 iso8601
   PYTHON=$PWD/pyvenv/bin/python3

   echo "🔧 Running configure..."
    if ! ./configure                                \
    --prefix=/usr                          \
    --sysconfdir=/etc                      \
    --localstatedir=/var                   \
    --with-piddir=/run/samba               \
    --with-pammodulesdir=/usr/lib/security \
    --enable-fhs                           \
    --without-ad-dc                        \
    --with-system-mitkrb5                  \
    --enable-selftest                      \
    --disable-rpath-install                ; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! make; then
        echo "❌ Error: make failed!"
        exit 1
    fi

    sed '1s@^.*$@#!/usr/bin/python3@' \
       -i ./bin/default/source4/scripting/bin/*.inst
    
    echo "⚙️ installing..."
    if ! make install; then
        echo "❌ Error: make failed!"
        exit 1
    fi

   # <ETC>
   install -v -m644 examples/smb.conf.default /etc/samba 

   sed -e "s;log file =.*;log file = /var/log/samba/%m.log;"   \   
       -e "s;path = /usr/spool/samba;path = /var/spool/samba;" \
       -i /etc/samba/smb.conf.default 

   mkdir -pv /etc/openldap/schema 
   
   install -v -m644    examples/LDAP/README \   
                       /etc/openldap/schema/README.samba 
   
   install -v -m644    examples/LDAP/samba* \
                       /etc/openldap/schema 
   
   install -v -m755    examples/LDAP/{get*,ol*} \
                    /etc/openldap/schema

fi

echo "Configuring Samba"
echo "🎉 FINISHED :)"
