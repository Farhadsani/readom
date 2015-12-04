local PopupSingleButton = class("PopupSingleButton", require("app/views/PopupBase"))

function PopupSingleButton:ctor()
	-- super
	PopupSingleButton.super.ctor(self)

	-- button
	local buttonStateImages = {}
    buttonStateImages.normal = "#map_popup_single_button_normal.png"
    buttonStateImages.pressed = "#map_popup_single_button_pressed.png"
    -- buttonStateImages.disabled = "ui/image/map_popup_single_button_normal.png"
    self._button = cc.ui.UIPushButton.new(buttonStateImages, {scale9 = true})
    local buttonContentSize = self._button.sprite_[1]:getContentSize()
	self._button:setPosition(cc.p(self._extensionLineLen + buttonContentSize.height / 2, 0))
	self._button:setCascadeOpacityEnabled(true)
	self:addChild(self._button, 2)

    -- button text label
    self._buttonNormalLabel = display.newTTFLabel({size = 58})
    self._buttonNormalLabel:setString("")
    self._button:setButtonLabel("normal", self._buttonNormalLabel)

    self._buttonPressedlLabel = display.newTTFLabel({size = 58})
    self._buttonPressedlLabel:setString("")
    self._buttonPressedlLabel:setColor(cc.c3b(127, 127, 127))
    self._button:setButtonLabel("pressed", self._buttonPressedlLabel)

    self._button:addEventListener("PRESSED_EVENT", handler(self, self._buttonPressed))
    self._button:addEventListener("RELEASE_EVENT", handler(self, self._buttonReleased))
    
    -- caption
    self._captionLabel = display.newTTFLabel({size = 38})
    self._captionLabel:setString("")
	self._captionLabel:setAnchorPoint(0, 0)
	self._captionLabel:setPosition(cc.p(-buttonContentSize.width/2 + 10, buttonContentSize.height/2 * 1.04))
	self._button:addChild(self._captionLabel, 3)

	-- default pop direction
	self:setPopDirection("top")
end

function PopupSingleButton:updateRotation(rotation)
	self._button:setRotation(-rotation)
end

function PopupSingleButton:setButtonText(text)
	self._buttonNormalLabel:setString(text)
	self._buttonPressedlLabel:setString(text)
end

function PopupSingleButton:setCaptionText(text)
	self._captionLabel:setString(text)
end

function PopupSingleButton:setButtonClickedCallback(clickedCallback)
	self._button:onButtonClicked(clickedCallback)
end

function PopupSingleButton:_buttonPressed()
	self._mapDisableTouchFunc()
end

function PopupSingleButton:_buttonReleased()
    self._mapEnableTouchFunc()
end

return PopupSingleButton
