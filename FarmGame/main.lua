-----------------------------------------------------
-- 1. Imports and Includes
-----------------------------------------------------

--theFonts = native.getFontNames()
--for i=1, #theFonts do 
--    print(theFonts[i])
--end
--> Create physics (do we need this??)
if "Win" == system.getInfo( "platformName" ) then
    CustomFont = "Comic Neue"
elseif "Android" == system.getInfo( "platformName" ) then
    CustomFont = "ComicNeue-Bold.ttf"
else
    -- Mac and iOS
    CustomFont = "ComicNeue-Bold"
end

local physics = require "physics"
local socket = require "socket"
physics.start()
physics.setGravity( 0, 0 )
physics.setDrawMode( hybrid )

storyboard = require "storyboard"
storyboard.purgeOnSceneChange = true

display.setStatusBar(display.HiddenStatusBar)

obsSheetInfo = require("ImageSheets.Obstruction_sheet")
obsSheet = graphics.newImageSheet("ImageSheets/Obstruction_sheet.png", obsSheetInfo:getSheet())
overlaySheetInfo = require("ImageSheets.Overlay_sheet")
overlaySheet = graphics.newImageSheet("ImageSheets/Overlay_sheet.png", overlaySheetInfo:getSheet())
pestSheetInfo = require("ImageSheets.pest_sheet")
pestSheet = graphics.newImageSheet("ImageSheets/pest_sheet.png", pestSheetInfo:getSheet())plantSheetInfo = require("ImageSheets.plant_sheet")
plantSheetInfo = require("ImageSheets.plant_sheet")
plantSheet = graphics.newImageSheet("ImageSheets/plant_sheet.png", plantSheetInfo:getSheet())
uiSheetInfo = require("ImageSheets.UI_sheet")
uiSheet = graphics.newImageSheet("ImageSheets/UI_sheet.png", uiSheetInfo:getSheet())
weaponSheetInfo = require("ImageSheets.weapon_sheet")
weaponSheet = graphics.newImageSheet("ImageSheets/weapon_sheet.png", weaponSheetInfo:getSheet())

