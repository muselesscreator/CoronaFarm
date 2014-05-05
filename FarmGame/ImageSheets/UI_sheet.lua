--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:20542cf4b126b1af5bdca54637b1d5e7:0ebcd132424ded10abb7c9fdb7c7a3d9:ae09f11341d98652c26b3e5918eb2e68$
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
            -- tutorialHand
            x=292,
            y=59,
            width=99,
            height=55,

        },
        {
            -- tutorialHandBack
            x=292,
            y=2,
            width=100,
            height=55,

        },
    },
    
    sheetContentWidth = 394,
    sheetContentHeight = 149
}

SheetInfo.frameIndex =
{

    ["boxClosed"] = 1,
    ["boxOpen"] = 2,
    ["tutorialHand"] = 3,
    ["tutorialHandBack"] = 4,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
