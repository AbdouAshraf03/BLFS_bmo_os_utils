#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://www.freedesktop.org/software/appstream/releases/AppStream-1.0.6.tar.xz
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>
    mkdir build &&
    cd    build
   echo "🔧 Running configure..."
    if ! meson setup --prefix=/usr       \
            --buildtype=release \
            -D apidocs=false    \
            -D stemming=false   .. ; then
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
    mv -v /usr/share/doc/appstream{,-1.0.6}
   # <ETC>
    install -vdm755 /usr/share/metainfo &&
cat > /usr/share/metainfo/org.linuxfromscratch.lfs.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<component type="operating-system">
  <id>org.linuxfromscratch.lfs</id>
  <name>BMO-OS</name>
  <summary>A customized Linux system built entirely from source</summary>
  <description>
    <p>
      BMO OS is a custom Linux-based operating system built entirely from source using Linux From Scratch (LFS) and Beyond Linux From Scratch (BLFS).
      Designed and developed by BMOs — focused on simplicity, performance, and modular design.
    </p>
  </description>
  <url type="homepage">https://github.com/AbdouAshraf03/bmo-os</url>
  <metadata_license>MIT</metadata_license>
  <developer id='linuxfromscratch.org'>
    <name>ABDOU ASHRAF and BMOS</name>
  </developer>

  <releases>
    <release version="1.0" type="release" date="2025-11-30">
      <description>
        <p>Now contains Binutils 2.45, GCC-15.2.0, Glibc-2.42,
        Linux kernel 6.16, and twelve security updates.</p>
      </description>
    </release>
  </releases>
</component>
EOF
fi


echo "🎉 FINISHED :)"
