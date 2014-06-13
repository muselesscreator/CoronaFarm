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

local function gotoLevel( self, event )
    storyboard.gotoScene('level_screen')
    return true
end

local function gotoTitle ( self, event )
   storyboard.gotoScene('title_screen')
   return true
end

function toggleWeapon( self, event )

    if event.phase == 'began' then
        if weaponToggled == false then
            weaponToggled = true
            wpnBtn:setSequence('magicWeapon'..theField.weapon)
        else
            weaponToggled = false
            wpnBtn:setSequence('magicWeaponIdle')
        end
    end
end

function clearTip()
    tipBox:removeSelf()
    tipWrapper:removeSelf()
    return true
end 

-- Called when the scene's view does not exist:
function scene:createScene( event)
    gameOver = false
    goodGameOverHappened = false
    touchesAllowed = true
    weaponToggled = false
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
    audio.stop(1)
    fieldMusic = audio.loadStream(fn)
    audio.setVolume(thePlayer.musicVolume, {channel = 1})
    backgroundMusicChannel = audio.play( fieldMusic, { channel=1, loops=-1, fadein=100 } )

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
    layers.tutorial = display.newGroup()
    layers.adPopup = display.newGroup()
    layers.gameOver = display.newGroup()
    layers.tips = display.newGroup()
    layers.loading = display.newGroup()
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


    ------------------------------------------------
    -- Score HUD
    -------------------------------------------------

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

