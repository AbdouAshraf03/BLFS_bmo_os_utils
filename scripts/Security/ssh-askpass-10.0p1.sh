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

   echo "🔧 Running configure..."
    if ! <CONFIG>; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! cd contrib &&
        make gnome-ssh-askpass3; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    install -v -d -m755                    /usr/libexec/openssh/contrib  &&
    install -v -m755    gnome-ssh-askpass3 /usr/libexec/openssh/contrib  &&
    ln -sv -f contrib/gnome-ssh-askpass3   /usr/libexec/openssh/ssh-askpass

   # <ETC>

fi


echo "🎉 FINISHED :)"
