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
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://sysstat.github.io/sysstat-packages/sysstat-12.7.8.tar.xz
    echo "✅ the package downloaded successfully"

    sa_lib_dir=/usr/lib/sa    \
    sa_dir=/var/log/sa        \
    conf_dir=/etc/sysstat     \

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr \
            --disable-file-attr; then
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

    install -v -m644 sysstat.service /usr/lib/systemd/system/sysstat.service                      &&
    install -v -m644 cron/sysstat-collect.service /usr/lib/systemd/system/sysstat-collect.service &&
    install -v -m644 cron/sysstat-collect.timer /usr/lib/systemd/system/sysstat-collect.timer     &&
    install -v -m644 cron/sysstat-rotate.service /usr/lib/systemd/system/sysstat-rotate.service   &&
    install -v -m644 cron/sysstat-rotate.timer /usr/lib/systemd/system/sysstat-rotate.timer       &&
    install -v -m644 cron/sysstat-summary.service /usr/lib/systemd/system/sysstat-summary.service &&
    install -v -m644 cron/sysstat-summary.timer /usr/lib/systemd/system/sysstat-summary.timer

    sed -i "/^Also=/d" /usr/lib/systemd/system/sysstat.service
    systemctl enable sysstat
fi


echo "🎉 FINISHED :)"
