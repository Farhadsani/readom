local TravelCommentController = class("TravelCommentController")

function TravelCommentController:ctor(parentController)
	self._parentController = parentController
end

function TravelCommentController:getName()
	return self.__cname
end

function TravelCommentController:attachView(view)
	self._attachedView = view
end

function TravelCommentController:enter()
	self._attachedView:setDelegate(self)
	self._attachedView:switchToMenuForController(self:getName(), true)
	self._attachedView:setMapBackgroundToDark(true, true)
end

function TravelCommentController:quit()
	self._attachedView:dismissMapPopupMenu()
	self._attachedView:setMapBackgroundToDark(false, true)
end

function TravelCommentController:getValueForMenuLabelWithName(labelName)
	if labelName == "cityName" then
		return self._parentController.city:getDisplayName()
	else
		printError("label not defined: %s", labelName)
		return ""
	end
end

function TravelCommentController:tappedScenicSpotWithName(scenicSpotName)

	local displayname = self._parentController.city:getSightDisplayName(scenicSpotName)
	if not displayname then 
		printInfo("the name of sight %s is nil, ", scenicSpotName)
	end

	self._attachedView:showPopupSingleButtonMenuForSelectedScenicSpot({ buttonName="comment",
																		buttonText="说说",
																		scenicSpotDisplayName=displayname })
end

function TravelCommentController:tappedElseWhere()
	self._attachedView:dismissMapPopupMenu()
end

function TravelCommentController:tappedPopupSingleButtonMenuAtScenicSpotWithName(buttonName, scenicSpotName)

	self._parentController.navigationController:push("AddSightRemarkViewController", {	cityid = self._parentController.city:getCityId(),
																			 			packid = scenicSpotName  })

	-- self._parentController.navigationController:push("EditMarkController", {	cityid = self._parentController.city:getCityId(),
	-- 																		 			packid = scenicSpotName  })
end

function TravelCommentController:tapMenuButtonWithName(buttonName)
	
	if buttonName == "back" then
		self._parentController:switchMapToScenicSpotsScenario()

	elseif buttonName == "edit" then
		self._parentController.navigationController:push("EditSightRemarkViewController", {cityid = self._parentController.city:getCityId()})

	elseif buttonName == "publish" then
		QMapGlobal.DataManager:publishJourney(self._parentController.city:getCityId(), function()
			self:showPublishModalMessage()
		end)
		
	else
		printError("unexpected button: %s", buttonName)
	end
end

function TravelCommentController:showPublishModalMessage()
	self._attachedView:setMenuButtonsEnabled({a="back", b="edit", c="publish"}, false)
	self._attachedView:showOkButtonMessage("发布后别人将能浏览到你的游记", "publish")
end

function TravelCommentController:messageDismissed(messageKey, returnValue)
	if messageKey == "publish" then
		self._attachedView:setMenuButtonsEnabled({a="back", b="edit", c="publish"}, true)
	end
end

return TravelCommentController
