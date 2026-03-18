--[[
InfoCard widget.

This widget comes with no warranties. YOU USE IT AT YOUR OWN RISK!

Developed for RadioMaster TX16S Max.
Tested on RadioMaster TX16S Max.
   EdgeTX 2.8.3

This widget displays an image file from the \WIDGETS\InfoCard\Cards folder that has the same filename as the model name (case sensitive). It can be either a png, jpg or bmp.

        Colin Barnes
        Colin@ColinsRadioControl.com
        May 2023

https://ColinsRadioControl.com
]]

local Card            -- The bitmap object
local CardWidth       -- The width of the card
local CardHeight      -- THe height of the card
local CardScale       -- The overall scaling factor (%) of the card to fit it in the widget zone
local CardWidthScale  -- The scaling factor of the width of the card
local CardHeightScale -- The scaling factor of the height of the card
                      -- The width and height scaling factors are used to determine how the card should be scaled.  The card will be scaled in one axis and centered in the other.

local x               -- x origin co-ordinate (top left of card) (for centering)
local y               -- y origin co-ordinate (top left of card) (for centering)

local options = {
  -- There are no options required for this widget.
}

local function create(zone, options)
  if fstat("/WIDGETS/InfoCard/Cards/".. model.getInfo().name..".jpg") then        -- is there a jpg card?
    Card = Bitmap.open("/WIDGETS/InfoCard/Cards/".. model.getInfo().name..".jpg") -- if so then open it.
    
  elseif fstat("/WIDGETS/InfoCard/Cards/".. model.getInfo().name..".png") then    -- is there a png card?
    Card = Bitmap.open("/WIDGETS/InfoCard/Cards/".. model.getInfo().name..".png") -- if so then open it.
    
  elseif fstat("/WIDGETS/InfoCard/Cards/".. model.getInfo().name..".bmp") then    --is there a bmp card?
    Card = Bitmap.open("/WIDGETS/InfoCard/Cards/".. model.getInfo().name..".bmp") -- if so then open it.
    
  else
    Card = Bitmap.open("/WIDGETS/InfoCard/Cards/NoCard.png")                      -- if there is no corresponding file then open the NoCard.png file.
  end
  return { zone=zone, options=options }
end

local function update(wgt, newOptions)
  -- This routine isn't required as there are no options required.  It's left in for future features.
  wgt.options = newOptions
end

local function refresh(wgt)
  CardWidth, CardHeight = Bitmap.getSize(Card)                -- Get the size of the card
  CardWidthScale = wgt.zone.w / CardWidth                     -- Calculate the width scaling factor
  CardHeightScale = wgt.zone.h / CardHeight                   -- Calculate the height scaling factor
  
  if CardWidthScale > CardHeightScale then                    -- Determine whether to scale by width or height.
    CardScale = math.floor(CardHeightScale * 100)             --   This ensures that the card is as big as possible
                                                              --    without cutting off part of the card.
  else                                                        --   The overall scale is set to the width or height scale
    CardScale = math.floor(CardWidthScale * 100)              --    and multiplied by 100 to give a percentage.
  end
  
    x = (wgt.zone.w - (CardWidth * CardScale / 100)) / 2      -- Calculate the origin co-ordinates of the card
    y = (wgt.zone.h - (CardHeight * CardScale / 100)) / 2
    
  lcd.drawBitmap(Card, x, y ,CardScale)                       -- Display the card
end

return { name="InfoCard", options=options, create=create, update=update, refresh=refresh }

