#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/silnrsi/graphite/releases/download/1.3.14/graphite2-1.3.14.tgz
    echo "✅ the package downloaded successfully"


     echo "🔧test..."
    if ! sed -i '/cmptest/d' tests/CMakeLists.txt; then
        echo "❌ Error: test failed!"
        exit 1
    fi
    

   echo "🔧 fix build pk. with cmake ..."
    if ! sed -i '/cmake_policy(SET CMP0012 NEW)/d' CMakeLists.txt &&
        sed -i 's/PythonInterp/Python3/' CMakeLists.txt          &&
        find . -name CMakeLists.txt | xargs sed -i 's/VERSION 2.8.0 FATAL_ERROR/VERSION 4.0.0/'; then
        echo "❌ Error: fix build pk. with cmake failed!"
        exit 1
    fi

    echo "🔧 fix build pk. with gcc ..."
    if ! sed -i '/Font.h/i #include <cstdint>' tests/featuremap/featuremaptest.cpp; then
        echo "❌ Error: fix build pk. with gcc failed!"
        exit 1
    fi
     
    
    mkdir build &&
    cd    build 

    echo "🔧 Running configure..."
    if ! cmake -D CMAKE_INSTALL_PREFIX=/usr ..; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! make; then
        echo "❌ Error: make failed!"
        exit 1
    fi
     
     make docs
    
    echo "⚙️ installing..."
    if ! make install; then
        echo "❌ Error: make failed!"
        exit 1
    fi

    install -v -d -m755 /usr/share/doc/graphite2-1.3.14 &&

    cp      -v -f    doc/{GTF,manual}.html \
                    /usr/share/doc/graphite2-1.3.14 &&
    cp      -v -f    doc/{GTF,manual}.pdf \
                    /usr/share/doc/graphite2-1.3.14

fi


echo "🎉 FINISHED :)"
