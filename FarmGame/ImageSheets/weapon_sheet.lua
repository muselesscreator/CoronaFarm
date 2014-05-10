--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:64272f6d0568ab74bcb0fc8731066511:0e310e474d0ff142d617a44e5d9c7e22:1917c218a53722d4cc9389d6c293b8ad$
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
            -- mallet
            x=2,
            y=295,
            width=79,
            height=135,

            sourceX = 33,
            sourceY = 22,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- mallet01
            x=2,
            y=670,
            width=61,
            height=105,

            sourceX = 12,
            sourceY = 37,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- mallet02
            x=2,
            y=561,
            width=63,
            height=107,

            sourceX = 41,
            sourceY = 36,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- mallet03
            x=2,
            y=194,
            width=83,
            height=99,

            sourceX = 39,
            sourceY = 45,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- mallet04
            x=2,
            y=2,
            width=107,
            height=125,

            sourceX = 30,
            sourceY = 38,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- mallet05
            x=2,
            y=129,
            width=107,
            height=63,

            sourceX = 29,
            sourceY = 90,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- slingshot
            x=2,
            y=432,
            width=79,
            height=127,

            sourceX = 52,
            sourceY = 24,
            sourceWidth = 175,
            sourceHeight = 175
        },
    },
    
    sheetContentWidth = 111,
    sheetContentHeight = 777
}

SheetInfo.frameIndex =
{

    ["mallet"] = 1,
    ["mallet01"] = 2,
    ["mallet02"] = 3,
    ["mallet03"] = 4,
    ["mallet04"] = 5,
    ["mallet05"] = 6,
    ["slingshot"] = 7,
}


sequenceData =
{
    { name="Mallet", sheet=weaponSheet, frames={ 1, 2, 3, 4, 5, 6}, time=250, loopCount=1},
    { name="Slingshot", sheet=weaponSheet, frames={7}}
}

function SheetInfo:getSequenceData()
    return self.sequenceData;
end

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
