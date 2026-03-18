local toolName = "TNS|Rotor Rush|TNE" 

local lcdW = LCD_W
local lcdH = LCD_H

-- Game variables
local heli = { x = LCD_W - 90, y = 100, w = 20, h = 12 }
local points = 0
local lives = 3
local speed = 1

local enemies = {}
local spawnTimer = 0

local pointsItems = {}
local pointSpawnTimer = 0

local crashTimer = 0
local heliVisible = true

local gameoverTimer = 0
local gameoverVisible = true

local bgOffset = 0

local gameOver = false

local splashBmp = bitmap.open("/IMAGES/RotorRush.png")
local showSplash = true

local mountainBaseHeight = 20
local mountainBaseY = lcdH - mountainBaseHeight
local mountainWidth = 200


----------------------------------------------------
-- SPLASH SCREEN
----------------------------------------------------
local function drawSplash()

   if splashBmp then
    lcd.drawBitmap(splashBmp, 0, 0)
   end

end
----------------------------------------------------

local function drawTopBar()
    lcd.setColor(CUSTOM_COLOR, lcd.RGB(0,120,200)) -- blue
    lcd.drawFilledRectangle(0, 0, lcdW, 30, CUSTOM_COLOR)

    lcd.setColor(CUSTOM_COLOR, lcd.RGB(255,255,255))
    lcd.drawText(5, 5, "Lives: "..lives)
    lcd.drawText(lcdW - 80, 5, "Points: "..points)
end

----------------------------------------------------

local function drawBackground()

    -- SKY
    lcd.setColor(CUSTOM_COLOR, lcd.RGB(180,220,255))
    lcd.drawFilledRectangle(0, 30, lcdW, lcdH-30, CUSTOM_COLOR)

--------------------------------------------------
-- MOUNTAINS (scrolling left → right)
--------------------------------------------------

-- mountain base (fixed ground)
lcd.setColor(CUSTOM_COLOR, lcd.RGB(100,60,20))
lcd.drawFilledRectangle(0, mountainBaseY, lcdW, mountainBaseHeight, CUSTOM_COLOR)

-- move mountain
if not gameOver then
  bgOffset = bgOffset + speed
end

-- reset AFTER mountain fully leaves screen
if bgOffset > lcdW then
  bgOffset = -300   -- mountain + trees width
end

lcd.setColor(CUSTOM_COLOR, lcd.RGB(100,60,20))

-- mountain position
baseX = bgOffset

-- draw mountain
lcd.drawFilledRectangle(baseX,       mountainBaseY - 20, 200, 20, CUSTOM_COLOR)
lcd.drawFilledRectangle(baseX + 30,  mountainBaseY - 40, 140, 20, CUSTOM_COLOR)
lcd.drawFilledRectangle(baseX + 60,  mountainBaseY - 60, 80,  20, CUSTOM_COLOR)

--------------------------------------------------
-- TREES (beside the mountain)
--------------------------------------------------

-- trunk color
lcd.setColor(CUSTOM_COLOR, lcd.RGB(120,70,40))

-- trunks
lcd.drawFilledRectangle(baseX + 220, mountainBaseY - 10, 3, 10, CUSTOM_COLOR)
lcd.drawFilledRectangle(baseX + 250, mountainBaseY - 14, 4, 14, CUSTOM_COLOR)
lcd.drawFilledRectangle(baseX + 280, mountainBaseY - 12, 3, 12, CUSTOM_COLOR)

-- leaves
lcd.setColor(CUSTOM_COLOR, lcd.RGB(0,100,0))

lcd.drawFilledCircle(baseX + 221, mountainBaseY - 14, 6, CUSTOM_COLOR)
lcd.drawFilledCircle(baseX + 252, mountainBaseY - 20, 8, CUSTOM_COLOR)
lcd.drawFilledCircle(baseX + 281, mountainBaseY - 16, 7, CUSTOM_COLOR)

end
----------------------------------------------------

-- HELI ICON
local function drawHeliIcon(x, y, color)
  lcd.drawFilledRectangle(x + 6,  y + 12, 28, 12, color)
  lcd.drawFilledRectangle(x + 34, y + 14, 28, 8,  color)
  lcd.drawFilledRectangle(x + 58, y + 8,  6,  18, color)
  lcd.drawFilledRectangle(x + 6,  y + 26, 28, 4,  color)
  lcd.drawFilledRectangle(x + 18, y + 6,  4,  6,  color)
  lcd.drawFilledRectangle(x - 8,  y + 4,  58, 4,  color)
end

