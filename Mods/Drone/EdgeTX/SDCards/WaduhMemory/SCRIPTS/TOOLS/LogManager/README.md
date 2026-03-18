# LogManager
A tool for managing LOG-Files in an EdgeTX b/w or color RC transmitter.
Actions can be performed on all models or a selected model.

Since the color version is using the LVGL widgets API, EdgeTX version 2.11 or later is needed to run. However,
the b/w version can be used on color radios with older versions of EdgeTX.

If you wish to have a more detailed control of LOG-File management, you may want to have a look at my [LogFM Project](https://github.com/icebreaker-ch/EdgeTX-LogFM) (the Log File Manager for EdgeTX)

![start](https://github.com/user-attachments/assets/ab624f43-ed1d-4521-943b-24e5f55ae9ab)

![screenshot_zorro_25-05-28_08-47-48](https://github.com/user-attachments/assets/27e2f7e3-b8c9-473e-9a59-14fe888ec615) ![screenshot_zorro_25-05-28_08-48-42](https://github.com/user-attachments/assets/59cdf50a-f4c0-48cb-a38b-a9db05439ee6)

## Model selection

![modelSelection](https://github.com/user-attachments/assets/b45c827b-fd70-4740-9f43-216a48ceee2f) 

## Actions
The following actions can be executed:
- Delete all empty logs
- Keep all logs recorded today
- Keep latest date: Keeps all log files for the latest flying day for the selcted model(s).
- Keep last flight: Keeps the latest log file for the selected model(s)
- Delete small log files with max size of 10 kB, 20 kB, 50 kB or 100 kB
- Delete all Logs: Deletes all log files found for the selected model(s)

![actionSelection](https://github.com/user-attachments/assets/9b90d415-8e73-4459-8181-27d91e86c307)

![confirm](https://github.com/user-attachments/assets/7eaacdd5-11ea-410a-b3af-07ee60db548d)

## Installation
### Color screen Radios
Copy the file `LogManager.lua` to the folder `/SCRIPTS/TOOLS` on your transmitter.
Copy the files `colorui.lua`, `logfile.lua`, `logfiles.lua` and `uimodel.lua`
to the folder `/SCRIPTS/TOOLS/LogManager`
The structure on your SD card should look like this afterwards:
```
/TOOLS
    LogManager.lua
    :
    /LogManager
        colorui.lua
        logfile.lua
        logfiles.lua
        uimodel.lua
```
### Black and white screen Radios
Copy the file `LogManager.lua` to the folder `/SCRIPTS/TOOLS` on your transmitter.
Copy the files `bwui.lua`, `logfile.lua`, `logfiles.lua`, `selector.lua` and `uimodel.lua`
to the folder `/SCRIPTS/TOOLS/LogManager`
The structure on your SD card should look like this afterwards:
```
/TOOLS
    LogManager.lua
    :
    /LogManager
        bwui.lua
        logfile.lua
        logfiles.lua
        selector.lua
        uimodel.lua
```
### State diagram BW Radio
```mermaid
stateDiagram
    IDLE-->CHOICE_MODEL_SELECTED: ROT
    IDLE-->EXECUTING: LONG ENTER
    CHOICE_MODEL_SELECTED-->CHOICE_MODEL_EDITING: ENTER
    CHOICE_MODEL_EDITING-->CHOICE_MODEL_SELECTED: ENTER
    CHOICE_MODEL_EDITING-->CHOICE_MODEL_EDITING: ROT
    CHOICE_MODEL_SELECTED-->CHOICE_ACTION_SELECTED: ROT
    CHOICE_ACTION_SELECTED-->CHOICE_ACTION_EDITING: ENTER
    CHOICE_ACTION_SELECTED-->CHOICE_MODEL_SELECTED: ROT
    CHOICE_ACTION_EDITING-->CHOICE_ACTION_EDITING: ROT
    CHOICE_ACTION_EDITING-->CHOICE_ACTION_SELECTED: ENTER
    CHOICE_MODEL_SELECTED-->EXECUTING: LONG ENTER
    CHOICE_ACTION_SELECTED-->EXECUTING:LONG ENTER
    EXECUTING-->REPORT: finished
    REPORT-->DONE: RTN
    DONE-->IDLE
```
