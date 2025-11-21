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
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://www.freedesktop.org/software/accountsservice/accountsservice-23.13.9.tar.xz
    echo "✅ the package downloaded successfully"

    mv tests/dbusmock{,-tests}

    sed -e '/accounts_service\.py/s/dbusmock/dbusmock-tests/' \
    -e 's/assertEquals/assertEqual/'                      \
    -i tests/test-libaccountsservice.py

    sed -i '/^SIMULATED_SYSTEM_LOCALE/s/en_IE.UTF-8/en_HK.iso88591/' tests/test-daemon.py

    mkdir build 
    cd    build


   echo "🔧 Running configure..."
    if ! meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      -D admin_group=adm; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    grep 'print_indent'     ../subprojects/mocklibc-1.0/src/netgroup.c \
     | sed 's/ {/;/' >> ../subprojects/mocklibc-1.0/src/netgroup.h 

    sed -i '1i#include <stdio.h>'                                      \
        ../subprojects/mocklibc-1.0/src/netgroup.h

    echo "⚙️  Running make..."
    if ! ninja; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! ninja install; then
        echo "❌ Error: make failed!"
        exit 1
    fi

        cat > /etc/polkit-1/rules.d/40-adm.rules << "EOF"
    polkit.addAdminRule(function(action, subject) {
    return ["unix-group:adm"];
    });
    EOF

fi


echo "🎉 FINISHED :)"
