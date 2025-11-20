#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    wget https://www.linuxfromscratch.org/patches/blfs/12.4/nss-standalone-1.patch --no-check-certificate -O nss-standalone-1.patch

    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://archive.mozilla.org/pub/security/nss/releases/NSS_3_115_RTM/src/nss-3.115.tar.gz
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>

    patch -Np1 -i ../nss-standalone-1.patch
    cd nss

    # echo "🔧 Running configure..."
    # if ! <CONFIG>; then
    #     echo "❌ Error: configure failed!"
    #     exit 1
    # fi

    echo "⚙️  Running make..."
    if ! make BUILD_OPT=1                      \
  NSPR_INCLUDE_DIR=/usr/include/nspr  \
  USE_SYSTEM_ZLIB=1                   \
  ZLIB_LIBS=-lz                       \
  NSS_ENABLE_WERROR=0                 \
  $([ $(uname -m) = x86_64 ] && echo USE_64=1) \
  $([ -f /usr/include/sqlite3.h ] && echo NSS_USE_SYSTEM_SQLITE=1); then
        echo "❌ Error: make failed!"
        exit 1
    fi
    

    echo "⚙️ installing..."
    if ! cd ../dist                                                          &&

    install -v -m755 Linux*/lib/*.so              /usr/lib              &&
    install -v -m644 Linux*/lib/{*.chk,libcrmf.a} /usr/lib              &&

    install -v -m755 -d                           /usr/include/nss      &&
    cp -v -RL {public,private}/nss/*              /usr/include/nss      &&

    install -v -m755 Linux*/bin/{certutil,nss-config,pk12util} /usr/bin &&

    install -v -m644 Linux*/lib/pkgconfig/nss.pc  /usr/lib/pkgconfig; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    ln -sfv ./pkcs11/p11-kit-trust.so /usr/lib/libnssckbi.so

   # <ETC>

fi


echo "🎉 FINISHED :)"
