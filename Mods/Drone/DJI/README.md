# DJI Stuffs

## Height Limit

Sorry, we cannot provide height limit remover mod at this time. Mostly, either choices are illegal, and breaking this rule imposed by your region can get you **heavily penalized with hefty fines**. Besides, **Do not pay that mod!!**, never trust it! You'll only lose even more money beside getting fines & prison, and more stress because that mod is not gratis & **has subscription (non-permanent purchase only) (counted based on version)**.

You should've bought Van Elektronische Stork flagship or FPV DIY instead, or whatever that's not DJI nor notoriously limiting brands, and fly them in DNB regions. in almost all DNB realms, max height is 5 Km (for no large Airplane area) counted from where you start flying it / arming. Mind you, the ESC & the remote is pre-flashed 120 m limit due to Old Terra (irl Earth) compatibility export. Make sure you're not there, and increase the limit (or turn it off / set to `infinity` if you're on Surreal Blender Meme Realms) using the configurator, then apply quickflash. Then, on the RemoteMod screen, go to Safety Setting & set the height limit to 5 Km (or `infinity` if you're on Surreal Blender Meme). Fly with caution.  
Pls do not bypass the limit your realm imposed. Unlike DJI, we are not responsible of the control at all. Even the flagship ones, not just FPV DIY like usually.

## Softwares

Go to [Download Center here](https://www.dji.com/id/downloads).

- [DJI Fly](https://www.dji.com/id/downloads/djiapp/dji-fly) **NEW**
- [DJI Virtual Flight](https://www.dji.com/id/downloads/djiapp/dji-virtual-flight) **deprecated**. Newer Android crash. New Simulator only available in DJI RC-2 & RC Pro 2
  - [Windows](https://www.dji.com/id/downloads/products/dji-virtual-flight#other_software) **GONE**
- DJI Assistant
  - [Consumer 2](https://www.dji.com/id/downloads/softwares/dji-assistant-2-consumer-drones-series)
- [DJI Decrypt Tool](https://www.dji.com/id/downloads/softwares/dji-decrypt-tool)
- [DJI Robomaster](https://www.dji.com/id/downloads/softwares/robomaster-win) **deprecated**
- 3rd Party Softwares worth analyzing while you're still there, until OpenIPC works best of the best
  - https://github.com/annesteenbeek/dji_desktop_streamer **old**
  - [OBS](https://obsproject.com/download). your DJI App can stream to an RTMP.
    - [Instruction here](https://gist.github.com/unitycoder/f4ad3be420e73ec05b27d5474b9e3aba)
    - [Mona Server](http://monaserver.ovh/installation.html) to host RTMP locally. Configure, start it up, and set RTMP address to IP address of that PC running Mona server
    - The RTMP address can be opened into OBS' VLC player overlay.
    - alternative server: [nginx-rtmp](https://github.com/illuspas/nginx-rtmp-win32) for Windows
  - [SquirrelCast](https://play.google.com/store/apps/details?id=com.NuclearSquirrel.SquirrelCast) ([doc](https://github.com/xNuclearSquirrel/SquirrelCast-Public)). it's a **paid** proprietary android app that has multitude of features (especially RTMPing) and DRMs (to activate its Windows client).  Otherwise very recommended, better than Cosmostreamer box & DJI tho, and way way way way ywa cheaper than having to Cosmostreamer let alone DIY the RaspberryPi just to Android the DJI Fly app. It also has ELRS support, used to wrangle those Telemetries. 
  - Carry 2 cameras at once, if you don't mind weight.
    - One use DJI O4 lite, for low latency realtime viewing that cannot afford disconnection midflight
    - and the other, OpenIPC to be streamed easily. can accept disconnection midflight since we got realtime above.
    - Or Recording action camera.

## Tips

- You can fly drones standalone without phone (for non-screen RC) if you already paired those. Though it's not recommended, and you should only fly with phone connected, and (with Screen RC) View Camera all time.
- You can transfer file over USB without battery attached at all. Though if you wanted to DJI Assistant USB, you must insert battery & turn the drone on for it to show up.
- Remove unecessary accessories! These adds weight and will severely impact performance and battery length.