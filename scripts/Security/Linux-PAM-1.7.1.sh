#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    wget https://anduin.linuxfromscratch.org/BLFS/Linux-PAM/Linux-PAM-1.7.1-docs.tar.xz --no-check-certificate

    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/linux-pam/linux-pam/releases/download/v1.7.1/Linux-PAM-1.7.1.tar.xz
    echo "✅ the package downloaded successfully"
    
    sed -e "s/'elinks'/'lynx'/"                       \
    -e "s/'-no-numbering', '-no-references'/      \
          '-force-html', '-nonumbers', '-stdin'/" \
    -i meson.build
   
   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>
    mkdir build &&
    cd    build 
    
    echo "🔧 Running configure..."
    if ! meson setup ..        \
  --prefix=/usr       \
  --buildtype=release \
  -D docdir=/usr/share/doc/Linux-PAM-1.7.1; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! ninja; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    install -v -m755 -d /etc/pam.d &&

cat > /etc/pam.d/other << "EOF"
auth     required       pam_deny.so
account  required       pam_deny.so
password required       pam_deny.so
session  required       pam_deny.so
EOF
    rm -fv /etc/pam.d/other


    echo "⚙️ installing..."
    if ! ninja install ; then
        echo "❌ Error: make failed!"
        exit 1
    fi

    chmod -v 4755 /usr/sbin/unix_chkpwd

    tar -C / -xvf ../../Linux-PAM-1.7.1-docs.tar.xz
   # <ETC>
    
fi


echo "🎉 FINISHED :)"
