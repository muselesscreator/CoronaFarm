-----------------------------------------------------
-- 1. Imports and Includes
-----------------------------------------------------
--> Create physics (do we need this??)
local physics = require "physics"
local socket = require "socket"
physics.start()
physics.setGravity( 0, 0 )
physics.setDrawMode( hybrid )

local storyboard = require "storyboard"
storyboard.purgeOnSceneChange = true
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
    { name="seqCarrotFrame1", frames = {36, 34}, time=350},
    { name="seqCarrotFrame2", frames = {35, 34}, time=350},
    { name="seqCarrotFrame3", frames = {37, 34}, time=350},
    { name="seqCelery", frames = {48, 41, 42, 43, 47}},
    { name="seqCeleryFrame1", frames = {45, 43}, time=350},
    { name="seqCeleryFrame2", frames = {44, 44}, time=350},
    { name="seqCeleryFrame3", frames = {46, 44}, time=350},
    { name="seqChamomile", frames = {57, 50, 51, 52, 56}},
    { name="seqChamomileFrame1", frames = {54, 52}, time=350},
    { name="seqChamomileFrame2", frames = {53, 52}, time=350},
    { name="seqChamomileFrame3", frames = {55, 52}, time=350},
    { name="seqGopher", frames = { 63, 62, 61, 60, 59}, time=200, loopCount=1},
    { name="seqGopherOut", frames = { 59, 60, 61, 62, 63 }, time=200, loopCount=1},    
    { name="seqGopherDie", frames = {64, 65, 66, 67}, time=800},
    { name="seqJalapeno", frames={75, 68, 69, 70, 74}},
    { name="seqJalapenoFrame1", frames={72, 70}, time=350},
    { name="seqJalapenoFrame2", frames={71, 70}, time=350},
    { name="seqJalapenoFrame3", frames={73, 70}, time=350},
    { name="seqLettuce", frames={84, 77, 78, 79, 83}},
    { name="seqLettuceFrame1", frames={81, 79}, time=350},
    { name="seqLettuceFrame2", frames={80, 79}, time=350},
    { name="seqLettuceFrame3", frames={82, 79}, time=350},
    { name="seqMallet", frames={ 86, 87, 88, 89, 90, 91 }, time=250, loopCount=1},
    { name="seqMint", frames={99, 92, 93, 94, 98}},
    { name="seqMintFrame1", frames={96, 94}, time=350},
    { name="seqMintFrame2", frames={95, 94}, time=350},
    { name="seqMintFrame3", frames={97, 94}, time=350},
    { name="seqPotato", frames={108, 101, 102, 103, 107}},
    { name="seqPotatoFrame1", frames={106, 103}, time=350},
    { name="seqPotatoFrame2", frames={104, 103}, time=350},
    { name="seqPotatoFrame3", frames={105, 103}, time=350},
    { name="seqRadish", frames={117, 110, 111, 112, 116}},
    { name="seqRadishFrame1", frames={114, 112}, time=350},
    { name="seqRadishFrame2", frames={113, 112}, time=350},
    { name="seqRadishFrame3", frames={115, 112}, time=350},
    { name="seqRock", frames={ 119 }},
    { name="seqScoreStar", frames={ 120 }},
    { name="seqSlingshot", frames={ 121 }, time=200, loopCount=1},
    { name="seqSmell", frames={122, 123, 124, 125}, time=225},
    { name="seqSwoop", frames={162, 163, 164, 165, 166, 167}, time=800, loopCount=1},
    { name="seqTag", frames={168}},
    { name="seqTomato", frames={176, 169, 170, 171, 175}},
    { name="seqTomatoFrame1", frames={173, 171}, time=350},
    { name="seqTomatoFrame2", frames={172, 171}, time=350},
    { name="seqTomatoFrame3", frames={174, 171}, time=350},
    { name="seqTutorialHand", frames={ 178, 179 }},
    { name='seqStoneCarrot', frames={126, 127, 128, 129}},
    { name='seqStoneCelery', frames={130, 131, 132, 133}},
    { name='seqStoneChamomile', frames={134, 135, 136, 137}},
    { name='seqStoneJalapeno', frames={138, 139, 140, 141}},
    { name='seqStoneLettuce', frames={142, 143, 144, 145}},
    { name='seqStoneMint', frames={146, 147, 148, 149}},
    { name='seqStonePotatoes', frames={150, 151, 152, 153}},
    { name='seqStoneRadish', frames={154, 155, 156, 157}},
    { name='seqStoneTomatos', frames={158, 159, 160, 161}}
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
tutorial = false

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
-----------------------------------------------------
--Main Create Function
-----------------------------------------------------

storyboard.gotoScene( "title_screen", "fade", 400 )

