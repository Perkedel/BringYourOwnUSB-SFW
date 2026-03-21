# Stork air Quick Start Guide

Thank you for purchasing Stork air drone series. Please read this Quick Start Guide before using

## What's inside the box?

### Drone package

- Stork Drone.
  - If you buy with Remote Combo, this drone has already prebound
- Batteries (4x), inside Flame Retardant bag. 6S 2000 mAh, XT60 Plug, JTAG Plug for balance terminal
- Multitype LiPo Charger.
- Flame Retardant Bag.
- Stickers
  - Digital Merchandise set
  - Info set
    - Model name & Binding Phrase (1x), **only if you buy Remote Combo**

### Remote package

- RemoteMod Remote
- Stickers
  - Digital Merchandise set
  - Warning set
    - Regulatory Warning. This tells you to beware of Max Height, Max TX Power, etc. as your Remote does not impose artificial limitation to your flight experience.
  - Info set
    - Model Name & Binding Phrase (2x), one is already attached inside the battery base.
- Fidget Servo. A minimal servo fidget toy to test your remote connection. Already pre-bound to this Remote. Has small sticker saying Binding Phrase of the Remote.
  - Coin cell battery (Pre-installed), with circuit cutoff tag pre-attached.
- Battery. Depending on your battery choices, it can be these. Cables to the remote are pre-disconnected in shipping
  - 2x 18650 2500 mAh in a caddy included
  - 1x 5000 mAh Extralong-Life Li-FePO4 SolidPouch

## Remote

### Connection

#### Remote Combo

Your Remote + Unit has already been prebound. There's no further action needed. Just turn on these and start flying.

#### Standalone buy

If you buy just the Remote or Unit, you must bind these two together before they can connect. When you buy just the RemoteMod Remote, you should receive a strip paper containing the Binding Phrase for its internal antenna that contains e.g.:

> Remote: RemoteMod TENS 01  
> Binding Phrase: `herzschlag-febcb2a0-0499-47fe-91ba-7891e4c14906`
> This paper matches the sticker at the battery base

Where there is the model of the Remote and Binding Phrase pre-defined by the factory, with matching sticker printed inside the battery base (behind battery caddy). **You do not need to change this**.  
Instead, **set the Binding Phrase on the drone**.

##### Automatic (Recommended)

Use RemoteMod app!

- Start RemoteMod App.
- Connect your RC's DATA port to your configurator computer
- Select the Remote that just appeared. You should now entered the Remote's Dashboard screen.
- Connect drone's DATA port to your configurator computer. For this new drone, your RemoteMod app should notify you the offer for binding first time.
- Click `Bind New` (the blinking waving button). A special popup of bind confirmation will appear
- Confirm both the Remote & the Drone and make sure that they're correct units. Click `Confirm` once you have confirmed.
- This will set the Drone's Binding Phrase, from what it **fetched from the Remote**.
- The Drone should reboot automatically to apply this new configuration.
- Test the connection

##### Manually

You can also do this manually if you wish. You will need a computer / smartphone capable of WiFi Web-login or Web Browser

- Drone / RX
  - Power cycle the drone 3 times. Plug battery in, Unplug, then repeat and repeat. **The Antenna LED should blink fast**, which mean it's in Hotspot mode. Note: If your drone kept failing to connect to valid bound Remote, the Antenna will automatically switch to Hotspot mode.
  - Connect your computer WiFi to it's Antenna's WiFi.
    - SSID: `ExpressLRS RX`
    - Pass: `expresslrs`
    - Gateway / Open in Browser: `10.0.0.1` / `...`
  - Click `Login to WiFi` when prompted after connection, or open above Gateway IP Address in your browser
  - fetch your Binding Phrase you got from Remote's sticker, then paste it onto this `Binding Phrase` field.
  - Save. Power cycle the drone one last time to reboot and apply the configuration.
  - Test the connection
- Remote / TX. for TENS, other Remote models maybe different
  - If your Remote already has Binding Phrase that correctly matches the sticker, you don't have to change it. However if you need to change it,
  - Turn on Remote / Go to its main screen
  - `SYS` once to see Lua App list
  - run `ExpressLRS` (`elrs.lua`)
  - go to `WiFi Connectivity`
  - `Enable WiFi` to enable Hotspot mode
  - Connect your computer WiFi to it's Remote Antenna's WiFi.
    - SSID: `ExpressLRS TX`
    - Pass: `expresslrs`
    - Gateway / Open in Browser: `10.0.0.1` / `...`
  - Click `Login to WiFi` when prompted after connection, or open above Gateway IP Address in your browser
  - define your Binding Phrase or copy back the Binding Phrase from the Remote's sticker, then paste it onto this `Binding Phrase` field.
  - Save. Stop the Hotspot & then reboot your Remote.
  - Test your connection
- Backpack TX
  - See `Remote / TX` procedure above.
  - ...

## Flying Safely

### Safe Flying!

- Always fly only with well lit & textured environment
- Make sure you can see your drone from where you standing. Avoid exclusively relying on its camera feed!
- Fly only up to the defined maximum from ground height of your region
  - **⚠️ WARNING**, your Remote does not limit Height automatically! Fly with caution!
  - Most worlds: 120m (Class 0)
  - DNB: 1000m (Class 0 u/t 5)
- Avoid attaching accessories that make your drone too heavy!
- Beware of the max weight limit set by your region. Exceeding which of these weight may requires special License.
  - Most Worlds: 250g
  - DNB: 500g
- Always enable Crash Prevent sensor
- Always enable RTH on Signal Loss
- Avoid causing interference against critical infrastructures
- Battery Fully charged before start flying
- Props not damaged. Replace broken props immediately!

### Start Flying

Start to Fly is easy!

- Make sure Left stick's vertical placed all the way down
- Make sure switch `SF` OFF (pushed away from you)
- Arm your Drone. Pull switch `SF` towards you
- Slowly push left stick vertical up to takeoff
- Enjoy your flight!
  - Left stick vertical: Thrust (Up down)
  - Left stick horizontal: Aileron (Rotate left right)
  - Right stick vertical: Pitch (Tilt front back)
  - Right stick horizontal: Roll (Tilt left right)