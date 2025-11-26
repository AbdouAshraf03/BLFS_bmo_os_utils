#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/asciidoctor/asciidoctor/archive/v2.0.23/asciidoctor-2.0.23.tar.gz
    echo "✅ the package downloaded successfully"

    # When building this package, the following message may appear:
    #fatal: not a git repository (or any of the parent directories): .git
    #. This is normal, and the package will continue building past this point

   echo "🔧 Build the Ruby gem..."
    if ! gem build asciidoctor.gemspec; then
        echo "❌ Error: Build the Ruby gem failed!"
        exit 1
    fi

    echo "⚙️ installing..."
    if ! gem install asciidoctor-2.0.23.gem &&
        install -vm644 man/asciidoctor.1 /usr/share/man/man1; then
        echo "❌ Error: installing failed!"
        exit 1
    fi


fi


echo "🎉 FINISHED :)"
