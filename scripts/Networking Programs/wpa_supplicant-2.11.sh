#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://w1.fi/releases/wpa_supplicant-2.11.tar.gz
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>
cat > wpa_supplicant/.config << "EOF"
CONFIG_BACKEND=file
CONFIG_CTRL_IFACE=y
CONFIG_DEBUG_FILE=y
CONFIG_DEBUG_SYSLOG=y
CONFIG_DEBUG_SYSLOG_FACILITY=LOG_DAEMON
CONFIG_DRIVER_NL80211=y
CONFIG_DRIVER_WEXT=y
CONFIG_DRIVER_WIRED=y
CONFIG_EAP_GTC=y
CONFIG_EAP_LEAP=y
CONFIG_EAP_MD5=y
CONFIG_EAP_MSCHAPV2=y
CONFIG_EAP_OTP=y
CONFIG_EAP_PEAP=y
CONFIG_EAP_TLS=y
CONFIG_EAP_TTLS=y
CONFIG_IEEE8021X_EAPOL=y
CONFIG_IPV6=y
CONFIG_LIBNL32=y
CONFIG_PEERKEY=y
CONFIG_PKCS12=y
CONFIG_READLINE=y
CONFIG_SMARTCARD=y
CONFIG_WPS=y
CFLAGS += -I/usr/include/libnl3
EOF
cat >> wpa_supplicant/.config << "EOF"
CONFIG_CTRL_IFACE_DBUS=y
CONFIG_CTRL_IFACE_DBUS_NEW=y
CONFIG_CTRL_IFACE_DBUS_INTRO=y
EOF
cd wpa_supplicant


   

    echo "⚙️  Running make..."
    if ! make BINDIR=/usr/sbin LIBDIR=/usr/lib; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    

   # <ETC>
   install -v -m755 wpa_{cli,passphrase,supplicant} /usr/sbin/ 
   install -v -m644 doc/docbook/wpa_supplicant.conf.5 /usr/share/man/man5/ 
   install -v -m644 doc/docbook/wpa_{cli,passphrase,supplicant}.8 /usr/share/man/man8/
   install -v -m644 systemd/*.service /usr/lib/systemd/system/
   install -v -m644 dbus/fi.w1.wpa_supplicant1.service \
                    /usr/share/dbus-1/system-services/ 
   install -v -d -m755 /etc/dbus-1/system.d 
   install -v -m644 dbus/dbus-wpa_supplicant.conf \
                    /etc/dbus-1/system.d/wpa_supplicant.conf

fi

echo "Configuring wpa_supplicant"
echo "🎉 FINISHED :)"
