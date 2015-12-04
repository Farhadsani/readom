local BrowseTravelNoteController = class("BrowseTravelNoteController")

function BrowseTravelNoteController:ctor(parentController)
	self._parentController = parentController
end

function BrowseTravelNoteController:getName()
	return self.__cname
end

function BrowseTravelNoteController:attachView(view)
	self._attachedView = view
end

function BrowseTravelNoteController:enter()
	self._attachedView:setDelegate(self)
	
	self._attachedView:setMapBackgroundToDark(true, true)
	self._attachedView:setMarkLayerPresentationTravelNote()

	self:_loadNextTravelNote(function (  )
		self._attachedView:switchToMenuForController(self:getName(), true, function()
			self:_showLoadedTravelNote()
			self._attachedView:setMapMarkLayerVisible(true)
		end)
	end, function (  )
		device.showAlert("连接服务器出错!", "无法获取服务器数据！", {"关闭"}, function ( event )
            if event.buttonIndex == 1 then
            	device.cancelAlert()
            	self._parentController:switchMapToScenicSpotsScenario()
            end
        end)
		
	end)
	
end

function BrowseTravelNoteController:quit()
	self._attachedView:setMapBackgroundToDark(false, true)
	self._attachedView:setMapMarkLayerVisible(false)
end

function BrowseTravelNoteController:_showNextTravelNote()
	self:_loadNextTravelNote(handler(self, self._showLoadedTravelNote))
end

function BrowseTravelNoteController:_loadNextTravelNote(callback, callbackFail)
	local userid = 1111 -- next userid
	self._journey = require("app/data/Journey").new(self._parentController.city:getCityId(), userid, callback, callbackFail)
end

function BrowseTravelNoteController:_updateMenuWidget( )
		local userHead = "user/"..self._journey:getAuthorid()..".jpg"
		local value = {	cityname = self._parentController.city:getDisplayName(), 
						username = self._journey:getUserName(),
						desc = self._journey:getDesc(), 
						image = userHead
					  }
		self._attachedView:setMenuCustomizeWidgetValue("jouneyWidget", value)
end

function BrowseTravelNoteController:_showLoadedTravelNote()
	if not self._journey:getData() then
		self._parentController:switchMapToScenicSpotsScenario()
		return 
	end

	local orderedSightIds = self._journey:getOrderedSightIds()

	if not orderedSightIds then
		printError("no sightid found in journey")
		return
	end

	self:_updateMenuWidget()

	if QMapGlobal.DataManager:isJourneyCollect(self._journey:getAuthorid(), self._journey:getCityID(), 1) then
		self._attachedView:setMenuButtonsEnabled({"addFavorite"}, false)
	else
		self._attachedView:setMenuButtonsEnabled({"addFavorite"}, true)
	end
	dump(orderedSightIds)
	local travelNoteScreenData = {}
	for index = 1, #orderedSightIds do
		local imagePath = self._journey:getThumbnailPathForImage(orderedSightIds[index], tostring(orderedSightIds[index]) .. "_" .. "2_1.jpg")
		if not cc.FileUtils:getInstance():isFileExist(imagePath) then
			print("imagePath", imagePath, " not exist!")
			imagePath = nil
		end
		travelNoteScreenData[index] = { scenicSpotName = tostring(orderedSightIds[index]),
										imagePath = imagePath }
	end
	-- print("..........................")
	self._attachedView:clearAllMarks()
	-- dump(travelNoteScreenData)
	self._attachedView:addScenicSpotsDataToTravelNote(travelNoteScreenData)
end

function BrowseTravelNoteController:getValueForCustomizedWidgetWithName(name)
	if name == "jouneyWidget" then
		-- param format: {cityname = [city name], username = [some one], desc = [user self description], image = [user head image]}
		local userImage = "user/"..self._journey:getAuthorid()..".jpg"
		return {	cityname = self._parentController.city:getDisplayName(), 
					username = self._journey:getUserName(),
					desc = self._journey:getDesc(), 
					image = userImage
				}
	else
		printError("widget not defined: %s", name or "nil")
		return nil
	end
end

function BrowseTravelNoteController:getValueForMenuLabelWithName(labelName)
	if labelName == "cityName" then
		return self._parentController.city:getDisplayName()
	else
		printError("label not defined: %s", labelName)
		return ""
	end
end

function BrowseTravelNoteController:tappedElseWhere()
	-- printf("tap elsewhere")
end

function BrowseTravelNoteController:tappedScenicSpotWithName(scenicSpotName)
	-- printf("BrowseTravelNoteController:tappedScenicSpotWithName %s", scenicSpotName)
end

function BrowseTravelNoteController:tappedPhotoThumbnailWithScenicSpothName(scenicSpotName)
	printf("BrowseTravelNoteController:tappedPhotoThumbnailWithScenicSpothName %s", scenicSpotName)

	local orderedSightIds = self._journey:getOrderedSightIds()

	if not orderedSightIds then
		printError("no sightid found in journey")
		return
	end

	self:_updateMenuWidget()

	local travelNoteScreenData = {}
	local order = 1
	for index = 1, #orderedSightIds do
		if tostring(orderedSightIds[index]) == scenicSpotName then
			order = index
			break
		end
	end

	local param = { 
					cityid = self._parentController.city:getCityId(),
					packData = self._parentController.city:getSightData(scenicSpotName),
					cityData = QMapGlobal.systemData.mapData[self._parentController.city:getCityId()],
					journey = self._journey,
					order = order
				  }

	self._parentController.navigationController:push("BrowseTravelNoteInfoController", param)
end

function BrowseTravelNoteController:tapMenuButtonWithName(buttonName)

	if buttonName == "roundBack" then
		self._parentController:switchMapToScenicSpotsScenario()

	elseif buttonName == "addFavorite" then
		
		self._attachedView:showAutoCloseMessage("已收藏", "addFavorite")
		QMapGlobal.DataManager:collectJourney(self._journey:getAuthorid(), self._journey:getCityID(), 1) 
		self._attachedView:setMenuButtonsEnabled({"addFavorite"}, false)

	elseif buttonName == "next" then
		self:_showNextTravelNote()

	else
		-- printError("BrowseTravelNoteController:tapMenuButtonWithName unexpected button: %s", buttonName)
	end
end

return BrowseTravelNoteController
