#!/bin/bash  

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else

   # wget <LINK> --no-check-certificate

    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://bitbucket.org/multicoreware/x265_git/downloads/x265_4.1.tar.gz
    echo "✅ the package downloaded successfully"
    
    # First, remove some CMake policy settings that are no longer compatible with CMake-4.0 and later:

   echo "🔧 Running remove some CMake..."
    if ! sed -r '/cmake_policy.*(0025|0054)/d' -i source/CMakeLists.txt; then
        echo "❌ Error: remove some CMake failed!"
        exit 1
    fi

    mkdir bld 
    cd    bld 

   echo "🔧 Running configure..."
    if ! cmake -D CMAKE_INSTALL_PREFIX=/usr        \
               -D GIT_ARCHETYPE=1                  \
               -D CMAKE_POLICY_VERSION_MINIMUM=3.5 \
               -W no-dev                           \
               ../source ; then
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
        exit 1nstal
    fi

    rm -vf /usr/lib/libx265.a

fi


echo "🎉 FINISHED :)"
