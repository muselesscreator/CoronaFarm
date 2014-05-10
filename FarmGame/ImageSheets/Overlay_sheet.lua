--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:b18173fe18a4d780480d2b9bc995d0be:b7171525bbdcf1a97afd12f9a064bbc2:285be0f7c99882f226d5737d226e4378$
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
            -- smell01
            x=2,
            y=235,
            width=99,
            height=75,

            sourceX = 34,
            sourceY = 15,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- smell02
            x=2,
            y=2,
            width=105,
            height=75,

            sourceX = 32,
            sourceY = 15,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- smell03
            x=2,
            y=79,
            width=103,
            height=77,

            sourceX = 33,
            sourceY = 13,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- smell04
            x=2,
            y=158,
            width=101,
            height=75,

            sourceX = 34,
            sourceY = 14,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- tag
            x=2,
            y=312,
            width=51,
            height=135,

            sourceX = 114,
            sourceY = 10,
            sourceWidth = 175,
            sourceHeight = 175
        },
    },
    
    sheetContentWidth = 109,
    sheetContentHeight = 449
}

SheetInfo.frameIndex =
{

    ["smell01"] = 1,
    ["smell02"] = 2,
    ["smell03"] = 3,
    ["smell04"] = 4,
    ["tag"] = 5,
}

sequenceData =
{
    { name="Smell", sheet=overlaySheet, frames={ 1, 2, 3, 4 }, time=225},
    { name="Tag", sheet=overlaySheet, frames={ 5 }}
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getSequenceData()
    return self.sequenceData;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
