# blheli musics

Tunes for your Drones that use blheli to drive the rotors

> [!CAUTION]  
> **NoAI**, Please do not use below data for LLM/AI Sampling. This includes the open source ones (even Creative Commons Free Culture such as `CC4.0-BY-SA`)

## Sofwares Needed!

### First, Update your esc firmware!

Please update your ESC to better firmware version

- BLHeli_32. Use [Escape32](https://github.com/neoxic/ESCape32), the new open source alternative of the original (which is proprietary btw, idk).
  - [Info](https://github.com/bitdump/BLHeli/tree/master/BLHeli_32%20ARM)
  - [Custom firmware for JDM-188 RC](https://github.com/neoxic/STM32F0/blob/master/doc/jdm.md)
- BLHeli_S. Use [BLHeli_S & AM32 Bluejay Configurator](https://github.com/mathiasvr/bluejay-configurator/releases) or [Online PWA](https://esc-configurator.com/) or [CN Mirror](https://esc-configurator.pitronic.top/). New for `S` is [Bluejay](https://github.com/bird-sanctuary/bluejay)

### Flashers

Use the following softwares to do so

- [BlHeli_32 BLHeliSuite](https://www.mediafire.com/folder/dx6kfaasyo24l/BLHeliSuite) or [this](https://github.com/bitdump/BLHeli/releases), use ~~32.3.0.4 /~~ latest there is (32.10.0.0). from [here](https://github.com/bitdump/BLHeli) ~~a~~
  - [Info](https://github.com/bitdump/BLHeli/tree/master/BLHeli_32%20ARM)
- [BLHeli_S & AM32 Bluejay Configurator](https://github.com/mathiasvr/bluejay-configurator/releases) or [Online PWA](https://esc-configurator.com/) or [CN Mirror](https://esc-configurator.pitronic.top/). [Source Code](https://github.com/stylesuxx/esc-configurator)
  - [CP210x Driver](https://www.silabs.com/developers/usb-to-uart-bridge-vcp-drivers)
  - [STM USB VCP Driver](https://www.st.com/en/development-tools/stsw-stm32102.html)
  - inspired from [Original blheli-configurator](https://github.com/blheli-configurator/blheli-configurator)
  - [AM32 Config](https://am32.ca/configurator) & [Website](https://am32.ca/configurator)
- [Betaflight Configurator (Online PWA)](https://app.betaflight.com/) & [Android Releases](https://github.com/betaflight/betaflight-configurator/releases). [Source Code](https://github.com/betaflight/betaflight-configurator), [GitHub total](https://github.com/betaflight). Configure your Betaflight Flight Units
- [Escape32 Tools CLI](https://github.com/neoxic/ESCape32-Tools/releases). If you want Escape32 instead.
- [ESCTunes.com](http://esctunes.com/) Libraries of ESC musics
  - [Tunes](http://esctunes.com/tunes)
  - The Bluejay (BLHeli_S) configurator & This site uses Nokia RTTL format
- [Skully's RTTL Composer](https://rtttl.skully.tech/). [Source Code](https://github.com/ImSkully/rtttl-web-composer). Easy & Intuitive RTTL Nokring Composer. You can copy the RTTL result directly to your Bluejay Configurator!

## **Musics**

Enjoy these musics now!!

### Bluejay Configurator

Flash your **BLHeli_S** with Bluejay & install which music you'd like using [`Open Melody Editor`](https://esc-configurator.com/). Choose over different presets from dropdown. Bunch of Copies of those songs below:

- Template Separate
  - ESC 1: `a`
  - ESC 2: `b`
  - ESC 3: `c`
  - ESC 4: `d`
- Template Synchronize
  - All: `abcd`
- Bluejay Default
  - All: `bluejay:b=570,o=4,d=32:4b,p,4e5,p,4b,p,4f#5,2p,4e5,2b5,8b5`
- Super Mario Mushroom Power up
  - ESC 1: `powerup_1: d=2,o=2,b=960:8c4,8g3,8c4,8e4,8g4,8c5,8g4,8g#3,8c4,8d#4,8g#4,8d#4,8g#4,8c5,8d#5,8g#5,8d#5,8d4,8f4,8a#4,8f4,8a#4,8d5,8f5,8d5,8f5,8a#5,8f5`
  - ESC 2: `powerup_2: d=2,o=2,b=960:8c5,8g4,8c5,8e5,8g5,8c6,8g5,8g#4,8c5,8d#5,8g#5,8d#5,8g#5,8c6,8d#6,8g#6,8d#6,8d5,8f5,8a#5,8f5,8a#5,8d6,8f6,8d6,8f6,8a#6,8f6`
  - ESC 3: `powerup_1: d=2,o=2,b=960:8c4,8g3,8c4,8e4,8g4,8c5,8g4,8g#3,8c4,8d#4,8g#4,8d#4,8g#4,8c5,8d#5,8g#5,8d#5,8d4,8f4,8a#4,8f4,8a#4,8d5,8f5,8d5,8f5,8a#5,8f5`
  - ESC 4: `powerup_2: d=2,o=2,b=960:8c5,8g4,8c5,8e5,8g5,8c6,8g5,8g#4,8c5,8d#5,8g#5,8d#5,8g#5,8c6,8d#6,8g#6,8d#6,8d5,8f5,8a#5,8f5,8a#5,8d6,8f6,8d6,8f6,8a#6,8f6`
- 2Pac - Hit Em Up
  - All: `2pac_hit_em_up:d=4,o=5,b=200:a,8p,a,8g,a,p,a,c6,a,d6,8p,d6,8c6,d6,2p,8p,8d6,8d#6,e6,8p,e6,8d6,e6,p,c6,8b,8g,e,a.,a,8g,a`
- Abba - Chiquita
  - ESC 1: `ab_chiq_m1:b=104,o=5,d=16:8f#,c#,p,c#,p,c#,p,c#,p,c#,p,c#,h4,c#,d,8f#,e6,e,e6,p,e6,e,e6,e,e6,e,e6,e,e6,e,g#6,g#,g#6,g#,g#6,g#,g#6,g#,a6,a,a6,a,a6,a,a6,a,g#6,g#,g#6,g#,a6,a,a6,a,h6,h,h6,h,8a6`
  - ESC 2: `ab_chiq_m2:b=104,o=6,d=16:8f#,c#,p,c#,p,c#,p,c#,p,c#,p,c#,h5,c#,d,8f#,a5,p,a5,p,a5,p,a5,p,a5,p,a5,p,a5,p,d,p,d,p,d,p,d,p,d,p,d,p,d,p,d,p,d,p,d,p,d,p,d,p,d,p,d,p,8d`
  - ESC 3: `ab_chiq_b1:b=104,o=4,d=16:a3,p,a3,p,e,p,a3,p,a3,p,a3,p,e,p,a3,p,a3,p,a3,p,e,p,a3,p,a3,p,a3,p,h3,p,c#,p,d,p,d,p,a,p,d,p,d,p,d,p,a,p,d,p,d,p,d,p,a,p,d,p,d,p,d,p,8a`
  - ESC 4: `ab_chiq_b2:b=104,o=4,d=16:a3,p,a3,p,a,p,a3,p,a3,p,a3,p,a,p,a3,p,a3,p,a3,p,a,p,a3,p,a,p,a,p,h,p,c#5,p,d,p,d,p,d5,p,d,p,d,p,d,p,d5,p,d,p,d,p,d,p,d5,p,d,p,d,p,d,p,8d5`
- Among Us Theme
  - All: `Amongus:b=95,o=5,d=4:c4,8c6,8d#6,8f6,8f#6,8f6,8d#6,c6,8c6,16a#,16d6,c6,16c6,8g3,c4,8c6,8d#6,8f6,8f#6,8f6,8d#6,2f#6,16f#6,16f6,16d#6,16f#6,16f6,16d#6`
- AC/DC - Black in Black
  - ESC 1: `ACDCBack1:b=180,o=5,d=4:16b4,8p.,2p,16d,16p,16d,16p,16d,8p.,2p,16a4,16p,16a4,16p,16a4,8p.,2p.,8p,16g4,16p,16e4,16p,16d4,16p,16b3,16p,16a3,16b3,16a3,16p,16g3,16p`
  - ESC 2: `ACDCBack2:b=180,o=5,d=4:16g#4,8p.,2p,16d4,16p,16d4,16p,16d4,8p.,2p,16e4,16p,16e4,16p,16e4,8p.,2p.,1p`
  - ESC 3: `ACDCBack3:b=180,o=5,d=4:16e3,8p.,p,16e3,8p.,p,2p,16e3,8p.,p,2p,16e3,8p.,p,2p,16e3,8p.,p`
  - ESC 4: `ACDCBack4:b=180,o=5,d=4:16e4,8p.,2p,16a3,16p,16a3,16p,16a3,8p.,2p,16c#4,16p,16c#4,16p,16c#4,8p.,2p.,1p`
- AC/DC - TNT
  - ESC 1: `tnt1:d=4,o=3,b=250:2c6,4c6,2p,4d#6,4p,2f6,4f6,4p,4d#5,4f6,4d#5,4p,2c6`
  - ESC 2: `tnt2:d=4,o=3,b=250:2g5,4g5,2p,4a#5,4p,2c6,4c6,2p,4c6,2p,2g5`
  - ESC 3: `tnt3:d=4,o=3,b=250:2c5,4c5,2p,4d#5,4p,2f5,4f5,4p,4d#5,4f5,4d#5,4p,2c5`
  - ESC 4: `tnt4:d=4,o=3,b=250:8c4,8p,8c4,8p,8c4,8p,8c4,8p,8c4,8p,8d#4,8p,8d#4,8p,8f4,8p,8f4,8p,8f4,8p,8f4,8p,8d#4,8p,8f4,8p,8d#4,8p,8d#4,8p,2c4`
- Bad Apple
  - ESC 1: `Melody:b=147,o=5,d=8:d#,f,f#,g#,16a#,p,16a#,d#6,c#6,16a#,p,16a#,16d#,p,16d#,1p,1p,2p,d#,f,f#,g#,16a#,p,16a#,d#6,c#6,16a#,p,16a#,16d#,1p,1p,4p`
  - ESC 2: `Melody:b=147,o=5,d=8:1p,2p,a#,g#,f#,f,d#,f,f#,g#,16a#,p,16a#,g#,f#,f,d#,f,f#,f,d#,d,f,1p,2p,a#,g#,f#,f,d#,f,f#,g#,16a#,p,16a#,1p,p`
  - ESC 3: `Melody:b=147,o=5,d=8:d#4,a#4,d#4,a#4,d#4,a#4,d#4,a#4,d#4,a#4,d#4,a#4,d#4,a#4,d#4,a#4,b3,f#4,b3,f#4,b3,f#4,b3,f#4,c#4,g#4,c#4,g#4,d4,a#4,d4,a#4,d#4,a#4,d#4,a#4,d#4,a#4,d#4,a#4,d#4,a#4,d#4,a#4,d#4,a#4,d#4,a#4,b3,f#4,b3,f#4,b3,f#4,b3,f#4,c#4,g#4,c#4,g#4,d4,a#4`
  - ESC 4: `Melody:b=147,o=5,d=8:1p,1p,1p,1p,1p,1p,2p,4p,g#,f#,16f,p,16f,16f#,p,16f#,16g#,p,16g#,16a#,p,16a#`
- Batman Theme
  - ESC 1: `bm_0:b=180,o=4,d=32:8d#5,p,8d#5,p,8d5,p,8d5,p,8c#5,p,8c#5,p,8d5,p,8d5,p,4d#5,p,p,2d#5`
  - ESC 2: `bm_1:b=180,o=4,d=32:8g#,p,8g#,p,8g#,p,8g#,p,8g#,p,8g#,p,8g#,p,8g#,p,4g#,p,p,2g#`
  - ESC 3: `bm_2:b=180,o=4,d=32:8d#6,p,8d#6,p,8d6,p,8d6,p,8c#6,p,8c#6,p,8d6,p,8d6,p,4g#6,p,p,2g#6`
  - ESC 4: `bm_3:b=180,o=4,d=32:8g#,p,8g#,p,8g#,p,8g#,p,8g#,p,8g#,p,8d#6,p,8d#6,p,4d#6,p,p,2d#6`
- NOMA - Brain Power
  - ESC 1: `Brainpower:b=170,o=4,d=32:16e5,16p,16f#5,16p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,e5,p,e5,p,e5,p,e5,p,16b,16p,16c#5,16p,16a,16p,16f#5,16p,16f#5,16p,16e5`
  - ESC 2: `Brainpower:b=170,o=4,d=32:16e5,16p,16f#5,16p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,e5,p,e5,p,e5,p,e5,p,16b,16p,16c#5,16p,16a,16p,16f#5,16p,16f#5,16p,16e5`
  - ESC 3: `Brainpower:b=170,o=4,d=32:1p,1p,16e5,16p,16f#5,16p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,d5,p,d5,p,d5,p,d5,p,16f#5,16p,16a5,16p,16g#5,16p,16a5,16p,16g#5,p,16g#5,16c#5`
  - ESC 4: `Brainpower:b=170,o=4,d=32:1p,1p,16e5,16p,16f#5,16p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,f#5,p,d5,p,d5,p,d5,p,d5,p,16f#5,16p,16a5,16p,16g#5,16p,16a5,16p,16g#5,p,16g#5,16c#5`
- Britney Spears - Oops!... I did it again
  - ESC 1: `oops1:d=4,o=5,b=120:8a,8g,8f,8e,16d,16p,8d.,16p,8d.,16p,8c#,8d,8e,8d`
  - ESC 2: `oops2:d=4,o=5,b=120:8c,8p,8c,8a.4,16p,8a.4,16p,8a.4,16p,8a4,8b4,8c#,8a4`
  - ESC 3: `oops3:d=4,o=5,b=120:8c,8p,8c,8a.4,16p,8a.4,16p,8a.4,16p,8a4,8b4,8c#,8a4`
  - ESC 4: `oops4:d=4,o=5,b=120:p.,a3,2d4,2c#4`
- Bobby Helms - Jingle Bell Rock
  - ESC 1: `jingle1:b=200,o=5,d=4:f#,32p,8f#,32p,8f#,p,f#,32p,8f#,32p,8f#,p,f#,32p,8a,32p,d,32p,8e,64p,f,32p,8e,32p,d,32p,8b4,32p,2a4`
  - ESC 2: `jingle2:b=200,o=5,d=4:d,32p,8d,32p,8d,p,c#,32p,8c#,32p,8c#,p,d,32p,8e,32p,a4,32p,8b4,32p,c,32p,8b4,64p,a4,32p,8g4,32p,2f#4`
  - ESC 3: `jingle3:b=200,o=5,d=4:f#,32p,8f#,32p,8f#,p,f#,32p,8f#,32p,8f#,p,f#,32p,8a,32p,d,32p,8e,64p,f,32p,8e,32p,d,32p,8b4,32p,2a4`
  - ESC 4: `jingle4:b=200,o=5,d=4:d,32p,8d,32p,8d,p,c#,32p,8c#,32p,8c#,p,d,32p,8e,32p,a4,32p,8b4,32p,c,32p,8b4,64p,a4,32p,8g4,32p,2f#4`
- Castlevania Adventure - Battle of the Holy
  - ESC 1: `battle1:b=120,o=5,d=16:e,b4,e,b,b4,e,a#,b4,e,a,b4,e,g,b4,e,b4,g,b4,e,a,b4,e,g,b4,e,f#,b4,e,f#,b4,b3,8a,32a,32p,8a#,32a#,32p,8b.`
  - ESC 2: `battle2:b=120,o=4,d=16:1e3,2c.,8d,8p,8e3,8p,8e3,8p`
  - ESC 3: `battle3:b=120,o=4,d=16:1p,2p.,b3,b5,8e3,8p,8e3,8p,8e3`
  - ESC 4: `battle4:b=120,o=5,d=16:e,b4,e,b,b4,e,a#,b4,e,a,b4,e,g,b4,e,b4,g,b4,e,a,b4,e,g,b4,e,f#,b4,e,f#,b4,b,8a,32a,32p,8a#,32a#,32p,8b.`
- Cheech and Chong - Earache my Eye
  - ESC 1: `Earache:d=4,o=3,b=180:8b,8a#,a,8b,8a#,a,d4,32p,d4,1b,1b`
  - ESC 2: `Earache:d=4,o=4,b=180:8b,8a#,a,8b,8a#,a,d5,32p,d5,1b,1b`
  - ESC 3: `Earache:d=4,o=3,b=180:8b,8a#,a,8b,8a#,a,d4,32p,d4,1b,1b`
  - ESC 4: `Earache:d=4,o=4,b=180:8f#,8f,e,8f#,8f,e,a,32p,a,1f#,1f#`
- Chopin - Revolutionary Etude
  - ESC 1: `rev_etude_0:o=5,b=160,d=16:8p,g#6,g6,f6,d6,d#6,d6,b,g,g#,g,f,d,d#,d,b4,g4,g#4,g4,f4,d4,d#4,d4,c4,g3,c4,g3,c4,g3,c4,g3,1d6,2p.,8g#.,g,1f6`
  - ESC 2: `rev_etude_1:o=5,b=160,d=16:1b,2p.,8g#.,g,8b3,g#6,g6,f6,d6,d#6,d6,b,g,g#,g,f,d,d#,d,b4,g4,g#4,g4,f4,d4,d#4,d4,c4,g3,c4,g3,c4,g3,c4,g3,1d6`
  - ESC 3: `rev_etude_2:o=5,b=160,d=16:1g,2p.,8f.,32g.,64p,1g,2p.,8f.,32g.,64p,8p,g#6,g6,f6,d6,d#6,d6,b,g,g#,g,f,d,d#,d,b4,g4,g#4,g4,f4,d4,d#4,d4,c4,b3,g4,f4,d#4,d4,d#4,d4,c4,b3,a#4,g#4,g4`
  - ESC 4: `rev_etude_3:o=5,b=160,d=16:1f,2p.,8d#.,g,1f,2p.,8d#.,32g.,64p,8g,8p,1p,1p,p,f4,g4,f4,d#4,d4,d#,d,c,b4,c,b4,g#4,g4,g#4,g4,f4,d#4,f4,d#4,2c4`
- IOSYS - Cirno's Perfect Math Class
  - ESC 1: `Melody:b=180,o=5,d=8:a,a#,b,c6,p,c6,b,a#,a,a#,b,c6,p,c6,b,a#,a,a#,b,c6,d6,e6,f6,d6,g6,f6,e6,c6,p,16c,32c,32p,4c,1p,1p,1p,2p`
  - ESC 2: `Melody:b=180,o=5,d=8:a4,a#4,b4,c,p,c,b4,a#4,a4,a#4,b4,c,p,c,b4,a#4,f4,g4,g#4,a4,a#4,c,d,a#4,e,d,c,g4,p,16b4,32b4,32p,4b4,1p,1p,1p,2p`
  - ESC 3: `Melody:b=180,o=5,d=8:1p,1p,1p,1p,a,a#,b,c6,p,c6,b,c6,d6,e6,f6,a6,p,a6,g6,a6,a#6,a6,a#6,g6,e6,d6,e6,c6,16f6,32f6,32p,f6,e6,f6`
  - ESC 4: `Melody:b=180,o=5,d=8:1p,1p,1p,1p,a4,a#4,b4,c,p,c,b4,c,4p,p,d,p,d,e,f#,4g,g,16g,32g,32p,2g,a,g#,g,f`
- Toby Fox - (Undertale) Megalovania
  - ESC 1: `Megalo:b=280,o=5,d=8: 4d,d6,p,a,4p,g#,p,g,p,4f,d,f,g,4c,d6,p,a,4p,g#,p,g,p,4f,d,f,g,4b,d6,p,a,4p,g#,p,g,p,4f,d,f,g,a#,a#,d6,p,a,4p,g#,p,g,p,4f,d,f,g`
  - ESC 2: `Megalo:b=280,o=6,d=8:4d,d7,p,a,4p,g#,p,g,p,4f,d,f,g,4c,d7,p,a,4p,g#,p,g,p,4f,d,f,g,4b,d7,p,a,4p,g#,p,g,p,4f,d,f,g,a#,a#,d7,p,a,4p,g#,p,g,p,4f,d,f,g`
  - ESC 3: `Megalo:b=280,o=4,d=8:4d,d5,p,a,4p,g#,p,g,p,4f,d,f,g,4c,d5,p,a,4p,g#,p,g,p,4f,d,f,g,4b,d5,p,a,4p,g#,p,g,p,4f,d,f,g,a#,a#,d5,p,a,4p,g#,p,g,p,4f,d,f,g`
  - ESC 4: `Megalo:b=280,o=4,d=8:d,p,d,p,d,p,d,p,d,p,d,p,d,p,d,p,4e,4p,4e,4p,4e,4p,4e,4p,f,p,f,p,f,p,f,p,f,p,f,p,f,p,f,p,4g,4p,4g,4p,4g,4p,4g,4p`
- Oh my God, too many to list, pls continue!

### [RoxWolf](https://youtube.com/@roxwolf8280)

Musics for your **BLHeli_32**, covers by RoxWolf below!

> [!NOTE]
> I'm tired! pls do rest of all!!!!!!!!!!!!!!!!!!!!!!!!!!

#### for BLHeli_32

- Template BLHeli_32 Configurator Separate
  - ESC 1: ✅ Music On, Gen. Length = `14`, Gen. Interval = `2` ;`a`
  - ESC 2: ✅ Music On, Gen. Length = `14`, Gen. Interval = `2` ;`b`
  - ESC 3: ✅ Music On, Gen. Length = `14`, Gen. Interval = `2` ;`c`
  - ESC 4: ✅ Music On, Gen. Length = `14`, Gen. Interval = `2` ;`d`
- Template BLHeli_32 Configurator Apply to all ESCs
  - All: ✅ Music On, Gen. Length = `14`, Gen. Interval = `2`; `abcd`
- [Axel F Crazy Frog Theme](https://youtu.be/_8VD5BeEb8U)
  - ESC 1: ✅ Music On, Gen. Length = `15`, Gen. Interval = `0` ;`F5 4 P4 G#5 4 P8 F5 8 P8 F5 8 A#5 4 F5 4 D#5 4 F5 4 P4 C6 4 P 8 F5 8 P8 F5 8 C#6 4 C6 4 G#5 4 F5 4 C6 4 F6 4 F5 8 D#5 8 P8 D#5 8 C5 4 G5 4 F5 1`
  - ESC 2: ✅ Music On, Gen. Length = `15`, Gen. Interval = `0` ;`F4 4 P4 F5 4 P8 D#4 8 P8 D#5 8 C4 4 C5 4 D#4 4 F4 4 P4 F5 4 P4 P8 C4 8 C4 4 D#4 4 F4 4 C#4 4 P4 C#5 4 P8 D#4 8 P8 D#5 8 C5 4 D#4 4 F4 1`
  - ESC 3: ✅ Music On, Gen. Length = `15`, Gen. Interval = `0` ;`F4 4 P4 F5 4 P8 D#4 8 P8 D#5 8 C4 4 C5 4 D#4 4 F4 4 P4 F5 4 P4 P8 C4 8 C4 4 D#4 4 F4 4 C#4 4 P4 C#5 4 P8 D#4 8 P8 D#5 8 C5 4 D#4 4 F4 1`
  - ESC 4: ✅ Music On, Gen. Length = `15`, Gen. Interval = `0` ;`F6 4 P4 G#6 4 P8 F6 8 P8 F6 8 A#6 4 F6 4 D#6 4 F6 4 P4 C7 4 P8 F6 8 P8 F6 8 C#7 4 C7 4 G#6 4 F6 4 C7 4 F7 4 F6 8 D#6 8 P8 D#6 8 C6 4 G6 4 F6 1`
- [Street Fighters II](https://youtu.be/s49Uj4EML7Y)
  - ESC 1: ✅ Music On, Gen. Length = `14`, Gen. Interval = `2` ;`G4 2 G4 2 P8 P16 C5 8 D5 8 C5 8 A#4 8 A4 8 G4 8 F4 8 D#4 2 D#4 2 P8 P16 D#4 8 D4 8 D#4 4 D#4 4 P8 C4 2 C4 4 P8 D4 4 D4 4 D4 4 P8 F4 4 G4 8 P8 G4 8 F4 8 P8 F4 8 G4 4 P8 C5 8 D5 8 C5 8 G4 4`
  - ESC 2: ✅ Music On, Gen. Length = `14`, Gen. Interval = `2` ;`A#5 8 P8 A#5 8 A5 8 P8 A5 8 A#5 1 P32 A5 8 P8 A#5 8 P8 A#5 8 A5 8 P8 A5 8 A#5 1 P32 A5 8 P8 A#5 8 A5 8 P8 A#5 8 P8 A5 8 P8 C6 8 P8 C6 8 A#5 4 A5 4 F5 4 A#5 8 P8 A#5 8 A5 8 P8 A5 8 A#5 1`
  - ESC 3: ✅ Music On, Gen. Length = `14`, Gen. Interval = `2` ;`G5 8 P8 G5 8 F5 8 P8 F5 8 G5 1 P32 F5 8 P8 G5 8 P8 G5 8 F5 8 P8 F5 8 G5 1 P32 F5 8 P8 G5 8 F5 8 P8 G5 8 P8 F5 8 P8 G5 8 P8 G5 8 F5 4 F5 4 C5 4 G5 8 P8 G5 8 F5 8 P8 F5 8 G5 1`
  - ESC 4: ✅ Music On, Gen. Length = `14`, Gen. Interval = `2` ;`D5 8 P8 D5 8 C5 8 P8 C5 8 D5 1 P32 C5 8 P8 D5 8 P8 D5 8 C5 8 P8 C5 8 D5 1 P32 C5 8 P8 D5 8 C5 8 P8 D5 8 P8 C5 8 P8 D#5 8 P8 D#5 8 D5 4 C5 4 A4 4 D5 8 P8 D5 8 C5 8 P8 C5 8 D5 1`
  - oscar: ✅ Music On, Gen. Length = `14`, Gen. Interval = `2` ;`A#5 8 P8 A#5 8 A5 8 P8 A5 8 A#5 1 P32 A5 8 P8 A#5 8 P8 A#5 8 A5 8 P8 A5 8 A#5 1 P32 A5 8 P8 A#5 8 A5 8 P8 A#5 8 P8 A5 8 P8 C6 8 P8 C6 8 A#5 4 A5 4 F5 4 A#5 8 P8 A#5 8 A5 8 P8 A5 8 A#5 1`
- Fast Silent (does not delete Ready tone)
  - All: ✅ Music On, Gen. Length = `8`, Gen. Interval = `0`; `P128`
- Europe - Final Countdown
  - ESC 1: ✅ Music On, Gen. Length = `15`, Gen. Interval = `0` ;`D#5 1 D#5 1 E5 1 E5 1 E5 1 E51 C#5 1 C#5 1 D#5 4`
  - ESC 2: ✅ Music On, Gen. Length = `15`, Gen. Interval = `0` ;`B4 1 B4 1 G#4 1 B4 1 C#5 1 C#5 1 A#4 1 A#4 1 B4 4`
  - ESC 3: ✅ Music On, Gen. Length = `15`, Gen. Interval = `0` ;`G#4 1 G#4 2 F#4 2 E4 1 E4 1 G#4 1 G#4 1 F#4 1 G4 1 G#4 4`
  - ESC 4: ✅ Music On, Gen. Length = `15`, Gen. Interval = `0` ;`P2 P4 D#6 8 C#6 8 D#6 2 G#5 2 P2 P4 E6 8 D#6 8 E6 8 P8 D#6 8 P8 C#6 2 P2 P4 E6 8 D#6 8 E6 2 G#5 2 P2 P4 C#6 8 B5 8 C#6 8 P8 B5 8 P8 A#5 8 P8 F#6 8 P8 G#6 4`

### [NinjaSauce](https://youtube.com/@ninjasauce8855)

NinjaSauce covers of songs too below! **BLHeli_32**

### [Scout339th](https://youtube.com/@Scount339)

#### for BLHeli_32

- [Still Alive](https://youtu.be/DFVXgsJqw9M) 
  - ESC 1: ✅ Music On, Gen. Length = `8`, Gen. Interval = `0`; `G7 1/2 F#7 1/2 E7 1/2 E7 1/2 F#7 1/2 P1/1 P1/1 P1/1 P1/2`
  - ESC 2: ✅ Music On, Gen. Length = `8`, Gen. Interval = `0`; `P1/1 P1/1 A5 1/2 D6 1/2 F#6 1/2 D6 1/2 B5 1/2 D6 1/2 F#6 1/2 D6 1/2`
  - ESC 3: ✅ Music On, Gen. Length = `8`, Gen. Interval = `0`; `G6 1/2 F#6 1/2 E6 1/2 E6 1/2 F#6 1/2 P1/1 P1/1 P1/1 P1/2`
  - ESC 4: ✅ Music On, Gen. Length = `8`, Gen. Interval = `0`; `P1/1 P1/1 A5 1/2 D6 1/2 F#6 1/2 D6 1/2 B5 1/2 D6 1/2 F#6 1/2 D6 1/2`

### [VisionFPV](https://youtube.com/@visionfpv8226)

#### for BLHeli_32

- [AC/DC - Highway to Hell](https://youtu.be/M8BR83Rq2_A) 
  - ESC 1: ✅ Music On, Gen. Length = `15`, Gen. Interval = `2`; `A#5 4 A#5 4 A#5 4 P1 P8 G5 4 G5 4 G#5 4 P1 P8 G5 4 G5 4 G#5 4 P4 G5 4 G5 4 G#5 4 P4 G5 4 P4 A#5 4 A#5 4`
  - ESC 2: ✅ Music On, Gen. Length = `15`, Gen. Interval = `2`; `F5 4 F5 4 F5 4 P1 P8 D#5 4 D#5 4 D#5 4 P1 P8 D#5 4 D#5 4 D#5 4 P4 D#5 4 D#5 4 D#5 4 P4 D#5 4 P4 F5 4 F5 4`
  - ESC 3: ✅ Music On, Gen. Length = `15`, Gen. Interval = `2`; `D5 4 D5 4 D5 4 P1 P8 A#4 4 A#4 4 C5 4 P1 P8 A#4 4 A#4 4 C5 4 P4 A#4 4 A#4 4 C5 4 P4 A#4 4 P4 D5 4 D5 4`
  - ESC 4: ✅ Music On, Gen. Length = `15`, Gen. Interval = `2`; `A#4 4 A#4 4 A#4 4 P1 P8 G4 4 G4 4 G#4 4 P1 P8 G4 4 G4 4 G#4 4 P4 G4 4 G4 4 G#4 4 P4 G4 4 P4 A#4 4 A#4 4`

### [Dustindufault](https://youtube.com/@dustindufault7880)

#### for BLHeli_S / Bluejay / AM32

- [Pinkfong - Baby Shark && JAWS Theme](https://youtu.be/DFVXgsJqw9M) 
  - ESC 1: ✅ Music On, Gen. Length = `15`, Gen. Interval = `0`; `D6 1/2 E6 1/2 G6 1/4 G6 1/4 G6 1/4 G6 1/8 G6 1/4 G6 1/8 G6 1/4 D6 1/4 E6 1/4 G6 1/4 G6 1/4 G6 1/4 G6 1/8 G6 1/4 G6 1/8 G6 1/4 D6 1/4 E6 1/4 G6 1/4 G6 1/4 G6 1/4 G6 1/8 G6 1/4 G6 1/8 G6 1/4 G6 1/4 G6 1/4 F#6 1/2 P1/1 G4 1/2 G#4 1/4 P1/2 G4 1/2 G#4 1/4 P1/2 G4 1/4 G#4 1/8 P1/4 G4 1/4 G#4 1/8 P1/4 G4 1/4 G#4 1/8 B5 1/1`
  - ESC 2: ✅ Music On, Gen. Length = `15`, Gen. Interval = `0`; `D6 1/2 E6 1/2 B5 1/4 G6 1/4 G6 1/4 G6 1/8 B5 1/4 G6 1/8 G6 1/4 D6 1/4 E6 1/4 B5 1/4 G6 1/4 G6 1/4 G6 1/8 B5 1/4 G6 1/8 G6 1/4 D6 1/4 E6 1/4 B5 1/4 G6 1/4 G6 1/4 G6 1/8 B5 1/4 G6 1/8 G6 1/4 G6 1/4 G6 1/4 G4 1/2 P1/1 G4 1/2 G#4 1/4 P1/2 G4 1/2 G#4 1/4 P1/2 G4 1/4 G#4 1/8 P1/4 G4 1/4 G#4 1/8 P1/4 G4 1/4 G#4 1/8 B5 1/1`
  - ESC 3: ✅ Music On, Gen. Length = `15`, Gen. Interval = `0`; `P1/2 P1/2 G5 1/2 G5 1/2 G5 1/2 G5 1/2 C4 1/2 C4 1/2 C4 1/2 C4 1/2 E4 1/2 E4 1/2 E4 1/2 E4 1/2 D4 1/2 P1/1 C4 1/2 C#4 1/4 P1/2 C4 1/2 C#4 1/4 P1/2 C4 1/4 C#4 1/8 P1/4 C4 1/4 C#4 1/8 P1/4 C4 1/4 C#4 1/8 B5 1/1`
  - ESC 4: ✅ Music On, Gen. Length = `15`, Gen. Interval = `0`; `P1/2 P1/2 G5 1/2 G5 1/2 G5 1/2 G5 1/2 C4 1/2 C4 1/2 C4 1/2 C4 1/2 E4 1/2 E4 1/2 E4 1/2 E4 1/2 D4 1/2 P1/1 C4 1/2 C#4 1/4 P1/2 C4 1/2 C#4 1/4 P1/2 C4 1/4 C#4 1/8 P1/4 C4 1/4 C#4 1/8 P1/4 C4 1/4 C#4 1/8 B5 1/1`

### [Skully](https://github.com/ImSkully)

This person makes the [composer for it](https://rtttl.skully.tech/) ([Source Code](https://github.com/ImSkully/rtttl-web-composer)). Bascially the **BLHeli_S/ Bluejay** Configurator Melody editor accepts Nokia RTTL Format. You can just plop any RTTL songs into respective ESCs, but be careful, **avoid the song that's too long** to prevent huge startup delay & overheat!

#### for BLHeli_S / Bluejay / AM32

- Trim Phone
  - All: `Trim Phone:d=16,o=5,b=355:a,b,a,b,a,b,a,4p,a,b,a,b,a,b,a,b,a`
- Kimmunitcator
  - All: `Kimmunicator:d=8,o=7,b=715:d,g,p,g4,p,p,d,g,p,g4,p,p,f,a#,p,d,g`
- Pager
  - All: `Pager:d=8,o=5,b=160:d6,16p,2d6,16p,d6,16p,2d6,16p,d6,16p,2d6`
- Aqua - Barbie Girl (Note corrected)
  - All: `Barbie Girl:d=8,o=6,b=125:g#,e,g#,c#7,4a,4p,f#,d#,f#,b,4g#,f#,e,4p,e,c#,4f#,4c#,4p,f#,e,4g#,4f#`

### [ESCTunes.com](https://esctunes.com)

Best of the best?, Only?.. There's alot of them there! Remember, **avoid installing long song!**

#### for BLHeli_S / Bluejay / AM32

- Nokia Tune
  - All: `Nokia - Nokia Tune:o=5,d=4,b=225:8e6,8d6,f#5,g#5,8c#6,8b5,d5,e5,8b5,8a5,c#5,e5,2a5`
- Nokia Buffoon
  - All: `Nokia - The Buffoon:o=5,d=32,b=90:c#5,8e5,g#5,c#6,8p5,c6,8p5,8b5,8p5,b5,8a5,b5,a5,16p5,8g#5,8p5,g#5,8a5,b5,a5,8p5,g#5,8p5,e5,16p5,e5,f#5,8p5,8g5,8g#5,16p5`
- Nokia Groovy Blue
  - All: `nokia - groovy Blue:o=6,d=32,b=112:p6,16g6,16a#6,16g6,a#6.,16f6.,a6,8p6.,a6,8p6.,a6,8p6,a6,8p6,a6,8p6.,a6,a#6.,a6.,a6,8a#6,a6,8g#6,a6,8p6.,a6,8p6.,a6,8p6.,a6,8p6.,a6,8p6.,a6,8p6,16g6,16a#6,16g6,16a#6,16f6,a6,8p6.,a6,8p6.,a6,8p6,a6,8p6,a6,8p6.`
- Nokia Circles
  - All: `Nokia - Circles:o=5,d=16,b=180:a6,a5,c6,e6,8a6,8a5,8c7,8b6,8a6,8f6.,f5,a5,c6,8f6,8f5,8a6,8g6,8f6,8g6.,g5,b5,d6,8g6,8g5,8c7,8b6,8a6,4a6,2p5,f5,a5,c6,f5,f6,p5,g5,b5,d6,g5,g6,2p5`
- Nokia Entertainer
  - All: `nokia - Entertainer:o=5,d=16,b=140:8d6,8d#6,8e6,4c7,8e6,4c7,8e6,2c7,8c7,8d7,8d#7,8e7,8c7,8d7,4e7,8b6,4d7,2c7,4p5,8d6,8d#6,8e6,4c7,8e6,4c7,8e6,2c7,8p5,8a6,8g6,8f#6,8a6,8c7,4e7,8d7,8c7,8a6,2d7`
- Nokia Jumping
  - All: `Nokia Standard Tones - Jumping:o=6,d=4,b=225:8c5,8p6,2c5.,8p6,16b5.,16g5.,16p6,16a5.,16g5.,16p6,16e5.,16p6,16c5.,16g5.,16p6,16c5.,16f5.,16p6,16c5.,16p6,16e5.,16c5.,16d5.,16p6,16c5.,1p6,16c5.,8p6,2c5.,8p6,16b5.,16g5.,8p6,16a5.,16g5.,16p6,16e5.,16p6,16c5.,16g5.,16p6,16c5.,16f5.,16p6,16c5.,16p6,16e5.,16c5.,16d5.,16p6,16c5.`
- Nokia Auld Lang Syne
  - All: `Nokia Standard Tones - Auld Lang Syne:o=6,d=4,b=140:g5,c6.,8c6,c6,e6,d6.,8c6,d6,8e6,8d6,c6.,8c6,e6,g6,2a6.,a6,g6.,8e6,e6,c6,d6.,8c6,d6,8e6,8d6,c6.,8a5,a5,g5,2c6`
- Twinkle Twinkle Little Star
  - All: `Other - Twinkle Twinkle Little Star:o=5,d=4,b=80:32p5,8c5,8c5,8g5,8g5,8a5,8a5,g5,8f5,8f5,8e5,8e5,8d5,8d5,c5,8g5,8g5,8f5,8f5,8e5,8e5,d5,8g5,8g5,8f5,8f5,8e5,8e5,d5,8c5,8c5,8g5,8g5,8a5,8a5,g5`


### [maritomppa123](https://www.youtube.com/@maritomppa123)

#### for BLHeli_S / Bluejay / AM32

- [Bohemian Rhapsody](https://youtu.be/BcPiPyg5yc4?si=TZn7kdRc8vULp4Tm): very frightening me
  - ESC 1: `Melody:b=150,o=5,d=4:1p,16g,16p,16g,16p,16g,16p,16g,16p,8g#,8p,8g#,8p,14a`
  - ESC 2: `Melody:b=150,o=5,d=4:16g#,16p,16g#,16p,16g#,16p,16g#,16p,8d#,8p,8d#,8p,16e,16p,16e,16p,16e,16p,16e,16p,8d,8p,8d,8p,14e`
  - ESC 3: `Melody:b=150,o=5,d=4:16c#,16p,16c#,16p,16c#,16p,16c#,16p,8c,8p,8c,8p,16c,16p,16c,16p,16c,16p,16c,16p,8b4,8p,8b4,8p,14c#`
  - ESC 4: `Melody:b=150,o=5,d=4:16g#4,16p,16g#4,16p,16g#4,16p,16g#4,16p,8g#4,8p,8g#4,8p,16g4,16p,16g4,16p,16g4,16p,16g4,16p,8e4,8p,8e4,8p,14a4`

### JOELwindows7

It's my turn now. **Bluejay / BLHeli_S** yey!

#### for BLHeli_S / Bluejay / AM32

- Template Separate
  - ESC 1: `a`
  - ESC 2: `b`
  - ESC 3: `c`
  - ESC 4: `d`
- Template Synchronize
  - All: `abcd`
- Doremi Basic
  - All: `Doremi:d=8,o=5,b=63:c,d,e,f,g,a,b,4c6`
- Samsung Notification not Whatsapp
  - All: `SamsungWA:d=4,o=5,b=320:b4,d,b,a,p,f#`
- OIIA
  - All: `Oiia:d=8,o=5,b=125:d#,16e,32p,16e,d#,e,32p,e,d,16e,32p,16e,d#,16e,32p,16e`
- Van Elektronische Startup. When you plug the battery to our Stork Fly Unit.
  - ESC 1: `VanElektronische_0:d=8,o=5,b=63:e,16c#,d,4e`
  - ESC 2: `VanElektronische_1:d=8,o=5,b=63:c#,16a4,b4,4c#`
  - ESC 3: `VanElektronische_2:d=8,o=5,b=63:a4,16e4,g4,4a4`
  - ESC 4: `VanElektronische_3:d=8,o=5,b=63:e,16c#,d,4e`
- One by One. Check if any of 4 of your motors fried first! When battery plugged in, one by one ESC rings below songs in `C Major+`, followed by the chord. If there's an unusual long gap, that mean you fried that motor or ESC.
  - Mono: `OneByOne_Mono:d=4,o=4,b=160:c,e,p,e,g,p,g,a#,p,a#,c5,2p,2c` If you only had one ESC / Single Rotor e.g. Airplane Aeromodel
  - ESC 1: `OneByOne_0:d=4,o=4,b=160:c,e,p,p,p,p,p,p,p,p,p,2p,2c`
  - ESC 2: `OneByOne_1:d=4,o=4,b=160:p,p,p,e,g,p,p,p,p,p,p,2p,2e`
  - ESC 3: `OneByOne_2:d=4,o=4,b=160:p,p,p,p,p,p,g,a#,p,p,p,2p,2g`
  - ESC 4: `OneByOne_3:d=4,o=4,b=160:p,p,p,p,p,p,p,p,p,a#,c5,2p,2c`
- [Bethel Music - Goodness of God](https://youtu.be/n0FBb6hnwTo) / [Sudirman Worship - KebaikanMu Tuhan](https://youtu.be/0siXThnV59k). Make your drone sings of the goodness of God everytime you plug its battery in
  - Mono: `GoodnessOfGod_M:d=4,o=5,b=125:e,d,2c,8p,8d,8e,8e,2d,p,8c,2c`
  - ESC 1: `GoodnessOfGod_0:d=4,o=5,b=125:e,d,2c,8p,8d,8e,8e,2d,p,8c,2c`
  - ESC 2: `GoodnessOfGod_1:d=4,o=5,b=125:b4,a4,2g4,8p,8g4,8a4,8b4,2g4,p,8g4,2c`
  - ESC 3: `GoodnessOfGod_2:d=4,o=4,b=125:e,d,2c,8p,8d,8e,8e,2d,p,8c,2c`
  - ESC 4: `GoodnessOfGod_0:d=4,o=5,b=125:e,d,2c,8p,8d,8e,8e,2d,p,8c,2c`
- [Matt Redman - 10000 Reason](https://youtu.be/XtwIT8JjddM). Bless the Lord oh my soul!
  - Mono: `10kReasons_M:d=4,o=4,b=160:a,g,a,b,2a,2p,g,1g`
  - ESC 1: `10kReasons_0:d=4,o=4,b=160:a,g,a,b,2a,2p,g,1g`
  - ESC 2: `10kReasons_1:d=4,o=4,b=160:a,g,f#,g,2a,2p,f#,1g`
  - ESC 3: `10kReasons_2:d=4,o=4,b=160:a,g,a,b,2a,2p,g,1g`
  - ESC 4: `10kReasons_3:d=4,o=4,b=160:a,g,a,b,2a,2p,f#,1g`
  - ~~Old 3: `10kReasons_2:d=4,o=4,b=160:e,d,e,f#,2a,2p,f#,1g`~~
- Blheli_32 Ready. Wait, what's the point?!
  - All: `BLHeli32:d=4,o=5,b=63:a,16p,d6`
- Rasa Sayange. Regional Song, from Maluku, Indonesia, Old Terra.
  - All: `RasaSayange:d=4,o=5,b=225:e,f,2g,2g,2c6,b,a,g,g,e,f,g,p,c6,b,a,a,g,f,e,g,c,e,d,d,c,b4,c`
- Ondel Ondel. Regional Song, from Jakarta (Batavia), Indonesia, Old Terra. *Nyok, kite nonton Ondel-ondel, nyok!*
  - All: `OndelOndel:d=4,o=5,b=225:b4,8p,8b4,8b4,8p,e,d,e,d,a4,b4,p,d,b4`
- [24GH - Lovely Sad](https://vt.tiktok.com/ZSu6qE4CQ). *Iya iya-aa, yeye, yeye!!*
  - All: `IyaIyaaYeyeYeye:d=4,o=5,b=200:d,d,f#,d,2b4,p,d,2c#,p,f#,2d`
- Pizza Hut Indonesia. *Berbagi bersama, di Pizza Hut!*. If only we did found some SMS Ring back tone download back in early 2000s somehow, never heard this particular one tho. Also Virtual Triples is impossible with RTTL. Apology for off length in the end.
  - All: `PizzaHutID:d=4,o=5,b=250:2e,c#,d,e,f,e,p,e,e,2c#6,2b,a`
- Van Elektronische's SMS Fanfare. Phones have various SMS attachment tone, while selections are standardized (Chime Low High, Ding, Tada, Beep, Fanfare, Chord Low High), so what sounds like this on this brand, will be different on recipient's other brand. Think of Sony Ericsson's, Samsung, Siemen, LG, Alcatel, or even Nokia, etc. This one is Van Elektronische's. It should be marching band's vibe with flute trill ending it, but limited by RTTL not only numbers of phonic but also archaicness of time measures.
  - All: `VE-Fanfare:d=4,o=5,b=225:b4,e,g,16g#,a,g#,16g,8e,8p,e,d,16d#,e`
- Kasih ibu kepada beta
  - All: `KasihIbuKepadaBeta:d=4,o=5,b=100:e,8d,8e,c,8p,8c,c6,8a,8c6,g,p,8a,8a,8g,8f,e,8c,8d,8e,8e,8d,8d,c`
- [How do I `Gracie Film` title](https://youtube.com/shorts/5NFZ9tBq-OE) again?
  - ESC 1: `a`
  - ESC 2: `b`
  - ESC 3: `c`
  - ESC 4: `d`
- Nokia Bounce Classic Pickup / Ring
  - All: `bounce_pickup:d=4,o=6,b=250:c,8e5,8g5,8c`
- Nokia Bounce Classic Powerup
  - All: `bounce_up:d=4,o=6,b=250:c,8g5,8c`
- Nokia Bounce Classic Pop / death
  - All: `bounce_pop:d=4,o=5,b=250:16g,16b,c`

## How to install the song?

### Bluejay Configurator (BLHeli_S & AM32)

- Start the configurator.
- Connect your Flight Unit to the computer, usually via USB interface. It will connect to the configurator through serial.
- `Select Serial Port` and choose your Flight Unit controller.
- Do something.
  - You can replace old firmwares with another new ones here. e.g., **to replace the old `BLHeli_S` firmware with Bluejay**.
  - Write Melodies to it. The configurator has many presets to choose from, provided by the communities. You can also write one yourself, using a tools like [Skully's RTTL composer](https://rtttl.skully.tech/) & Copy Paste the text result one by one to respective ESCs, or sync all. Accept each ESCs and `Write Melodies`.
- Enjoy. When you plug the battery back in / power cycle, you'll hear your chosen song.

### BLHeli_32 Suite

...

## Which BLHeli should I pick?

> [!TIP]  
> TLDR: 
> - Recommended to choose pre-Bluejay'd ones! Its ESCs must be **`BLHeli_S`** compatible (such as `EFM8XXXX` based) Ask the store owner if they got one, and request flashing Bluejay if it isn't that already. it's okay if main MCU is STM32 based.
> - If you got AM32 ones (where formerly would've been `BLHeli_32`), it's still work with Bluejay's ESC Configurator, just flash AM32 if haven't AM32 already.  
> - Escape32 is rare and no GUI Editor compatible atm! Bluejay Configurator untested!
> - Only `BLHeli_32` is proprietary. Rest are Open Sourced.

You should pick whatever you already have.

If you haven't, then you must find **pre-Bluejay'd Flight Units**, or at least each of those ESCs you wanted to have. Keywords be like:

- `esc bluejay`

If there's no bluejay available due to out of stock or terrible knowhows of the marketplace try pick `BLHeli_S` (8 Bit) or `AM32` (32 Bit), whatever idk, make sure you can at least easily mod the programmings. The pre-Bluejay flight units often have STM32 based chips as the main.

If you ask why people recommend the BLHeli_S (8 Bit) ESC, that is because the 32 Bit newer counterpart, `BLHeli_32` is **[Closed Source](https://github.com/bitdump/BLHeli/tree/master/BLHeli_32%20ARM)**. And worse part is that the BLHeli company itself was constricted during the conflicts of war, which is alleged potential of usage abuse by Russia, at that time during Ukraine conflicts. So BLHeli must close down, **without releasing source code** nor relieving the license whatsoever. Thankfully, we have alternatives like AM32, and now new in the scene, **Escape32**. Of course, because of this circumstances, flashing such firmware may currently becomes excruciatingly cumbersome, since `BLHeli_32` ultimately nichenified.  
At the end, its 8 Bit ESC ones seems prevail, because not only unaffected by the sanction, it has been Open Source ([loc citato](https://github.com/bitdump/BLHeli/tree/master/BLHeli_32%20ARM)) since. But digressly, we already had `Bluejay` for it anyways.

In the end, Perkedel & Affiliates personally recommends you try the Bluejay preflashed Flight Units or individual ESCs. Don't worry about anything else, STM32 based (ARM 32 Bit) on the description is the **MCU**, the main not-Arduino Microcontroller that controls the ESCs. **Look at the ESCs beside it!!**, it must be **Blueheli_S / EFM8XXXX** (Common). This one, Bluejay, we feel is the currently active as of 2026 we writing this article.

cmiiw

### What about the Escape32?

We seems couldn't find pre-Escape32 ones easily, since that one's new. If you wanted 32-bit ESC, chances are, **the AM32'd one is more common**. You can try [flashing them one](https://github.com/neoxic/ESCape32/wiki), but beware, [no compatible GUI configurator](https://github.com/neoxic/ESCape32-Tools/releases) available afaik. Maybe stick back to AM32 for now?, coz you can config with [Bluejay's Configurator](https://esc-configurator.com/)..  
Pls confirm if this Bluejay's Configurator can detect Escape32 ESCs in it. Just have a Escape32 flashed fly units (or 4 of them with passthrough over your separate Flight Unit), connect to your PC, uses serial. See what happen.

If it seems to complicate you, feel free to find other ones with all 4 8-Bit ESCs, or individual 8-Bit ESC, they seems to have imperceptible differences compared to 32-bit ones. And they are even more common / easier to find.

## Sauce

- https://youtube.com/@roxwolf8280 RoxWolf
  - [Instruction](https://youtu.be/AA4SRmm6Z_c)
- https://youtube.com/playlist?list=PLwip8UXl_Wqg4FUnzJBpHO_VSBquJgiac NinjaSauce
- https://oscarliang.com/blheli-32-custom-startup-tone-music Oscar Liang
  - https://oscarliang.com/bluejay-blheli-s/ Bluejay 
- https://github.com/mathiasvr/bluejay-configurator/releases
- https://github.com/bird-sanctuary/bluejay
  - https://github.com/bird-sanctuary/bluejay/wiki/Tested-Hardware
- https://youtu.be/4wCmhiaBkjA TRONCAT
- https://youtu.be/_alIV-sDU8g Nick Burns
- https://youtu.be/vv4EwcCMG7s Senyx Escape32
- https://youtu.be/xtHc8XHCySM VisionFPV
- https://youtube.com/shorts/vHgOgkCuREQ FPVPilot33
- https://youtu.be/e4VHGVPjhtA FlickFPV
- https://eddmann.com/posts/building-a-nokia-composer-rtttl-player-and-wav-file-generator-in-the-browser/
- https://en.wikipedia.org/wiki/Ring_Tone_Text_Transfer_Language
- https://adamonsoon.github.io/rtttl-play/
- http://microblocks.fun/mbtest/NokringTunes.txt
- https://github.com/neoxic/ESCape32/wiki
  - https://github.com/neoxic/ESCape32-Tools/releases
- https://github.com/drewcrawford/bassdll
- https://youtu.be/tc76K8QB8FY
- https://github.com/Skarune/midi 

## End

by JOELwindows7  
Perkedel Technologies  
CC4.0-BY-SA