**Flight Progress – EdgeTX Flight Logger**


**Overview:**

Flight Progress is a lightweight EdgeTX toolset that automatically records flight activity for each model and saves it to a simple text log file on the transmitter’s SD card.
It tracks when your motor (and optional arm switch) becomes active, logs the flight duration, and stores useful session data such as date, start time, end time, flight duration, maneuver being practiced, model maintenance and crash events. The goal is to give pilots an easy way to review flying time, practice progress, historical totals, and incidents without needing any external software.
Each model automatically maintains its own log file, making it ideal for tracking multiple aircraft independently.
In addition to live flight logging, the system also supports manual entry of historical flight data so you can backfill previous months or seasons and keep a complete yearly record in one place.
The system is designed to be fast, safe, and reliable on the radio by using simple append-only logging, minimal memory usage, and avoiding any file parsing or heavy processing.
All logging and configuration happens directly on the transmitter — no PC or external tools required.


**Included Widgets**

The Flight Progress Lua is a complete package that includes five powerful widgets: Flight Stats, Model Count Comparison, Crash Tracker, Maneuver Tracker, and Maintenance Tracker. Each widget provides clear, real-time insight into your flying activity, progress, reliability, and service status, helping you monitor and manage your model with ease. You can also filter by year to view detailed statistics and history for any specific year.


**Features:**
- Automatic flight detection
  Starts and stops logging automatically based on motor and optional arm switch positions. Arm and motor switches and on positions are fully configurable. 

- Per-model log files
  Each model uses its own modelname.txt file for completely independent tracking. Data is organised across four files to ensure the widgets remain fast and responsive.

- Flight time tracking
  Records start time, end time, total duration, and flags valid flights (>60 seconds).

- Maneuver tracking
  Select a 3-digit maneuver ID (000–999) to record what you are practicing during that flight.

  You can also use the RS slider for quick control:
  - Top position → records Maneuver 1
  - Middle position → records Maneuver 2
  - Bottom position → records 0 (no maneuver)

  The bottom position is useful for free-flying sessions, allowing flights without a practice focus to be logged cleanly without changing the Lua Setup page.

- Yearly flight target
  Set a 3-digit yearly flight goal that is stored with every log entry for progress tracking and analysis.

- Crash logging
  One-button crash entry that instantly appends a crash record without editing previous lines (safe and memory efficient).

- Maintenance logging
  One-button maintenance entry that instantly appends a service record with date and time without editing previous lines.
  Supports selectable service types including Full Service, Part Service, Inspection Only, and Crash Repair for accurate maintenance history tracking.

- Historical flight entry
  Dedicated “Enter Flight History” page allows manual backfilling of past data:
  - Date (YYYY-MM)
  - Number of flights
  - Total duration (seconds)
  - Crash count
  - Yearly target for that period

  Entries are appended as historical records so older seasons or months can be added without affecting live logs.

- Line type tagging
  Each log row is tagged with a line type:
  - L = Live (automatic or crash events)
  - H = Historical (manual entries)
  - S = Service (manual entries)
  - C = Crash (manual entries)
  This makes filtering and analysis in spreadsheets easy.

- Maintenance mode (6POS5)
  The radio’s 6POS5 panel button temporarily disables all flight logging.
  While active, the Functions script ignores motor/arm activity and no entries are written to the log file.
  This is ideal for bench testing, setup, or maintenance work where motors may run briefly and you don’t want extra log lines.
  Logging automatically resumes as soon as the button is released.

- Log File Format
  - Each line contains: ModelName,Date,StartTime,EndTime,Flight,TimeSeconds,Maneuver,Crash,YTarget,LineType,SrvType,SrvFltNbr
  - Example: MyModel,2026-02-17,14:32:10,14:38:22,1,372,363,0,200,L,Z,0

- Update Summary Data
  A single button updates your live flight data into one summary line per year. This keeps the widgets fast and responsive with no delays, while preserving your complete flight history in the main model file.

- Append-only & safe
  No file editing, parsing, or rewriting — only appending. This maximizes reliability and minimizes SD wear.

- Low memory footprint
  Designed specifically for EdgeTX radios — no large file parsing or heavy processing.

- Fully transmitter-side
  Everything runs directly on the radio. No PC, scripts, or external software required.

- Sound files included in the zip file

- Included Widgets:
  Flight Progress includes five dedicated widgets:
  - Flight Stats
  - Model Count Comparison
  - Crash Tracker
  - Maneuver Tracker
  - Maintenance Tracker

  These widgets provide clear visual insight into flying activity, progress, reliability, and maintenance status.
  All widgets support optional year filtering, allowing you to view statistics for a specific year or lifetime totals.
  

**Widgets Overview:**

Flight Progress includes five powerful widgets that give you real-time insight into your flying, training, crashes, and maintenance. Each widget reads directly from your model’s Flight Progress log files and updates automatically. These widgets can be added to any EdgeTX screen and customised by year where applicable.


1. Model Stats Widget (fltprgW1)
  The Model Stats widget provides a complete statistical overview of your model’s activity.
  It displays:
    - Total lifetime flights
    - Total flight duration
    - Total crashes
    - Total services performed
    - Current year statistics
    - Previous year statistics
    - Optional additional year comparison
    - Flight target progress (% achieved)
    - Number of maneuvers practiced this year
    - Maneuvers currently in progress
    - Bar chart comparing yearly flight totals
    - Target achievement indicator
    - Crash percentage indicator
    - Maneuver count indicator
    - Date of last fligh
  The current year flight target is read directly from your radio’s Flight Progress configuration.
  This widget gives you an instant overview of your model’s performance and progress.


