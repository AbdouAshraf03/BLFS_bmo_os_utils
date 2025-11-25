#!/bin/bash
# set -E
# trap 'echo "❌ Error: command failed at line $LINENO"; exit 1' ERR

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh http://www.mirbsd.org/MirOS/dist/mir/cpio/paxmirabilis-20240817.tgz
    echo "✅ the package downloaded successfully"

    
    echo "⚙️ installing..."
    if ! bash Build.sh; then
        echo "❌ Error: installing failed!"
        exit 1
    fi

        echo "⚙️ installing..."
    if ! install -v pax /usr/bin ; then
        echo "❌ Error: installing failed!"
        exit 1
    fi

        echo "⚙️ installing..."
    if ! install -v -m644 pax.1 /usr/share/man/man1; then
        echo "❌ Error: installing failed!"
        exit 1
    fi

fi


echo "🎉 FINISHED :)"
