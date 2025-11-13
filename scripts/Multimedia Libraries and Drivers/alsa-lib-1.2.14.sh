cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
elsez

    wget  https://www.alsa-project.org/files/pub/lib/alsa-ucm-conf-1.2.14.tar.bz2 --no-check-certificate

    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://www.alsa-project.org/files/pub/lib/alsa-lib-1.2.14.tar.bz2
    echo "✅ the package downloaded successfully"

   sed 's/playmidi1//' -i test/Makefile.am
   autoreconf -fi


   echo "🔧 Running configure..."
    if ! ./configure; then
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
         tar -C /usr/share/alsa --strip-components=1 -xf ../alsa-ucm-conf-1.2.14.tar.bz2 ;then
        echo "❌ Error: make failed!"
        exit 1
    fi

  install -v -d -m755 /usr/share/doc/alsa-lib-1.2.14/html/search
  install -v -m644 doc/doxygen/html/*.* \
                /usr/share/doc/alsa-lib-1.2.14/html 
  install -v -m644 doc/doxygen/html/search/* \
                /usr/share/doc/alsa-lib-1.2.14/html/search              

fi


echo "🎉 FINISHED :)"
