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
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://anduin.linuxfromscratch.org/BLFS/at/at_3.2.5.orig.tar.gz
    echo "✅ the package downloaded successfully"

    groupadd -g 17 atd                                                 
useradd -d /dev/null -c "atd daemon" -g atd -s /bin/false -u 17 atd

   echo "🔧 Running configure..."
    if ! ./configure --with-daemon_username=atd        \
            --with-daemon_groupname=atd       \
            SENDMAIL=/usr/sbin/sendmail       \
            --with-jobdir=/var/spool/atjobs   \
            --with-atspool=/var/spool/atspool \
            --with-systemdsystemunitdir=/lib/systemd/system; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! make -j1; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! make install docdir=/usr/share/doc/at-3.2.5 \
             atdocdir=/usr/share/doc/at-3.2.5; then
        echo "❌ Error: make failed!"
        exit 1
    fi

    cat > /etc/pam.d/atd << "EOF"
# Begin /etc/pam.d/atd

auth     required pam_unix.so
account  required pam_unix.so
password required pam_unix.so
session  required pam_unix.so

# End /etc/pam.d/atd
EOF

  systemctl enable atd

fi


echo "🎉 FINISHED :)"
