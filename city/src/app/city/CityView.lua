
local CityView = class("CityView", function()
    return display.newLayer()
end)

function CityView:ctor(param)
    self:_initUI(param)
end

function CityView:_initUI(param)
     -- map param
    local mapParam = param.mapParam or {}
    mapParam.mapName = param.cityData.name
    mapParam.cityID = param.cityid

    -- map layer
    self._mapLayer = require("app/views/MapLayer").new(mapParam)
    self._mapLayer:addTo(self)

    -- menu layer
    self._menuLayer = require("app/views/MenuLayer").new()
    self._menuLayer:addTo(self)
    self._menuLayer:setParentView(self)

    -- barrage layer
    -- self._barrageLayer = require("app/views/BarrageLayer").new()
    -- self._barrageLayer:addTo(self)
    -- self._barrageLayer:setVisible(false)

    -- 显示简介
    self._IntroduceLayer = require("app/views/IntroduceLayer").new()
    -- self._IntroduceLayer:setPosition(display.width/2, display.height/2)
    self._IntroduceLayer:setPosition(cc.p(0,0))
    self._IntroduceLayer:addTo(self)
    self._IntroduceLayer:setVisible(false)

    self:setKeypadEnabled(true)
    self:addNodeEventListener(cc.KEYPAD_EVENT, function(event)
        print("CityView    -------------------------")
        print_r(event)

        if event.key == "back" then
            -- if self._IntroduceLayer:isVisible() then
            --     self:showIntrduce(false)
            -- end
            self._delegate:onBack()
        end
    end)

end

function CityView:setDelegate(delegate)
    self._delegate = delegate
	self._menuLayer:setDelegate(delegate)
    self._mapLayer:setDelegate(delegate)
    -- self._barrageLayer:setDelegate(delegate)
    self._IntroduceLayer:setDelegate(delegate)
end

function CityView:showIntrduce( isShow , introData)
    -- self._IntroduceLayer:setVisible(isShow)
    if isShow then
        self._IntroduceLayer:onInit(introData)
    end

    self._IntroduceLayer:showAction(isShow)

    self:setSuspendVisible(not isShow)

    self:setMenuButtonsVisible("back", not isShow)

    self._mapLayer:introduceWillShow(isShow)
end

function CityView:showMenu( isShow )
    self._menuLayer:setVisible(isShow)
end

------ map layer recognition enabled
function CityView:setMapGestureRecognitionEnabled(enabled)
    self._mapLayer:setGestureRecognitionEnabled(enabled)
end

------ top, bottom menu
function CityView:menuQuit()
    self._menuLayer:menuQuit(animated)
end

function CityView:menuEnterForController(controllerName, animated, menuEnteredCallback)
    self._menuLayer:menuEnterForController(controllerName, animated, menuEnteredCallback)
end

function CityView:switchToMenuForController(controllerName, animated, menuEnteredCallback)
    self._menuLayer:switchToMenuForController(controllerName, animated, menuEnteredCallback)
end

function CityView:setMenuButtonsEnabled(buttonNames, enabled)
    for k, buttonName in pairs(buttonNames) do
        self._menuLayer:setButtonEnabled(buttonName, enabled)
    end
end

function CityView:setLocationLabel1( widgetName, value )
    self._menuLayer:setLocationLabel1(widgetName, value)
end

function CityView:setLocationLabel2( widgetName, value )
    self._menuLayer:setLocationLabel2(widgetName, value)
end

function CityView:setMenuCustomizeWidgetValue(widgetName, value)
    self._menuLayer:setWidgetValue(widgetName, value)
end

function CityView:setMenuButtonsVisible( buttonName, isVisible )
    self._menuLayer:setButtonVisible(buttonName, isVisible)
end

function CityView:setSuspendVisible( isVisible )
    self._menuLayer:setSuspendVisible(isVisible)
end

------ popup menu
function CityView:showPopupSingleButtonMenuForSelectedScenicSpot(param)
    self._mapLayer:showPopupSingleButtonMenuForSelectedScenicSpot(param)
end

function CityView:showPopupTwoButtonMenuForSelectedScenicSpot( param )
    self._mapLayer:showPopupTwoButtonMenuForSelectedScenicSpot(param)
end

function CityView:showPopupThreeButtonMenuForSelectedScenicSpot(param)
    self._mapLayer:showPopupThreeButtonMenuForSelectedScenicSpot(param)
end

function CityView:dismissMapPopupMenu()
    self._mapLayer:dismissPopupMenu()
end

