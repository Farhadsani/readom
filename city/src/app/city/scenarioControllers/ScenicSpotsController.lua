
local ScenicSpotsController = class("ScenicSpotsController")

function ScenicSpotsController:ctor(parentController)
	self._parentController = parentController
end

function ScenicSpotsController:getName()
	return self.__cname
end

function ScenicSpotsController:attachView(view)
	self._attachedView = view
end

function ScenicSpotsController:enter()
	self._attachedView:setDelegate(self)
	self._attachedView:switchToMenuForController(self:getName(), true)
	self._attachedView:setMapAllSenicSpotsFlash(true)
	-- self._attachedView:enterBarrage()
end

function ScenicSpotsController:quit()
	if self._scenicSpotNameOfCurrentPopup then
		self._attachedView:dismissMapPopupMenu()
		self._attachedView:setMapSelectedScenicSpotHighLighted(false, true, nil)
		self._scenicSpotNameOfCurrentPopup = nil
	end
	self._attachedView:setMapAllSenicSpotsFlash(false)
	self._attachedView:quitBarrage()
end

function ScenicSpotsController:getValueForMenuLabelWithName(labelName)
	if labelName == "cityName" then
		return self._parentController.city:getShowName()
	else
		printError("label not defined: %s", labelName)
		return ""
	end
end

function ScenicSpotsController:_mapSelectedScenicSpotHighLightOn()
	self._mapSelectedScenicSpotHighLightAnimationInProgress = false
end

function ScenicSpotsController:tappedScenicSpotWithName(scenicSpotName)
	-- print("function ScenicSpotsController:tappedScenicSpotWithName(scenicSpotName)....", scenicSpotName)
	if self.curScenicSpotName then
		self:tappedElseWhere()
		return
	end
	self.curScenicSpotName = scenicSpotName
	-- print(self._scenicSpotNameOfCurrentPopup, scenicSpotName)
	if self._scenicSpotNameOfCurrentPopup ~= scenicSpotName then
		if not self._scenicSpotNameOfCurrentPopup then
			self._attachedView:setMapAllSenicSpotsFlash(false)
			-- self._attachedView:quitBarrage()
		else
			self._attachedView:clearScenicSpotWithNameAboveLocationMask(self._scenicSpotNameOfCurrentPopup, false)
			-- self._attachedView:enterBarrage()
		end
		self._attachedView:dismissMapPopupMenu()
		self._scenicSpotNameOfCurrentPopup = scenicSpotName
		-- self:_popupThreeButtonMenuForSelectedScenicSpot()

		local sightData = self._parentController.city:getSightData(self._scenicSpotNameOfCurrentPopup)
		print(scenicSpotName,self._scenicSpotNameOfCurrentPopup, "-------------------------")
		if sightData then
			local param = {
				name = sightData.cname,
				intros = sightData.desc
				-- desc = 
			}
			self._attachedView:showIntrduce(true, param)

			self._attachedView:setMenuButtonsEnabled({"shop", "strategy"}, false)
		end

		self._mapSelectedScenicSpotHighLightAnimationInProgress = true
		self._attachedView:setMapSelectedScenicSpotHighLighted(true, true, 
														   	   handler(self, self._mapSelectedScenicSpotHighLightOn))

		self._attachedView:enterBarrage()
		-- self.curScenicSpotName = scenicSpotName
	end
end

function ScenicSpotsController:_mapSelectedScenicSpotHighLightOff()
	self._attachedView:setMapAllSenicSpotsFlash(true)
	self._mapSelectedScenicSpotHighLightAnimationInProgress = false
end

-- 手机返回键
function ScenicSpotsController:onBack( ... )
	self:tappedElseWhere()
	self._parentController.navigationController:pop()
end

