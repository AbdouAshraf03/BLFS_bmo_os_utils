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
    . ./../BLFS_bmo_os_utils/scripts/installer.sh http://fcron.free.fr/archives/fcron-3.4.0.src.tar.gz
    echo "✅ the package downloaded successfully"

    groupadd -g 22 fcron &&
    useradd -d /dev/null -c "Fcron User" -g fcron -s /bin/false -u 22 fcron
    
    find doc -type f -exec sed -i 's:/usr/local::g' {} \;


   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --without-sendmail   \
            --with-piddir=/run   \
            --with-boot-install=no ; then
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


fi

echo "Configuring Fcron"
echo "🎉 FINISHED :)"
