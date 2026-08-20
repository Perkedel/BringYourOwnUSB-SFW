#!/bin/sh

# install to user!

themetitle='Vacuum Skoll Endfield Dark'
foldername=$(echo $themetitle | sed -e 's/[^A-Za-z0-9_-]/-/g')

cp -rf $foldername "$HOME/.local/share/icons"