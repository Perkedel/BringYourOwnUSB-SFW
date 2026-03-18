-- EdgeTX TX16S widget by Mika Korhonen (Spider)
-- V 1.1, 2025/03/06

local app_name = "LQorDBM"
local app_path = "/WIDGETS/LQorDBM/"

local options = {
  { "LQorDBM", BOOL, 0 }
}

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
    options = options,
	width = math.ceil(zone.w / 2),
	height = math.floor(zone.h / 2),
	offset1 = 0,
	offset2 = 0,
	dbm = 0,
	snr = 0,
	lq = 0,
	tpwr = 0,
	font = fontSize(zone.h, 55)
  }
  local txt_w, txt_h = lcd.sizeText("100", widget.font + WHITE + SHADOWED)
  widget.offset1 = txt_w 
  txt_w, txt_h = lcd.sizeText("-120", widget.font + WHITE + SHADOWED)
  widget.offset2 = txt_w 
  return widget
end

local function update(widget, options)
  widget.options = options
end

local function background(widget)
   -- Do Nothing
end

local function refresh(widget, event, touchState)
  widget.dbm = getValue("1RSS")
  widget.snr = getValue("RSNR")
  widget.lq = getValue("RQly")
  widget.tpwr = getValue("TPWR")
  lcd.drawLine(widget.zone.w * 0.10, widget.height, widget.zone.w * 0.90, widget.height, SOLID, BLACK)
  if widget.options.LQorDBM == 0 then
    if widget.dbm ~= 0 then
      lcd.drawText(widget.width - 5, widget.zone.h / 4, "LQ", RIGHT + VCENTER + widget.font + WHITE + SHADOWED)
      lcd.drawNumber(widget.width + widget.offset1, widget.zone.h / 4, widget.lq, RIGHT + VCENTER + widget.font + (widget.lq > 50 and GREEN or RED + BLINK) + SHADOWED)
      lcd.drawText(widget.width, widget.zone.h * 0.75, widget.tpwr.."mW", CENTER + VCENTER + widget.font + GREEN + SHADOWED)
    else
      lcd.drawText(widget.width - 5, widget.zone.h / 4, "LQ", RIGHT + VCENTER + widget.font + COLOR_THEME_DISABLED + SHADOWED + BLINK)
      lcd.drawNumber(widget.width + widget.offset1, widget.zone.h / 4, widget.lq, CENTER + VCENTER + widget.font + COLOR_THEME_DISABLED + SHADOWED + BLINK)
      lcd.drawText(widget.width, widget.zone.h * 0.75, widget.tpwr.."mW", CENTER + VCENTER + widget.font + COLOR_THEME_DISABLED + SHADOWED + BLINK)
    end
  else
    if widget.dbm ~= 0 then
      lcd.drawText(widget.width, widget.zone.h / 4, "dBm", RIGHT + VCENTER + widget.font + WHITE + SHADOWED)
      lcd.drawNumber(widget.width + widget.offset2, widget.zone.h / 4, widget.dbm, RIGHT + VCENTER + widget.font + (widget.dbm > -100 and GREEN or RED + BLINK) + SHADOWED)
      lcd.drawText(widget.width + 4, widget.zone.h * 0.75, "rSNR", RIGHT + VCENTER + widget.font + WHITE + SHADOWED)
      lcd.drawNumber(widget.width + widget.offset2, widget.zone.h * 0.75, widget.snr, RIGHT + VCENTER + widget.font + (widget.snr > 1 and GREEN or RED + BLINK) + SHADOWED)
    else
      lcd.drawText(widget.width, widget.zone.h / 4, "dBm", RIGHT + VCENTER + widget.font + COLOR_THEME_DISABLED + SHADOWED + BLINK)
      lcd.drawNumber(widget.width + widget.offset2, widget.zone.h / 4, widget.dbm, RIGHT + VCENTER + widget.font + COLOR_THEME_DISABLED + SHADOWED + BLINK)
      lcd.drawText(widget.width + 4, widget.zone.h * 0.75, "rSNR", RIGHT + VCENTER + widget.font + COLOR_THEME_DISABLED + SHADOWED + BLINK)
      lcd.drawNumber(widget.width + widget.offset2, widget.zone.h * 0.75, widget.snr, RIGHT + VCENTER + widget.font + COLOR_THEME_DISABLED + SHADOWED + BLINK)
    end
  end
end

return {
  name = app_name,
  options = options,
  create = create,
  update = update,
  refresh = refresh,
  background = background
}