#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/google/shaderc/archive/v2025.3/shaderc-2025.3.tar.gz
    echo "✅ the package downloaded successfully"

    echo "🔧 building..."
    if ! sed '/build-version/d'   -i glslc/CMakeLists.txt            &&
        sed '/third_party/d'     -i CMakeLists.txt                  &&
        sed 's|SPIRV|glslang/&|' -i libshaderc_util/src/compiler.cc; then
        echo "❌ Error: build failed!"
        exit 1
    fi
    echo '"2025.3"' > glslc/src/build-version.inc

    mkdir build &&
    cd    build

   echo "🔧 Running configure..."
    if ! cmake -D CMAKE_INSTALL_PREFIX=/usr \
       -D CMAKE_BUILD_TYPE=Release  \
       -D SHADERC_SKIP_TESTS=ON     \
       -G Ninja ..; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running ninja..."
    if ! ninja; then
        echo "❌ Error: ninja failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! install -vm755 glslc/glslc /usr/bin; then
        echo "❌ Error: install failed!"
        exit 1
    fi


fi


echo "🎉 FINISHED :)"
