local storyboard = require 'storyboard'
local widget = require("widget")

local function gotoLevel()
    storyboard.gotoScene('level_screen')
end
local function gotoTitle ( event )
   storyboard.gotoScene('title_screen')
   return true
end
local function volumeListener ( event )
    audio.setVolume(event.value/100, backgroundMusicChannel)
end
local function allowTouches(event)
    touchesAllowed=true
    print('You may now touch this!')
end

function fieldInit(group, fieldType, tutorial)
    tutorial = tutorial or false
    touchesAllowed = false
    if not tutorial then
        thePlayer:newLevel()
    end

    --local backgroundMusic = audio.loadStream('sound/farm_song.wav')
    --backgroundMusicChannel = audio.play( backgroundMusic, { channel=1, loops=-1, fadein=100 } )
    print('farm_screen')
    layers = display.newGroup()
    local function scrollListener( event )
        local phase = event.phase
        local direction = event.direction

        if "began" == phase then
            --print( "Began" )
        elseif "moved" == phase then
            --print( "Moved" )
        elseif "ended" == phase then
            --print( "Ended" )
        end

        -- If the scrollView has reached it's scroll limit
        if event.limitReached then
            if "up" == direction then
                print( "Reached Top Limit" )
            elseif "down" == direction then
                print( "Reached Bottom Limit" )
            elseif "left" == direction then
                print( "Reached Left Limit" )
            elseif "right" == direction then
                print( "Reached Right Limit" )
            end
        end

        return true
    end
    if not tutorial then
        layers.field = widget.newScrollView
        {
            left = 0,
            top = 0,
            width = display.contentWidth,
            height = display.contentHeight,
            scrollWidth = fields[fieldType].bg_w,
            scrollHeight = fields[fieldType].bg_h-150,
            bottomPadding = -155,
            isBounceEnabled = false,
            anchorX = 0,
            anchorY = 0,
            hideBackground = true,
            id = "onBottom",
            horizontalScrollDisabled = false,
            verticalScrollDisabled = false,
            listener = scrollListener,
        }
    else
        layers.field = widget.newScrollView
        {
            left = 0,
            top = 0,
            width = display.contentWidth,
            height = display.contentHeight,
            scrollWidth = fields[fieldType].bg_w,
            scrollHeight = fields[fieldType].bg_h-150,
            bottomPadding = 0,
            isBounceEnabled = false,
            anchorX = 0,
            anchorY = 0,
            hideBackground = true,
            id = "onBottom",
            horizontalScrollDisabled = false,
            verticalScrollDisabled = false,
            listener = scrollListener,
        }
    end

    layers.frame = display.newGroup()
    layers.overlays = display.newGroup()
    layers.overFrame = display.newGroup()
    layers.birdLayer = display.newGroup()
    layers.weaponLayer = display.newGroup()
    layers.popup = display.newGroup()
    if not tutorial then
        theField = Field(fieldType)
        theField:fill()
    else
        layers.tutorial = display.newGroup()
        theField = {}
        for i, v in pairs(fields[fieldType]) do
            theField[i] = v
        end
        local grid = {}
        for i=1,theField.columns do
            grid[i] = {}
            for j=1,theField.rows do
                grid[i][j] = {}
                grid[i][j].x = theField.X + (i-1) * (theField.W / theField.columns)
                grid[i][j].y = theField.Y + (j-1) * (theField.H / theField.rows)
            end
        end
        theField.grid = grid
        bg = display.newImage(theField.bg)
        bg.anchorX = 0
        bg.anchorY = 0
        bg.x = 0
        bg.y = 0
        bg.h = theField.bg_h
        bg.w = theField.bg_w
        layers.field:insert(bg)
    end
    layers.field:insert(layers.overlays)
    layers.field:insert(layers.birdLayer)
    layers.field:insert(layers.weaponLayer)

    frame_img = display.newImage('images/overlay.png')
    frame_img.anchorX = 0
    frame_img.anchorY = 0
    layers.frame:insert(frame_img)

    local Chute = display.newImage('images/chute.png')
    Chute.x = 180
    Chute.y = 185
    layers.frame:insert(Chute)

    local basketImg = display.newImage('images/basketBack.png')
    basketImg.x = 180
    basketImg.y = 500
    layers.frame:insert(basketImg)

    local ScoreCard = display.newImage('images/scorecard.png')
    ScoreCard.x = 125
    ScoreCard.y = 85
    layers.overFrame:insert(ScoreCard)

--> Set Label
    scoreHUD = display.newText(0, 0, 0, gameFont, 42)
    scoreHUD.anchorX = 0
    scoreHUD.anchorY = 0
    scoreHUD.x = 140
    scoreHUD.y = 60
    scoreHUD:setFillColor(0, 0, 0)
    layers.overFrame:insert(scoreHUD)
    --> Define Square and Queue Tables
    print('--@create: Create Field')

    
    theQueue = libQueue(theField.initialWeights, 3)
    theQueue:fill()
    for i, v in ipairs(theQueue) do
        print(i)
        print(v.square_type)
    end
    if tutorial then
        for i, q in ipairs(tutorials[fieldType].initial_queue) do
            print(i)
            print(q)
            print(theQueue[i])
            theQueue[i].sprite:setSequence('seq'..q)
            theQueue[i].square_type = q
        end
    end
    theBasket = Basket()

    setupOptionsMenu()

    group:insert(layers.field)
    group:insert(layers.frame)
    group:insert(layers.overFrame)
    group:insert(layers.popup)

    touchesAllowed = true
    --timer.performWithDelay(800, allowTouches, -1)
end

onDrawerButton = function ( event )
    if(layers.theDrawer.isOpen) then
        transition.to( layers.theDrawer, {x =  layers.theDrawer.x - 110 + 20, time = 200} )
        layers.theDrawer.isOpen = false
    else
        transition.to( layers.theDrawer, {x =  layers.theDrawer.x + 110 - 20, time = 200} )
        layers.theDrawer.isOpen = true
    end
    return true
end

toggleOptions = function ( event )
    if(layers.popup.visible) then
        layers.popup.alpha = 0
        layers.popup.visible = false
    else
        layers.popup.alpha = 1
        layers.popup.visible = true
    end
end

function setupOptionsMenu()
    local popupMenu = display.newImageRect( layers.popup, "images/popOutMenuBase.png", 534, 382)
    popupMenu.x = 100
    popupMenu.y = 100
    layers.popup.visible = false
    local tmpButton = widget.newButton
    {
        defaultFile = "images/popOutMenuButton.png",
        emboss = true,
        onRelease = toggleOptions
    }
    tmpButton.x = 60
    tmpButton.y = 200
    layers.frame:insert(tmpButton)

    local backButton = widget.newButton{
        defaultFile = "images/buttonResumeUp.png",
        overFile = "images/buttonResumeDown.png",
        emboss = true,
        onRelease = toggleOptions
    }
    backButton.x = -20
    backButton.y = 110
    layers.popup:insert(backButton)

    local exitButton = widget.newButton
    {
        defaultFile = "images/buttonExitUp.png",
        overFile = "images/buttonExitDown.png",
        emboss = true,
        onRelease = gotoTitle
    }
    exitButton.x = 230
    exitButton.y = 110
    layers.popup:insert(exitButton)

    local volumeSlider = widget.newSlider
    {
        top = 180,
        left = -90,
        width = 350,
        value = 50,  -- Start slider at 10% (optional)
        listener = volumeListener
    }
    layers.popup:insert(volumeSlider)
    layers.popup.x = 400
    layers.popup.y = 300
    layers.popup.alpha = 0
end