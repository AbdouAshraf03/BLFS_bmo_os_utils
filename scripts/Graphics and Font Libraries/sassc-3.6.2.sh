#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else

    wget https://github.com/sass/libsass/archive/3.6.6/libsass-3.6.6.tar.gz --no-check-certificate

    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/sass/sassc/archive/3.6.2/sassc-3.6.2.tar.gz
    echo "✅ the package downloaded successfully"

    #build the library
    tar -xf ../libsass-3.6.6.tar.gz &&
    pushd libsass-3.6.6 &&
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
        echo "❌ Error: make-install failed!"
        exit 1
    fi

    #Build the command line wrapper

    popd &&
    autoreconf -fi

    echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr; then
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
        echo "❌ Error: make-install failed!"
        exit 1
    fi


fi


echo "🎉 FINISHED :)"
