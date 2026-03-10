# EdgeTX Pack

Here are Packfiles for EdgeTX

## Advices

We've been scouring intels around the world about FPV and pretty much RCs of all kinds. Here are the advices we got so far:

- **Start from only Remote**. No Drone itself, just the remote. Yes, I know sounds weird. BUT trust me, when everyone in the RC community (both Flyings & Lands, on YouTube and other forums) say it, **that's because we already have simulator**. Comparatively only costs so much (even better, MultiTalent is $0, and there is permanent game mode about it!), and breaking your RC unit do not cost you anything huge if you did it IRL.
- **Never mess with your Input-Mixer-Output & Trims**! You no longer have to anymore this day, and if you messed up those Input-Mixer-Outputs, congratulations, you'll fly and drive tilt forever. **Always tune exclusively from the Core unit of the drone itself!!**, be with with **[Betaflight App](https://app.betaflight.com/), [Bluejay](https://esc-configurator.com/), Stork 🫀🩺🛠️ CardioTweaks, etc.** RC Core units these days are very sophisticated and has at worst mode, a minimum critical self adjusting. Therefore to tune your drone so it flies and drives stable, configure just the core unit with their respective configurator App. 
  - The RC, leave as is. Whatever it provided you, just leave it like that (but if it's not AETR (Ch0 `Ail`, Ch1 `Ele`, Ch1 `Thr`, Ch2 `Rud`), reorder them), Never mess with curves, etc. etc.
  - Also Disable the Trim! That's no longer needed, again your RC Core already has smarterest stabilizer too. go to `MDL` (press 1x), `Flight Modes`, the first one `FM0`, and turn off all of the trims. **Repeat for all Models**. And in Companion, Open up each & every model, `Flight Modes`, first one `FM0`, disable all trims down there. Now you can use these Trim buttons for something else yay!
  - You can still mess around with its Sounds & Themes. So add those Meme & those 😏😏😏😏 stuffs there. **No, don't do 😏😏😏😏 if you're bringing your RC to public**, there maybe those who mentally cannot see them yet!
  - Btw, ExpressLRS always use CH5 to `Arm`. So, lock that CH5 Input-Mixer-Output assigment excslusively to Arm. Because this channel in particular is binary ON/OFF only. Low is OFF, High is ON.
- **Configuring RC overall is only best using its configurator app**. use EdgeTX Companion exclusively to configure your otherwise configs. Add those channels your ExpressLRS needed if there's missing one (again, never mess their default parameters). Using the RC itself is possible, but slow & cluttered, can cause you mess up by misclick!
  - Unfortunately, as of March 2026, **you cannot configure your Telemetry / Widget, Telemtry Discovery, & Themes at all with Companion**. You have to first write all of your changed Companion configuration back to your RC, then build and rice in your RC itself after that. And then redownload the riced config for further adjustments and backup.
- Use RC **with the biggest Gimbal size**. the `Full Size` one (usually Radiomaster AG series implemented RCs). These 2 joystick Size alone also **severely affects your flying & driving control performance**. So if you chose the RC not because of budget but your decision solely, you're stupid. And even so, **just avoid small Gimbaled RC at all**! Trust me, your hands will thank you. 
  - I tried drone simulators and since I don't have RC, I had to just use gamepad. Man! **It's IMPOSSIBRU to fly at all!!** If only my joysticks are bigger than all of these typical gamepads, like those FPV Youtubers had! 
  - Because of this small gimbal size, you'll feel like when Yanti Efurteyas (Blue Archive: New Paradigm (fan game remake)) tried FPV and failed miserably, and turns out after another group of Students investigated it the other day, **The demo unit used Radiomaster Pocket** lmao!, maybe to avoid vandalism idk since it's used for Customer Demo Interaction. Huh, no wonder her older sister, Tasha Efurteyas did also have a bit struggle too when first time tried too. So, the store owner, Reko had to pay his guilt by gifting just-left-the Yanti RemoteMod Postquarter (alike Radiomaster TX16s Mk 7 Max) & Stork Whoops sets. Now both of the Efurteyas has FPV drone, and the large gimballed RCs, yey!, no more polar-siding (Tasha's FPV & Yanti's DJI flagship, yuck!). And when Yanti tried the simulator, she can cinefly it well!
- **Use DJI's VTX (the O4 and forward) if you fly and drive for general use**. Casual Cine, down to Freestyle parkour. This goes for both IRL & Perkedel Cinematic Universe. DJI despite being proprietary and expensive, is the only company who can make static-rare (jarang semut) digital VTX. Other else like HDZero, Walksnail, every OpenIPC, etc. still has reliability problem. Idk man, that Zerius crew said it. That's why the prebuilts often pre-install DJI O num series camera unit.
  - But DJI eats all channels to achieve this stable connection that aggressively removes static ants!. **Only if you are doing Racing (multiple pilots next by next), then DJI is forbidden**, and when a drone contest had to be sponsored by DJI, then, everyone must be DJI too. So tbf, use Analog or these not-DJI digitals. Usually the HDZero or Walksnail that's known.
  - Also still in DJI's properietariness, your Goggles choice is extremely constricted. You can only use DJI's also. Be it the Num or N Num series. And if you want to circumvent it, **DON't**, especially paying those 3rd party softwares about it, we always consider it scam and you have to yar...! idk, yeah, Just never install those. See I told you, I'm still awake! I wanted Not-DJI so choice is agnosticable, but yeah!
- Use Strong power of the signal. For city, maximum about 250 mw. And for woods, go as high as maybe 1000 mw above.
- Remotes usually have slow cyclings. What does that mean, **pilots rarely upgrade their RCs**, coz these almost never thrown out and has no Planned Obsolesence like smartphones do. In fact all chips and components in the RCs are Industry Grade, same ones used in factories and fields. Don't be surprised if many FPV stores seldom to stock new RCs and you had to look elsewhere or worse, import from the company itself with a huge hefty taxes. Bummer, even Posko Gaming that has FPV RC rabbit hole is also few branches only!, and Kivotos does not exist IRL!
- **Bring lots of batteries**. Having to charge all 3 of them let's say wastes your time. So, bring atleast maybe 10 batteries, for each of your drones. Heck, just bring batteries and bring just enough powerbanks just in case. Make sure it covers over 2 hours of session there. And once done, just charge all of them back home
- **Never leave your charging batteries unattended**, especially **LiPo** ones! Even tho today's modern BMS had best of the best cutoffs, safety, and all Fire Retardants and stuffs, **Batteries are batteries, and Batteries explodes**. Never ever you dare leave any of them unattended, even just a 🚽 pissing break. Just one unlucky pop, **💥 duar 🔥!** your whole office turns to dust. Also, **always sleeve charging of any kinds of batteries in a Fire Retardant Cooling case!** Because the faster you charge and discharge, larger the risk of explosion. And you don't get to know when shit happens. Just harness and practice every safety points of batteries you're handling, at all time.
- [Multiple RX in just one TX?!](https://youtu.be/ww2U8xxmBZU). You can connect multiple ExpressLRS Receivers into one single TX at the same time. 
  - On one condition that you have 2 Transmitter in it. One is internal ELRS CSRF, and the other External backpack ELRS CSRF.
  - Only one can have telemetry. Say your second one is the Head Tracking, so, disable telemetry on that ELRS RX. Leave the Main ELRS RX has telemtry.
  - With that second one away, also assign the control CH on that second RX far far away, be it like Ch14 camera pitch, Ch15 the Yaw, etc. So the main one (beginning from Ch0) is like this.
  - Binding Phrase on these 2 must be same, especially on the camera, if 2nd RX is this, then the Main RX too has to be this. **(verification needed)** Now if you ask if you can have more than 1 model turned on, no. Because you would control all of your turned on models that had same Binding Phrase at the same time. Whatever, if you wanted it but why? idk. So just give each build different Binding Phrase, idk.

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
  - Wait! You can use the emulator directly by using `SD Path` mode. Changes this time will now writes to that `SD Path`. Use emulator this way to rice your radio before you have one, then back to Companion, to `Read from SD Path`, and save to `.etx` again.

## Sounds

- [Seii GLaDOS Soundpack](https://youtu.be/SBN8CxHSRL8)
  - [EdgeTX_2.9.0](https://github.com/Seii-FPV/Seii-GLaDOS_EdgeTX_2.9.0)
  - wtf Windows Phone Link clipboarder kept broken after hours operational!
- TXU Amber's Soundpack
  - https://www.facebook.com/groups/edgetx/posts/3708514806145350
  - https://open-txu.org/amber-sound-pack/
  - https://www.rcgroups.com/forums/showpost.php?p=28161759&postcount=1
- [EdgeTX default TTS soundpack](https://github.com/EdgeTX/edgetx-sdcard-sounds). No Bahasa Indonesia atm.
  - [Forked to add Emily](https://github.com/xsnoopy/edgetx-sdcard-sounds)
- [G711 Sound Converter](https://g711.org). EdgeTX works best with up to **16-Bit 32 KHz PCM** WAV file. Be sure to convert them to this low quality first, or else you'll get too loud distortion.
- [3CX Sound Converter](https://3cx.com/docs/converting-wav-file) (yes, that PABX company)
- [Bill Clark's how to custom sound](https://youtu.be/DqF7HUsFrnE)
- [Windows CE Startup](SDCards/WaduhMemory/SOUNDS/en/wcelod.wav). I added Windows CE startup sound I yoinked from a WinCE device. I have converted this with Audacity, export to 32 Khz 16 Bit (coz original was 12.8 Khz idk), as this is new compatible format for the radio. 
  - You can replace `SD://SOUNDS/(lang)/SYSTEM/hello.wav` with this, or
  - just make this Global Function that's `ON` which is `Play Track` `wcelod.wav`. This will get late and break the immersive joke due to `👩🗣️ Welcome to EdgeTX` first, then this sound, in that Global Function order. Everytime you switch model & validated the Pre-start Notes & warnings, it should play everytime that.
  - You can also use other OS startup sound for alternative jokes, like **Windows XP Logon**, or something idk.
  - That's basically it, **minimum 32000 Hz 16 bit PCM**, Maximum about 96000 Hz 16 Bit PCM. that goes also for DOOM sound lumps you found across different WADs if they aren't in this quality yet or over than that.

## Lua Scripts

Telemetry / Widgets? Apps? Lua Scripts are the one!

- ExpressLRS Lua App. You can use the [configurator](https://www.expresslrs.org/quick-start/installing-configurator/) to download the matching Lua App version for your RC. After you connected, save the the app into `SCRIPTS/TOOLS` of your RC SDCard.
- [Moar Lua Script pls](https://github.com/EdgeTX/lua-scripts)
- [Betaflight's Lua Scripts App](https://github.com/betaflight/betaflight-tx-lua-scripts)
  - [Try Nightly](https://github.com/betaflight/betaflight-tx-lua-scripts-nightlies/releases) if your betaflight version is too new than stable.
- [Team Black Sheep Agent](https://team-blacksheep.com/products/prod:agentx)
  - [Online PWA](https://www.team-blacksheep.com/agentm/) **require login**
  - Use Desktop version instead! [Win](https://agent.team-blacksheep.com/agent/TBS-Agent-v4-latest-windows.zip), [Linux](https://agent.team-blacksheep.com/agent/TBS-Agent-v4-latest-linux.zip), [Linux ARM64](https://agent.team-blacksheep.com/agent/TBS-Agent-v4-latest-arm64-linux.zip), [macOS M1](https://agent.team-blacksheep.com/agent/TBS-Agent-v4-latest-arm64-mac.zip), [macOS Intel](https://agent.team-blacksheep.com/agent/TBS-Agent-v4-latest-linux.zip)
  - [Lua Script EdgeTX](https://www.team-blacksheep.com/media/files/tbs-agent-100-etx.zip) (put content of zip file to `SCRIPTS/TOOLS`), [FreedomTX / OpenTX](https://www.team-blacksheep.com/media/files/tbs-agent-100-legacy.zip), [ETHOS](https://www.team-blacksheep.com/media/files/TBSAGENTLITE.zip) ([how to install on ETHOS](https://www.team-blacksheep.com/media/files/tbs-agent-lite-ethos.pdf))
- [MadMonkey87's Telemetry Widgets](https://github.com/MadMonkey87/EdgeTX-Goodies)
- [Yaapu's Frsky Telemetry Widgets](https://github.com/yaapu/FrskyTelemetryScripts). clone this whole repository & copy folders accordingly!
  - for EdgeTX/OpenTX: choose & copy according `*_common` folders, based on `color` or `b/w` model you had. Then with `color` or `b/w`, also copy the resolution folders too e.g. `c480x320/SD` for RadioMaster TX16s which has `Color` display. 
  - [Horus Widget too](https://github.com/yaapu/HorusMappingWidget)
- [iNav Telemetry](https://github.com/iNavFlight/OpenTX-Telemetry-Widget). [Download Latest](https://github.com/iNavFlight/OpenTX-Telemetry-Widget/releases/latest)
  - [Outdated](https://github.com/teckel12/LuaTelemetry) old. [Download](https://github.com/teckel12/LuaTelemetry/releases/latest)
- [bob01's Widgets](https://github.com/bob01/etx-widgets)
- [dbarrios' Widgets](https://github.com/dbarrios83/edgetx-widgets). Daniel Barrios' Telemetry Collections!, **Full Screen All-in-1 Widget Available & Recommended**
- [EdgeTX About Widgets](https://manual.edgetx.org/color-radios/screen-settings/widgets)
  - https://github.com/offer-shmuely/edgetx-x10-widgets/wiki
  - [EdgeTX Lua more](https://github.com/EdgeTX/lua-scripts)
  - [EdgeTX Games Collections](https://github.com/EdgeTX/lua-scripts/blob/main/games.md). they got [FPV simulator](https://github.com/alexeystn/lua-fpv-sim) too
- [Moshir's Flight Tracker](https://github.com/moshirfakhoury/edgetx-flightprogress-luascript)
  - [Video](https://youtu.be/JjI5H5LCPlc)
- [FM2M's Crazy Rices](https://fm2m.online/download) **PAID** Free trial available, [buy info](https://fm2m.online/toolbox-edgetx/#paypal). Drastically rices / changes the look of your EdgeTX RCs! Try the **ToolBox**! Other than that, there are free Telemetries:
  - [Digital Clock](https://download.fm2m.online/edgetx/stable/FM2M_DigitalClock_110.zip)
  - [Widget Pack](https://download.fm2m.online/edgetx/stable/FM2M_DigitalClock_110.zip)
  - [Visual Pack](https://download.fm2m.online/edgetx/stable/FM2M_VisualPack.zip)
- [btastic's 6POS RGB LED](https://github.com/btastic/rgb-throttle-edgetx)
  - [Video tutorial](https://youtu.be/Pv36h7FIiYc)
  - put the `ledfinder.lua` into just `SCRIPTS` folder (optionally again to `SCRIPTS/TOOLS`)
  - put the `idle.lua` & `throttle.lua` into `SCRIPTS/RGBLED` folder
- [TaraniTunes](https://github.com/jrwieland/TaraniTunes-v4.x). Music Player
  - [AutoPlaylist](https://github.com/jrwieland/TaraniTunes-v4.x/tree/master/Auto_Playlist). [Discuss](https://www.rcgroups.com/forums/showpost.php?p=31361271&postcount=41772)
  - [MP3 tag to make tage](http://www.mp3tag.de/en/)

## Splash Screens

Wanna have Splash Screen? There you go.  
Wanna make one? Res is `128x64`. Use any image making softwares! I recommend Inkscape, GIMP, Pixelorama, Krita.

- Pls Windows Clipboard broken, sauce uncopied

## Model Images

We got Model Images

- [SkyRacoon.com](https://www.skyraccoon.com/)
  - thancc [Painless360](https://youtu.be/41soFy3Ddfs)
- [droneshakk's images](https://youtu.be/9_nBqWIg4Yc)
  - Images
    - ![Bg](SDCards/WaduhMemory/IMAGES/droneshakk/background.png)
    - ![expr](SDCards/WaduhMemory/IMAGES/droneshakk/adobe_expr.jpg)
    - ![big](SDCards/WaduhMemory/IMAGES/droneshakk/BigImage.jpg)
  - Dropbox sauces
    - [480x320](https://www.dropbox.com/scl/fi/b436aoa10puc12viuq9xo/InShot_20251017_013727302.jpg?rlkey=fizchetuljr6ph4yrqvw9z04x&st=d750k8l3&dl=0)
    - [Link 2](https://www.dropbox.com/scl/fi/xtvbv20enf44ztt159o71/background.png?rlkey=1fodpf5a51apef4wlbqxm6p3d&st=2hpmd4xw&dl=0)
    - [Link 3](https://www.dropbox.com/scl/fi/jq6orpu8p4jqqpsxabmb0/Adobe-Express-file.jpg?rlkey=khazb2uuuntttq8rj30hqdd3q&st=cn2krk63&dl=0)

## Bind Phrases

ExpressLRS Bind Phrases! Here are public Bind Phrases ideas you can use just to test things out. These too also used on our Stork kits

- Your own name
- Your organization name. Be it company you're working, racing team, whatever team.
- `Stork`
- `DetakJantung`. I am Cardiophile. I need home. I need.. yeah you know.
- `HeartJumpOutOfChest`
- `StethingMyWifeHeart`
- `FemalePoundingHeartbeat`
- `HoshinoIsWatchingYouSenseis`
- `I listen to female heartbeat, and it's always exciting everytime when her heart beats so fast`. You can also add spaces, comma, and other punctuations etc., they'll be dotted too. But be careful, too long may cause lag. Probably you have 255 Characters limit on the field.
- `HoshinoNotHorus`. the default Bluetooth name given on EdgeTX is `horus`. And so why not? The Stork's golden era was first time started during Blue Archive (the New Paradigm fan remake ones, not original, pls don't attempt scouring thancc) not-limited event about Efurteyas duo who tried FPV Drone scene. In Blue Archive since original, there's a Student from Abydos named Hoshino. Without giving spoilers, whatever that relates with her, is that she's Horus. Something that's *Telemetrical*. Her heterochroma eyes tells us it's really something. ***To see***. In fact, you may find our RemoteMod RC Bluetooth name `hoshino` out of the box instead of `horus`.
- `AndHerNameIsKasumizawaMiyuDuar`. That Reference lmao! Miyu from Rabbit Squad is a sniper. She has a quirk that everything ignores her, like she can't be seen nor noticed, a terminally diamond advantage amongst Sniping rabbit hole. She's therefore considered invisible and ultra-stealthy. So much ignored she's notorious hiding in a trash can, coz she felt being useless. Btw, Blue Archive is not Perkedel's idea, that's from Nexon. We're remaking it into Open World, coz we are not interested with its strategy card chess-like gameplay. 
- `ImSuckIfItsNotDJI`. Or you're too coward to buy just the remote & simulator. You know, you don't have to buy the drone itself coz it's too expensive if you bork it anyway. Simulators on the other hand doesn't, and they already realistic enough to be useful as training system.
- `DJIIsClosedSourceBruh`. E.g., with O4 Air Unit, you can only use DJI's Goggles. Connection options for other observers are also limited too, coz you must use DJI's software to be so (**DO NOT PAY 3RD PARTY SOFTWARES SUCH ONE THAT PROMISES CONNECT TO MONITOR, USUALLY SCAM & VIRUS!!**). Also btw, DJI eats all channels to achieve ant-rare digitals. If you & your friend fly together each a unit, then all VTX's in whole premise must be DJI. 
- `DJICanConsumeMyPosterior`. coz if instead they're open source, we'd justify their actions, idk.
- `EnvironmentalMyPosterior`. because companies claim to be environmental, when it's all about removal of used to components. Isn't this... yeah you know (can't say it here, use NSFL!). 

You can also prepend & append extra words to further differentiate the connection IDs.

Now why should you ask? Coz it's easier in the end. Once setup, just turn the RC & Drone on properly, and they'll always bound, rare to forget about it assuming no short circuit or what.

Now with that in mind, **both RX & TX must have matching Binding Phrase** you just selected. As simple as that! And you can separate it by assigning different RX Channel number in each of your Model & the unit of that.

## Frequently Asked Questions

- Why Van Elektronische Drone rabbithole doohickeys branded it after heartbeat fetish?
  - It was following random codenaming. Apparently, when Joel was entering the world of FPV (Flying Drone), he was homesick of Cardiophilia stuffs. Things like
    - Small Drone was codenamed `Kesturi` which is known to have the fastest idle heartbeat.
    - Large heavyweight Drone called `Cardiomegaly` like Heart organ enlarged and becomes very heavy to operate.
    - Conversely, the largest drone MCU model was named `Hypertrophy` like something coming from a muscular bodybuilder whose heart have enlarged because of muscle hypertrophy. Like the name says, it has lots of feature and huge power output.
    - And not forget, the drone mcu is labeled `Corazon`, meaning 🫀 `heart` in certain European language. Because it's the central unit of a drone, and also because of homesick of Cardiphilia.
- `STORK`?
  - a department in Van Elektronische, spearheaded by Samuel Stork. Samuel himself loves FPV so much, but he was not satisfied with existing droning system that time. So he proposed ideas to Van ELektronische and there you have it.
  - Also, Van Elektronische at the same time was looking for RC rabbithole spearheads, solely because DJI's corcerning monopoly tactics. They loathe the world of Proprietarism, and just so lucky that they got Samuel in.
  - Coincidentally, the family was named `Stork` because back home in the old days, they used to deliver stuffs around the hoods, **including living babies too!** Eventually, the Stork department comes to full circle when they are tackling DJI's Flycart with `Cargo`. Cargo combines Flycart & Agras, because this model is designed to carry heavy item & drops few of them when needed. Cargo is available also in
  - Hmm. Josh Sivre. Sivre is wireless data port access. Something like RFID & NFC, but Open Source and reliable too.
- What else those funny names you got?
  - Selonjoran
    - a word in Bahasa Indonesia / Dozeric. Meaning *to relax*, *lie down*.
    - This is used for Surface Drones. Namely Cars, Motorbike, etc.
  - Menciut
    - *Shrank*, as in *your heart organ shrank like Grinch*.
    - Indicate this RC model has smaller gimbals (i.e. not Full Size) to achieve compact size. Much like Radiomaster Pocket.
    - The name sometime is insulting because we do not recommend pilots to use this kind of Gimbal size, you should stick to Full Size if you can.
  - Onta
    - *Ostrich*
    - This is a Surface Drone that has Mecanum wheels, where all of the wheels are direct drive.
    - It controls same like Flying Drones, but without altitude. Yeah, just like birb Ostrich, can't fly but run instead.
    - Unlike other Surface types, Onta uses Dual Joystick RCs. The Throttle (Left Joystick Vertical) is unused.
- Is using ExpressLRS going to need License, since this able to reach far distance?
  - Depends.
    - **DNB relieves the License requirements** off of POC License for **ExpressLRS both 2.4 GHz & 900 MHz (SubG)** 
    - **Even in Old Terra you don't need License**, also both ELRS freq bands. 
    - Please review your laws carefully, especially pertaining to Wireless Interactions. Make sure you set your radio parameters so that you don't disturb national critical infrastructures.
  - I can't find why rn, but one thing certain is that RC data like this is very compact unlike many Complex Audio Video Transmission (since Chatting one, not including Machinery VTX). Plus POC License only scrutinize anything that causes **Public Social Interaction** from single way (Television) down to multi way (Chats like IRC, Discord Teamspeak, Facebook, Zoom, Ham Radio DMR and analog, etc.). The ExpressLRS (among like Analog, DJI, OpenIPC) feature sets it has as of 2026 currently only causes **Private Machinery Interaction**, which does not make sense to be scrutinized. Really, to use CCTV doorbell you need License?? Huh?
    - If you ask me, then Social media poses significant risks, that's why it requires Ham Radio License (POC License: Analog, DMR, Social Media), **in DNB**. Hey, at least in Old Terra there's no Ham License required to use Facebook, that's why so many depressions haha!
- (Extra) Wait, then Meshtastic requires Ham Radio License then?!?!?!?!?!?!?
  - in DNB, **Yes.** Because it causes **Public Social Interaction**.
  - But not (yet) in Old Terra, as of *2026*. Sssh, don't give them an idea! They would execute it poorly by solely asking age for their selfish purposes rather than properly enforcing our POC curiculum it supposed to be!

## Fun facts

- The TBS CSRF (Crossfire) was the first ever Protocol that able to achieve long distance RC connection. However, such module hardwares are exhorbitantly expensive. But thanks to **ExpressLRS**, now everyone can Crossfire Open Sourcely & much cheaper, yeay!!
- The whole RC revolution (EdgeTX as the OS, & ExpressLRS as the connection protocol) was indeed came from this exact Flying Drone of this RC sub-rabbithole.
  - Then followed by Surface (car) & Sea (boat), with especially Radiomaster MT12. The first ever EdgeTX Surface Radio (Pistol Wheel RC) we've come across common markets.
- Van Elektronische had an experiment to use ExpressLRS as one of the connection method with their Gamepads. You can activate this as your auto-dynamic switching by binding your computer to it. Simple enable `ELRS`, and the computer will automatically setup matching Binding Phrase on both for you. This option is experimental, hence the computer prioritize MIDI BLE connection.

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
- https://youtu.be/YMTVJgIRzDY
- https://youtu.be/b9dT8JthB7E
- https://youtu.be/QS9c5OvomKI
- https://github.com/offer-shmuely/edgetx-x10-widgets (should be included with your EdgeTX Companion update button)
  - https://github.com/offer-shmuely/edgetx-x10-widgets/wiki
- https://youtu.be/41soFy3Ddfs
  - https://www.skyraccoon.com/
- https://youtu.be/SAQHowQ3rFM
  - https://github.com/iNavFlight/LuaTelemetry/
  - https://github.com/yaapu/FrskyTelemetryScript/
- https://www.expresslrs.org/software/switch-config
  - https://www.youtube.com/live/ARCfafma1rM
- https://youtu.be/3rIxhtkNYEU On Off switch Bill Clark
- https://youtu.be/NvIKHa90x2k
- Zerius FPV! [Shopee](https://s.shopee.co.id/6Ag85Cs16Q) or [Tokopedia](https://tk.tokopedia.com/ZSu2kDoGb/) here! & [**Google Map + Plus Code = `RXR7+PV`**](https://maps.app.goo.gl/PpD1re7ajs9ebqSL7?g_st=ac) The only physical & tangible & decently luxury FPV RC store across Indonesia. Big shoutout to them for providing coolest FPV parts in their collection, and their advices while we had been there. at that time in 2025-03-08, One of the technician gave us lots of feedbacks & advice how to FPV well and don't screw up the first time.
- https://youtu.be/ww2U8xxmBZU multi connect receiver just one tx
- https://youtu.be/YjbQZFXJOJY CgitEinsteins how to program for Mechanum car