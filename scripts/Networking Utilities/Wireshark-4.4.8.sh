#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else

    wget https://www.wireshark.org/download/docs/

    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://www.wireshark.org/download/src/all-versions/wireshark-4.4.8.tar.xz
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>
   groupadd -g 62 wireshark
   mkdir build
   cd    build

   echo "🔧 Running configure..."
    if ! cmake -D CMAKE_INSTALL_PREFIX=/usr \
      -D CMAKE_BUILD_TYPE=Release  \
      -D CMAKE_INSTALL_DOCDIR=/usr/share/doc/wireshark-4.4.8 \
      -G Ninja \; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! ninja; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! ninja install; then
        echo "❌ Error: make failed!"
        exit 1
    fi

   # <ETC>
install -v -m755 -d /usr/share/doc/wireshark-4.4.8 
install -v -m644    ../README.linux ../doc/README.* ../doc/randpkt.txt \
                    /usr/share/doc/wireshark-4.4.8 

pushd /usr/share/doc/wireshark-4.4.8 
   for FILENAME in ../../wireshark/*.html; do
      ln -s -v -f $FILENAME .
   done
popd
unset FILENAME
install -v -m644 <Downloaded_Files> \
                 /usr/share/doc/wireshark-4.4.8
chown -v root:wireshark /usr/bin/tshark &&
chmod -v 6550 /usr/bin/tshark
usermod -a -G wireshark $(whoami)

fi


echo "🎉 FINISHED :)"
