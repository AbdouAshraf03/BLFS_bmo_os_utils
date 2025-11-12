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
    
    wget https://www.alsa-project.org/files/pub/lib/alsa-ucm-conf-1.2.14.tar.bz2 --no-check-certificate
    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://www.alsa-project.org/files/pub/lib/alsa-lib-1.2.14.tar.bz2
    echo "✅ the package downloaded successfully"

    