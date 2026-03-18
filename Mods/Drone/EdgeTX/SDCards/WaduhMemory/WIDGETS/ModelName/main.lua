--- Name widget.
--- Version 1.1 - 26th August 2023
---
--- This widget comes with no warranties. YOU USE IT AT YOUR OWN RISK!
---
--- Originally developed for Jumper T16 running OpenTX.
--- Updated and modified for Edge TX.
--- Tested on RadioMaster TX16S Pro Max; Jumper T16 pro V2
---    EdgeTX Version 2.8.5 (Flying Dutchman)
---
--- Known bugs / constraints
---    If the model name is longer than the widget zone the name does not flow
---        beyond the widget zone.
--- This widget displays the model name in double size.
---
--- Colin Barnes
--- Colin@ColinsRadioControl.com
--- August 2023
---
--- http://ColinsRadioControl.com

local options = {
  { "Colour", COLOR, 62761 },
  { "Shadow", BOOL, 0},
  { "ColinsRadioControl.com" }
}
  
local function create(zone, options)
  return { zone=zone, options=options }
end

local function update(wgt, newOptions)
  wgt.options = newOptions
end

local function refresh(wgt)
  lcd.setColor( CUSTOM_COLOR, wgt.options.Colour )
  if wgt.options.Shadow == 1 then
    lcd.drawText(wgt.zone.x, wgt.zone.y, model.getInfo().name, CUSTOM_COLOR + DBLSIZE + SHADOWED)
  else
    lcd.drawText(wgt.zone.x, wgt.zone.y, model.getInfo().name, CUSTOM_COLOR + DBLSIZE)
  end
end

return { name="Model name", options=options, create=create, update=update, refresh=refresh }

