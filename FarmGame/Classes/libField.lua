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

function Field:chkGameOver()
    print("--@Field:chkGameOver: checking for game over")
    local box = theBasket.box.contents
    local basket = theQueue[1].contents

    if fieldType == 'Stew' then
        local num_flags = 0
        for i, v in ipairs(self.elements.Obstruction) do
            if v.elem_type == 'Urn' then
                num_flags = num_flags + 1
            end
        end
        if num_flags > 5 then
            print('CAAAAAAAWWWWWW...n!!!!!!!!!!')
            print('Crow God!!!!!!!!!!!!!!!!')
            storyboard:gotoScene('title_screen')
            return true
        end
    elseif fieldType == 'Tea' then
        local num_flags = 0
        for i, v in ipairs(self.elements.Obstruction) do
            if v.elem_type == 'StonePlant' then
                num_flags = num_flags + 1
            end
        end
        if num_flags > self.total_squares*0.5 then
            print('CRWWWWWWASDFASDF!!!')
            print('Cockatrice God!!!!!!!!!!!!')
            storyboard:gotoScene('title_screen')
            return true
        end
    else
        local num_flags = 0
        for i, v in ipairs(self.elements.Obstruction) do
            if v.elem_type == 'Stone' then
                num_flags = num_flags + 1
            end
        end
        if num_flags > self.total_squares * 0.5 then
            print("OOOOOOOOOOOOOOOOMMM NOOOOOOOOOMMMMMM!!!")
            print('Fat Stone Gopher!!!!!!!!!!!!!!')
            storyboard:gotoScene('title_screen')
            return true
        end
    end
    if box.is_weapon or box.empty or basket.is_weapon or #self.elements.Blank then
        return true
    end
    for i, v in ipairs(self.elements.Plant) do
        if v.myStage == v.rot or v.myStage == v.mature then
            return true
        end
    end
    print('DOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOMMMMMMMMM!!!')
    print('Out of Turns!')
    storyboard:gotoScene('title_screen')
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