-- 
function ScenicSpotsController:tappedElseWhere()
	self._attachedView:setMenuButtonsEnabled({"shop", "strategy"}, true)
	self._attachedView:quitBarrage()
	self._attachedView:showIntrduce(false)
	self._mapSelectedScenicSpotHighLightAnimationInProgress = true
	self._attachedView:clearScenicSpotWithNameAboveLocationMask(self._scenicSpotNameOfCurrentPopup, false)
	self._scenicSpotNameOfCurrentPopup = nil
	self._attachedView:dismissMapPopupMenu()
	self._attachedView:setMapSelectedScenicSpotHighLighted(false, true, handler(self, self._mapSelectedScenicSpotHighLightOff))
	self.curScenicSpotName = nil
	-- print("function ScenicSpotsController:tappedElseWhere()....")
end

function ScenicSpotsController:_popupThreeButtonMenuForSelectedScenicSpot()
	-- print(displayName, type(displayName))
	local displayName = self._parentController.city:getSightDisplayName(self._scenicSpotNameOfCurrentPopup)
	if not displayName then 
		print("the name of sight %s is nil, ", self._scenicSpotNameOfCurrentPopup, type(self._scenicSpotNameOfCurrentPopup))
		return
	end
	-- print(displayName, type(displayName))
	local param = {	scenicSpotDisplayName = displayName, 
					buttonNames = { { key = "intro", text = "简介"},
									-- { key = "label", text = "标签"},
									-- { key = "comment", text = "大家说"} 
								}
				  }
	-- self._attachedView:showPopupThreeButtonMenuForSelectedScenicSpot(param)
	-- self._attachedView:showPopupTwoButtonMenuForSelectedScenicSpot(param)
	print(displayName, "当前选择的景点是。。。。。。。。。")
	self._attachedView:showPopupSingleButtonMenuForSelectedScenicSpot({ buttonName="intro",
																		buttonText="简介",
																		scenicSpotDisplayName=displayName })
end

function ScenicSpotsController:tappedPopupSingleButtonMenuAtScenicSpotWithName( buttonKey, scenicSpotName )
	local scenicSpotDataParam = { 
									
								  packData = self._parentController.city:getSightData(scenicSpotName),
								  cityData = QMapGlobal.systemData.mapData[self._parentController.city:getCityId()]
								}

	if buttonKey == "intro" then
		self._parentController.navigationController:push("SightDescriptionViewController", scenicSpotDataParam)

	elseif buttonKey == "label" then
		-- self._parentController.navigationController:push("SightLabelViewController", scenicSpotDataParam)

	elseif buttonKey == "comment" then
		-- self._parentController.navigationController:push("SightBrowseRemarkViewController", scenicSpotDataParam)

	end

	self:tappedElseWhere()
end

function ScenicSpotsController:tappedPopupThreeButtonMenuAtScenicSpotWithName(buttonKey, scenicSpotName)

	local scenicSpotDataParam = { 
									
								  packData = self._parentController.city:getSightData(scenicSpotName),
								  cityData = QMapGlobal.systemData.mapData[self._parentController.city:getCityId()]
								}

	if buttonKey == "intro" then
		self._parentController.navigationController:push("SightDescriptionViewController", scenicSpotDataParam)

	elseif buttonKey == "label" then
		self._parentController.navigationController:push("SightLabelViewController", scenicSpotDataParam)

	elseif buttonKey == "comment" then
		self._parentController.navigationController:push("SightBrowseRemarkViewController", scenicSpotDataParam)
	end

	self:tappedElseWhere()
end

