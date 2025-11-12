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
    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://github.com/libfuse/libfuse/releases/download/fuse-3.17.4/fuse-3.17.4.tar.gz
    echo "✅ the package downloaded successfully"

    sed -i '/^udev/,$ s/^/#/' util/meson.build &&

    mkdir build &&
    cd    build

   echo "🔧 Running configure..."
    if ! meson setup --prefix=/usr --buildtype=release .. ; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! ninja; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! ninja install   ; then
        echo "❌ Error: make failed!"
        exit 1
    fi

    chmod u+s /usr/bin/fusermount3 &&

    cd ..                          &&
    cp -Rv doc/html -T /usr/share/doc/fuse-3.17.4 &&
    install -v -m644   doc/{README.NFS,kernel.txt} \
                    /usr/share/doc/fuse-3.17.4

    cat > /etc/fuse.conf << "EOF"
    # Set the maximum number of FUSE mounts allowed to non-root users.
    # The default is 1000.
    #
    #mount_max = 1000

    # Allow non-root users to specify the 'allow_other' or 'allow_root'
    # mount options.
    #
    #user_allow_other
    EOF
fi


echo "🎉 FINISHED :)"

