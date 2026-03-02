# EdgeTX Pack

Here are Packfiles for EdgeTX

## Companion

Use the Companion to start the SDCard content!

- Start EdgeTX Companion
- Accept `Create Profile` if you don't have profile already. On the first time you start, you should get this prompt.
  - Create profile now and choose the one that matches your model
  - on `Radio Profile`, Configure `SD Structure Path` to a folder somewhere. You may create a new folder in your EdgeTX Companion directory, or another disk. We recommend that folder is version controlled so you can upload the SD Card to backup server.
  - on `Update Settings` tab, in section `Components`, Enable all checkboxes so the `Update Components` button downloads all these
  - on `Application Settings` tab, enable `Enable automatic backup before writing firmware`, & `Prompt to run installer after update`.
  - `OK`
- `Update Components`. Accept update installation prompt if asked.
- The total prepared SDCard files is in your EdgeTX Companion save folder directory: `update`. If you don't have any radio, you can copy everything in this `update` folder into the `SD Structure Path` you've just set.
- Create a dummy model file (`.etx`) or import from radio, and start simulation to test if you've set the EdgeTX workstation correctly.
- Enjoy configuring!

### Gripes

Unfortunately, EdgeTX Companion has Cons atm:

- You cannot edit widgets with companion. Even tho you've set up models in `.etx` file already, the companion does not support widget editing, you must use radio and resync everything back to here and forth.

## Sounds

- [Seii GLaDOS Soundpack](https://youtu.be/SBN8CxHSRL8)
  - [EdgeTX_2.9.0](https://github.com/Seii-FPV/Seii-GLaDOS_EdgeTX_2.9.0)
  - wtf Windows Phone Link clipboarder kept broken after hours operational!
- TXU Amber's Soundpack
  - https://www.facebook.com/groups/edgetx/posts/3708514806145350
  - https://open-txu.org/amber-sound-pack/
  - https://www.rcgroups.com/forums/showpost.php?p=28161759&postcount=1
- [EdgeTX default TTS soundpack](https://github.com/EdgeTX/edgetx-sdcard-sounds). No Bahasa Indonesia atm.
- [G711 Sound Converter](https://g711.org). EdgeTX works best with up to **16-Bit 32 KHz PCM** WAV file. Be sure to convert them to this low quality first, or else you'll get too loud distortion.
- [3CX Sound Converter](https://3cx.com/docs/converting-wav-file) (yes, that PABX company)

## Lua Scripts

Telemetry / Widgets? Apps? Lua Scripts are the one!

- ExpressLRS Lua App. You can use the [configurator](https://www.expresslrs.org/quick-start/installing-configurator/) to download the matching Lua App version for your RC. After you connected, save the the app into `SCRIPTS/TOOLS` of your RC SDCard.
- [Betaflight's Lua Scripts App](https://github.com/betaflight/betaflight-tx-lua-scripts)
  - [Try Nightly](https://github.com/betaflight/betaflight-tx-lua-scripts-nightlies/releases) if your betaflight version is too new than stable.
- [Team Black Sheep Agent](https://team-blacksheep.com/products/prod:agentx)
  - [Online PWA](https://www.team-blacksheep.com/agentm/) **require login**
  - Use Desktop version instead! [Win](https://agent.team-blacksheep.com/agent/TBS-Agent-v4-latest-windows.zip), [Linux](https://agent.team-blacksheep.com/agent/TBS-Agent-v4-latest-linux.zip), [Linux ARM64](https://agent.team-blacksheep.com/agent/TBS-Agent-v4-latest-arm64-linux.zip), [macOS M1](https://agent.team-blacksheep.com/agent/TBS-Agent-v4-latest-arm64-mac.zip), [macOS Intel](https://agent.team-blacksheep.com/agent/TBS-Agent-v4-latest-linux.zip)
  - [Lua Script EdgeTX](https://www.team-blacksheep.com/media/files/tbs-agent-100-etx.zip) (put content of zip file to `SCRIPTS/TOOLS`), [FreedomTX / OpenTX](https://www.team-blacksheep.com/media/files/tbs-agent-100-legacy.zip), [ETHOS](https://www.team-blacksheep.com/media/files/TBSAGENTLITE.zip) ([how to install on ETHOS](https://www.team-blacksheep.com/media/files/tbs-agent-lite-ethos.pdf))
- [MadMonkey87's Telemetry Widgets](https://github.com/MadMonkey87/EdgeTX-Goodies)
- [Yaapu's Frsky Telemetry Widgets](https://github.com/yaapu/FrskyTelemetryScripts)
- [bob01's Widgets](https://github.com/bob01/etx-widgets)
- [dbarrios' Widgets](https://github.com/dbarrios83/edgetx-widgets)
- [EdgeTX About Widgets](https://manual.edgetx.org/color-radios/screen-settings/widgets)
  - https://github.com/offer-shmuely/edgetx-x10-widgets/wiki
- [FM2M's Crazy Rices](https://fm2m.online/download) **PAID** Free trial available, [buy info](https://fm2m.online/toolbox-edgetx/#paypal). Drastically rices / changes the look of your EdgeTX RCs! Try the **ToolBox**! Other than that, there are free Telemetries:
  - [Digital Clock](https://download.fm2m.online/edgetx/stable/FM2M_DigitalClock_110.zip)
  - [Widget Pack](https://download.fm2m.online/edgetx/stable/FM2M_DigitalClock_110.zip)
  - [Visual Pack](https://download.fm2m.online/edgetx/stable/FM2M_VisualPack.zip)
- [btastic's 6POS RGB LED](https://github.com/btastic/rgb-throttle-edgetx)
  - [Video tutorial](https://youtu.be/Pv36h7FIiYc)
  - put the `ledfinder.lua` into just `SCRIPTS` folder (optionally again to `SCRIPTS/TOOLS`)
  - put the `idle.lua` & `throttle.lua` into `SCRIPTS/RGBLED` folder

## Splash Screens

Wanna have Splash Screen? There you go.  
Wanna make one? Res is `128x64`. Use any image making softwares! I recommend Inkscape, GIMP, Pixelorama, Krita.

- Pls Windows Clipboard broken, sauce uncopied

## Sauce

- https://www.facebook.com/groups/edgetx/posts/3708514806145350
- https://open-txu.org/amber-sound-pack/
- https://www.rcgroups.com/forums/showpost.php?p=28161759&postcount=1
- https://github.com/EdgeTX/edgetx-sdcard-sounds
- https://www.facebook.com/groups/edgetx/posts/4149546125375547/
- https://youtu.be/O0ijk41jJWo
- https://youtu.be/_A557wLrwyA
- https://youtu.be/CSWXkPCldP8
- https://youtu.be/DNqbPw5NpR0
- https://youtu.be/Pv36h7FIiYc
- https://youtu.be/fPfm3ZjOTsE