#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <link>"
  exit 1
fi

link="$1"
file=$(basename "$link")             # get last part of URL
echo "$file"
dir="${file%.tar.*}"                 # remove .tar.* from name

wget "$link" --no-check-certificate
tar -xvf "$file"
cd "$dir" || exit




