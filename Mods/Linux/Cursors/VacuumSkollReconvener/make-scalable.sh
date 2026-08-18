#!/bin/env

# pls scalable too
# JOELwindows7

scalables='pngs/scalable'
target='Vacuum Skoll Reconvener Dark'

foldername=$(echo $title | sed -e 's/[^A-Za-z0-9_-]/-/g')

# cd $scalables
cd 'pngs/scalable'
for f in *.svg; do
    cp $f "../../$foldername/cursor_scalable"
metadataing='[
    {
        "filename": "'$f'",
    }
]'
echo $metadataing > "../../$foldername/cursor_scalable/$f.json"
done