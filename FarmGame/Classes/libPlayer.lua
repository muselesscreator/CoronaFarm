local json = require('json')
math.randomseed(os.time())

-----------------------------------------
--Player Class and Score Function
-----------------------------------------


function saveTable(t, filename)
    local path = system.pathForFile(filename, system.DocumentsDirectory)
    local file = io.open(path, 'w')
    if file then
        local contents = json.encode(t)
        file:write( contents )
        io.close( file )
        return true
    else
        return false
    end
end

function loadTable(filename)
    local path = system.pathForFile( filename, system.DocumentsDirectory)
    local contents = ""
    local myTable = {}
    local file = io.open( path, "r" )
    if file then
        local contents = file:read( "*a" )
        myTable = json.decode(contents);
        io.close( file )
        return myTable
    end
    return nil
end


Player = class(function(player)
        tmp_player = loadTable('player.json')
        if tmp_player ~= nil then
            for i, v in pairs(tmp_player) do
                player[i] = v
            end
            if player.numCoins == nil then
                player.numCoins = 0
            end
            if player.tips == nil then
                player:genTipList()
                player.tipIndex = 1
            end
            if player.musicVolume == nil then
                player.musicVolume = .5
                player.soundEffectsVolume = .5
                player.vibrateEnabled = true
            end
            print("returning player")
            return player
        end
        player.id = 0
        player.levelScore = 0
        player.totalScore = 0
        player.numCoins = 0
        player.highScores = {Salad = 0,Stew = 0,Salsa = 0,Tea = 0}
        player.has_played_level = {false, false, false, false}
        player.has_unlocked_level = {false, false, false, false}
        player.musicVolume = .5
        player.soundEffectsVolume = .5
        player.vibrateEnabled = true
        player:genTipList()
        player.tipIndex = 1
        return player
    end)

function Player:addScore(inc)
    self.levelScore = self.levelScore + inc
    self.totalScore = self.totalScore + inc
    local maskX = ((self.levelScore / theField.goalScore) * 240) - 120
    progressBar.maskX = maskX
    scoreHUD.text = self.levelScore
    print("score = "..self.levelScore)
    print("totalScore = "..self.totalScore)
    if self.levelScore > self.highScores[fieldType] then
        self.highScores[fieldType] = self.levelScore
    end
    saveTable(self, 'player.json')

    if self.levelScore >= theField.goalScore and not gameOver and not goodGameOverHappened then
        theField:goodGameOver()
    end
end

function Player:useCoin()
    self.numCoins = self.numCoins - 1
    weaponToggled = false
    wpnBtn:setSequence('magicWeaponIdle')
    wpnCount.text = 'x'..self.numCoins
    saveTable(self, 'player.json')
end

function Player:addCoin()
    self.numCoins = self.numCoins + 1
    if self.numCoins >= 5 then
        disableGiftButton()
    end
    saveTable(self, 'player.json')
end

function Player:genTipList()
    self.tips = {}
    for i=1, 16, 1 do
        if i < 10 then
            self.tips[i] = 'images/tip0'..i..'.png'
        else
            self.tips[i] = 'images/tip'..i..'.png'
        end
    end
    for i=16, 2, -1 do
        local j = math.random(1, i)
        self.tips[i], self.tips[j] = self.tips[j], self.tips[i]
    end
end

function Player:hasCoins()
    if self.numCoins > 0 then
        return true
    else
        return false
    end
end

function Player:newLevel()
    self.levelScore = 0
end

function Player:nextTip()
    local tip = self.tips[self.tipIndex]
    if self.tipIndex < 16 then
        self.tipIndex = self.tipIndex + 1
    else
        self.tipIndex = 1
        self:genTipList()
    end
    saveTable(self, 'player.json')
    return tip
end