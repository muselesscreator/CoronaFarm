local widget = require('widget')
local scene = storyboard.newScene()

require 'farm_sound'

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

local function gotoLevel( event )
    storyboard.gotoScene('level_screen')
    return true
end

local function gotoTitle ( event )
   storyboard.gotoScene('title_screen')
   return true
end
-- Called when the scene's view does not exist:
function scene:createScene( event)
    gameOver = false
    touchesAllowed = false
    thePlayer:newLevel()
    local r = math.random(1, 100)
    if r < 5 then
        fn = 'sound/gopherSong.mp3'
    elseif fieldType == 'Tea' then
        fn = 'sound/ZenFarm.mp3'
    elseif fieldType == 'Stew' then
        fn = 'sound/DarkFarm.mp3'
    elseif fieldType == 'Salsa' then
        fn = 'sound/SalsaFarm.mp3'
    else
        fn = 'sound/FarmSong.mp3'
    end
    local backgroundMusic = audio.loadStream(fn)
    print("MUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUSIC VOLUME")
    print(musicVolume)
    backgroundMusicChannel = audio.play( backgroundMusic, { channel=1, loops=-1, fadein=100 } )
    audio.setVolume(musicVolume, {channel = backgroundMusicChannel})
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
        scrollHeight = fields[fieldType].bg_h,
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


    layers.frame = display.newGroup()
    layers.overlays = display.newGroup()
    layers.overFrame = display.newGroup()
    layers.birdLayer = display.newGroup()
    layers.weaponLayer = display.newGroup()
    layers.doom = display.newGroup()
    layers.popup = display.newGroup()
    layers.gameOver = display.newGroup()
    theField = Field(fieldType)

    theField:fill()

    layers.field:insert(layers.overlays)
    layers.field:insert(layers.birdLayer)
    layers.field:insert(layers.weaponLayer)
    layers.field:insert(layers.doom)

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



    local progressBarBG = display.newImage('images/uiProgressBar.png')
    progressBarBG.anchorX = 0
    progressBarBG.anchorY = 0
    progressBarBG.y = 60
    layers.overFrame:insert(progressBarBG)

    progressBar = display.newImage('images/uiProgressBarFull.png')
    progressBar.x = 0
    progressBar.y = 60
    progressBar.anchorX = 0
    progressBar.anchorY = 0
    layers.overFrame:insert(progressBar)

    progressMask = graphics.newMask('images/uiProgressBarMask.png')
    
    progressBar:setMask(progressMask)
    progressBar.maskX = -120


    local ScoreCard = display.newImage('images/scorecard.png')
    ScoreCard.x = 120
    ScoreCard.y = 80
    layers.overFrame:insert(ScoreCard)

    local doomBG = display.newImage('images/doomCounter.png')
    doomBG.x = 60
    doomBG.y = 345
    layers.overFrame:insert(doomBG)

    doomHUD = display.newText(0,theField.maxDoomCounter,0,native.systemFontBold, 35)
    doomHUD.x = 62
    doomHUD.y = 362
    doomHUD:setFillColor(0,.5,0)
    doomHUD.text = theField.maxDoomCounter
    layers.overFrame:insert(doomHUD)


--> Set Label
    scoreHUD = display.newText(0, 0, 0, CustomFont, 30)
    scoreHUD.anchorX = 0
    scoreHUD.anchorY = 0
    scoreHUD.x = 110
    scoreHUD.y = 67
    scoreHUD:setFillColor(0, 0, 0)
    layers.overFrame:insert(scoreHUD)
    --> Define Square and Queue Tables
    print('--@create: Create Field')


    local popupMenu = display.newImageRect( layers.popup, "images/popOutMenuBase.png", 534, 382)
    popupMenu.x = display.contentWidth/2
    popupMenu.y = display.contentHeight/2

    popupMenu.xScale = 1.2
    popupMenu.yScale = 1.2
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
    backButton.x = 380
    backButton.y = 360
    layers.popup:insert(backButton)

    local exitButton = widget.newButton
    {
        defaultFile = "images/buttonExitUp.png",
        overFile = "images/buttonExitDown.png",
        emboss = true,
        onRelease = gotoTitle
    }
    exitButton.x = 620
    exitButton.y = 360
    layers.popup:insert(exitButton)


    local txt = display.newText(layers.popup, 'Music Volume', 500, 440, native.systemFontBold, 25)
    txt:setFillColor(0, 0, 0)
    local mscSlider = VolSlider({x = 340, y=460, w=350, h=55, range=100, startX = musicVolume, event='setMusicVolume'})
    mscSlider.icon:addEventListener('setMusicVolume', setMusicVolume)
    
    txt = display.newText(layers.popup, 'Sound-Effects Volume', 500, 520, native.systemFontBold, 25)
    txt:setFillColor(0, 0, 0)
    local sfxSlider = VolSlider({x = 340, y=530, w=350, h=55, range=100, startX = sfxVolume, event='setSFXVolume'})
    sfxSlider.icon:addEventListener('setSFXVolume', setSFXVolume)

    layers.popup.alpha = 0


    theBasket = Basket()
    theQueue = libQueue(theField.initialWeights, 3)
    theQueue:fill()

    group:insert(layers.field)
    group:insert(layers.frame)
    group:insert(layers.overFrame)
    group:insert(layers.popup)
    group:insert(layers.gameOver)

    touchesAllowed = true
    --timer.performWithDelay(800, allowTouches, -1)
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
