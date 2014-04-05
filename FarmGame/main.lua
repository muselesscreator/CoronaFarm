-----------------------------------------------------
-- 1. Imports and Includes
-----------------------------------------------------
--> Create physics (do we need this??)
local physics = require "physics"
physics.start()
physics.setGravity( 0, 0 )
physics.setDrawMode( hybrid )

local storyboard = require "storyboard"
storyboard.purgeOnSceneChange = true
--> Import Sprite Sheet
sheetInfo = require("plant_sheet")
myImageSheet = graphics.newImageSheet("plant_sheet.png", sheetInfo:getSheet())
sequenceData =
{
    { name="seqArrowLeft", frames={ 1 }},
    { name="seqArrowRight", frames={ 2 }},
    { name="seqBarren", frames={ 3 }},
    { name="seqBird", frames={5, 6, 7, 8, 9, 10, 11, 12, 13, 14}, time=800},
    { name="seqBirdDead", frames={15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29}, time=1500, loopCount = 1},
    { name="seqBlank", frames={ 30 }},
    { name="seqBoxClosed", frames={ 31 }},
    { name="seqBoxOpen", frames={ 32 }},
    { name="seqCarrot", frames = {33, 34, 35, 36, 37}},
    { name="seqCelery", frames = {38, 39, 40, 41, 42}},
    { name="seqChamomile", frames = {43, 44, 45, 46, 47}},
    { name="seqGopher", frames = { 52, 51, 50, 49, 49}, time=200, loopCount=1},
    { name="seqGopherOut", frames = { 49, 49, 50, 51, 52 }, time=200, loopCount=1},    
    { name="seqGopherDie", frames = {53, 54, 55, 56}, time=800},
    { name="seqJalapeno", frames={58, 59, 60, 61, 57}},
    { name="seqLettuce", frames={62, 63, 64, 65, 66}},
    { name="seqMallet", frames={ 67 }, time=200, loopCount=1},
    { name="seqMint", frames={68, 69, 70, 71, 72}},
    { name="seqPotato", frames={74, 75, 76, 77, 73}},
    { name="seqRadish", frames={82, 83, 84, 85, 86}},
    { name="seqRock", frames={ 87 }},
    { name="seqScoreStar", frames={ 88 }},
    { name="seqSeeds", frames={ 89 }},
    { name="seqSlingshot", frames={ 90 }, time=200, loopCount=1},
    { name="seqSmell", frames={91, 92, 93, 94}, time=225},
    { name="seqStage00", frames={ 95 }},
    { name="seqSwoop", frames={96, 97, 98, 99, 100, 101}, time=800, loopCount=1},
    { name="seqTag", frames={ 102 }},
    { name="seqTomato", frames={103, 104, 105, 106, 107}},
    { name="seqTutorialHand", frames={ 108 }}
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
local plantsHarvested = 0


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

function AddPlantsHarvested(inc)
    print("Adding "..inc.." plants harvested")
    plantsHarvested = plantsHarvested + inc
end

function getPlantsHarvested()
    return plantsHarvested
end

function setPlantsHarvested(n)
    plantsHarvested = n
end
-----------------------------------------------------
--Main Create Function
-----------------------------------------------------

storyboard.gotoScene( "title_screen", "fade", 400 )

