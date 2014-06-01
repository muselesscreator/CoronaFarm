
FarmElement = Class()

function FarmElement:initialize(args)
    self.i = args.i
    self.j = args.j
    self:deriveXY()
    local function onClick(event)

        local target  = event.target
        local phase = event.phase

        if touchesAllowed and not layers.popup.visible and not gameOver and not layers.tutorial.visible then       
             
            if self:whatIsNext().type == 'Slingshot' then
                touchesAllowed = false
                local stuff = theField:whatIsAt(self.i, self.j)
                can_shoot = true
                local myPlant = nil
                for i, v in ipairs(stuff) do
                    if v.elem_type == 'Plant' then
                        myPlant = v
                    end
                end
                if myPlant == nil or myPlant.myStage ~= myPlant.mature then
                --if myPlant == nil then
                    self:useSlingshot()
                else
                    if theBasket.box.selected then
                        self:useSlingshot()
                    else
                        self:confSlingshot(myPlant)
                    end
                end
                return true
            end


            local pest = theField:pestAt(self.i, self.j)
            print('--@FarmElement:onClick')
            print(pest)
            if pest ~= false then
                if pest:canClick() ~= false then
                    print('CLICK ON PEST')
                    touchesAllowed = false
                    theField:waitADay()
                    pest:onClick(event)
                    return true
                end
            end           
            if self:canClick() then
                touchesAllowed = false
                theField:waitADay()
                self:onClick(event)
                return true
            end

        end
    end

    local base_sprite = display.newSprite(plantSheet, sequenceData)
    base_sprite:setSequence('seqBlank')
    base_sprite.x = self.x 
    base_sprite.y = self.y
    base_sprite.tap = onClick
    base_sprite:addEventListener('tap', onClick)


    local overlay = display.newSprite(overlaySheet, sequenceData)
    overlay:setSequence('seqBlank')
    overlay.x = self.x
    overlay.y = self.y
    overlay.alpha = 0

    local weapon = display.newSprite(weaponSheet, sequenceData)
    weapon.x = self.x
    weapon.y = self.y
    weapon.alpha = 0
    self.weapon_sprite = weapon

    draw_priority = 0 --1 and up are drawn (1 first)

    self.base_sprite = base_sprite
    self.overlay = overlay
end

function FarmElement:deriveXY()
    self.x = theField.X + (self.i-1)*((theField.W/theField.columns))
    self.y = theField.Y + (self.j-1)*((theField.H/theField.rows))   
end

function FarmElement:addSpritesToLayers()
    local layer = theField.layers[self.j]
    layer:insert(self.base_sprite)
    layer:insert(self.overlay)
    layer:insert(self.weapon_sprite)
end

function FarmElement:move()
    self.base_sprite.x = self.x
    self.base_sprite.y = self.y
    self.overlay.x = self.x
    self.overlay.y = self.y
end

--Done
function FarmElement:getNeighbors()
    print('--@FarmElement:getNeighbors')
    local neighbors = {above=nil, below=nil, right=nil, left=nil}
    if self.i > 1 then
        neighbors.left = theField:whatIsAt(self.i-1, self.j)
    end
    if self.i < theField.columns then
        neighbors.right = theField:whatIsAt(self.i+1, self.j)
    end    
    if self.j > 1 then
        neighbors.above = theField:whatIsAt(self.i, self.j-1)
    end
    if self.j < theField.rows then
        neighbors.below = theField:whatIsAt(self.i, self.j+1)
    end
    return neighbors
end
--Done
function FarmElement:nextDay()
    return true
end
--Done
function FarmElement:onClick( event )
    if self.elem_type == 'Blank' then
        return Blank:onClick( event )
    end
    return false
end
--Done
function FarmElement:nextDay()
    print('--@FarmElement:nextDay()')
    return true
end
--Done
function FarmElement:die()
    print('FarmElement:die')
    if self.base_sprite ~= nil then
        self.base_sprite:removeSelf()
        self.overlay:removeSelf()
        self.base_sprite = nil
        self.overlay = nil
    end
    self:removeFromField()
    self = nil
end

--Done
function FarmElement:whatIsNext()
    if theBasket.box.selected then
        return theBasket.box.contents
    else
        return theQueue[1].contents
    end
end
--Done
function FarmElement:useNext()
    if theBasket.box.selected then
        theBasket:empty()
    else
        theQueue:nextEntry()
    end
end
--Done
function FarmElement:nextIsValid()
    print('--@FarmElement:nextIsValid')
    return false
end
--Done
function FarmElement:canClick()
    print('--@FarmElement:canClick()')
    print(self:nextIsValid())
    return self:nextIsValid()
end

