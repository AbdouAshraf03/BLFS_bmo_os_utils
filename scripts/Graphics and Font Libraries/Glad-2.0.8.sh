#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/Dav1dde/glad/archive/v2.0.8/glad-2.0.8.tar.gz
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>

   echo "🔧 Running installing..."
    if ! pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD; then
        echo "❌ Error: install failed!"
        exit 1
    fi

    echo "⚙️  Running testing..."
    if ! pip3 install --no-index --find-links dist --no-user glad2; then
        echo "❌ Error: test failed!"
        exit 1
    fi

fi


echo "🎉 FINISHED :)"
