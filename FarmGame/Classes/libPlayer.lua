local json = require('json')

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
            print("returning player")
            player.totalScore = 2500
            player.highScores = {Salad = 0,Stew = 0,Salsa = 0,Tea = 0}

            return player
        end
        player.id = 0
        player.levelScore = 0
        player.totalScore = 0
        player.highScores = {Salad = 0,Stew = 0,Salsa = 0,Tea = 0}
        player.has_played_level = {false, false, false, false}
        player.has_unlocked_level = {false, false, false, false}
        return player
    end)

function Player:addScore(inc)
    self.levelScore = self.levelScore + inc
    self.totalScore = self.totalScore + inc
    scoreHUD.text = self.levelScore
    print("score = "..self.levelScore)
    print("totalScore = "..self.totalScore)
    if self.levelScore > self.highScores[fieldType] then
        self.highScores[fieldType] = self.levelScore
    end
    saveTable(self, 'player.json')
end

function Player:newLevel()
    self.levelScore = 0
end