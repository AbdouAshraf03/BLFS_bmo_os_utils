#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://downloads.sourceforge.net/traceroute/traceroute-2.1.6.tar.gz
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>



    echo "⚙️  Running make..."
    if ! make; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! make prefix=/usr install; then
        echo "❌ Error: make failed!"
        exit 1
    fi

   # <ETC>
   ln -sv -f traceroute /usr/bin/traceroute6                
   ln -sv -f traceroute.8 /usr/share/man/man8/traceroute6.8 
   rm -fv /usr/share/man/man1/traceroute.1

fi


echo "🎉 FINISHED :)"