-- PLANE ICON (facing RIGHT)
local function drawPlaneIcon(x, y, color)

  local xOff = 0
  local yOff = -3
  local w = 60  

  lcd.drawFilledCircle(x + (w - (5 + xOff)),  y + 22 + yOff, 3, color) -- nose
  lcd.drawFilledRectangle(x + (w - (6 + xOff) - 52), y + 18 + yOff, 52, 8, color) -- fuselage
  lcd.drawFilledRectangle(x + (w - (18 + xOff) - 9), y + 5 + yOff, 9, 33, color) -- wing
  lcd.drawFilledRectangle(x + (w - (45 + xOff) - 20), y + 3 + yOff, 20, 4, color) -- tailplane
  lcd.drawFilledRectangle(x + (w - (52 + xOff) - 6), y + 4 + yOff, 6, 20, color) -- fin
end

-- DRONE ICON
local function drawDroneIcon(x, y, color)

  local yOff = -5

  lcd.drawFilledRectangle(x + 22, y + 16 + yOff, 16, 8, color)
  lcd.drawFilledRectangle(x + 6,  y + 10 + yOff, 12, 4, color)
  lcd.drawFilledRectangle(x + 42, y + 10 + yOff, 12, 4, color)
  lcd.drawFilledRectangle(x + 6,  y + 26 + yOff, 12, 4, color)
  lcd.drawFilledRectangle(x + 42, y + 26 + yOff, 12, 4, color)
end

--------------------------------------------------
-- DRONE / PLANE IN THE SKY ONLY
--------------------------------------------------
local function spawnEnemy()

  local enemy = {}

  -- random type
  if math.random(0,1) == 0 then
    enemy.type = "plane"
  else
    enemy.type = "drone"
  end

  -- spawn off the left side
  enemy.x = -80

  -- random sky height (above mountains)
  enemy.y = math.random(40, lcdH - 100)

  table.insert(enemies, enemy)
end

--------------------------------------------------
-- DRAW HELI
--------------------------------------------------
local function drawHeli()

  if not heliVisible then return end

  local sc = getValue("sc")
  local heliColor

  if sc <= -512 then
    heliColor = BLACK
  elseif sc >= 512 then
    heliColor = lcd.RGB(255,105,180) -- pink
  else
    heliColor = DARKRED
  end

  drawHeliIcon(heli.x, heli.y, heliColor)
end

--------------------------------------------------
-- YELLOW POINTS CIRCLE
--------------------------------------------------
local function spawnPoint()

  local p = {}

  p.x = -20
  p.y = math.random(40, lcdH - 100)

  table.insert(pointsItems, p)
end
----------------------------------------------------
-- UPDATE YELLOW POINTS CIRCLE
----------------------------------------------------
local function updatePoints()

  pointSpawnTimer = pointSpawnTimer + 1

  if pointSpawnTimer > 120 then
    spawnPoint()
    pointSpawnTimer = 0
  end

  for i = #pointsItems, 1, -1 do
    local p = pointsItems[i]

    -- move
    p.x = p.x + speed + 2

    -- collision with heli
    if math.abs(p.x - heli.x) < 30 and math.abs(p.y - heli.y) < 20 then
      points = points + 1
      playTone(900, 150, 0, PLAY_NOW)
      playTone(1200, 150, 0, PLAY_NOW)
      table.remove(pointsItems, i)
    elseif p.x > lcdW + 20 then
      table.remove(pointsItems, i)
    end
  end
end
----------------------------------------------------
-- UPDATE HELICOPTER MOVEMENTS
----------------------------------------------------

local function updateHeli()

    -- Read sticks
    local stickY = getValue(3)  -- CH3 (up/down)
    local stickX = getValue(2)  -- CH2 (left/right)

    if not stickY then stickY = 0 end
    if not stickX then stickX = 0 end

    --------------------------------------------------
    -- Vertical movement (CH3)
    --------------------------------------------------

    local topLimit = 30
    local bottomLimit = lcdH - 50
    local usableHeight = bottomLimit - topLimit

    local normY = (stickY + 1024) / 2048
    heli.y = topLimit + (usableHeight * (1 - normY))

    --------------------------------------------------
    -- Horizontal movement (CH2)
    --------------------------------------------------

    local leftLimit = 10
    local rightLimit = lcdW - 80   -- keep heli on screen
    local usableWidth = rightLimit - leftLimit

    local normX = (stickX + 1024) / 2048
    heli.x = leftLimit + (usableWidth * (1 - normX))

    --------------------------------------------------
    -- Clamp safety
    --------------------------------------------------

    if heli.y < topLimit then heli.y = topLimit end
    if heli.y > bottomLimit then heli.y = bottomLimit end

    if heli.x < leftLimit then heli.x = leftLimit end
    if heli.x > rightLimit then heli.x = rightLimit end
end

