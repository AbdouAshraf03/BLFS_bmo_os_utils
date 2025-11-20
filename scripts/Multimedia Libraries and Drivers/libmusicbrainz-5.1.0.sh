#!/bin/bash     

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else

     wget  https://www.linuxfromscratch.org/patches/blfs/12.4/libmusicbrainz-5.1.0-cmake_fixes-1.patch --no-check-certificate
    
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/metabrainz/libmusicbrainz/releases/download/release-5.1.0/libmusicbrainz-5.1.0.tar.gz
    echo "✅ the package downloaded successfully"

    patch -Np1 -i ../libmusicbrainz-5.1.0-cmake_fixes-1.patch
    sed -e 's/xmlErrorPtr /const xmlError */'     \
        -i src/xmlParser.cc
    mkdir build 
    cd    build

   echo "🔧 Running configure..."
    if ! cmake -D CMAKE_INSTALL_PREFIX=/usr \
               -D CMAKE_BUILD_TYPE=Release  \
               -D CMAKE_POLICY_VERSION_MINIMUM=3.5 ..; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! make install; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! make install; then
        echo "❌ Error: make failed!"
        exit 1nstal
    fi

    rm -rf /usr/share/doc/libmusicbrainz-5.1.0 
    cp -vr docs/ /usr/share/doc/libmusicbrainz-5.1.0

fi


echo "🎉 FINISHED :)"
