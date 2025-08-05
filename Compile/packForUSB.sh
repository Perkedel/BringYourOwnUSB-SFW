#!/bin/bash
# Pack our mods for USB!
# (JOELwindows7)
# https://tldp.org/LDP/abs/html/comparison-ops.html
# https://stackoverflow.com/a/2172367/9079640
# https://github.com/actions/checkout/tree/v4/q
# https://stackoverflow.com/a/40082454/9079640
# https://stackoverflow.com/a/638980/9079640

folderCompile="outCompile"

mkdir -p $folderCompile

for thing in Mods/GZDoom/*; do
    baseFilename=$(basename -- "$thing")
    extensionFile="${thing##*.}"
    justFilename=${baseFilename%.*}
    obtainedTarget="$folderCompile/$justFilename.pk7"
    specificFilename=$(basename -- "$justFilename")
    specificFilenameExt="$specificFilename.pk7"
    if [[ $extensionFile != md ]] && [[ $baseFilename != "ZD-TEMPLATE" ]]; then
        
        echo "Folder $thing, let's pack to $obtainedTarget ($specificFilenameExt)"
        cd "$thing"
        #7z a -t7z -mx9 -m0=lzma2 -- "$obtainedTarget" "$thing"
        7z a -t7z -mx9 -m0=lzma2 -- "$specificFilenameExt" *
        mv -f "$specificFilenameExt" ../../../outCompile
        cd ../../..
    fi
done