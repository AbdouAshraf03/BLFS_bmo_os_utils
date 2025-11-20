#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    wget  https://github.com/cracklib/cracklib/releases/download/v2.10.3/cracklib-words-2.10.3.xz --no-check-certificate

    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://github.com/cracklib/cracklib/releases/download/v2.10.3/cracklib-2.10.3.tar.xz
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>

   echo "🔧 Running configure..."
    if ! CPPFLAGS+=' -I /usr/include/python3.13' \
        ./configure --prefix=/usr               \
            --disable-static            \
            --with-default-dict=/usr/lib/cracklib/pw_dict; then
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
        exit 1
    fi
    xzcat ../cracklib-words-2.10.3.xz \
                            > /usr/share/dict/cracklib-words       &&
    ln -v -sf cracklib-words /usr/share/dict/words                &&
    echo $(hostname) >>      /usr/share/dict/cracklib-extra-words &&
    install -v -m755 -d      /usr/lib/cracklib                    &&

    create-cracklib-dict     /usr/share/dict/cracklib-words \
                             /usr/share/dict/cracklib-extra-words
   # <ETC>

fi


echo "🎉 FINISHED :)"
