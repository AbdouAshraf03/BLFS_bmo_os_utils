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

    wget https://www.linuxfromscratch.org/patches/blfs/12.4/gpm-1.20.7-consolidated-1.patch --no-check-certificate 
    wget https://www.linuxfromscratch.org/patches/blfs/12.4/gpm-1.20.7-gcc15_fixes-1.patch --no-check-certificate 

    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://anduin.linuxfromscratch.org/BLFS/gpm/gpm-1.20.7.tar.bz2
    echo "✅ the package downloaded successfully"


   
    patch -Np1 -i ../gpm-1.20.7-consolidated-1.patch                &&
    patch -Np1 -i ../gpm-1.20.7-gcc15_fixes-1.patch                 &&
    ./autogen.sh 

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr --sysconfdir=/etc ac_cv_path_emacs=no; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! make; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! make install ; then
        echo "❌ Error: make failed!"
        exit 1
    fi

    install-info --dir-file=/usr/share/info/dir           \
             /usr/share/info/gpm.info                 &&

    rm -fv /usr/lib/libgpm.a                              &&
    ln -sfv libgpm.so.2.1.0 /usr/lib/libgpm.so            &&
    install -v -m644 conf/gpm-root.conf /etc              &&

    install -v -m755 -d /usr/share/doc/gpm-1.20.7/support &&
    install -v -m644    doc/support/*                     \
                        /usr/share/doc/gpm-1.20.7/support &&
    install -v -m644    doc/{FAQ,HACK_GPM,README*}        \
                        /usr/share/doc/gpm-1.20.7



    install -v -dm755 /etc/systemd/system/gpm.service.d
    make install-gpm
    cat > /etc/systemd/system/gpm.service.d/99-user.conf << EOF
    [Service]
    ExecStart=/usr/sbin/gpm <list of parameters>
EOF                   

fi


echo "🎉 FINISHED :)"
