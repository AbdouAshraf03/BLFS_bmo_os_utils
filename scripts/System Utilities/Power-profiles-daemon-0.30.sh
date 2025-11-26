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
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://gitlab.freedesktop.org/upower/power-profiles-daemon/-/archive/0.30/power-profiles-daemon-0.30.tar.gz
    echo "✅ the package downloaded successfully"

    mkdir build &&
    cd build

   echo "🔧 Running configure..."
    if ! meson setup                \
      --prefix=/usr        \
      --buildtype=release  \
      -D gtk_doc=false     \
      -D tests=false       \
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

    systemctl enable power-profiles-daemon

    powerprofilesctl
    powerprofilesctl set performance

    gov=performance
    for CPUFREQ in /sys/devices/system/cpu/cpufreq/policy*/scaling_governor; do
    echo -n ${gov} > ${CPUFREQ}"
    done


fi


echo "🎉 FINISHED :)"