2. Model Comparison Widget (fltprgW2)
  This widget lets you compare up to 9 models side-by-side. You can view lifetime totals or filter the data by a specific year. All information is read automatically from each model’s Flight Progress log files.


3. Crash Tracker Widget (fltprgW3)
  The Crash Tracker widget provides a detailed view of your model’s crash history. You can view lifetime totals or filter by a specific year. This makes it easy to spot trends, review recent incidents, and   compare your crash rate year-to-year.
  It displays:
    - Total number of flights
    - Total number of crashes, including historical crashes
    - Crash percentage based on total flights
    - Current year crash total compared with last year
    - The date and time of the last 10 crashes, shown in order with the most recent first


4. Maneuver Tracker Widget (fltprgW4)
  The Maneuver Tracker widget tracks your training progress across all maneuvers. This helps you see how much of your flying is dedicated to structured training. Perfect for pilots working toward certifications    or improving skills.
  It displays:
    - List of maneuvers performed
    - Total number of flights per maneuver
    - Total flight time per maneuver
    - Crash count per maneuver
    - Last date each maneuver was flown
    - Total maneuver flights
    - Total flights
    - Practice percentage


5. Maintenance Tracker Widget (fltprgW5)
  The Maintenance Tracker widget helps ensure your model is serviced on time. This helps prevent mechanical failures and keeps your model reliable.
  It tracks:
    - Last service date / flight number
    - Service due date / flight number
    - Days / flights remaining until next service
    - Total services performed this year and last year
    - Days since last service
    - Date of last 3 services
    - Totals per service typ
    - Clearly display when service is due or overdue
    - Supports Date-based or Flight based service tracking
    - Writes to Global Variable 6 FM0, allowing you to use logical switches and special functions to trigger reminders.
    Value meanings: 0 = no service due, 2 = service due soon, 1 = service overdue.


**Data Storage & Performance:**

Flight Progress stores data separately for each model, ensuring completely independent tracking, maximum performance, and full history preservation. All files are created and managed automatically.


Master Flight Log:
Each model records every flight in its own ModelName.txt file. This is the permanent master log and contains complete flight details including date, duration, maneuver, crashes, and targets. This file is never modified, ensuring your full flight history is always preserved.


Yearly Summary File:
Flight Progress maintains a live summary file called ModelName_S.txt. Widgets read this file to display totals instantly without needing to scan the full log. When the Update Summary Data button is pressed, this file is overwritten and rebuilt into one summary line per year. This keeps widget performance fast while your complete history remains safely stored in the master log.


Operations File:
The ModelName_O.txt file stores crashes, maintenance, and historical entries. This includes crash dates and times, service records, and manually entered history. This allows accurate crash tracking, maintenance scheduling, and correct lifetime totals.


Maneuver Summary File:
The ModelName_M.txt file stores summarized maneuver data, including total flights, total duration, and the last performed date for each maneuver. This allows the Maneuver Tracker widget to load instantly and display lifetime or yearly maneuver progress without delay.


**Installation:**
- Download the FlightProgressPack ZIP file file
- Extract the contents of the ZIP file
- Find the last folder named FlightProgressPack (it contains FlightProgress.lua, fltbg.lua, FlightProgress folder, README.txt and fltprgW1-5 folders)
- Copy FlightProgress.lua and paste into your transmitter's /SCRIPTS/TOOLS folder
- Copy FlightProgress folder and paste into your transmitter's /SCRIPTS/TOOLS folder
- Copy fltbg.lua and paste into your transmitter's /SCRIPTS/FUNCTIONS folder
- Copy fltprgW1-5 folders and paste into your transmitter's /WIDGETS folder
- (Optional) If you want to use the included sound file, copy them into SDCard/SOUNDS/en

**Transmitter Setup:**
- Click on the SYS button
- Navigate to Global Functions 
- Add a new Function with the below settings
  - Trigger = ON
  - Function = Lua Script
  - Value = fltbg
  - Repeat = On
  - Enable = True

Configure the below Steps for each model:
- Click the MDL button
- Navigate to Global Variables
- Click on GV6
- Click Edit
- Enable FM2 to FM8

<img width="479" height="271" alt="image" src="https://github.com/user-attachments/assets/e6073256-6d48-4aff-a683-590a11180cd2" />

<img width="478" height="271" alt="image" src="https://github.com/user-attachments/assets/de3e2254-1123-429c-87a4-0e4c16a9bb3a" />

<img width="478" height="271" alt="image" src="https://github.com/user-attachments/assets/af4b1e05-3b79-4c45-b124-4a057e7751ee" />

<img width="477" height="271" alt="image" src="https://github.com/user-attachments/assets/a1b6e52b-1490-4f0c-b0bf-9b38c2bb227b" />

<img width="478" height="272" alt="image" src="https://github.com/user-attachments/assets/d156ee1f-5ad6-4490-af99-8f839c55a0a0" />

<img width="478" height="270" alt="image" src="https://github.com/user-attachments/assets/d3cdeb61-b81f-4b33-8b40-2fc6d3f95240" />

<img width="480" height="273" alt="image" src="https://github.com/user-attachments/assets/efb62013-d7ab-41ca-9efe-bd31075e64dc" />

<img width="479" height="272" alt="image" src="https://github.com/user-attachments/assets/7b1d18c2-5bce-48d9-83b0-4411be92fde4" />

<img width="484" height="275" alt="image" src="https://github.com/user-attachments/assets/4130498e-6661-4ac6-9d09-4a4c8d641eb1" />

<img width="483" height="276" alt="image" src="https://github.com/user-attachments/assets/bd4dc5e1-49e9-4922-94ef-581841145457" />

<img width="483" height="274" alt="image" src="https://github.com/user-attachments/assets/1fe708a1-f28b-4179-97c9-109764d0be68" />


















