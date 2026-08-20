#!/bin/sh

# prep
# JOELwindows7

cd "pngs/scalable"
for f in *.svg; do
    cp -r "${f}" "../../hyprcursor/extract/hyprcursors/${f%.svg}"
done