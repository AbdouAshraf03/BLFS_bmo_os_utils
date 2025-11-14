#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else

    wget https://ftp.gnu.org/gnu/aspell/dict/en/aspell6-en-2020.12.07-0.tar.bz2 --no-check-certificate

    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://ftp.gnu.org/gnu/aspell/aspell-0.60.8.1.tar.gz
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>
   sed -e 's/; i.*size)/, e = end(); i != e; ++i, ++size_)/' \
    -i modules/speller/default/vector_hash-t.hpp
   

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/us; then
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
    ln -svfn aspell-0.60 /usr/lib/aspell &&

install -v -m755 -d /usr/share/doc/aspell-0.60.8.1/aspell{,-dev}.html &&

install -v -m644 manual/aspell.html/* \
    /usr/share/doc/aspell-0.60.8.1/aspell.html &&

install -v -m644 manual/aspell-dev.html/* \
    /usr/share/doc/aspell-0.60.8.1/aspell-dev.html

    install -v -m 755 scripts/ispell /usr/bin/

    install -v -m 755 scripts/spell /usr/bin/

   # <ETC>
   tar xf ../aspell6-en-2020.12.07-0.tar.bz2 &&
   cd aspell6-en-2020.12.07-0                &&

    ./configure &&
    make
    make install
fi


echo "🎉 FINISHED :)"
