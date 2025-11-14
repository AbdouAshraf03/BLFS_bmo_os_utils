#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else

    wget  https://download.gnome.org/sources/gobject-introspection/1.86/gobject-introspection-1.86.0.tar.xz --no-check-certificate
    wget https://www.linuxfromscratch.org/patches/blfs/svn/glib-skip_warnings-1.patch --no-check-certificate

    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://download.gnome.org/sources/glib/2.86/glib-2.86.1.tar.xz
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>
    patch -Np1 -i ../glib-skip_warnings-1.patch
    mkdir build &&
    cd    build 

   echo "🔧 Running configure..."
    if ! meson setup ..                  \
      --prefix=/usr             \
      --buildtype=release       \
      -D introspection=disabled \
      -D glib_debug=disabled    \
      -D man-pages=enabled      \
      -D sysprof=disabled     ; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! ninja; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! ninja install; then
        echo "❌ Error: make failed!"
        exit 1
    fi

    tar xf ../../gobject-introspection-1.86.0.tar.xz &&

    meson setup gobject-introspection-1.86.0 gi-build \
            --prefix=/usr --buildtype=release     &&
    ninja -C gi-build

    ninja -C gi-build install

    meson configure -D introspection=enabled &&
    ninja

    echo "⚙️ installing..."
    if ! ninja install; then
        echo "❌ Error: make failed!"
        exit 1
    fi

   # <ETC>

fi


echo "🎉 FINISHED :)"
