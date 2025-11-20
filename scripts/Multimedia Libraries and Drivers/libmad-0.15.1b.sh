#!/bin/bash     

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else

     wget https://www.linuxfromscratch.org/patches/blfs/12.4/libmad-0.15.1b-fixes-1.patch --no-check-certificate
    
    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://downloads.sourceforge.net/mad/libmad-0.15.1b.tar.gz
    echo "✅ the package downloaded successfully"

    patch -Np1 -i ../libmad-0.15.1b-fixes-1.patch                
    sed "s@AM_CONFIG_HEADER@AC_CONFIG_HEADERS@g" -i configure.ac 
    touch NEWS AUTHORS ChangeLog                                 
    autoreconf -fi                                              


   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr --disable-static; then
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
        exit 1nstal
    fi

    cat > /usr/lib/pkgconfig/mad.pc << "EOF"
    prefix=/usr
    exec_prefix=${prefix}
    libdir=${exec_prefix}/lib
    includedir=${prefix}/include

    Name: mad
    Description: MPEG audio decoder
    Requires:
    Version: 0.15.1b
    Libs: -L${libdir} -lmad
    Cflags: -I${includedir}
EOF
fi


echo "🎉 FINISHED :)"
   