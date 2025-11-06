
#!/bin/bash

# Get the script name without .sh extension
folder_name=$(basename "$0" .sh)

# Check if a folder with the same name exists
if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
else
    . ./../instller.sh

    # configure 
    ./configure --prefix=/usr --disable-static 

    # make it 
    make

    # install it 
    make install

    # If you did not pass the --enable-gtk-doc parameter to the configure script, you can install the API documentation using the following command as the root user:
    make -C doc/reference install-data-local
    
fi