----------------------------------------------------
-- UPDATE PLANE / DRONE MOVEMENTS
----------------------------------------------------
local function updateEnemies()

  spawnTimer = spawnTimer + 1

  local spawnRate = 60

  if points >= 20 then
    spawnRate = 30
  end
  if points >= 25 then
    spawnRate = 10
  end

  if spawnTimer > spawnRate then
    spawnEnemy()
    spawnTimer = 0
  end

  for i = #enemies, 1, -1 do
    local e = enemies[i]

    -- move enemies (faster by 20% every 10 points)
    local difficulty = 1 + (math.floor(points / 10) * 0.5)
    e.x = e.x + (speed + 2) * difficulty

    -- remove if off screen
    if e.x > lcdW + 100 then
      table.remove(enemies, i)
    end
  end
end

----------------------------------------------------
-- CHECK COLLISIONS
----------------------------------------------------

local function checkCollisions()

  if crashTimer > 0 then return end

  -- enemy collision
  for i = 1, #enemies do
    local e = enemies[i]

    if math.abs(e.x - heli.x) < 40 and math.abs(e.y - heli.y) < 30 then
      lives = lives - 1
      crashTimer = 40
      playTone(300, 400, 0, PLAY_NOW)
      break
    end
  end

  -- mountain collision
  local mountainTop = mountainBaseY - 60
  local mountainBottom = mountainBaseY

  if heli.x > baseX and heli.x < baseX + mountainWidth then
    if heli.y > mountainTop and heli.y < mountainBottom then
      lives = lives - 1
      crashTimer = 40
      playTone(300, 400, 0, PLAY_NOW)
    end
  end

  -- tree collision
  local treeLeft = baseX + 220
  local treeRight = baseX + 300
  local treeTop = mountainBaseY - 50
  local treeBottom = mountainBaseY

  if heli.x > treeLeft and heli.x < treeRight then
    if heli.y > treeTop and heli.y < treeBottom then
      lives = lives - 1
      crashTimer = 40
      playTone(300, 400, 0, PLAY_NOW)
    end
  end

  -- check for game over
  if lives <= 0 then
    gameOver = true
    gameoverTimer = 9999
  end

end

----------------------------------------------------
-- HELI FLASHES DURING CRASH
----------------------------------------------------
local function updateCrashFlash()

  if crashTimer > 0 then

    crashTimer = crashTimer - 1

    if crashTimer % 10 < 5 then
      heliVisible = false
    else
      heliVisible = true
    end

  else
    heliVisible = true
  end

end

----------------------------------------------------
-- DRAW PLANE / DRONE
----------------------------------------------------
local function drawEnemies()

  for i = 1, #enemies do
    local e = enemies[i]

    if e.type == "plane" then
      drawPlaneIcon(e.x, e.y, WHITE)
    else
      drawDroneIcon(e.x, e.y, GREY)
    end
  end
end
----------------------------------------------------
-- DRAW YELLOW POINTS CIRCLE
----------------------------------------------------
local function drawPoints()

  for i = 1, #pointsItems do
    local p = pointsItems[i]

    lcd.setColor(CUSTOM_COLOR, lcd.RGB(255,220,0))
    lcd.drawFilledCircle(p.x, p.y, 8, CUSTOM_COLOR)

    lcd.setColor(CUSTOM_COLOR, lcd.RGB(0,0,0))
    lcd.drawText(p.x - 3, p.y - 8, "1", SMLSIZE)
  end
end

----------------------------------------------------
-- RESET GAME
----------------------------------------------------
local function resetGame()

  heli.x = LCD_W - 90
  heli.y = 100

  points = 0
  lives = 3

  enemies = {}
  pointsItems = {}

  spawnTimer = 0
  pointSpawnTimer = 0

  crashTimer = 0
  heliVisible = true

  bgOffset = 0
  
  gameoverTimer = 0
  gameoverVisible = true

  gameOver = false

end

----------------------------------------------------
-- GAMEOVER FLASHES
----------------------------------------------------
local function gameoverFlash()

  if not gameOver then return end

    gameoverTimer = gameoverTimer + 1

    if gameoverTimer % 20 < 10 then
      gameoverVisible = true
    else
      gameoverVisible = false
    end

end

----------------------------------------------------

local function run(event)

  lcd.clear()

  -- Splash screen
  if showSplash then

    if splashBmp then
      lcd.drawBitmap(splashBmp, 0, 0)
    end

    if event == EVT_ENTER_BREAK then
      showSplash = false
    end

    return 0
  end

  -- restart after game over
  if gameOver and event == EVT_ENTER_BREAK then
    resetGame()
  end

  drawBackground()

  if not gameOver then
    updateHeli()
    updateEnemies()
    updatePoints()

    checkCollisions()
    updateCrashFlash()
  end

  drawEnemies()
  drawPoints()
  drawHeli()
  drawTopBar()

  if gameOver and gameoverVisible then
    lcd.drawText(lcdW/2 - 90, lcdH/2 - 10, "GAME OVER", DBLSIZE + RED)
  end

  gameoverFlash()

  return 0

end
----------------------------------------------------

return { run=run }
