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
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://dbus.freedesktop.org/releases/dbus/dbus-1.16.2.tar.xz
    echo "✅ the package downloaded successfully"

    mkdir build 
    cd    build 

   echo "🔧 Running configure..."
    if ! meson setup --prefix=/usr          \
            --buildtype=release    \
            --wrap-mode=nofallback \
            ..; then
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

    chown -v root:messagebus /usr/libexec/dbus-daemon-launch-helper &&
    chmod -v      4750       /usr/libexec/dbus-daemon-launch-helper

    if [ -e /usr/share/doc/dbus ]; then
  rm -rf /usr/share/doc/dbus-1.16.2    &&
  mv -v  /usr/share/doc/dbus{,-1.16.2}
fi


echo "🔧 Running configure..."
    if ! meson configure -D asserts=true -D intrusive_tests=true; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

echo "⚙️ testing..."
    if ! ninja test; then
        echo "❌ Error: test failed!"
        exit 1
    fi

    cat > /etc/dbus-1/session-local.conf << "EOF"
<!DOCTYPE busconfig PUBLIC
 "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
 "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
<busconfig>

  <!-- Search for .service files in /usr/local -->
  <servicedir>/usr/local/share/dbus-1/services</servicedir>

</busconfig>
EOF

# Start the D-Bus session daemon
eval `dbus-launch`
export DBUS_SESSION_BUS_ADDRESS

# Kill the D-Bus session daemon
kill $DBUS_SESSION_BUS_PID

fi


echo "🎉 FINISHED :)"
