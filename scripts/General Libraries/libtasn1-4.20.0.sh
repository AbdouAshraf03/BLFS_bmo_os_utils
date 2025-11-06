
#!/bin/bash

set -e

cd ~
cd sources/BLFS

# Get the script name without .sh extension
folder_name=$(basename "$0" .sh)

# Check if a folder with the same name exists
if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
else
    . ./../installer.sh https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.20.0.tar.gz
    echo "✅ the package downloaded sucsuccessfully"
    # configure 
    ./configure --prefix=/usr --disable-static 
    echo "✅ the package configured sucsuccessfully"
    # make it 
    make
    echo "✅ the package maked sucsuccessfully"
    # install it 
    make install
    echo "✅ the package installed sucsuccessfully"
    # If you did not pass the --enable-gtk-doc parameter to the configure script, you can install the API documentation using the following command as the root user:
    make -C doc/reference install-data-local
    
fi

echo "FINISHED :)"
