local PopupBase = class("PopupBase", function()
    return display.newNode()
end)

function PopupBase:ctor()
	-- sprite frames
	display.addSpriteFrames("ui/image/popup_buttons.plist", "ui/image/popup_buttons.png")

	-- dot
	self._dot = display.newSprite("#map_popup_button_dot.png")
	self:addChild(self._dot, 1)
	local dotContentSize = self._dot:getContentSize()
	self._dot:setCascadeOpacityEnabled(true)

	-- extension line
	self._extensionLine = display.newSprite("#map_popup_button_extension_line.png")
	self._extensionLine:setAnchorPoint(cc.p(0, 0.5))
	self._extensionLine:setScaleX(1.5)
	self._extensionLine:setPosition(cc.p(dotContentSize.width / 2, dotContentSize.height / 2))
	self._dot:addChild(self._extensionLine)
	self._extensionLineLen = self._extensionLine:getContentSize().width * self._extensionLine:getScaleX()

	-- enable opacity cascading
	self:setCascadeOpacityEnabled(true)
end

function PopupBase:updateRotation(rotation)
	-- overwriten by subclass
end

function PopupBase:setPopDirection(direction)
	if self._popDirection ~= direction then
		if direction ==  "top" then
			self:setRotation(-90)
			self:updateRotation(-90)
		elseif direction == "bottom" then
			self:setRotation(90)
			self:updateRotation(90)
		else
			printError("pop direction not defined: %s", direction or "nil")
			return
		end
		self._popDirection = direction
	end
end

function PopupBase:setMapEnableDisableTouchFunc(enableCallback, disableCallback)
	self._mapEnableTouchFunc = enableCallback
	self._mapDisableTouchFunc = disableCallback
end

return PopupBase
