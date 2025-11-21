#!/bin/bash  

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else

    wget  https://downloads.xiph.org/releases/speex/speexdsp-1.2.1.tar.gz --no-check-certificate

    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://downloads.xiph.org/releases/speex/speex-1.2.1.tar.gz
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>

   echo "🔧 Running configure Speex..."
    if ! ./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/speex-1.2.1; then
        echo "❌ Error: configure Speex failed!"
        exit 1
    fi

    echo "⚙️  Running make Speex..."
    if ! make; then
        echo "❌ Error: make Speex failed!"
        exit 1
    fi
    
    echo "⚙️ installing Speex..."
    if ! make install; then
        echo "❌ Error: make Speex failed!"
        exit 1
    fi

    cd ..                          
    tar -xf speexdsp-1.2.1.tar.gz 
    cd speexdsp-1.2.1


    echo "🔧 Running configure speexdsp ..."
    if ! ./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/speexdsp-1.2.1; then
        echo "❌ Error: configure speexdsp  failed!"
        exit 1
    fi 


    echo "⚙️  Running make speexdsp ..."
    if ! make; then
        echo "❌ Error: make speexdsp  failed!"
        exit 1
    fi  


    echo "⚙️ installing speexdsp ..."
    if ! make install; then
        echo "❌ Error: make speexdsp  failed!"
        exit 1
    fi          


fi


echo "🎉 FINISHED :)"
