local storyboard = require( "storyboard" )
local widget = require('widget')
local scene = storyboard.newScene()
storyboard.purgeOnSceneChange = true

----------------------------------------------------------------------------------
--
--      NOTE:
--
--      Code outside of listener functions (below) will only be executed once,
--      unless storyboard.removeScene() is called.
--
---------------------------------------------------------------------------------


-- local forward references should go here --


---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

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
-- Called when the scene's view does not exist:
function scene:createScene( event)
    touchesAllowed = false
    thePlayer:newLevel()
    local r = math.random(1, 100)
    if r < 5 then
        fn = 'sound/gopherSong.wav'
    elseif fieldType=='Tea' then
        fn = 'sound/ZenFarm.wav'
    elseif fieldType=='Stew' then
        fn = 'sound/DarkFarm.wav'
    else
        fn = 'sound/FarmSong.wav'
    end
    local backgroundMusic = audio.loadStream(fn)
    backgroundMusicChannel = audio.play( backgroundMusic, { channel=1, loops=-1, fadein=100 } )
    print('farm_screen')
    local group = self.view

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
                log( "Reached Top Limit", 'Info' )
            elseif "down" == direction then
                log( "Reached Bottom Limit", 'Info' )
            elseif "left" == direction then
                log( "Reached Left Limit", 'Info' )
            elseif "right" == direction then
                log( "Reached Right Limit", 'Info' )
            end
        end

        return true
    end

    local function tapOverlay( event )
            return true
    end

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

    layers.frame = display.newGroup()
    layers.overlays = display.newGroup()
    layers.overFrame = display.newGroup()
    layers.birdLayer = display.newGroup()
    layers.weaponLayer = display.newGroup()
    layers.popup = display.newGroup()
    theField = Field(fieldType)

    theField:fill()

    layers.field:insert(layers.overlays)
    layers.field:insert(layers.birdLayer)
    layers.field:insert(layers.weaponLayer)

    clickBlock = display.newRect(0, 45, 269, 680)
    clickBlock.tap = tapOverlay
    clickBlock:addEventListener("tap", clickBlock)
    clickBlock.anchorX = 0
    clickBlock.anchorY = 0
    layers.frame:insert(clickBlock)

    frame_img = display.newImage('images/overlay.png')
    frame_img.anchorX = 0
    frame_img.anchorY = 0
    --frame_img.tap = tapOverlay
    --frame_img:addEventListener("tap", frame_img)
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
    scoreHUD = display.newText(0, 0, 0, CustomFont, 42)
    scoreHUD.anchorX = 0
    scoreHUD.anchorY = 0
    scoreHUD.x = 140
    scoreHUD.y = 60
    scoreHUD:setFillColor(0, 0, 0)
    layers.overFrame:insert(scoreHUD)
    --> Define Square and Queue Tables
    print('--@create: Create Field')


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


    theQueue = libQueue(theField.initialWeights, 3)
    theQueue:fill()
    theBasket = Basket()

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

-- Called BEFORE scene has moved onscreen:
function scene:willEnterScene( event )
        local group = self.view

        -----------------------------------------------------------------------------

        --      This event requires build 2012.782 or later.

        -----------------------------------------------------------------------------

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
        local group = self.view

        -----------------------------------------------------------------------------

        --      INSERT code here (e.g. start timers, load audio, start listeners, etc.)

        -----------------------------------------------------------------------------

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
        audio.stop(backgroundMusicChannel)
        local group = self.view
        -----------------------------------------------------------------------------

        --      INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)

        -----------------------------------------------------------------------------

end


-- Called AFTER scene has finished moving offscreen:
function scene:didExitScene( event )
        local group = self.view
        storyboard.purgeScene('farm_screen')

        -----------------------------------------------------------------------------

        --      This event requires build 2012.782 or later.

        -----------------------------------------------------------------------------

end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
        local group = self.view

        -----------------------------------------------------------------------------

        --      INSERT code here (e.g. remove listeners, widgets, save state, etc.)

        -----------------------------------------------------------------------------

end


-- Called if/when overlay scene is displayed via storyboard.showOverlay()
function scene:overlayBegan( event )
        local group = self.view
        local overlay_name = event.sceneName  -- name of the overlay scene

        -----------------------------------------------------------------------------

        --      This event requires build 2012.797 or later.

        -----------------------------------------------------------------------------

end


-- Called if/when overlay scene is hidden/removed via storyboard.hideOverlay()
function scene:overlayEnded( event )
        local group = self.view
        local overlay_name = event.sceneName  -- name of the overlay scene

        -----------------------------------------------------------------------------

        --      This event requires build 2012.797 or later.

        -----------------------------------------------------------------------------

end



---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "willEnterScene" event is dispatched before scene transition begins
scene:addEventListener( "willEnterScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "didExitScene" event is dispatched after scene has finished transitioning out
scene:addEventListener( "didExitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-- "overlayBegan" event is dispatched when an overlay scene is shown
scene:addEventListener( "overlayBegan", scene )

-- "overlayEnded" event is dispatched when an overlay scene is hidden/removed
scene:addEventListener( "overlayEnded", scene )

---------------------------------------------------------------------------------

return scene
