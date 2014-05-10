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
overlaySheet = graphics.newImageSheet("ImageSheets/Overlay_sheet.png", obsSheetInfo:getSheet())
pestSheetInfo = require("ImageSheets.pest_sheet")
pestSheet = graphics.newImageSheet("ImageSheets/pest_sheet.png", obsSheetInfo:getSheet())plantSheetInfo = require("ImageSheets.plant_sheet")
plantSheet = graphics.newImageSheet("ImageSheets/plant_sheet.png", obsSheetInfo:getSheet())
uiSheetInfo = require("ImageSheets.UI_sheet")
uiSheet = graphics.newImageSheet("ImageSheets/UI_sheet.png", obsSheetInfo:getSheet())
weaponSheetInfo = require("ImageSheets.weapon_sheet")
weaponSheet = graphics.newImageSheet("ImageSheets/weapon_sheet.png", obsSheetInfo:getSheet())

sequenceData =
{
    { name="Barren", sheet=obsImageSheet, frames={ 1 }},
    { name="Rock", sheet=obsImageSheet, frames={ 2 }},
    { name="StoneCarrot", sheet=obsImageSheet, frames={ 8, 4, 5, 6, 7 }},
    { name="StoneCelery", sheet=obsImageSheet, frames={ 13, 9, 10, 11, 12 }},
    { name="StoneChamomile", sheet=obsImageSheet, frames={ 18, 14, 15, 16, 17 }},
    { name="StoneJalapenos", sheet=obsImageSheet, frames={ 24, 20, 21, 22, 23 }},
    { name="StoneLettuce", sheet=obsImageSheet, frames={ 29, 25, 26, 27, 28, 29 }},
    { name="StoneMint", sheet=obsImageSheet, frames={ 34, 30, 31, 32, 33 }},
    { name="StonePotatoes", sheet=obsImageSheet, frames={ 39, 35, 36, 37, 38 }},
    { name="StoneRadish", sheet=obsImageSheet, frames={ 44, 40, 41, 42, 43 }},
    { name="StoneTomato", sheet=obsImageSheet, frames={ 49, 45, 46, 47, 48 }},
    { name="TurtleN", sheet=obsImageSheet, frames={ 50, 51, 52, 53, 54, 55, 56 }},
    { name="turtleNW", sheet=obsImageSheet, frames={ 57 }},
    { name="turtleS", sheet=obsImageSheet, frames={ 58, 59, 60, 61, 62, 63, 64 }},
    { name="turtleSW", sheet=obsImageSheet, frames={ 65 }},
    { name="TurtleW", sheet=obsImageSheet, frames={ 66, 67, 68, 69, 70, 71, 72 }},
    { name="Urn", sheet=obsImageSheet, frames={ 73 }},

    { name="Mallet", sheet=weaponSheet, frames={ 1, 2, 3, 4, 5, 6}, time=250, loopCount=1},
    { name="Slingshot", sheet=weaponSheet, frames={7}},

    { name="boxClosed", sheet=uiSheet, frames={1}},
    { name="boxOpen", sheet=uiSheet, frames={2}},

    { name="Smell", sheet=overlaySheet, frames={ 1, 2, 3, 4 }, time=225},
    { name="Tag", sheet=overlaySheet, frames={ 5 }},

    { name="Bird", sheet=pestSheet, start=1, count=10, time=800},
    { name="BirdDead", sheet=pestSheet, start=11, count=15, time=1200, loopCount=1},
    { name="Gopher", sheet=pestSheet, frames = {39, 38, 37, 36, 35, 34, 33, 32, 31, 30, 29, 28, 27, 26}, time=200, loopCount=1},
    { name="GopherOut", sheet=pestSheet, start=26, count=14, time=200, loopCount=1},
    { name="GopherDie", sheet=pestSheet, start=40, count=22, time=800, loopCount=1},
    { name="GopherHammerDie", sheet=pestSheet, start=63, count=27, time=800, loopCount=1},

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
    { name="Cilantro", sheet=plantSheet, frames = {69, }},
    { name="CilantroFrame1", sheet=plantSheet, frames = {70, 67}, time=350},
    { name="CilantroFrame2", sheet=plantSheet, frames = {68, 67}, time=350},
    { name="CilantroFrame3", sheet=plantSheet, frames = {69, 67}, time=350},
    { name="CilantroHarvest", sheet=plantSheet, frames = {73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84}, time=500, loopCount=1},
    { name="Jalapeno", sheet=plantSheet, frames={90, 8, 87, 88, 92}},
    { name="JalapenoFrame1", sheet=plantSheet, frames={91, 85}, time=350},
    { name="JalapenoFrame2", sheet=plantSheet, frames={89, 85}, time=350},
    { name="JalapenoFrame3", sheet=plantSheet, frames={90, 85}, time=350},
    { name="JalapenoHarvest", sheet=plantSheet, frames={ 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102}, time=500, loopCount=1},
    { name="Lettuce", sheet=plantSheet, frames={193, 186, 187, 188, 192}},
    { name="LettuceFrame1", sheet=plantSheet, frames={191, 188}, time=350},
    { name="LettuceFrame2", sheet=plantSheet, frames={189, 188}, time=350},
    { name="LettuceFrame3", sheet=plantSheet, frames={190, 188}, time=350},
    { name="LettuceHarvest", sheet=plantSheet, frames={194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205}, time=500, loopCount=1},
    { name="Mint", sheet=plantSheet, frames={220, 213, 214, 215, 219}},
    { name="MintFrame1", sheet=plantSheet, frames={218, 215}, time=350},
    { name="MintFrame2", sheet=plantSheet, frames={216, 215}, time=350},
    { name="MintFrame3", sheet=plantSheet, frames={217, 215}, time=350},
    { name="MintHarvest", sheet=plantSheet, frames={221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232}, time=500, loopCount=1},
    { name="Potato", sheet=plantSheet, frames={241, 234, 235, 236, 240}},
    { name="PotatoFrame1", sheet=plantSheet, frames={239, 236}, time=350},
    { name="PotatoFrame2", sheet=plantSheet, frames={237, 236}, time=350},
    { name="PotatoFrame3", sheet=plantSheet, frames={238, 236}, time=350},
    { name="PotatoHarvest", sheet=plantSheet, frames={242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253}, time=500, loopCount=1},
    { name="Radish", sheet=plantSheet, frames={262, 255, 256, 257, 261}},
    { name="RadishFrame1", sheet=plantSheet, frames={260, 257}, time=350},
    { name="RadishFrame2", sheet=plantSheet, frames={258, 257}, time=350},
    { name="RadishFrame3", sheet=plantSheet, frames={259, 257}, time=350},
    { name="RadishHarvest", sheet=plantSheet, frames={263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274}, time=500, loopCount=1},
    { name="Tomato", sheet=plantSheet, frames={333, 326, 327, 328, 332}},
    { name="TomatoFrame1", sheet=plantSheet, frames={331, 328}, time=350},
    { name="TomatoFrame2", sheet=plantSheet, frames={329, 328}, time=350},
    { name="TomatoFrame3", sheet=plantSheet, frames={330, 328}, time=350},
    { name="TomatoHarvest", sheet=plantSheet, frames={334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345}, time=500, loopCount=1},
    { name='StoneCarrot', sheet=plantSheet, frames={283, 284, 285, 286}},
    { name='StoneCelery', sheet=plantSheet, frames={287, 288, 289, 290}},
    { name='StoneChamomile', sheet=plantSheet, frames={291, 292, 293, 294}},
    { name='StoneJalapeno', sheet=plantSheet, frames={295, 296, 297, 298}},
    { name='StoneLettuce', sheet=plantSheet, frames={299, 300, 301, 302}},
    { name='StoneMint', sheet=plantSheet, frames={303, 304, 305, 306}},
    { name='StonePotatoes', sheet=plantSheet, frames={307, 308, 309, 310}},
    { name='StoneRadish', sheet=plantSheet, frames={311, 312, 313, 314}},
    { name='StoneTomatos', sheet=plantSheet, frames={315, 316, 317, 318}},

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
        print('hi')
        if(layers.popup.visible) then
            layers.popup.alpha = 0
            layers.popup.visible = false
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

