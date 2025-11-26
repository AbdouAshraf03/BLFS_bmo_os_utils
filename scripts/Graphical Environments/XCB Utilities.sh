#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    cat > xcb-utils.md5 << "EOF"
    a67bfac2eff696170259ef1f5ce1b611  xcb-util-image-0.4.1.tar.xz
    fbdc05f86f72f287ed71b162f1a9725a  xcb-util-keysyms-0.4.1.tar.xz
    193b890e2a89a53c31e2ece3afcbd55f  xcb-util-renderutil-0.3.10.tar.xz
    581b3a092e3c0c1b4de6416d90b969c3  xcb-util-wm-0.4.2.tar.xz
    bc30cd267b11ac5803fe19929cabd230  xcb-util-cursor-0.1.5.tar.xz
    EOF
    echo "✅ the package downloaded successfully"

    mkdir xcb-utils &&
    cd    xcb-utils &&
    grep -v '^#' ../xcb-utils.md5 | awk '{print $2}' | wget -i- -c \
         -B https://xcb.freedesktop.org/dist/ &&
    md5sum -c ../xcb-utils.md5

    
    as_root()
    {
        if   [ $EUID = 0 ];        then $*
        elif [ -x /usr/bin/sudo ]; then sudo $*
        else                            su -c \\"$*\\"
        fi
    }

    export -f as_root

    bash -e
    for package in $(grep -v '^#' ../xcb-utils.md5 | awk '{print $2}')
    do
        packagedir=${package%.tar.?z*}
        tar -xf $package
        pushd $packagedir
            ./configure $XORG_CONFIG
            make
            as_root make install
        popd
        rm -rf $packagedir
    done
    exit

  
fi


echo "🎉 FINISHED :)"