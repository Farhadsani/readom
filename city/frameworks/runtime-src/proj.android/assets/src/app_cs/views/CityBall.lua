


local CityBall = class("CityBall", function()
    return display.newNode()
end)

CityBall.state = {
	NONDEFINED		= "NonDefined",
	UNDOWNLOADED	= "Undownloaded",
	DOWNLOADING		= "Downloading",
	DOWNLOADED		= "Downloaded",
	UPDATE          = "Update",
	REMARKED		= "Remarked",
	PUBLISHED		= "Published",
	-- currentState	= "NonDefined"
}

function CityBall:ctor(cityBallImage, state, citySName)
	-- self:_createBallBackLight() -- will create or not in update()
	self.currentState	= "NonDefined"

	self:_createBall(cityBallImage)
	-- self:_createCloudSet(5) -- will create or not in update()

	-- self.coverLayer = cc.LayerColor:create(cc.c4b(0,0,0,180))
	-- 	:size(300, 300)
	-- 	:pos(-150, -150)

	-- self.coverLayer = display.newColorLayer(cc.c4b(0,0,0,180))
	-- -- self.coverLayer:setOpacity(30)
	-- self.coverLayer:setContentSize(cc.size(300,300))
	-- -- self.coverLayer:size(300,300)

	-- self.coverLayer:setAnchorPoint(cc.p(0,0))
	-- self.coverLayer:setPosition(cc.p(-150,-150))
	-- self.coverLayer:addTo(self)
	-- self:addChild(self.coverLayer, 3) 

	local txtName = ccui.Text:create()

    txtName:setPosition(cc.p(0, display.height*0.4))
    txtName:addTo(self, 5)
    txtName:setString(citySName)
    txtName:setFontSize(72)
    self.txtCityName = txtName
	

	self:_createButton()
	self:update(state)
	-- self:setDark()
end

function CityBall:setDelegate(delegate)
	self._button:setDelegate(delegate)
end

function CityBall:_createBallBackLight()
	printf("ball bk light")
	self._ballBackLight = display.newSprite("ui/image/city_ball_back_light.png")
	self:addChild(self._ballBackLight, 1)
end

function CityBall:setDark( isDark )
	-- body
	-- self._cityBall:setOpacity(100)

	if isDark then
		local a1 = cc.TintTo:create(0.5, 98,98,98)
		self._cityBall:runAction(a1)
	else
		local a1 = cc.TintTo:create(0.5, 255,255,255)
		self._cityBall:runAction(a1)
	end
end

function CityBall:_createBall(cityBallImage)

	local defaultImagePath = "ui/image/city_ball_default.png"

	defaultImagePath = cityBallImage
	self._cityBall = display.newSprite(defaultImagePath)

	local r1 = cc.RotateBy:create(1, 10)
	-- local r2 = cc.RotateTo:create(5, 0)
	local act = cc.RepeatForever:create(r1)

	self:addChild(self._cityBall, 2)
	self._cityBall:runAction(act)

end

function CityBall:setBallSprite( cityBallImage )
	self._cityBall:setTexture(cityBallImage)
end

function CityBall:_createRandomIndex(count)
	local orderedSet = {}
	for i = 1, count do
		orderedSet[i] = i
	end

	local set = {}
	for i = 1, count do
		local pickPos = math.random(#orderedSet)
		set[i] = orderedSet[pickPos]
		table.remove(orderedSet, pickPos)
	end

	return set
end

function CityBall:_cloudSideMarginCheck(cloud, currentPos)

	local boundingBox = cloud:getCascadeBoundingBox()

	local rectBLPoint = cc.p(boundingBox.x, boundingBox.y)
    local rectTRPoint = cc.p(rectBLPoint.x + boundingBox.width, rectBLPoint.y + boundingBox.height)

	local sideMargin =  100
	local positionAdjust = 0

    if rectBLPoint.x < -display.width/2 + sideMargin then
        positionAdjust = -display.width/2 + sideMargin - rectBLPoint.x
    elseif rectTRPoint.x > display.width/2 - sideMargin then
        positionAdjust = display.width/2 - sideMargin - rectTRPoint.x
    end

    cloud:setPosition(cc.p(currentPos.x + positionAdjust, currentPos.y))
end

function CityBall:_createCloudSet(count)
	self._cloudSetNode = display.newNode()

	local minRadius = 200
	local radiusRange = 100
	local angleDelta = math.pi * 2 / count

	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	local initAngle = math.random() * math.pi / 2
	local imageIndexSet = self:_createRandomIndex(count)
	for i = 1, count do
		local cloudImagePath = "ui/image/city_ball_front_cloud" .. tostring(imageIndexSet[i]) .. ".png"
		local cloud = display.newSprite(cloudImagePath)
		local radius = minRadius + radiusRange * math.random()
		local angle = initAngle + angleDelta * (i - 1)
		local position = cc.p(radius * math.cos(angle), radius * math.sin(angle))
		cloud:setPosition(position)
		self:_cloudSideMarginCheck(cloud, position)
		cloud:addTo(self._cloudSetNode)
	end
	-- self:addChild(self._cloudSetNode, 3)
end

function CityBall:_createButton()
	self._button = require(QMapGlobal.app.packageRoot .. "/views/CityBallButton").new("Start")
	self:addChild(self._button, 4)
end

function CityBall:updateButton(value) -- value
	self._button:update(value)
end

function CityBall:_setBallBackLightVisible(visible)

	if visible then
		if self._ballBackLight then
			self._ballBackLight:setVisible(true)
		else
			self:_createBallBackLight()
		end

	else
		if self._ballBackLight then
			self._ballBackLight:removeFromeParent()
			self._ballBackLight = nil
		end
	end
end

function CityBall:_setCloudSetVisible(visible)

	if visible then
		if self._cloudSetNode then
			-- self._cloudSetNode:setVisible(true)
		else
			self:_createCloudSet(5)
		end

	else
		if self._cloudSetNode then
			-- self._cloudSetNode:removeFromParent()
			self._cloudSetNode = nil
		end
	end
end

function CityBall:update(typeOrValue)

	local realType = type(typeOrValue)
	-- print(typeOrValue,"========================")
	if realType == "string" then

		if typeOrValue == self.state.UNDOWNLOADED then
			self:_setBallBackLightVisible(false)
			-- self:_setCloudSetVisible(true)
			self._button:update(self._button.frontType.DOWNLOAD)

		elseif typeOrValue == self.state.DOWNLOADING then
			self:_setBallBackLightVisible(false)
			-- self:_setCloudSetVisible(true)
			self._button:update(0)

		elseif typeOrValue == self.state.DOWNLOADED then
			self:_setBallBackLightVisible(false)
			-- self:_setCloudSetVisible(true)
			self._button:update(self._button.frontType.START)

		elseif typeOrValue == self.state.UPDATE then
			self:_setBallBackLightVisible(false)
			-- self:_setCloudSetVisible(true)
			self._button:update(self._button.frontType.UPDATE)
			
		elseif typeOrValue == self.state.REMARKED then
			self:_setBallBackLightVisible(false)
			self._button:update(self._button.frontType.START)
			-- self:_setCloudSetVisible(false)

		elseif typeOrValue == self.state.PUBLISHED then
			self:_setBallBackLightVisible(true)
			self._button:update(self._button.frontType.START)
			-- self:_setCloudSetVisible(false)

		else
			printError("update with undefined type: %s", typeOrValue)
			return

		end

		self.currentState = typeOrValue

	elseif realType == "number" then

		self.currentState = self.state.Downloading
		self._button:update(typeOrValue)

	end
end

return CityBall
