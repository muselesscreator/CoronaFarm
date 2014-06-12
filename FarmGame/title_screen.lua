local scene = storyboard.newScene()
local widget = require("widget")
local ads = require("ads")

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

local function playAd(self, event)
    if event.phase == 'ended' then
        toggleAdPopup()
        ads:setCurrentProvider( "vungle" )
        ads.show("interstitial", params)
    end
end

local function gotoFarm()
    if not layers.popup.visible and not layers.tutorial.visible and not layers.adPopup.visible then
        tmpField = ''
        for i, v in ipairs(fields.order) do
            if thePlayer.totalScore >= fields[v].minScore then
                print(thePlayer.totalScore)
                print(fields[v].minScore)
                tmpField = v
            else
                break
            end
        end
        fieldType = tmpField
        print(fieldType)
        storyboard.gotoScene('farm_screen')
        return true
    end
end

local function gotoLevel()
    if not layers.popup.visible and not layers.tutorial.visible and not layers.adPopup.visible then
        storyboard.gotoScene('level_screen')
        return true
    end
end

local function gotoSite()
    if not layers.popup.visible and not layers.tutorial.visible and not layers.adPopup.visible then
        system.openURL('http://www.nerdpilegames.com')
        return true
    end
end

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
    touchesAllowed = true

    gameOver = false
    print("title_screen")
    storyboard.returnTo='title_screen'
    group = self.view

    layers = display.newGroup()

    layers.bg = display.newGroup()
    layers.frame = display.newGroup()
    layers.popup = display.newGroup()
    layers.tutorial = display.newGroup()
    layers.adPopup = display.newGroup()

    bg = display.newImage('images/fieldBackground.png')
    bg.anchorX = 0
    bg.anchorY = 0
    layers.bg:insert(bg)

    local logo = display.newImage('images/farmLogo.png')
    logo.x = display.contentWidth/2
    logo.y = 280
    logo.xScale = 1.7
    logo.yScale = 1.7
    layers.bg:insert(logo)

    local gopher = display.newImage('images/gopherBig.png')
    gopher.x = display.contentWidth/2 - 12
    gopher.y = 470
    layers.bg:insert(gopher)

    giftButton = display.newSprite(magicWeaponSheet, sequenceData)

    giftButton.x = 100
    giftButton.y = 100
    if thePlayer.numCoins >= 5 then
        giftButton:setSequence('giftButtonDisabled')
    else
        giftButton:setSequence('giftButton')
        giftButton.touch = AdButton
        giftButton:addEventListener('touch', giftButton)
    end
    layers.frame:insert(giftButton)

    local FarmButton = widget.newButton
    {
        defaultFile = "images/playNow.png",
        overFile = "images/playNowDown.png",
        emboss = true,
        onRelease = gotoFarm,
    }
    FarmButton.x = display.contentWidth/2
    FarmButton.y = 520
    FarmButton.xScale = 1.1
    FarmButton.yScale = 1.1
    layers.frame:insert(FarmButton)

    

    local LevelButton = widget.newButton
    {
        defaultFile = "images/levelSelect.png",
        overFile = "images/levelSelectDown.png",
        emboss = true,
        onRelease = gotoLevel,
    }
    LevelButton.x = display.contentWidth/2
    LevelButton.y = 590
    LevelButton.xScale = 1.1
    LevelButton.yScale = 1.1
    layers.frame:insert(LevelButton)

    local LevelButton = widget.newButton
    {
        defaultFile = "images/siteButton.png",
        overFile = "images/siteButtonDown.png",
        font = native.systemFontBold,
        fontSize = 27,
        labelColor={ default={1, 1, 1, 1}, over={1, 1, 1, .5}},
        emboss = true,
        onRelease = gotoSite,
    }
    LevelButton.x = display.contentWidth * 0.5
    LevelButton.y = 660
    LevelButton.xScale = 1.1
    LevelButton.yScale = 1.1
    layers.frame:insert(LevelButton)



    scoreTxt = display.newText( 'Total Score', 195, 730, nil, 36)
    scoreTxt:setFillColor(0, 0, 0)
    layers.frame:insert(scoreTxt)
    local scorecard = display.newImage('images/scorebar.png')
    scorecard.x = 535
    scorecard.y = 730
    scorecard.yScale = .8
    layers.frame:insert(scorecard)
    scoreTxt = display.newText( thePlayer.totalScore, 320, 730, nil, 40)
    scoreTxt.anchorX = 0
    scoreTxt:setFillColor(0, 0, 1)
    layers.frame:insert(scoreTxt)


    ----------------------------------------------------------------------
    -- Popup menu
    ----------------------------------------------------------------------
    
    local optButton = widget.newButton
    {
        defaultFile = "images/popOutMenuButton.png",
        emboss = true,
        onRelease = toggleOptions
    }
    optButton.x = 930
    optButton.y = 710
    layers.frame:insert(optButton)

    local popupMenu = display.newImageRect( layers.popup, "images/popOutMenuBase.png", 534, 382)
    popupMenu.x = 250
    popupMenu.y = 200
    popupMenu.anchorX = 0
    popupMenu.anchorY = 0
    layers.popup.visible = false

    local exitButton = widget.newButton
    {
        defaultFile = "images/buttonEx.png",
        overFile = "images/buttonEx.png",
        emboss = true,
        onRelease = toggleOptions
    }
    exitButton.x = 730
    exitButton.y = 250
    exitButton.xScale = .7
    exitButton.yScale = .7
    layers.popup:insert(exitButton)

    local txt = display.newText(layers.popup, 'Music Volume', 510, 320, native.systemFontBold, 25)
    txt:setFillColor(0, 0, 0)
    local mscSlider = VolSlider({x = 340, y=330, w=350, h=55, range=100, startX = thePlayer.musicVolume, event='setMusicVolume'})
    mscSlider.icon:addEventListener('setMusicVolume', setMusicVolume)
    
    txt = display.newText(layers.popup, 'Sound-Effects Volume', 510, 400, native.systemFontBold, 25)
    txt:setFillColor(0, 0, 0)
    local sfxSlider = VolSlider({x = 340, y=410, w=350, h=55, range=100, startX = thePlayer.soundEffectsVolume, event='setSFXVolume'})
    sfxSlider.icon:addEventListener('setSFXVolume', setSFXVolume)

    txt = display.newText(layers.popup, 'Vibration Enabled', 450, 500, native.systemFontBold, 25)
    txt:setFillColor(0, 0, 0)
    local vibrateToggleBG = display.newImage('images/uiToggleBG.png')
    vibrateToggleBG.x = 620
    vibrateToggleBG.y = 500
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
    vibrateToggle.y = 500
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
    helpBtn.x = 830
    helpBtn.y = 710
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


    ---------------------------------------------------------------------------
    -- Advertising Popup
    ---------------------------------------------------------------------------
    layers.adPopup.visible = false
    layers.adPopup.alpha = 0

    local adPopupMenu = display.newImageRect( layers.adPopup, "images/videoConfirm.png", 534, 382)
    adPopupMenu.x = 250
    adPopupMenu.y = 200
    adPopupMenu.yScale = .75
    adPopupMenu.anchorX = 0
    adPopupMenu.anchorY = 0
    layers.adPopup.visible = false

    adPopupYes = display.newImage('images/uiButtonCheck.png')
    adPopupYes.yScale = .9
    adPopupYes.x = display.contentWidth/2 + 100
    adPopupYes.y = 412
    adPopupYes.touch = playAd
    adPopupYes:addEventListener('touch', adPopupYes)
    layers.adPopup:insert(adPopupYes)

    adPopupClose = display.newImage('images/uiButtonX.png')
    adPopupClose.yScale = .9
    adPopupClose.x = display.contentWidth/2 - 100
    adPopupClose.y = 412
    adPopupClose.touch = toggleAdPopup
    adPopupClose:addEventListener('touch', adPopupClose)
    layers.adPopup:insert(adPopupClose)


    group:insert(layers.bg)
    group:insert(layers.frame)
    group:insert(layers.popup)
    group:insert(layers.adPopup)
    group:insert(layers.tutorial)
    timer.performWithDelay(10, function() touchesAllowed = true end)



    --[[
    ------------------------------------------------------------------
    -- Debug images
    ------------------------------------------------------------------

    tmpImage = display.newImage('images/plus.png')
    tmpImage.x = 100
    tmpImage.y = 75
    tmpImage.xScale = .5
    tmpImage.yScale = .5
    tmpImage.alpha = .3
    layers.frame:insert(tmpImage)
    tmpImage.touch = promote_player
    tmpImage:addEventListener('touch', tmpImage)

    tmpImage = display.newImage('images/minus.png')
    tmpImage.x = 900
    tmpImage.y = 75
    tmpImage.xScale = .5
    tmpImage.yScale = .5
    tmpImage.alpha = .3
    layers.frame:insert(tmpImage)
    tmpImage.touch = clear_player
    tmpImage:addEventListener('touch', tmpImage)
    ]]--
end

function clear_player(self, event)
    thePlayer.id = 0
    thePlayer.levelScore = 0
    thePlayer.totalScore = 0
    thePlayer.highScores = {Salad = 0,Stew = 0,Salsa = 0,Tea = 0}
    thePlayer.has_played_level = {false, false, false, false}
    saveTable(thePlayer, 'player.json')
end

function promote_player(self, event)
    thePlayer.id = 0
    thePlayer.levelScore = 0
    thePlayer.totalScore = 36000
    thePlayer.highScores = {Salad = 0,Stew = 0,Salsa = 0,Tea = 0}
    thePlayer.has_played_level = {false, false, false, false}
    saveTable(thePlayer, 'player.json')
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
        local group = self.view

        -----------------------------------------------------------------------------

        --      INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)

        -----------------------------------------------------------------------------

end


-- Called AFTER scene has finished moving offscreen:
function scene:didExitScene( event )
        local group = self.view

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
