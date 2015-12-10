local MapMarkNumber = class("MapMarkNumber", function()
    return display.newSprite("#map_mark_number_dot.png")
end)

function MapMarkNumber:ctor()

	local dotContentSize = self:getContentSize()

	self._colorDot = display.newSprite(self:getSpriteFrame())
	self._colorDot:setScale(0.87)
	self._colorDot:setAnchorPoint(cc.p(0.5, 0.5))
	self._colorDot:setColor(cc.c3b(255, 0, 0))
	self._colorDot:setPosition(cc.p(dotContentSize.width/2, dotContentSize.height/2))
	self:addChild(self._colorDot, 1)

	self._numberLabel = display.newTTFLabel({size = 28})
	self:setAnchorPoint(0.5, 0.5)
	self._numberLabel:setPosition(cc.p(dotContentSize.width/2, dotContentSize.height/2))
	self:addChild(self._numberLabel, 2)
end

function MapMarkNumber:setNumber(number)
	self._numberLabel:setString(tostring(number))
end

return MapMarkNumber