--Done?
function FarmElement:addToField()
    theField.elements[self.elem_type][#theField.elements[self.elem_type]+1] = self
end
--Done
function FarmElement:removeFromField()
    print('--@FarmElement:removeFromField')
    for i, v in ipairs(theField.elements[self.elem_type]) do
        if v == self then
            table.remove(theField.elements[self.elem_type], i)
        end
    end
end

--Done
function FarmElement:useWeapon()
    if self:whatIsNext().type == 'Mallet' then
        self.weapon_sprite:setSequence(self:whatIsNext().type)
        self.weapon_sprite.alpha = 1
        vibrate()
        self.weapon_sprite:play()
        timer.performWithDelay(250, function()
            self:hideWeapon()
            end, 1)
    else
        print(self.weapon_sprite.x..', '..self.weapon_sprite.y)
        self.weapon_sprite:setSequence('Reticle')
        self.weapon_sprite.alpha = 1
        timer.performWithDelay(1000, function()
            self:hideWeapon()
            end, 1)
    end
end

function FarmElement:confSlingshot(myPlant)
    local function hideUI()
        self.menu:removeSelf()
        self.menu = nil
        self.doShoot:removeSelf()
        self.doShoot = nil
        self.doHarvest:removeSelf()
        self.doHarvest = nil
        theField:waitADay()
    end

    local function harvest()
        myPlant:onClick()
        hideUI()
    end

    local function shoot()
        self:useSlingshot()
        hideUI()
    end

    self.menu = display.newImage('images/uiConfirmDialog.png')
    self.doShoot = display.newImage('images/uiButtonShoot.png')
    self.doHarvest = display.newImage('images/uiButtonHarvest.png')
    if self.j == 1 then
        self.menu.yScale = -1
        self.menu.y = self.y + 100
        self.doShoot.y = self.y + 120
        self.doHarvest.y = self.y + 120
        theField.layers[self.j + 1]:insert(self.menu)
        theField.layers[self.j + 1]:insert(self.doHarvest)
        theField.layers[self.j + 1]:insert(self.doShoot)
    else
        self.menu.y = self.y - 100
        self.doShoot.y = self.y-120
        self.doHarvest.y = self.y-120
        theField.layers[self.j]:insert(self.menu)
        theField.layers[self.j]:insert(self.doHarvest)
        theField.layers[self.j]:insert(self.doShoot)
    end
    self.menu.x = self.x
    self.doShoot.x = self.x-50
    self.doHarvest.x = self.x+50
    
    self.doShoot.touch = shoot
    self.doShoot:addEventListener('touch', self.doShoot)
    self.doHarvest.touch = harvest
    self.doHarvest:addEventListener('touch', self.doHarvest)

    
end

function FarmElement:useSlingshot()
    neighbors = {}
    neighbors['self'] = self
    neighbors['N'] = {i=self.i, j=self.j-1}
    neighbors['NE'] = {i=self.i+1, j=self.j-1}
    neighbors['E'] = {i=self.i+1, j=self.j}
    neighbors['SE'] = {i=self.i+1, j=self.j+1}
    neighbors['S'] = {i=self.i, j=self.j+1}
    neighbors['SW'] = {i=self.i-1, j=self.j+1}
    neighbors['W'] = {i=self.i-1, j=self.j}
    neighbors['NW'] = {i=self.i-1, j=self.j-1}
    theField.slingAnim:setSequence('SlingAnim')
    theField.slingAnim.alpha = 1
    slingshotVibrate()
    theField.slingAnim:play()
    local killed_pest = false
    timer.performWithDelay(1000, function()
        theField.slingAnim.alpha = 0 
        theField.slingAnim:setSequence('SlingAnim')
        end, 1)
    for i, v in pairs(neighbors) do
        print('SLING NEIGHBORS!!!!!!!!!!!!!!!!!!')
        print(i..' '..v.i..', '..v.j)
        local pest = theField:pestAt(v.i, v.j)
        if pest ~= false then
            print('Kill thie Pest!')
            killed_pest = true
            pest:useWeapon()
        else
            local other_stuff = theField:whatIsAt(v.i, v.j)
            if #other_stuff > 0 then
                print('waste the slingshot')
                FarmElement.useWeapon(other_stuff[1])
            end
        end
    end
    timer.performWithDelay(1000, function()
        if killed_pest == true then
            theField.slingAnim:setSequence('BirdDeath')
            theField.slingAnim.alpha = 1
            theField.slingAnim:play()
            timer.performWithDelay(800, function()
                theField.slingAnim.alpha = 0
                theField.slingAnim:setSequence('SlingAnim')
                touchesAllowed = true
                self:useNext()
                theField:nextDay()
                end, 1)
        else
            touchesAllowed = true
            self:useNext()
            theField:nextDay()
        end
        end, 1)
end

function FarmElement:hideWeapon()
    if self.weapon_sprite ~= nil then
        self.weapon_sprite.alpha = 0 
        self.weapon_sprite:setSequence('seqBlank')
    end
end

function FarmElement:hide()
    self.base_sprite.alpha = 0
    self.overlay.alpha = 0
end

function FarmElement:show()
    self.base_sprite.alpha = 1
end