function CityView:enterBarrage( ... )
    -- self._barrageLayer:setVisible(true)
    -- self._barrageLayer:showBarrageContent()
end

function CityView:quitBarrage( ... )
    -- self._barrageLayer:setVisible(false)
    -- self._barrageLayer:QuitBarrageContent()
end

function CityView:showBarrage( ... )
    -- body
end

function CityView:hideBarrage( ... )
    -- body
end

------ scenic spot high light
function CityView:setMapAllSenicSpotsFlash(flashed)
    self._mapLayer:setAllSenicSpotsFlash(flashed)
end

function CityView:setMapBackgroundToDark(dark, animated)
    self._mapLayer:setBackgroundMapToDark(dark, animated)
end

function CityView:setMapSelectedScenicSpotHighLighted(highLighted, animated, callback)
    self._mapLayer:highLightSelectedScenicSpotSprite(highLighted, animated, callback)
end

function CityView:clearScenicSpotWithNameAboveLocationMask(spriteName, animated)
    self._mapLayer:clearScenicSpotWithNameAboveLocationMask(spriteName, animated)
end

------ mark layer
function CityView:setMapMarkLayerVisible(visible)
    self._mapLayer:setMarkLayerVisible(visible)
end

function CityView:clearAllMarks()
    self._mapLayer:clearAllMarks()
end

function CityView:setMarkLayerPresentationTravelPlan()
    self._mapLayer:setMarkLayerPresentationTravelPlan()
end

function CityView:setMarkLayerPresentationTravelNote()
    self._mapLayer:setMarkLayerPresentationTravelNote()
end

function CityView:addScenicSpotsNamesToTravelPlan(scenicSpotNames)
    self._mapLayer:addScenicSpotsNamesToTravelPlan(scenicSpotNames)
end

function CityView:addScenicSpotsDataToTravelNote(data)
    self._mapLayer:addScenicSpotsDataToTravelNote(data)
end

function CityView:addSelectedScenicSpotToRoutePlan()
    self._mapLayer:addSelectedScenicSpotToRoutePlan()
end

function CityView:removeSelectedScenicSpotFromRoutePlan()
    self._mapLayer:removeSelectedScenicSpotFromRoutePlan()
end

------ show message
function CityView:_createOkButtonMessageNode(message, messageKey)

    local messageNode = cc.uiloader:load("ui/oneBtnMsg.csb")
    local pnlBG = messageNode:getChildByName("pnlBG")
    local txtMsg = pnlBG:getChildByName("txtMsg")
    local btnOK = pnlBG:getChildByName("btnOK")
    txtMsg:setString(message)

    btnOK:addTouchEventListener(function(sender, event)
        if event == 2 then
            messageNode:removeFromParent()
            -- table.remove(self._messageNodes, messageKey)
            self._messageNodes[messageKey] = nil
            self._delegate:messageDismissed(messageKey, "")
        end
    end)

    return messageNode
end

function CityView:_createSimpleMessageNode(message, messageKey)
    local messageNode = cc.uiloader:load("ui/messageBox.csb")
    local txtMsg = messageNode:getChildByName("pnlBG"):getChildByName("txtMsg")
    txtMsg:setString(message)

    return messageNode
end

function CityView:_showMessage(messageCreateFunc, message, messageKey, autoClose)

    self._messageNodes = self._messageNodes or {}

    if not self._messageNodes[messageKey] then

        local messageNode = messageCreateFunc(message, messageKey)
        messageNode:setPosition(cc.p(display.width/2, display.height/2))
        messageNode:addTo(self)
        self._messageNodes[messageKey] = messageNode

        if autoClose then

            local delay = cc.DelayTime:create(1.5)
            local fadeOut = cc.FadeOut:create(0.3)
            local closeCall = cc.CallFunc:create(function()
                -- table.remove(self._messageNodes, messageKey)
                self._messageNodes[messageKey] = nil
                messageNode:removeFromParent()
            end)
            messageNode:runAction(cc.Sequence:create(delay,fadeOut, closeCall))
        end
    end
end

function CityView:showOkButtonMessage(message, messageKey)
    self:_showMessage(handler(self, self._createOkButtonMessageNode), message, messageKey, false)
end

function CityView:showAutoCloseMessage(message, messageKey)
    self:_showMessage(handler(self, self._createSimpleMessageNode), message, messageKey, true)
end

------ enter, exit
function CityView:onEnter()
    print("CitySelectionView onenter()")
end

function CityView:onExit()
    print("CitySelectionView onExit()")
end

return CityView
