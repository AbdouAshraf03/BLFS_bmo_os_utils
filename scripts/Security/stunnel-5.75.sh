#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://www.stunnel.org/downloads/archive/5.x/stunnel-5.75.tar.gz
    echo "✅ the package downloaded successfully"
    
    groupadd -g 51 stunnel &&
    useradd -c "stunnel Daemon" -d /var/lib/stunnel \
        -g stunnel -s /bin/false -u 51 stunnel
   
   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! make; then
        echo "❌ Error: make failed!"
        exit 1
    fi

     echo "⚙️ installing..."
    if ! make docdir=/usr/share/doc/stunnel-5.75 install; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    install -v -m644 tools/stunnel.service /usr/lib/systemd/system

    make cert

    install -v -m750 -o stunnel -g stunnel -d /var/lib/stunnel/run &&
    chown stunnel:stunnel /var/lib/stunnel
   
   # <ETC>
   cat > /etc/stunnel/stunnel.conf << "EOF"
; File: /etc/stunnel/stunnel.conf

; Note: The pid and output locations are relative to the chroot location.

pid    = /run/stunnel.pid
chroot = /var/lib/stunnel
client = no
setuid = stunnel
setgid = stunnel
cert   = /etc/stunnel/stunnel.pem

;debug = 7
;output = stunnel.log

;[https]
;accept  = 443
;connect = 80
;; "TIMEOUTclose = 0" is a workaround for a design flaw in Microsoft SSL
;; Microsoft implementations do not use SSL close-notify alert and thus
;; they are vulnerable to truncation attacks
;TIMEOUTclose = 0

EOF

systemctl enable stunnel

fi


echo "🎉 FINISHED :)"
