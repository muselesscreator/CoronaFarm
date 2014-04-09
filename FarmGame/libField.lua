require 'class'
require 'fields'
require 'fieldEvents'
local storyboard = require 'storyboard'

Field = class(function(tmpField, type)
        print('--@Field init: type =')
        print(type)
        tmp = fields[type]
        for i, v in pairs(tmp) do
            tmpField[i] = v
        end
        tmpField.turns = 0
        tmpField.pests = {}
        for i, v in pairs(tmpField.allowedPests) do
            tmpField.pests[v] = {}
        end
        tmpField.grid = {}
        bg = display.newImage(tmpField.bg)
        bg.anchorX = 0
        bg.anchorY = 0
        bg.x = 0
        bg.y = 0
        bg.h = tmpField.bg_h
        bg.w = tmpField.bg_w
        layers.field:insert(bg)
        return tmpField
    end)

function Field:fill()
    for i=1,self.columns do
        self.grid[i] = {}
        for j=1,self.rows do
            self.grid[i][j]={}
            x = self.X + (i-1)*((self.W/self.columns))
            y = self.Y + (j-1)*((self.H/self.rows))
            local tmp = FarmElement(x, y, i, j)
            self.grid[i][j] = tmp
        end
    end
    self.first = self.grid[1][1]
    square = self.first
    while square do
        square:initialize()
        square = square.next
    end
end

function Field:cleanup()
    print('--Field:cleanup()')
    square = self.first
    while square do
        tmp = square.sprite
        tmp.checked = false
        if tmp.isBarren then
            tmp:setSequence('seqBarren')
            tmp.alpha = 1
        elseif tmp.empty == true then
            tmp:setSequence('seqBlank')
        end
        square = square.next
    end
    while square do
        tmp = square.sprite
        if not tmp.empty and not tmp.isBarren then
            if tmp.isPlant then
                if tmp.myStage==0 then
                    tmp:setSequence('seqSeeds')
                else
                    tmp:setSequence('seq'..tmp.myType)
                    tmp:setFrame(tmp.myStage)
                end
            else
                --print(mytype)
                tmp:setSequence('seq'..tmp.myType)
            end
        end
        square = square.next
    end
end

function Field:chkGameOver()
    print("--@Field:chkGameOver: checking for game over")
    if theBasket.box.type == 'Mallet' or theBasket.box.type == 'Slingshot'  or theBasket.box.empty == true then
        --print("Not Game Over: Basket is empty or Weapon is in basket")
        return false
    end
    if theQueue[1].square_type == 'Mallet' or theQueue[1].square_type == 'Slingshot' then
        --print("Not Game Over: Weapon in queue")
        return false
    end
    square = self.first
    while square do
        tmp = square.sprite
        if tmp.myType == 'blank' or (tmp.isPlant == true and (tmp.myStage == 4 or tmp.myStage == 3))  then
            --print("Not Game Over: blank/mature/rotten @: "..tmp.id)
            return false
        end
        square = square.next
    end
    return true
end

function Field:nextDay()

    print('--@nextDay: Next Day Function')
    --print("--@nextDay: clicked ID: "..clickedID)
    if clickAction=='harvest' then
        --print("--@nextDay: harvest(in nextDay)")
        plantXP = getSquare(clickedID).sprite.xp
        getSquare(clickedID).sprite:checkNeighbors()
        --print("Adding Points: XP Value "..plantXP.." * # Harvested: "..getPlantsHarvested().." || Total Score = "..(plantXP * getPlantsHarvested() * getPlantsHarvested()))
        thePlayer:addScore(plantXP * getPlantsHarvested() * getPlantsHarvested())
        setPlantsHarvested(0)
        clickAction=""
    end
    if clickAction=='clear' then
        --print("--@nextDay: Pruning")
        getSquare(clickedID):makeBarren()
        clickAction=""
    end
    print('--@nextDay: updating unclicked plots')
    self:movePests()
    square = self.first
    while square do
        local sprite = square.sprite
        --if this is not the clicked on sprite, and
        --  it either full or barren
        if sprite.id~=clickedID and (not sprite.empty or sprite.isBarren) then
            if sprite.isPlant or sprite.isBarren then
                sprite.myProgress = sprite.myProgress + 1
                print("--@Field:nextDay: progress "..sprite.myProgress.." at "..sprite.id)
                if sprite.myProgress > sprite.toNext then
                    if sprite.isBarren then
                        square:clearImage()
                    elseif sprite.myStage < Plants.rot then
                        sprite:grow()
                    end
                end
            end
        end
        square = square.next
    end
    self:cleanup()
    self.turns = self.turns + 1
    self:spawnPests()
end

function Field:spawnPests()
    print('--@Field:spawnPests')
    for i, v in pairs(self.allowedPests) do
        if Pests[v].myType == 'air' then
            local num = Pests.does_spawn(v)
            if num > 0 then
                for i=1, num do
                    local new_pest = Pest(v)
                    new_pest:spawn()
                    self.pests[v][#self.pests[v]+1] = new_pest
                end
            end
        else
            if Pests.does_spawn(v) == true then
                local new_pest = Pest(v)
                new_pest:spawn()
                self.pests[v][#self.pests[v]+1] = new_pest
            end
        end
    end
    self:cleanup()
end

function Field:movePests()
    print('--@Field:movePests')
    for i, v in pairs(self.allowedPests) do
        for j, pest in pairs(self.pests[v]) do
            print('--@Field:movePests: Pest on square '..pest.square.id..' moves')
            pest:next_day()
        end
    end
    self:clearPests()
end

function Field:clearPests()
    print('--@Field:clearPests')
    for i, v in pairs(self.allowedPests) do
        for j=1, #self.pests[v] do
            while true do
                if j > #self.pests[v] then
                    break
                elseif self.pests[v][j].dead then
                    table.remove(self.pests[v], j)
                else
                    break
                end
            end
        end
    end
    self:cleanup()
    if self:chkGameOver() == true then
        print("--@Field:nextDay:  Game Over Man")
        storyboard.gotoScene( "title_screen", "fade", 400 )
    end

end

function Field:numPestsOfType(type)
    tmp = 0
    for i, v in pairs(self.allowedPests) do
        if Pests[v].type == type then
            tmp = tmp + #self.pests[v]
        end
    end
    return tmp
end