sequenceData =
{
    { name="Barren", sheet=obsSheet, frames={ 1 }},
    { name="Rock", sheet=obsSheet, frames={ 2, 3 }},
    { name="StoneCarrot", sheet=obsSheet, frames={ 8, 4, 5, 6, 7 }},
    { name="StoneCelery", sheet=obsSheet, frames={ 13, 9, 10, 11, 12 }},
    { name="StoneChamomile", sheet=obsSheet, frames={ 18, 14, 15, 16, 17 }},
    { name="StoneJalapenos", sheet=obsSheet, frames={ 23, 19, 20, 21, 22 }},
    { name="StoneLettuce", sheet=obsSheet, frames={ 28, 24, 25, 26, 27 }},
    { name="StoneMint", sheet=obsSheet, frames={ 33, 29, 30, 31, 32 }},
    { name="StonePotatoes", sheet=obsSheet, frames={ 38, 34, 35, 36, 37 }},
    { name="StoneRadish", sheet=obsSheet, frames={ 43, 39, 40, 41, 42 }},
    { name="StoneTomato", sheet=obsSheet, frames={ 48, 44, 45, 46, 47 }},
    { name="TurtleN", sheet=obsSheet, start=50, count=8, time=333},
    { name="TurtleNtoE", sheet=obsSheet, frames={ 59, 60, 61 }, time=125},
    { name="TurtleEtoN", sheet=obsSheet, frames={ 61, 60, 59 }, time=125},
    { name="TurtleS", sheet=obsSheet, start=62, count=8, time=333},
    { name="TurtleStoE", sheet=obsSheet, frames={ 73, 72, 71 }, time=125},
    { name="TurtleEtoS", sheet=obsSheet, frames={ 71, 72, 73 }, time=125},
    { name="TurtleE", sheet=obsSheet, start=74, count=8, time=333},
    { name="Urn", sheet=obsSheet, frames={ 83 }},

    { name="Reticle", sheet=weaponSheet, frames={ 1 }},
    { name="SlingAnim", sheet=weaponSheet, start=2, count=16, time=1000},
    { name="Mallet", sheet=weaponSheet, start=18, count=6, time=250, loopCount=1},
    { name="Slingshot", sheet=weaponSheet, frames={24}},

    { name="BoxClosed", sheet=uiSheet, frames={1}},
    { name="BoxOpen", sheet=uiSheet, frames={2}},
    { name="uiCarrot", sheet=uiSheet, frames={3}},
    { name="uiCelery", sheet=uiSheet, frames={4}},
    { name="uiChamomile", sheet=uiSheet, frames={5}},
    { name="uiJalapeno", sheet=uiSheet, frames={6}},
    { name="uiLettuce", sheet=uiSheet, frames={7}},
    { name="uiMallet", sheet=uiSheet, frames={8}},
    { name="uiMint", sheet=uiSheet, frames={9}},
    { name="uiPotato", sheet=uiSheet, frames={10}},
    { name="uiRadish", sheet=uiSheet, frames={11}},
    { name="uiSlingshot", sheet=uiSheet, frames={12}},
    { name="uiTomato", sheet=uiSheet, frames={13}},

    { name="Reticle", sheet=overlaySheet, frames={ 1 }},
    { name="Smell", sheet=overlaySheet, frames={ 2, 3, 4, 5 }, time=225},
    { name="Tag", sheet=overlaySheet, frames={ 6 }},

    { name="Bird", sheet=pestSheet, start=1, count=10, time=800},
    { name="BirdDead", sheet=pestSheet, start=11, count=15, time=1200, loopCount=1},
    { name="Gopher", sheet=pestSheet, frames = {39, 38, 37, 36, 35, 34, 33, 32, 31, 30, 29, 28, 27, 26}, time=200, loopCount=1},
    { name="GopherOut", sheet=pestSheet, start=26, count=14, time=200, loopCount=1},
    { name="GopherDie", sheet=pestSheet, start=40, count=22, time=800, loopCount=1},
    { name="GopherHammerDie", sheet=pestSheet, start=63, count=27, time=800, loopCount=1},
    { name="Swoop", sheet=pestSheet, start=91, count=6, time=800, loopCount=1},

    { name="Blank", sheet=plantSheet, frames = { 1 }},
    { name="Carrot", sheet=plantSheet, frames = {9, 2, 3, 4, 8}},
    { name="CarrotFrame1", sheet=plantSheet, frames = {7, 4}, time=350},
    { name="CarrotFrame2", sheet=plantSheet, frames = {5, 4}, time=350},
    { name="CarrotFrame3", sheet=plantSheet, frames = {6, 4}, time=350},
    { name="CarrotHarvest", sheet=plantSheet, frames = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21}, time=500, loopCount=1},
    { name="Celery", sheet=plantSheet, frames = {30, 23, 24, 25, 29}},
    { name="CeleryFrame1", sheet=plantSheet, frames = {28, 25}, time=350},
    { name="CeleryFrame2", sheet=plantSheet, frames = {26, 25}, time=350},
    { name="CeleryFrame3", sheet=plantSheet, frames = {27, 25}, time=350},
    { name="CeleryHarvest", sheet=plantSheet, frames = {31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42}, time=500, loopCount=1},
    { name="Chamomile", sheet=plantSheet, frames = {51, 44, 45, 46, 50}},
    { name="ChamomileFrame1", sheet=plantSheet, frames = {49, 46}, time=350},
    { name="ChamomileFrame2", sheet=plantSheet, frames = {47, 46}, time=350},
    { name="ChamomileFrame3", sheet=plantSheet, frames = {48, 46}, time=350},
    { name="ChamomileHarvest", sheet=plantSheet, frames = {52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63}, time=500, loopCount=1},
    { name="Jalapeno", sheet=plantSheet, frames={90, 83, 84, 85, 89}},
    { name="JalapenoFrame1", sheet=plantSheet, frames={88, 85}, time=350},
    { name="JalapenoFrame2", sheet=plantSheet, frames={86, 85}, time=350},
    { name="JalapenoFrame3", sheet=plantSheet, frames={87, 85}, time=350},
    { name="JalapenoHarvest", sheet=plantSheet, frames={ 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102}, time=500, loopCount=1},
    { name="Lettuce", sheet=plantSheet, frames={111, 104, 105, 106, 110}},
    { name="LettuceFrame1", sheet=plantSheet, frames={109, 106}, time=350},
    { name="LettuceFrame2", sheet=plantSheet, frames={107, 106}, time=350},
    { name="LettuceFrame3", sheet=plantSheet, frames={108, 106}, time=350},
    { name="LettuceHarvest", sheet=plantSheet, frames={112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123}, time=500, loopCount=1},
    { name="Mint", sheet=plantSheet, frames={132, 125, 126, 127, 131}},
    { name="MintFrame1", sheet=plantSheet, frames={130, 127}, time=350},
    { name="MintFrame2", sheet=plantSheet, frames={128, 127}, time=350},
    { name="MintFrame3", sheet=plantSheet, frames={129, 127}, time=350},
    { name="MintHarvest", sheet=plantSheet, frames={133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144}, time=500, loopCount=1},
    { name="Potato", sheet=plantSheet, frames={153, 146, 147, 148, 152}},
    { name="PotatoFrame1", sheet=plantSheet, frames={151, 148}, time=350},
    { name="PotatoFrame2", sheet=plantSheet, frames={149, 148}, time=350},
    { name="PotatoFrame3", sheet=plantSheet, frames={150, 148}, time=350},
    { name="PotatoHarvest", sheet=plantSheet, frames={154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165}, time=500, loopCount=1},
    { name="Radish", sheet=plantSheet, frames={174, 167, 168, 169, 173}},
    { name="RadishFrame1", sheet=plantSheet, frames={172, 169}, time=350},
    { name="RadishFrame2", sheet=plantSheet, frames={170, 169}, time=350},
    { name="RadishFrame3", sheet=plantSheet, frames={171, 169}, time=350},
    { name="RadishHarvest", sheet=plantSheet, frames={175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186}, time=500, loopCount=1},
    { name="Tomato", sheet=plantSheet, frames={195, 188, 189, 190, 194}},
    { name="TomatoFrame1", sheet=plantSheet, frames={193, 190}, time=350},
    { name="TomatoFrame2", sheet=plantSheet, frames={191, 190}, time=350},
    { name="TomatoFrame3", sheet=plantSheet, frames={192, 190}, time=350},
    { name="TomatoHarvest", sheet=plantSheet, frames={196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207}, time=500, loopCount=1}
}

