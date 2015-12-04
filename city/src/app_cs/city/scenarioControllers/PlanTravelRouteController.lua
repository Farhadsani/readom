

local PlanTravelRouteController = class("PlanTravelRouteController")

function PlanTravelRouteController:ctor(parentController)
	self._parentController = parentController
end

function PlanTravelRouteController:getName()
	return self.__cname
end

function PlanTravelRouteController:attachView(view)
	self._attachedView = view
end

function PlanTravelRouteController:enter()
	self._attachedView:setDelegate(self)

	self._attachedView:setMapBackgroundToDark(true, true)
	self._attachedView:setMarkLayerPresentationTravelPlan()

	self._attachedView:switchToMenuForController(self:getName(), true, function()
		self:_showCachedTravelPlan()
		self._attachedView:setMapMarkLayerVisible(true)
	end)
end

function PlanTravelRouteController:quit()
	self._attachedView:dismissMapPopupMenu()
	self._attachedView:setMapBackgroundToDark(false, true)
	self._attachedView:clearAllMarks()
	self._attachedView:setMapMarkLayerVisible(false)
end

function PlanTravelRouteController:getValueForMenuLabelWithName(labelName)
	if labelName == "cityName" then
		return self._parentController.city:getDisplayName()
	else
		printError("label not defined: %s", labelName)
		return ""
	end
end

function PlanTravelRouteController:tappedScenicSpotWithName(scenicSpotName)
	-- find if this scenic spot added to route list
	local displayname = self._parentController.city:getSightDisplayName(scenicSpotName)
	if not displayname then 
		printInfo("the name of sight %s is nil, ", scenicSpotName)
	end

	local cityid = self._parentController.city:getCityId()
	
	-- local thisScenicSpotInRouteList = (self:_indexOfScenicSpotWithName(scenicSpotName) ~= -1)
	if QMapGlobal.DataManager:sightIsInItinerary(cityid, scenicSpotName) then
		self._attachedView:showPopupSingleButtonMenuForSelectedScenicSpot({ buttonName="remove",
																			buttonText="取消",
																			scenicSpotDisplayName = displayname })
	else
		self._attachedView:showPopupSingleButtonMenuForSelectedScenicSpot({ buttonName="add",
																			buttonText="采集",
																			scenicSpotDisplayName = displayname })
	end
end

function PlanTravelRouteController:_showCachedTravelPlan()

	local cityid = self._parentController.city:getCityId()
	local itinerarys = QMapGlobal.DataManager:getUserItinerary(cityid)

	self._attachedView:clearAllMarks()
	self._attachedView:addScenicSpotsNamesToTravelPlan(itinerarys)
end

function PlanTravelRouteController:tappedElseWhere()
	self._attachedView:dismissMapPopupMenu()
end

function PlanTravelRouteController:_addScenicSpotWithName(scenicSpotName)
	self._attachedView:addSelectedScenicSpotToRoutePlan()
	self._pickedScenicSpotNames = self._pickedScenicSpotNames or {}
	local nextIndex = #self._pickedScenicSpotNames + 1
	self._pickedScenicSpotNames[nextIndex] = scenicSpotName

    -- 向数据库添加行程记录
    local cityid = self._parentController.city:getCityId()
    -- local order = QMapGlobal.DataManager:getItineraryOrder(cityid)
    -- print("添加的order is ...", order)
    local param = {cityid = cityid, sightid = scenicSpotName}
    QMapGlobal.DataManager:addItinerary(param)
end

function PlanTravelRouteController:_removeScenicSpotWithName(scenicSpotName)
	self._attachedView:removeSelectedScenicSpotFromRoutePlan()
	local index = self:_indexOfScenicSpotWithName(scenicSpotName)
	if index ~= -1 then
		table.remove(self._pickedScenicSpotNames, index)
	end

	-- 删除数据库中行程记录
	local cityid = self._parentController.city:getCityId()
	local sightid = scenicSpotName
	QMapGlobal.DataManager:delItinerary(cityid, sightid)
end

-- 清除行程数据。。。。
function PlanTravelRouteController:_clearTravelPlan()
	self._pickedScenicSpotNames = {}
	self._attachedView:clearAllMarks()

	local cityid = self._parentController.city:getCityId()
	QMapGlobal.DataManager:delAllItinerary(cityid)
end

function PlanTravelRouteController:_indexOfScenicSpotWithName(scenicSpotName)
	if self._pickedScenicSpotNames then
		for index, name in pairs(self._pickedScenicSpotNames) do
			if name == scenicSpotName then
				return index
			end
		end
	end
	return -1
end

-- 采集，取消景点
function PlanTravelRouteController:tappedPopupSingleButtonMenuAtScenicSpotWithName(buttonName, scenicSpotName)
	-- printf("PlanTravelRouteController:tappedPopupSingleButtonMenuAtScenicSpotWithName %s", scenicSpotName)
	if buttonName == "add" then
		self:_addScenicSpotWithName(scenicSpotName)
	elseif buttonName == "remove" then
		self:_removeScenicSpotWithName(scenicSpotName)
	end
end

function PlanTravelRouteController:tapMenuButtonWithName(buttonName)
	
	if buttonName == "back" then
		self._parentController:switchMapToScenicSpotsScenario()

	elseif buttonName == "sort" then
		self._parentController.navigationController:push("SortTravelRouteViewController", 
														 { 	cityid = self._parentController.city:getCityId(), 
			  									  			onQuitCallback = function() self:_showCachedTravelPlan() end  })

	elseif buttonName == "delete" then
		self:_clearTravelPlan()

	else
		printError("PlanTravelRouteController:tapMenuButtonWithName unexpected button: %s", buttonName)
	end
end

return PlanTravelRouteController
