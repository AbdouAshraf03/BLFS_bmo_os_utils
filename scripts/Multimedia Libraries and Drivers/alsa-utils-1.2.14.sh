cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://www.alsa-project.org/files/pub/utils/alsa-utils-1.2.14.tar.bz2
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>

   echo "🔧 Running configure..."
    if ! ./configure --disable-alsaconf \
            --disable-bat      \
            --disable-xmlto    \
            --with-curses=ncursesw; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! make; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if !make install; then
        echo "❌ Error: make failed!"
        exit 1
    fi

    alsactl init
    alsactl -L store
    cat > /etc/asound.conf << "EOF"
    # Begin /etc/asound.conf

    defaults.pcm.card 1
    defaults.ctl.card 1

    # End /etc/asound.conf
    EOF

fi


echo "🎉 FINISHED :)"