require 'Classes.class'
require 'Classes.newClass'
require 'Classes.libField'
require 'Classes.UI.libQueue'
require 'Classes.UI.libBasket'
require 'Classes.UI.libVolSlider'
require 'Classes.libPlayer'
require 'Data.plants'
require 'Data.fields'
require 'Classes.FarmElement'
require 'Classes.FarmElements.Blank'
require 'Classes.FarmElements.Plant'
require 'Classes.FarmElements.Pest'
require 'Classes.FarmElements.LandPest'
require 'Classes.FarmElements.AirPest'
require 'Classes.FarmElements.Obstruction'
require 'farm_sound'
require 'fieldEvents'

--> Import the Widget tool
local widget

------------------------------------------------------
-- 2. Global Variables
------------------------------------------------------
w = display.contentWidth
h = display.contentHeight
centerX = display.contentCenterX
centerY = display.contentCenterY
theQueue = {}
theField = {}
theBasket = {}
thePlayer = Player()
theLevelScroll = {}
fieldType = 'Salad'
field = {}
local createSquare
local onSquareTouch
local nextDay
layers = {}
local clickedID
local score = 0
local clickAction = ""
local plantsHarvested = {}

musicVolume = .5
sfxVolume = .5

gameOver = false
tutorial = false
no_pests = false
log_levels = {  Info = 3,
                Debug = 2,
                Warn = 1,
                Error = 0}
log_level = 'Debug'

------------------------------------------------------
-- 3. Global Functions
------------------------------------------------------
function getXY(id)
    sep = string.find(id, ',')
    x = tonumber(string.sub(id, 0, sep-1))
    y = tonumber(string.sub(id, -sep+1))
    return x, y
end

function getSquare(id)
    x, y = getXY(id)
    return theField.grid[x][y]
end

function AddPlantsHarvested(plant)
    print("Adding plants harvested")
    table.insert(plantsHarvested, plant)
end

function getPlantsHarvested()
    return plantsHarvested
end

function clearPlantsHarvested()
    plantsHarvested = {}
end


function newSprite(sequence, x, y)
    sprite = display.newSprite(myImageSheet, sequenceData)
    sprite:setSequence(sequence)
    sprite.x = x
    sprite.y = y
    return sprite
end

function sleep(sec)
    socket.select(nil, nil, sec)
    return true
end

function log(message, level)
    if log_levels[level] <= log_levels[log_level] then
        print(message)
    end
end

toggleOptions = function ( event )
    if not gameOver then
        if(layers.popup.visible) then
            layers.popup.alpha = 0
            timer.performWithDelay(10, function() layers.popup.visible = false end, 1)
        else
            layers.popup.alpha = 1
            layers.popup.visible = true
        end
    end
end

function allowTouches(event)
    touchesAllowed=true
    print('You may now touch this!')
end

-----------------------------------------------------
--Main Create Function
-----------------------------------------------------
local function onKeyEvent( event )

   local phase = event.phase
   local keyName = event.keyName
   print( event.phase, event.keyName )

   if ( "back" == keyName and phase == "up" ) then
      if ( storyboard.currentScene == "splash" ) then
         native.requestExit()
      else
         if ( storyboard.isOverlay ) then
            storyboard.hideOverlay()
         else
            if ( lastScene ) then
               storyboard.gotoScene( 'title_screen', { effect="crossFade", time=500 } )
            else
               native.requestExit()
            end
         end
      end
   end

   if ( keyName == "volumeUp" and phase == "down" ) then
      local masterVolume = audio.getVolume()
      print( "volume:", masterVolume )
      if ( masterVolume < 1.0 ) then
         masterVolume = masterVolume + 0.1
         audio.setVolume( masterVolume )
      end
      return true
   elseif ( keyName == "volumeDown" and phase == "down" ) then
      local masterVolume = audio.getVolume()
      print( "volume:", masterVolume )
      if ( masterVolume > 0.0 ) then
         masterVolume = masterVolume - 0.1
         audio.setVolume( masterVolume )
      end
      return true
   end
   return false  --SEE NOTE BELOW
end

--add the key callback
Runtime:addEventListener( "key", onKeyEvent )


storyboard.gotoScene( "title_screen", "fade", 400 )

