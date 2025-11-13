#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/unicode-org/icu/releases/download/release-77-1/icu4c-77_1-src.tgz
    echo "✅ the package downloaded successfully"

    case $(uname -m) in
    i?86) sed -e "s/U_PLATFORM_IS_LINUX_BASED/__X86_64__ \&\& &/" \
            -i source/test/intltest/ustrtest.cpp ;;
    esac
    cd source

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
    if ! make install
      ; then
        echo "❌ Error: make failed!"
        exit 1
    fi

   # <ETC>

fi


echo "🎉 FINISHED :)"
