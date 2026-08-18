#!/bin/env

# Simple SVG scouring script pls!
# https://github.com/scour-project/scour
# JOELwindows7

scalableSvgs='pngs/scalable'

cd $scalableSvgs
for f in *.svg; do
    nema="${f%.svg}-dirty.svg"
    mv "$f" $nema
    scour -i "$nema" -o "$f" --enable-viewboxing --enable-id-stripping --enable-comment-stripping --shorten-ids --indent=none
    rm $nema
done