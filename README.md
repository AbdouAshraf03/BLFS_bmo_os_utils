# BLFS_bmo_os_utils

## 1 - Main Script
```bash
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
    . ./../BLFS_bmo_os_utils/scripts/installer.sh <SCRIPT>
    echo "✅ the package downloaded successfully"

    <MORE_COMMAND_IF_EXISTS>

    <CONFIG> 
    echo "✅ the package configured successfully"
    
    <MAKE>
    echo "✅ the package made successfully"
    
    <MAKE_INSTALL>
    echo "✅ the package installed successfully"
    
    <ETC>
fi


echo "🎉 FINISHED :)"
```
