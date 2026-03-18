--- Armed widget.
--- Version 1.4, 11th February 2026
---
--- This widget comes with no warranties. YOU USE IT AT YOUR OWN RISK!
--- Note: This widget does not provide Armed / Safe functionality. It is only intended as an
---    indicator for an Armed / Safe setting that you have configured on your transmitter.
---
--- Originally dveloped for Jumper T16.
--- Tested on RadioMaster TX16S Pro Max; Jumper T16 pro V2
---    EdgeTX version 2.8.5 "Flying Dutchman"
---    EdgeTX version 2.9 "Providence"
---
--- This widget turns the background red when a source (I use switch SB) is in a certain position.
---    E.G. I have a Special Function set to override the throttle channel to -100 if switch SB is
---    the middle or up position.  The widget displays "Safe" with a green background if the switch
---    is in either if these positions. It displays "ARMED" with a red background if it is in the
---    down position.
--- Version 1.2 added the Arm/Thr option. This is so that you can have two widgets, one for Arm status
---    and another for Throttle status (if say, you use a switch to disable the throttle).
--- Version 1.3 set the default switch to something more sensible (SC).
--- Version 1.4, bugfix replaced WARNING_COLOR with CUSTOM_COLOR
---
--- Colin Barnes
--- Colin@ColinsRadioControl.com
---
--- http://ColinsRadioControl.com

local defaultOptions = {
  { "ArmThr", BOOL, 0},
  { "Source", SOURCE, 122 },
  { "Shadow", BOOL, 0}
}
  
local function createWidget(zone, options)
  lcd.setColor(CUSTOM_COLOR, RED)
  return { zone=zone, options=options }
end

local function updateWidget(wgt, newOptions)
  wgt.options = newOptions
end

local function refreshWidget(wgt)
  
  if getValue(wgt.options.Source) < 1 then
    lcd.drawFilledRectangle(wgt.zone.x, wgt.zone.y, wgt.zone.w, wgt.zone.h, GREEN)
    if wgt.options.Shadow == 0 then 
      lcd.drawText(wgt.zone.x + wgt.zone.w / 2 - 35, wgt.zone.y + wgt.zone.h / 2 - 20, "Safe", BLACK+DBLSIZE)
    else
      lcd.drawText(wgt.zone.x + wgt.zone.w / 2 - 35, wgt.zone.y + wgt.zone.h / 2 - 20, "Safe", BLACK+DBLSIZE + SHADOWED)
    end
  
  else
    lcd.drawFilledRectangle(wgt.zone.x, wgt.zone.y, wgt.zone.w, wgt.zone.h, RED)
    if wgt.options.Shadow == 0 then
      lcd.drawText(wgt.zone.x + wgt.zone.w / 2 - 55, wgt.zone.y + wgt.zone.h / 2 - 20, "ARMED", BLACK+DBLSIZE)
    else
      lcd.drawText(wgt.zone.x + wgt.zone.w / 2 - 55, wgt.zone.y + wgt.zone.h / 2 - 20, "ARMED", BLACK+DBLSIZE + SHADOWED)
    end
  end

  if wgt.options.ArmThr == 0 then
      lcd.drawText(wgt.zone.x, wgt.zone.y, "Arm status", BLACK+LEFT)
    else
      lcd.drawText(wgt.zone.x, wgt.zone.y, "Throttle status", BLACK+LEFT)
  end

      lcd.drawText(wgt.zone.x + wgt.zone.w, wgt.zone.y + wgt.zone.h - 15, "ColinsRadioControl.com", BLACK+RIGHT + SMLSIZE)
end

return { name="Armed", options=defaultOptions, create=createWidget, update=updateWidget
  , refresh=refreshWidget }

