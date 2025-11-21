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
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/logrotate/logrotate/releases/download/3.22.0/logrotate-3.22.0.tar.xz
    echo "✅ the package downloaded successfully"


   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr; then
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

    cat > /etc/logrotate.conf << EOF
# Begin /etc/logrotate.conf

# Rotate log files weekly
weekly

# Don't mail logs to anybody
nomail

# If the log file is empty, it will not be rotated
notifempty

# Number of backups that will be kept
# This will keep the 2 newest backups only
rotate 2

# Create new empty files after rotating old ones
# This will create empty log files, with owner
# set to root, group set to sys, and permissions 664
create 0664 root sys

# Compress the backups with gzip
compress

# No packages own lastlog or wtmp -- rotate them here
/var/log/wtmp {
    monthly
    create 0664 root utmp
    rotate 1
}

/var/log/lastlog {
    monthly
    rotate 1
}

# Some packages drop log rotation info in this directory
# so we include any file in it.
include /etc/logrotate.d

# End /etc/logrotate.conf
EOF

chmod -v 0644 /etc/logrotate.conf

mkdir -p /etc/logrotate.d

cat > /etc/logrotate.d/sys.log << EOF
/var/log/sys.log {
   # If the log file is larger than 100kb, rotate it
   size   100k
   rotate 5
   weekly
   postrotate
      /bin/killall -HUP syslogd
   endscript
}
EOF

chmod -v 0644 /etc/logrotate.d/sys.log

cat > /usr/lib/systemd/system/logrotate.service << "EOF" &&
[Unit]
Description=Runs the logrotate command
Documentation=man:logrotate(8)
DefaultDependencies=no
After=local-fs.target
Before=shutdown.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/sbin/logrotate /etc/logrotate.conf
EOF
cat > /usr/lib/systemd/system/logrotate.timer << "EOF" &&
[Unit]
Description=Runs the logrotate command daily at 3:00 AM

[Timer]
OnCalendar=*-*-* 3:00:00
Persistent=true

[Install]
WantedBy=timers.target
EOF
systemctl enable logrotate.timer

fi


echo "🎉 FINISHED :)"
