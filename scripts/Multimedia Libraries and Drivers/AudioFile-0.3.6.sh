#!/bin/bash 

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
     
    
    wget  https://www.linuxfromscratch.org/patches/blfs/12.4/audiofile-0.3.6-consolidated_patches-1.patch --no-check-certificate

    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://download.gnome.org/sources/audiofile/0.3/audiofile-0.3.6.tar.xz
    echo "✅ the package downloaded successfully"

   patch -Np1 -i ../audiofile-0.3.6-consolidated_patches-1.patch
   autoreconf -fiv

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr --disable-static; then  #--disable-static: This switch prevents installation of static versions of the libraries.
        echo "❌ Error: configure failed!"                 #اعمل ايه عشان تمنع تثبيت النسخ الستاتيكية من المكتبات
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

   # <ETC>

fi


echo "🎉 FINISHED :)"
