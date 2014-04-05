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
myImageSheet = graphics.newImageSheet("images/plant_sheet.png", sheetInfo:getSheet())
sequenceData =
{
    { name="seqArrowLeft", frames={ 1 }},
    { name="seqArrowRight", frames={ 2 }},
    { name="seqBarren", frames={ 3 }},
    { name="seqBird", frames={5, 6, 7, 8, 9, 10, 11, 12, 13. 14}, time=800},
    { name="seqBirdDead", frames={15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28. 29}, time=1500, loopCount = 1},
    { name="seqBlank", frames={ 30 }},
    { name="seqBoxClosed", frames={ 31 }},
    { name="seqBoxOpen", frames={ 32 }},
    { name="seqCarrot", frames = {33, 34, 35, 36, 37}},
    { name="seqCelery", frames = {38, 39, 40, 41, 42}},
    { name="seqChamomile", frames = {43, 44, 45, 46, 47}},
    { name="seqGopher", frames = { 52, 51, 50, 49, 49}, time=200, loopCount=1},
    { name="seqGopherOut", frames = { 49, 49, 50, 51, 52 }, time=200, loopCount=1},    
    { name="seqGopherDie", frames = {52, 53, 54, 55}, time=800},
    { name="seqJalapeno", frames={56, 57, 58, 59, 60}},
    { name="seqLettuce", frames={61, 62, 63, 64, 65}},
    { name="seqMallet", frames={ 66 }, time=200, loopCount=1},
    { name="seqMint", frames={67, 68, 69, 70, 71}},
    { name="seqPotato", frames={73, 74, 75, 76, 72}},
    { name="seqRadish", frames={81, 82, 83, 84, 85}},
    { name="seqRock", frames={ 86 }},
    { name="seqSeeds", frames={ 87 }},
    { name="seqSlingshot", frames={ 88 }, time=200, loopCount=1},
    { name="seqSmell", frames={ 89, 90, 91, 92}, time=225},
    { name="seqStage00", frames={ 93 }},
    { name="seqSwoop", frames={94, 95, 96, 97, 98, 99}, time=800, loopCount=1},
    { name="seqTag", frames={ 100 }},
    { name="seqTomato", frames={101, 102, 103, 104, 105}}
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

