#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://invisible-mirror.net/archives/xterm/xterm-401.tgz
    echo "✅ the package downloaded successfully"

   sed -i '/v0/{n;s/new:/new:kb=^?:/}' termcap &&
    printf '\tkbs=\\177,\n' >> terminfo &&

   echo "🔧 Running configure..."
    TERMINFO=/usr/share/terminfo \
    if ! ./configure $XORG_CONFIG     \
                    --with-app-defaults=/etc/X11/app-defaults; then
        echo "❌ Error: configure failed!"
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

    mkdir -pv /usr/share/applications &&
    cp -v *.desktop /usr/share/applications/

    cat >> /etc/X11/app-defaults/XTerm << "EOF"
*VT100*locale: true
*VT100*faceName: Monospace
*VT100*faceSize: 10
*backarrowKeyIsErase: true
*ptyInitialErase: true
EOF

fi


echo "🎉 FINISHED :)"