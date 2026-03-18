A widget to remind you what every switch on your radio does in every position.
It needs a quarter to a full sized widget area.

Install:
- unzip switch2.zip in /WIDGETS/.
- move /WIDGETS/Switch2/switchcfg.lua to /SCRIPTS/TOOLS, to have the configuration script in the SYS->Tools menu.

How to use "switchcfg.lua":
- roller left/right selects switch position or image.
- roller short press changes between image and switch selection.
- switch selection can also be done by toggling the matching hardware switch.

- in image mode:
  - long roller press deletes image from switch position.
  - "PAGE<" jumps to the first, "PAGE>" to last known position in the image list. 
  - "TELE" toggles between selection for active and normal images.

- special feature:
  Above the images for the 6Pos switch, you can display the values of global variables.

How to add new images:
Images in the "img" folder are named 1.png, 2.png, 3.png, ..., but only every 3rd is a real image.
The others are 3x3 pixel placeholders for future icon additions. This way old configurations
will keep working, when new images are added between already existing ones.
I found no better work around for the missing "readdir" function in the open-TX lua implementation.
The folder "img/imgnamed" contains all the currently used, the folder "img/imgnotused" all the unused
images. If you need one of those or created a new one, copy it over a numbered placeholder image.