function ScenicSpotsController:tapMenuButtonWithName(buttonName)

	if buttonName == "back102" then
		printf("ScenicSpotsController:tapMenuButtonWithName, back button tapped")
		-- self._attachedView:quitBarrage()
		-- self._parentController:switchBackToCitySelection()

		local downloadPath = cc.FileUtils:getInstance():getDownloadPath()
	    -- self.path = device.writablePath .. "map/" .. cityName .. "/image/" .. cityName 
	    local cityName = self._parentController.city:getMapName()
	    local path = downloadPath .. "map/" .. cityName .. "/image/" .. cityName
	    print("移除plist  ", path)
	    display.removeSpriteFramesWithFile(path ..".plist", path .. ".png")

	    
		self._parentController.navigationController:setControllerPathBase("")
		self._parentController.navigationController:switchTo( "app/citySelection/CitySelectionViewController", {cityid = self._parentController.city:getCityId()}, "fade" )

	elseif buttonName == "start" then
		self._parentController:switchMapToTravelNoteScenario()

	elseif buttonName == "record" then
		self._parentController:switchMapToCommentScenario()
	elseif buttonName == "shop" then

		local param = {cityID = self._parentController.city:getCityId()}
		param.callBack = function (  )
			self._attachedView:showMenu(true)
		end
		-- self:tappedElseWhere()
		self._attachedView:showMenu(false)
		self._parentController.navigationController:push("ShopController", param)

	-- elseif buttonName == "plan" then
	-- 	self._parentController:switchMapToTravelPlanScenario()
	elseif buttonName == "strategy" then
		print("攻略。。。。。。")
		local param = {cityID = self._parentController.city:getCityId(), cityName = self._parentController.city:getShowName()}
		param.callBack = function ( reParam )
			-- if reParam then
				-- local reType = reParam.type
				-- local index = reParam.index
				-- local posPer = reParam.posPer
				-- local param1 = {cityID = self._parentController.city:getCityId(), cardID = reParam.cardID, type = reParam.type, index = reParam.index}
				-- param1.callBack = function (  )
				-- 	-- self._attachedView:showMenu(true)
				-- 	param.type = reType
				-- 	param.index = index
				-- 	param.posPer = posPer
				-- 	self._parentController.navigationController:push("StrategyController", param)
				-- end
				-- self._parentController.navigationController:push("CardController", param1)
			-- else
				self._attachedView:showMenu(true)
			-- end
		end
		-- self:tappedElseWhere()
		self._attachedView:showMenu(false)
		self._parentController.navigationController:push("StrategyController", param)
	elseif buttonName == "swicthCity" then
		local downloadPath = cc.FileUtils:getInstance():getDownloadPath()
	    -- self.path = device.writablePath .. "map/" .. cityName .. "/image/" .. cityName 
	    local cityName = self._parentController.city:getMapName()
	    local path = downloadPath .. "map/" .. cityName .. "/image/" .. cityName
	    print("移除plist  ", path)
	    display.removeSpriteFramesWithFile(path ..".plist", path .. ".png")

	    
		self._parentController.navigationController:setControllerPathBase("")
		self._parentController.navigationController:switchTo( "app/citySelection/CitySelectionViewController", {cityid = self._parentController.city:getCityId()}, "fade" )
	elseif buttonName == "strategy1" then
		print("攻略。。。。。。")
		local param = {cityID = self._parentController.city:getCityId(), cityName = self._parentController.city:getShowName()}
		param.callBack = function ( reParam )

				self._attachedView:showMenu(true)
		end
		-- self:tappedElseWhere()
		self._attachedView:showMenu(false)
		self._parentController.navigationController:push("StrategyController", param)
		
	else
		printError("unexpected button: %s", buttonName)
	end
end

function ScenicSpotsController:WriteBarrage( callBack )
	-- print("function ScenicSpotsController:WriteBarrage( ... )")
	-- self._parentController.superior:addView("WriteBarrageController", {callBack = callBack})
	self._parentController.navigationController:push("WriteBarrageController", {cityid = self._parentController.city:getCityId(), sightid = self.curScenicSpotName, callBack = callBack})
end

function ScenicSpotsController:getBarrageData(callBack)
	local cityID = self._parentController.city:getCityId()
	-- local sightID = self._parentController.city:getSightData(self.curScenicSpotName)
	local sightID = self.curScenicSpotName
	QMapGlobal.DataManager:getLabelData(tonumber(cityID), tonumber(sightID), callBack)
	-- dump(datas)
end

return ScenicSpotsController
