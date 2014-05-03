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

local storyboard = require "storyboard"
storyboard.purgeOnSceneChange = true

display.setStatusBar(display.HiddenStatusBar)

--> Import Sprite Sheet
sheetInfo = require("plant_sheet")
myImageSheet = graphics.newImageSheet("plant_sheet.png", sheetInfo:getSheet())
print(myImageSheet)
sequenceData =
{
    { name="seqArrowLeft", frames={ 1 }},
    { name="seqArrowRight", frames={ 2 }},
    { name="seqBarren", frames={ 3 }},
    { name="seqBird", frames={4, 5, 6, 7, 8, 9, 10, 11, 12, 13}, time=800},
    { name="seqBirdDead", frames={14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28}, time=1500, loopCount = 1},
    { name="seqBlank", frames={ 29 }},
    { name="seqBoxClosed", frames={ 30 }},
    { name="seqBoxOpen", frames={ 31 }},
    { name="seqCarrot", frames = {39, 32, 33, 34, 38}},
    { name="seqCarrotFrame1", frames = {37, 34}, time=350},
    { name="seqCarrotFrame2", frames = {35, 34}, time=350},
    { name="seqCarrotFrame3", frames = {36, 34}, time=350},
    { name="seqCarrotHarvest", frames = {40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51}, time=500},
    { name="seqCelery", frames = {60, 53, 54, 55, 59}},
    { name="seqCeleryFrame1", frames = {58, 55}, time=350},
    { name="seqCeleryFrame2", frames = {56, 55}, time=350},
    { name="seqCeleryFrame3", frames = {57, 55}, time=350},
    { name="seqCeleryHarvest", frames = {61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72}, time=500},
    { name="seqChamomile", frames = {81, 74, 75, 76, 80}},
    { name="seqChamomileFrame1", frames = {79, 76}, time=350},
    { name="seqChamomileFrame2", frames = {77, 76}, time=350},
    { name="seqChamomileFrame3", frames = {78, 76}, time=350},
    { name="seqChamomileHarvest", frames = {82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 92}, time=500},
    { name="seqGopher", frames = { 113, 112, 111, 110, 109, 108, 107, 106, 105, 104, 103, 102, 101, 100}, time=200, loopCount=1},
    { name="seqGopherOut", frames = { 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113 }, time=200, loopCount=1},    
    { name="seqGopherDie", frames = {113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136}, time=800},
    { name="seqGopherHammerDie", frames = { 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164}, time=800},
    { name="seqJalapeno", frames={172, 165, 166, 167, 171}},
    { name="seqJalapenoFrame1", frames={170, 167}, time=350},
    { name="seqJalapenoFrame2", frames={168, 167}, time=350},
    { name="seqJalapenoFrame3", frames={169, 167}, time=350},
    { name="seqJalapenoHarvest", frames={ 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184}, time=500},
    { name="seqLettuce", frames={193, 186, 187, 188, 192}},
    { name="seqLettuceFrame1", frames={191, 188}, time=350},
    { name="seqLettuceFrame2", frames={189, 188}, time=350},
    { name="seqLettuceFrame3", frames={190, 188}, time=350},
    { name="seqLettuceHarvest", frames={194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205}, time=500, loopCount=1},
    { name="seqMallet", frames={ 207, 208, 209, 210, 211, 212 }, time=250, loopCount=1},
    { name="seqMint", frames={220, 213, 214, 215, 219}},
    { name="seqMintFrame1", frames={218, 215}, time=350},
    { name="seqMintFrame2", frames={216, 215}, time=350},
    { name="seqMintFrame3", frames={217, 215}, time=350},
    { name="seqMintHarvest", frames={221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232}, time=500},
    { name="seqPotato", frames={241, 234, 235, 236, 240}},
    { name="seqPotatoFrame1", frames={239, 236}, time=350},
    { name="seqPotatoFrame2", frames={237, 236}, time=350},
    { name="seqPotatoFrame3", frames={238, 236}, time=350},
    { name="seqPotatoHarvest", frames={242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253}, time=500},
    { name="seqRadish", frames={262, 255, 256, 257, 261}},
    { name="seqRadishFrame1", frames={260, 257}, time=350},
    { name="seqRadishFrame2", frames={258, 257}, time=350},
    { name="seqRadishFrame3", frames={259, 257}, time=350},
    { name="seqRadishHarvest", frames={263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274}, time=500},
    { name="seqRock", frames={ 276 }},
    { name="seqScoreStar", frames={ 277 }},
    { name="seqSlingshot", frames={ 278 }, time=200, loopCount=1},
    { name="seqSmell", frames={279, 280, 281, 282}, time=225},
    { name="seqSwoop", frames={319, 320, 321, 322, 323, 324}, time=800, loopCount=1},
    { name="seqTag", frames={325}},
    { name="seqTomato", frames={333, 326, 327, 328, 332}},
    { name="seqTomatoFrame1", frames={331, 328}, time=350},
    { name="seqTomatoFrame2", frames={329, 328}, time=350},
    { name="seqTomatoFrame3", frames={330, 328}, time=350},
    { name="seqTomatoHarvest", frames={334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345}, time=500},
    { name="seqTutorialHand", frames={ 347, 348 }},
    { name='seqStoneCarrot', frames={283, 284, 285, 286}},
    { name='seqStoneCelery', frames={287, 288, 289, 290}},
    { name='seqStoneChamomile', frames={291, 292, 293, 294}},
    { name='seqStoneJalapeno', frames={295, 296, 297, 298}},
    { name='seqStoneLettuce', frames={299, 300, 301, 302}},
    { name='seqStoneMint', frames={303, 304, 305, 306}},
    { name='seqStonePotatoes', frames={307, 308, 309, 310}},
    { name='seqStoneRadish', frames={311, 312, 313, 314}},
    { name='seqStoneTomatos', frames={315, 316, 317, 318}}
}
--> Import Queue class
require 'class'
require 'libField'
require 'libQueue'
require 'libBasket'
require 'libPlayer'
require 'plants'
require 'fields'
require 'farmElement'


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
    print('hi')
    if(layers.popup.visible) then
        layers.popup.alpha = 0
        layers.popup.visible = false
    else
        layers.popup.alpha = 1
        layers.popup.visible = true
    end
end

function allowTouches(event)
    touchesAllowed=true
    print('You may now touch this!')
end

-----------------------------------------------------
--Main Create Function
-----------------------------------------------------

storyboard.gotoScene( "title_screen", "fade", 400 )

