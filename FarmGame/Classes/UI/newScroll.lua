newScroll = Class()

function newScroll:initialize(args)
    img = display.newRect(0, 0, theField.width, theField.height)
    img.anchorX = 0
    img.anchorY = 0
    img.alpha = 0
    img.isHitTestable = true
    def function imgTouch(event)
        self:touch(event)
    img.touch = imgTouch
    img:addEventListener('touch', img)
    self.img = img
end

function newScroll:touch(event)
    if event


end