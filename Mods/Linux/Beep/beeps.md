# GRUB Init Tune & `beep`s

Checkout these PC Beep songs!

## Row of Tips

- Your motherboard should have a header called `BEEP`, `PC_BEEP`, or anything.
  - You can build a doohickey consisting of an 8 Ohm toy speaker, led to said dupont connector for the header.
  - You can buy a generic Piezo beeper for just a dime on many PC & Server builder marketplaces, cut off those cable and replace it with the 8 Ohm toy speaker
  - However, if your soundcard has `PC_BEEP_IN` (just like whereas `CD IN` next to it), create connection to that instead, and make sure correct driver of the soundcard is installed. On your Volume Control, you can adjust Output `PC Speaker` volume there. This make PC beeps also to normal speaker or headphones.
- If your motherboard evolution finally lost that `PC_BEEP` header, game over. We cannot find anything that could emulate PC Beep reliably over normal soundcard by software.
  - afaik, `snd_pcsp` (AUR available `snd_pcsp_dkms` & `modprobe -r pcskr && modprobe snd_pcsp`) is about turning that `PC_BEEP` into a soundcard itself, not the vice versa we thought, I think.. Huh??
- Destroy PC Beep outright if that's annoyed you. Here [article](https://wiki.archlinux.org/title/PC_speaker#Globally)
  - file `/etc/modprobe.d/nobeep.conf` contains
    - `blacklist pcspkr`
    - `blacklist snd_pcsp`
  - Or over boot parameter
    - add to `GRUB_CMDLINE_LINUX_DEFAULT` the `module_blacklist=pcspkr,snd_pcsp`
    - then update now! `sudo grub-mkconfig -o /boot/grub/grub.cfg`. Tired? install the wrapper, `update-grub` AUR and use `sudo update-grub`.
    - [see article](https://wiki.archlinux.org/title/GRUB)
  - Do it now, before restart
    - `rmmod pcspkr`
    - `rmmod snd_pcsp`

## Arch Linux

- Beep
  - Info
    - [About `PC Speaker`](https://wiki.archlinux.org/title/PC_speaker)

## spkr-beep

- Beep
  - Info
    - We got Beep fork!
  - [Sauce](https://github.com/spkr-beep/beep)
    - [Original](https://github.com/johnath/beep)

## ShaneMcC

- GRUB Init Tune
  - ...
- Beep
  - Info
    - See each file in the repo at below sauce!
    - Custom [`beep`](https://github.com/ShaneMcC/beeps/blob/master/beep) program included for Laptops & Motherboard without PC Beep header (circa since 2023, e.g. X670s)
      - One off e.g. `PATH="$PWD:$PATH" bash mario-victory.sh`. Note the `PATH="$PWD:$PATH"`, you can play those beep music bash files or debug with `PATH="$PWD:$PATH beep -f 440 -l 1000` e.g.
      - User level permanently replace original `beep` with included by symlinking `ln -s "$PWD/beep" ~/.local/bin/beep`
  - [Sauce](https://github.com/ShaneMcC/beeps)

## Unknown

- GRUB Init Tune
  - Arpegio A. from GRUB somewhere
    - `480 220 1 277 1 330 1 440 1 185 1 220 1 277 1 370 1 294 1 370 1 440 1 587 1 330 1 415 1 494 1 659 1`
- Extras
  - [cocafe's Windows PC Beeper](https://github.com/cocafe/pc-beeper)
  - [Beep emulatatoaot](https://bbs.archlinux.org/viewtopic.php?id=77732). `snd_pcsp`

## JOELwindows7

- GRUB Init Tune
  - Guruku Tersayang. 
    - `202 493 1 391 1 293 1 493 1 523 1 391 1 329 1 0 1 293 1 369 1 440 1 523 1 523 1 493 1 493 1 0 1 493 1 391 1 293 1 493 1 523 1 391 1 329 1 0 1 293 1 0 1 369 1 0 1 391 2`
  - Chinese Bluetooth Headset Beebop sound variant
    - Start `320 220 1 277 1 440 1 544 1`
    - Stop `320 554 1 440 1 311 1 220 1`
    - Beep `320 493 1`
  - Sounds Beyond Range & Commonality
    - Ultrasonic `100 20000 5`
    - Infrasonic `100 20 5`
    - Left-Right `20 432 5 512 5 432 5 512 5 432 5 512 5 432 5 512 5 432 5 512 5 432 5 512 5`
    - *Scientific `A` tuning* `60 432 500`
  - [Sauce](https://github.com/JOELwindows7/GRUB_INIT_TUNE_Compilation)
    - Related
      - [Drone Startup Sounds!](/Mods/Drone/blheli/blheli_musics.md)