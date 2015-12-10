local CityBallButton = class("CityBallButton", function()
    return display.newNode()
end)

CityBallButton.frontType = {
	NONDEFINED	= "NonDefined",
	DOWNLOAD	= "Download",
	START		= "Start",
	PERCENT		= "Percent",
	UPDATE      = "Update",
	
}

function CityBallButton:ctor(typeOrValue)
	self:_createButtonBackground()
	self:_createButtonFront(typeOrValue)
	self.currentType = "NonDefined"
end

function CityBallButton:setDelegate(delegate)
	self._delegate = delegate
end

function CityBallButton:_createButtonBackground()

    local buttonStateImages = {}
    buttonStateImages.normal = "ui/image/city_ball_button_background.png"
    buttonStateImages.pressed = "ui/image/city_ball_button_background.png"
    buttonStateImages.disabled = "ui/image/city_ball_button_background.png"
    
    self._background = cc.ui.UIPushButton.new(buttonStateImages, {scale9 = true})
    self._background:setButtonEnabled(true)
	self._background:addTo(self)
	self._background:onButtonClicked(function(event)
		self:_tapHandler()
	end)

	self.waittingNode1 =  cc.uiloader:load("ui/dlWaittingNode.csb")
	self.waittingNode1:addTo(self)
	local action = cc.CSLoader:createTimeline("ui/dlWaittingNode.csb");   
	self.waittingNode1:runAction(action);   
	action:gotoFrameAndPlay(0, 60, true);
	self.waittingNode1:setVisible(false)

	self.waittingNode2 =  cc.uiloader:load("ui/dlWaittingNode2.csb")
	self.waittingNode2:addTo(self)
	local action2 = cc.CSLoader:createTimeline("ui/dlWaittingNode2.csb");   
	self.waittingNode2:runAction(action2);   
	action2:gotoFrameAndPlay(0, 55, true);
	self.waittingNode2:setVisible(false)
end

function CityBallButton:_eventHandler(event)

    printf("CityBallButton...... click...")

    if event.name == "began" then
        return true

    elseif event.name == "moved" then

    elseif event.name == "ended" then

    end
end

function CityBallButton:_tapHandler()
	if self.currentType == self.frontType.DOWNLOAD then
		self._background:setOpacity(0)
		self._delegate:setBallDark(true)
		self.waittingNode1:setVisible(true)
		self._delegate:cityBallDownloadTapped()
	elseif self.currentType == self.frontType.START then
		self._background:setOpacity(0)
		self._delegate:setBallDark(true)
		self.waittingNode2:setVisible(true)
		self._buttonFront:setVisible(false)
		local a1 = cc.CallFunc:create(function()
			self._delegate:cityBallStartTapped()
		end)
		transition.execute(self, a1, {delay = 0.5})
		
		-- self:runAction(a1)
		
	elseif self.currentType == self.frontType.UPDATE then
		self._background:setOpacity(0)
		self._delegate:setBallDark(true)
		self.waittingNode1:setVisible(true)
		self._delegate:cityBallUpdateTapped()
	end
end

function CityBallButton:_createButtonFront(typeOrValue)

	local frontType = self:_parseFrontType(typeOrValue)
	self.waittingNode1:setVisible(false)
	self.waittingNode2:setVisible(false)

	if frontType == self.frontType.PERCENT then
		self._background:setOpacity(0)
		self._delegate:setBallDark(true)
		self.waittingNode1:setVisible(true)
		-- self.waittingNode2:sestVisible(false)
		self._buttonFront = display.newTTFLabel({size = 48})
		self._buttonFront:setString(tostring(typeOrValue) .. "%")

	elseif frontType == self.frontType.START then
		if self._delegate then
			self._delegate:setBallDark(false)
		end
		self._background:setOpacity(255)
		self._buttonFront = display.newSprite("ui/image/city_ball_button_start.png")
		-- self._buttonFront:setPosition(cc.p())
	elseif frontType == self.frontType.DOWNLOAD then
		self._buttonFront = display.newSprite("ui/image/city_ball_button_download.png")
		-- self._background:setOpacity(0)
		if self._delegate then
			self._delegate:setBallDark(false)
		end
		self._background:setOpacity(255)
	elseif frontType == self.frontType.UPDATE then
		self._buttonFront = display.newSprite("ui/image/city_ball_button_update.png")
		-- self._background:setOpacity(0)
		if self._delegate then
			self._delegate:setBallDark(false)
		end
		self._background:setOpacity(255)
	else
		printError("CityBallButton:_createButtonFront cannot creat, failed in parsing")
		return
	end

	self.currentType = frontType

	self._buttonFront:addTo(self)

	
end

function CityBallButton:_parseFrontType(value)
	local valueType = type(value)
	local newFrontType

	if valueType == "number" then
		newFrontType = self.frontType.PERCENT

	elseif valueType == "string" then
		if value == self.frontType.DOWNLOAD then
			newFrontType = self.frontType.DOWNLOAD
		elseif value == self.frontType.START then
			newFrontType = self.frontType.START
		elseif value == self.frontType.UPDATE then
			newFrontType = self.frontType.UPDATE
		else
			print("[ERR] CityBallButton:_parseFrontType cannot parse value:", value)
			printError("") -- for stack print
			return nil
		end

	else
		print("[ERR] CityBallButton:_parseFrontType cannot parse value:", value)
		printError("") -- for stack print
		return nil
	end

	return newFrontType
end

function CityBallButton:update(typeOrValue)

	local newFrontType = self:_parseFrontType(typeOrValue)

	if newFrontType then
		if newFrontType ~= self.currentType then
			self._buttonFront:removeFromParent()
			self:_createButtonFront(typeOrValue)

		else
			if self.currentType == self.frontType.PERCENT then
				self._buttonFront:setString(tostring(typeOrValue) .. "%")
			end
		end
	end
end

return CityBallButton