--> Set Label
    scoreHUD = display.newText(0, 0, 0, CustomFont, 30)
    scoreHUD.anchorX = 0
    scoreHUD.x = 110
    scoreHUD.y = 86
    scoreHUD:setFillColor(0, 0, 0)
    layers.overFrame:insert(scoreHUD)


    -----------------------------------------
    -- Doom HUD
    -----------------------------------------

    local doomBG = display.newImage('images/doomCounter.png')
    doomBG.x = 55
    doomBG.y = 475
    layers.overFrame:insert(doomBG)

    doomHUD = display.newText(0,theField.maxDoomCounter,0,native.systemFontBold, 35)
    doomHUD.x = 57
    doomHUD.y = 492
    doomHUD:setFillColor(0,.5,0)
    doomHUD.text = theField.maxDoomCounter
    layers.overFrame:insert(doomHUD)


    -----------------------------------------
    -- Magic Weapon Button
    -----------------------------------------
    wpnBtn = display.newSprite(magicWeaponSheet, sequenceData)
    wpnBtn:setSequence('magicWeaponIdle')
    wpnBtn.x = 60
    wpnBtn.y = 625
    wpnBtn.touch = toggleWeapon
    wpnBtn:addEventListener('touch', wpnBtn)
    layers.frame:insert(wpnBtn)

    wpnCount = display.newText(layers.frame, 'x'..thePlayer.numCoins, 30, 590, native.systemFontBold, 25)
    wpnCount:rotate(330)
    wpnCount:setFillColor(1,1, .5)
    ----------------------------------------------------------
    -- Popup Menu
    ---------------------------------------------------------

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
    tmpButton.y = 190
    layers.frame:insert(tmpButton)


    local backButton = widget.newButton{
        defaultFile = "images/buttonResumeUp.png",
        overFile = "images/buttonResumeDown.png",
        emboss = true,
        onRelease = toggleOptions
    }
    backButton.x = 390
    backButton.y = 300
    layers.popup:insert(backButton)

    local exitButton = widget.newButton
    {
        defaultFile = "images/buttonExitUp.png",
        overFile = "images/buttonExitDown.png",
        emboss = true,
        onRelease = gotoTitle
    }
    exitButton.x = 615
    exitButton.y = 300
    layers.popup:insert(exitButton)

    local txt = display.newText(layers.popup, 'Music Volume', 510, 360, native.systemFontBold, 25)
    txt:setFillColor(0, 0, 0)
    local mscSlider = VolSlider({x = 340, y=370, w=350, h=55, range=100, startX = thePlayer.musicVolume, event='setMusicVolume'})
    mscSlider.icon:addEventListener('setMusicVolume', setMusicVolume)
    
    txt = display.newText(layers.popup, 'Sound-Effects Volume', 510, 440, native.systemFontBold, 25)
    txt:setFillColor(0, 0, 0)
    local sfxSlider = VolSlider({x = 340, y=450, w=350, h=55, range=100, startX = thePlayer.soundEffectsVolume, event='setSFXVolume'})
    sfxSlider.icon:addEventListener('setSFXVolume', setSFXVolume)

    txt = display.newText(layers.popup, 'Vibration Enabled', 450, 540, native.systemFontBold, 25)
    txt:setFillColor(0, 0, 0)
    local vibrateToggleBG = display.newImage('images/uiToggleBG.png')
    vibrateToggleBG.x = 620
    vibrateToggleBG.y = 540
    layers.popup:insert(vibrateToggleBG)

    local vibrateToggle = display.newImage('images/uiToggleThing.png')
    local function toggleVibrate(self, event)
        if event.phase == 'began' then
            if thePlayer.vibrateEnabled then
                print('no')
                thePlayer.vibrateEnabled = false
                transition.to(vibrateToggle, {x=595, time=400})
            else
                print('yes')
                thePlayer.vibrateEnabled = true
                transition.to(vibrateToggle, {x=645, time=400})
            end
            saveTable(thePlayer, 'player.json')
        end
    end

    if thePlayer.vibrateEnabled then
        vibrateToggle.x = 645
    else
        vibrateToggle.x = 595
    end
    vibrateToggle.y = 540
    layers.popup:insert(vibrateToggle)
    vibrateToggleBG.touch = toggleVibrate
    vibrateToggleBG:addEventListener('touch', toggleVibrateBG)

    layers.popup.alpha = 0

    ---------------------------------------------------------------------------
    -- Tutorial
    ---------------------------------------------------------------------------

    layers.tutorial.visible = false
    layers.tutorial.alpha = 0
    layers.tutorial.frame = 1

    local helpBtn = widget.newButton
    {
        defaultFile = "images/questionMenuButton.png",
        emboss = true,
        onRelease = toggleTutorial
    }
    helpBtn.x = 60
    helpBtn.y = 290
    layers.frame:insert(helpBtn)

    tutorialPanel = display.newSprite(uiSheet, sequenceData)
    tutorialPanel:setSequence('help')
    tutorialPanel:setFrame(1)
    tutorialPanel.x = display.contentWidth/2
    tutorialPanel.y = display.contentHeight/2
    layers.tutorial:insert(tutorialPanel)

    tutorialBackBtn = display.newImage('images/uiArrow.png')
    tutorialBackBtn.xScale = -1.2
    tutorialBackBtn.yScale = 1.2
    tutorialBackBtn.x = 250
    tutorialBackBtn.y = 590
    tutorialBackBtn.alpha = 0
    tutorialBackBtn.touch = tutorialBack
    tutorialBackBtn:addEventListener('touch', tutorialBackBtn)
    layers.tutorial:insert(tutorialBackBtn)

    tutorialNextBtn = display.newImage('images/uiArrow.png')
    tutorialNextBtn.xScale = 1.2
    tutorialNextBtn.yScale = 1.2 
    tutorialNextBtn.x = 780
    tutorialNextBtn.y = 590
    tutorialNextBtn.touch = tutorialNext
    tutorialNextBtn:addEventListener('touch', tutorialNextBtn)
    layers.tutorial:insert(tutorialNextBtn)

    tutorialClose = widget.newButton{
        defaultFile = "images/uiButtonX.png",
        overFile = "images/uiButtonX.png",
        emboss = true,
        onRelease = toggleTutorial
    }
    tutorialClose.x = 830
    tutorialClose.y = 150
    tutorialClose.xScale = .7
    tutorialClose.yScale = .7
    layers.tutorial:insert(tutorialClose)


    ---------------------------------------------------------------
    -- Tips Panel
    ---------------------------------------------------------------
    local tip = thePlayer:nextTip()
    print(tip)
    tipBox = display.newImage(tip)
    tipBox.x = display.contentWidth/2
    tipBox.y = display.contentHeight/2
    layers.tips:insert(tipBox)

    tipWrapper = display.newRect(0,0,display.contentWidth, display.contentHeight)
    tipWrapper.anchorX = 0
    tipWrapper.anchorY = 0
    tipWrapper.alpha = 0
    tipWrapper.isHitTestable = true
    tipWrapper.tap = clearTip
    tipWrapper:addEventListener('tap', clearTip)
    layers.tips:insert(tipWrapper)

    theBasket = Basket()
    theQueue = libQueue(theField.initialWeights, 3)
    theQueue:fill()


    local backdrop = display.newImage('Default-Landscape.png')
    backdrop.anchorX = 0
    backdrop.anchorY = 0
    local backdropTouch = function()
        return true
    end
    backdrop.tap = backdropTouch
    backdrop:addEventListener('tap', backdrop)
    layers.loading:insert(backdrop)
    local emptyLoading = display.newImage('images/uiProgressBar.png')
    emptyLoading.x = display.contentWidth/2
    emptyLoading.xScale = 3
    emptyLoading.y = 650
    layers.loading:insert(emptyLoading)
    local fullLoading = display.newImage('images/uiProgressBarFull.png')
    fullLoading.x = display.contentWidth/2
    fullLoading.xScale = 3
    fullLoading.y = 650
    local loadingMask = graphics.newMask('images/uiProgressBarMask.png')
    fullLoading:setMask(loadingMask)
    layers.loading:insert(fullLoading)
    local width = 480
    fullLoading.maskX = -(width/2)
    transition.to(fullLoading, {maskX = width/2, time=5000})
    timer.performWithDelay(7500, function()
            backdrop:removeSelf()
            backdrop = nil
            emptyLoading:removeSelf()
            emptyLoading = nil
            fullLoading:removeSelf()
            fullLoading = nil
            loadingMask = nil
        end, 1)



    group:insert(layers.field)
    group:insert(layers.frame)
    group:insert(layers.overFrame)
    group:insert(layers.popup)
    group:insert(layers.tutorial)
    group:insert(layers.gameOver)
    group:insert(layers.tips)
    group:insert(layers.loading)
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
