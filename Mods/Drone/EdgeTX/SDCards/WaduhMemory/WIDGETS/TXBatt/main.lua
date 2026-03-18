-- EdgeTX TX16S widget by Mika Korhonen (Spider)
-- V 1.1, 2025/03/06

local app_name = "TXBatt"
local app_path = "/WIDGETS/TXBatt/"

local options = {}

local function fontSize(height, persentage)
  local txt_w, txt_h
  local fonts = {SMLSIZE, 0, MIDSIZE, DBLSIZE, XXLSIZE}
  local font = SMLSIZE
  for Count = 1, #fonts do
    txt_w, txt_h = lcd.sizeText("SIZE", fonts[Count] + WHITE + SHADOWED)
    if txt_h <= ((height / 100) * persentage) then
	  font = fonts[Count]
	end
  end
  return font
end

local function create(zone, options)
  local widget = {
    zone = zone,
    height = math.floor(zone.h / 2),
	battId = getSourceIndex("Batt"),
	battVolt = 0,
	percentage = 0,
    options = options,
    font = fontSize(zone.h, 55)
  }
  return widget
end

local function update(widget, options)
  widget.options = options
end

local function background(widget)
   -- Do Nothing
end

local function refresh(widget, event, touchState)
  widget.battVolt = getSourceValue(widget.battId)
  widget.percentage = math.floor((widget.battVolt - 6.4) / ((8.4 - 6.4) / 100))
  if widget.percentage < 0 then widget.percentage = 0 end
  lcd.drawLine(widget.zone.w * 0.10, widget.height, widget.zone.w * 0.90, widget.height, SOLID, BLACK)
  lcd.drawText(widget.zone.w / 2, widget.zone.h / 4, string.format("%.1fv", widget.battVolt), CENTER + VCENTER + widget.font + WHITE + SHADOWED)
  lcd.drawText(widget.zone.w / 2, widget.zone.h * 0.75, widget.percentage.."%", CENTER + VCENTER + widget.font + (widget.percentage > 20 and GREEN or RED + BLINK) + SHADOWED)
end

return {
  name = app_name,
  options = options,
  create = create,
  update = update,
  refresh = refresh,
  background = background
}