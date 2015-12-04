local PopupThreeButton = class("PopupThreeButton", require("app/views/PopupBase"))

function PopupThreeButton:ctor()
	-- super
	PopupThreeButton.super.ctor(self)

	-- button state sprite frames
	self._buttonNormalFrame = display.newSpriteFrame("map_popup_three_button_normal.png")
	self._buttonPressedFrames = {}
	self._buttonPressedFrames[1] = display.newSpriteFrame("map_popup_three_button_pressed1.png")
	self._buttonPressedFrames[2] = display.newSpriteFrame("map_popup_three_button_pressed2.png")
	self._buttonPressedFrames[3] = display.newSpriteFrame("map_popup_three_button_pressed3.png")

	-- button
	self._button = cc.Sprite:create()
	self._button:setSpriteFrame(self._buttonNormalFrame)
	self._buttonContentSize = self._button:getContentSize()
	self._button:setPosition(cc.p(self._extensionLineLen + self._buttonContentSize.height / 2, 0))
	self._button:setCascadeOpacityEnabled(true)
	self:addChild(self._button, 2)

	-- button text
	local singleWidth = self._buttonContentSize.width / 3
	self._buttonsText = {}
	for i = 1, 3 do
		self._buttonsText[i] = display.newTTFLabel({size = 58})
		self._buttonsText[i]:setPosition(cc.p(singleWidth * (i - 1 + 0.5), self._buttonContentSize.height * 0.5))
		self._button:addChild(self._buttonsText[i])
	end
    
    -- caption
    self._captionLabel = display.newTTFLabel({size = 38})
    self._captionLabel:setString("")
	self._captionLabel:setAnchorPoint(0, 0)
	self._captionLabel:setPosition(cc.p(10, self._buttonContentSize.height * 1.04))
	self._button:addChild(self._captionLabel, 3)

	-- default pop direction
	self:setPopDirection("top")

	self:_initEvents()
end

function PopupThreeButton:updateRotation(rotation)
	self._button:setRotation(-rotation)
end

function PopupThreeButton:setButtonText(index, text)
	self._buttonsText[index]:setString(text)
end

function PopupThreeButton:setCaptionText(text)
	self._captionLabel:setString(text)
end

function PopupThreeButton:setButtonsTapCallback(func)
	self._buttonsTapCallback = func
end

function PopupThreeButton:_displayStateForButtonWithIndex(index, pressed)
	if pressed then
		self._buttonsText[index]:setColor(cc.c3b(127, 127, 127))
		self._button:setSpriteFrame(self._buttonPressedFrames[index])
	else
		self._buttonsText[index]:setColor(cc.c3b(255, 255, 255))
		self._button:setSpriteFrame(self._buttonNormalFrame)
	end
end

------ event handle
function PopupThreeButton:_initEvents()
    self._button:setTouchEnabled(true)
    self._button:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self._touchHandler))
end

function PopupThreeButton:_buttonTouchBegan()
	self._mapDisableTouchFunc()
end

function PopupThreeButton:_buttonTouchEnded()
    self._mapEnableTouchFunc()
end

function PopupThreeButton:_tapButtonWithIndex(index)
	self._buttonsTapCallback(index)
end

function PopupThreeButton:_boundingBoxForButtonWithIndex(index)
	local boundingBoxWidth = self._buttonContentSize.width / 3
	return cc.rect((index - 1) * boundingBoxWidth, 0, boundingBoxWidth, self._buttonContentSize.height)
end

function PopupThreeButton:_buttonContainsPoint(buttonIndex, point)
	return cc.rectContainsPoint(self:_boundingBoxForButtonWithIndex(buttonIndex), point)
end

function PopupThreeButton:_indexOfTouchedButton(point)
	local boundingBoxWidth = self._buttonContentSize.width / 3
    for k = 1, 3 do
        if self:_buttonContainsPoint(k, point) then
            return k
        end
    end
    return nil
end

function PopupThreeButton:_touchHandler(event)

    local point = self._button:convertToNodeSpace(cc.p(event.x, event.y))

    if event.name == "began" then
    	self._buttonStillTouched = false
        self._touchedButtonIndex = self:_indexOfTouchedButton(point)
        if self._touchedButtonIndex then
            self._buttonStillTouched = true
            self:_displayStateForButtonWithIndex(self._touchedButtonIndex, self._buttonStillTouched)
            self:_buttonTouchBegan()
            return true
        end
        return false
        
    elseif event.name == "moved" then
        if not self:_buttonContainsPoint(self._touchedButtonIndex, point) then
            self._buttonStillTouched = false
            self:_displayStateForButtonWithIndex(self._touchedButtonIndex, self._buttonStillTouched)
        end

    elseif event.name == "ended" then
    	self:_buttonTouchEnded()
    	self:_displayStateForButtonWithIndex(self._touchedButtonIndex, self._buttonStillTouched)
        if self._buttonStillTouched then
            self:_tapButtonWithIndex(self._touchedButtonIndex)
        end
    end
end

return PopupThreeButton
