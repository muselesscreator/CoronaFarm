--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:bb2443e3884cbe083c07ee91f1b5a31a:1108937a6df044ce9d59cfec68ab1a3e:2e79a1b73e6e22e35e251479156ff34a$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- boxClosed
            x=147,
            y=2,
            width=143,
            height=145,

        },
        {
            -- boxOpen
            x=2,
            y=2,
            width=143,
            height=145,

        },
        {
            -- carrotBag
            x=620,
            y=87,
            width=101,
            height=83,

            sourceX = 37,
            sourceY = 56,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- celeryBag
            x=557,
            y=2,
            width=101,
            height=83,

            sourceX = 37,
            sourceY = 56,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- chamomileBag
            x=517,
            y=87,
            width=101,
            height=83,

            sourceX = 37,
            sourceY = 56,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- jalapenosBag
            x=454,
            y=2,
            width=101,
            height=83,

            sourceX = 37,
            sourceY = 56,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- lettuceBag
            x=414,
            y=131,
            width=101,
            height=83,

            sourceX = 37,
            sourceY = 56,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- mallet
            x=292,
            y=2,
            width=79,
            height=135,

            sourceX = 33,
            sourceY = 22,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- mintBag
            x=311,
            y=139,
            width=101,
            height=83,

            sourceX = 37,
            sourceY = 56,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- potatoesBag
            x=208,
            y=149,
            width=101,
            height=83,

            sourceX = 37,
            sourceY = 56,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- radishBag
            x=105,
            y=149,
            width=101,
            height=83,

            sourceX = 37,
            sourceY = 56,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- slingshot
            x=373,
            y=2,
            width=79,
            height=127,

            sourceX = 52,
            sourceY = 24,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- tomatosBag
            x=2,
            y=149,
            width=101,
            height=83,

            sourceX = 37,
            sourceY = 56,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- tutorialHand
            x=619,
            y=172,
            width=99,
            height=55,

        },
        {
            -- tutorialHandBack
            x=517,
            y=172,
            width=100,
            height=55,

        },
    },
    
    sheetContentWidth = 723,
    sheetContentHeight = 234
}

SheetInfo.frameIndex =
{

    ["boxClosed"] = 1,
    ["boxOpen"] = 2,
    ["carrotBag"] = 3,
    ["celeryBag"] = 4,
    ["chamomileBag"] = 5,
    ["jalapenosBag"] = 6,
    ["lettuceBag"] = 7,
    ["mallet"] = 8,
    ["mintBag"] = 9,
    ["potatoesBag"] = 10,
    ["radishBag"] = 11,
    ["slingshot"] = 12,
    ["tomatosBag"] = 13,
    ["tutorialHand"] = 14,
    ["tutorialHandBack"] = 15,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
