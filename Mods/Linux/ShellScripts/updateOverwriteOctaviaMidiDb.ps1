#!/bin/pwsh
# Download new Octavia Midi-Db & overwrite the old one

$Wget = "wget"
$Download = "https://gh.ltgc.cc/midi-db/dist/OctaviaRecommend.ins"
$DownloadTwo = "https://gh.ltgc.cc/midi-db/dist/OctaviaAlternative.ins"

Invoke-Expression "$($Wget) $($Download) -N"
Invoke-Expression "$($Wget) $($DownloadTwo) -N"