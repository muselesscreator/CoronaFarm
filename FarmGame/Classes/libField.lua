local storyboard = require 'storyboard'

Field = class(function(tmpField, type)
        print('--@Field init: type =')
        print(type)
        tmp = fields[type]
        for i, v in pairs(tmp) do
            tmpField[i] = v
        end
        print(tmpField.Pest)
        tmpField.turns = 0        

        tmpField.elements = {Blank = {}, Plant = {}, Pest = {}, Obstruction = {}}
        tmpField.total_squares = 0

        tmpField.layers = {}
        tmpField.birdLayer = {}

        tmpField.allElements = {}
        tmpField.lastElementID = 0

        bg = display.newImage(tmpField.bg)
        bg.anchorX = 0
        bg.anchorY = 0
        bg.x = 0
        bg.y = 0
        bg.h = tmpField.bg_h
        bg.w = tmpField.bg_w
        layers.field:insert(bg)

        local monster = display.newImage(tmpField.monster)
        monster.anchorX = 0
        monster.anchorY = 0
        monster.x = 75
        monster.y = -1000
        monster.h = tmpField.monster_h
        monster.w = tmpField.monster_w        
        monster.alpha = 0
        tmpField.monster_layer = monster
        layers.gameOver:insert(monster)


        local overlay = display.newImage('images/gameOverOverlay.png')
        overlay.anchorX = 0
        overlay.anchorY = 0
        overlay.x = 0
        overlay.y = 0
        overlay.h = tmpField.overlay_h
        overlay.w = tmpField.overlay_w 
        overlay.alpha = 0       
        tmpField.overlay = overlay
        layers.gameOver:insert(overlay)

        return tmpField
    end)

function Field:fill()
    for i=1, self.rows do
        self.layers[i] = display.newGroup()
        layers.field:insert(self.layers[i])
    end
    self.birdLayer = display.newGroup()
    layers.field:insert(self.birdLayer)

    for c=1,self.columns do
        for r=1,self.rows do
            local blocked = false
            for num, v in pairs(self.blocked) do
                if c == v[1] and r == v[2] then
                    blocked = true
                end
            end
            if not blocked then
                local tmp = Blank:new({i=c, j=r})
                self.total_squares = self.total_squares + 1
            end
        end
    end
end

function Field:cleanup()
    for i, v in ipairs(self.elements.Plant) do
        v:cleanup()
    end
end

function Field:pestGameOver()
    self.monster_layer.alpha = 1
    transition.to(self.monster_layer, {y=150, time=1500})
    timer.performWithDelay(2000, function() 
        transition.to(self.overlay, {alpha=1, time=500}) 
        timer.performWithDelay(1500, function() storyboard:gotoScene('title_screen') end, 1)
        end, 1)
end


function Field:boringGameOver()
    transition.to(self.overlay, {alpha=1, time=1000})
    timer.performWithDelay(1500, function() storyboard:gotoScene('title_screen') end, 1)
end

function Field:getDoomCounter()
    local num_flags
    for i, v in ipairs(theField.elements.Obstruction) do
        if v.elem_type == self.DoomObjType then
            num_flags = num_flags + 1
        end
    end
    return self.maxDoomCounter - num_flags
end

function Field:updateDoomCounter()
    local doomCounter = theField:getDoomCounter()
    local maxDoomCounter = theField.maxDoomCounter
    local fracDoomCount = (doomCounter/maxDoomCounter)
    if fracDoomCount <= .25 then
        doomHUD.setFillColor(1,1,1)
    elseif (fracDoomCount > .25 and fracDoomCount <= .5) then
        doomHUD.setFillColor(255,215,0)
    elseif (fracDoomCount > .5 and fracDoomCount <= .75)
        doomHUD.setFillColor(255,128,0)
    else
        doomHUD.setFillColor(220,20,60)
    end
    doomHUD.text = doomCounter
end

function Field:chkGameOver()
    print("--@Field:chkGameOver: checking for game over")
    local box = theBasket.box.contents
    local basket = theQueue[1].contents
 
    if self:getDoomCounter == 0 then
        gameOver = true
        self:pestGameOver()
        return true
    end

    if box.is_weapon or box.empty or basket.is_weapon or #self.elements.Blank > 0 then
        return true
    end
    for i, v in ipairs(self.elements.Plant) do
        if v.myStage == v.rot or v.myStage == v.mature then
            return true
        end
    end
    print('DOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOMMMMMMMMM!!!')
    print('Out of Turns!')
    gameOver = true
    self:boringGameOver()
    return true
end

function Field:nextDay()
    print('--@Field:nextDay')
    for i, v in ipairs(theField.elements.Plant) do
        theField.elements.Plant[i]:nextDay()
    end
    for i, v in ipairs(theField.elements.Obstruction) do
        v:nextDay()
    end
    for i, v in ipairs(theField.elements.Pest) do
        v:nextDay()
    end
    self:cleanup()
    self.turns = self.turns + 1
    self:spawnPests()
    self:chkGameOver()
    self:updateDoomCounter()
    self.touchesAllowed = true
end

function Field:spawnPests()
    Pest:spawn(self.Pest)
end


function Field:whatIsAt(i, j)
    local opts = {}
    for l, v in pairs(theField.elements) do
        for k, val in ipairs(v) do
            if val.i == i and val.j == j then
                opts[#opts+1] = val
            end
        end
    end
    return opts
end

function Field:pestAt(i, j)
    for k, v in ipairs(self.elements.Pest) do
        if v.i == i and v.j ==j then
            return v
        end
    end
    return false
end

function Field:plantAt(i, j)
    for k, v in ipairs(self.elements.Plant) do
        if v.i == i and v.j == j then
            return v
        end
    end
    return false
end

function Field:addElement(elem)
    print('-- @Field:addElement')
    local id = 'elem'..self.lastElementID+1
    self.lastElementID = self.lastElementID + 1
    self.allElements[id] = elem
    local type = elem.elem_type
    print(type)
    self.elements[elem.elem_type][#self.elements[elem.elem_type]+1] = elem
    elem.id = id
    elem.base_sprite.id = id

end

function Field:getElement(id)
    return self.allElements[id]
end