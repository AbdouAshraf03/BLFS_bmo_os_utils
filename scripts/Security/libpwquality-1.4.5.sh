#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/libpwquality/libpwquality/releases/download/libpwquality-1.4.5/libpwquality-1.4.5.tar.bz2
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr                      \
            --disable-static                   \
            --with-securedir=/usr/lib/security \
            --disable-python-bindings      ; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! make ; then
        echo "❌ Error: make failed!"
        exit 1
    fi

    echo "⚙️ python installing..."
    if !  pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD/python; then
        echo "❌ Error: install failed!"
        exit 1
    fi
   

    echo "⚙️ installing..."
    if ! make install &&
            pip3 install --no-index --find-links dist --no-user pwquality; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    mv /etc/pam.d/system-password{,.orig} &&
cat > /etc/pam.d/system-password << "EOF"
# Begin /etc/pam.d/system-password

# check new passwords for strength (man pam_pwquality)
password  required    pam_pwquality.so   authtok_type=UNIX retry=1 difok=1 \
                                         minlen=8 dcredit=0 ucredit=0      \
                                         lcredit=0 ocredit=0 minclass=1    \
                                         maxrepeat=0 maxsequence=0         \
                                         maxclassrepeat=0 gecoscheck=0     \
                                         dictcheck=1 usercheck=1           \
                                         enforcing=1 badwords=""           \
                                         dictpath=/usr/lib/cracklib/pw_dict

# use yescrypt hash for encryption, use shadow, and try to use any
# previously defined authentication token (chosen password) set by any
# prior module.
password  required    pam_unix.so        yescrypt shadow try_first_pass

# End /etc/pam.d/system-password
EOF
   # <ETC>

fi


echo "🎉 FINISHED :)"
