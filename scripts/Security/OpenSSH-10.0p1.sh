#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-10.0p1.tar.gz
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>
    install -v -g sys -m700 -d /var/lib/sshd &&

    groupadd -g 50 sshd        &&
    useradd  -c 'sshd PrivSep' \
            -d /var/lib/sshd  \
            -g sshd           \
            -s /bin/false     \
            -u 50 sshd

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr                            \
            --sysconfdir=/etc/ssh                    \
            --with-privsep-path=/var/lib/sshd        \
            --with-default-path=/usr/bin             \
            --with-superuser-path=/usr/sbin:/usr/bin \
            --with-pid-dir=/run             ; then
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
    
    install -v -m755    contrib/ssh-copy-id /usr/bin     &&

    install -v -m644    contrib/ssh-copy-id.1 \
                    /usr/share/man/man1              &&
    install -v -m755 -d /usr/share/doc/openssh-10.0p1     &&
    install -v -m644    INSTALL LICENCE OVERVIEW README* \
                    /usr/share/doc/openssh-10.0p1
   # <ETC>

fi


echo "🎉 FINISHED :)"
