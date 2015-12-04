local PopupMenuLayer = class("PopupMenuLayer", function()
    return display.newNode()
end)

function PopupMenuLayer:ctor(param)
end

function PopupMenuLayer:setDelegate(delegate)
    self._delegate = delegate
end

function PopupMenuLayer:setMapDisableTouchFunc(disableFunc)
    self._mapDisableTouchFunc = disableFunc
end

function PopupMenuLayer:setMapEnableTouchFunc(enableFunc)
    self._mapEnableTouchFunc = enableFunc
end

function PopupMenuLayer:dismissPopupMenu(animated)
    self:removeAllChildren()
    self._currentPopupMenu = nil
end

function PopupMenuLayer:_startShowAnimationForMenuNode(delay, node)
    node:setScale(0.5)
    node:setOpacity(0)

    local fadeIn = cc.FadeIn:create(0.3)
    local scaleUp = cc.ScaleTo:create(0.2, 1.1)
    local scaleDown = cc.ScaleTo:create(0.05, 1.0)
    local scale = cc.Sequence:create(scaleUp, scaleDown)

    local spawn = cc.Spawn:create(fadeIn, scale)
    if delay > 0 then
        local delayAction = cc.DelayTime:create(delay)
        node:runAction(cc.Sequence:create(delayAction, spawn))
    else
        node:runAction(spawn)
    end
end

function PopupMenuLayer:showSingleButtonAtPoint(point, param, scenicSpotName, boundingBoxCheckCallback)

    self:dismissPopupMenu()

    local popupMenu = require("app/views/PopupSingleButton").new()
    popupMenu:setMapEnableDisableTouchFunc(self._mapEnableTouchFunc, self._mapDisableTouchFunc)
    popupMenu:setPosition(point)
    print(param.scenicSpotDisplayName, "..................")
    popupMenu:setCaptionText(param.scenicSpotDisplayName)
    popupMenu:setButtonText(param.buttonText)
    popupMenu:addTo(self)

    popupMenu:setButtonClickedCallback(function()
            self:dismissPopupMenu(false)
            self._delegate:tappedPopupSingleButtonMenuAtScenicSpotWithName(param.buttonName, scenicSpotName)
    end)

    local params = boundingBoxCheckCallback(popupMenu:getCascadeBoundingBox())
    popupMenu:setPopDirection(params.popDirection)
    
    self._currentPopupMenu = popupMenu

    self:_startShowAnimationForMenuNode(params.animationDelay, popupMenu)
end

function PopupMenuLayer:showTwoButtonAtPoint(point, param, scenicSpotName, boundingBoxCheckCallback)

    self:dismissPopupMenu()

    local popupMenu = require("app/views/PopupTwoButton").new()
    popupMenu:setMapEnableDisableTouchFunc(self._mapEnableTouchFunc, self._mapDisableTouchFunc)

    popupMenu:setButtonText(1, param.buttonNames[1].text)
    popupMenu:setButtonText(2, param.buttonNames[2].text)
    popupMenu:setCaptionText(param.scenicSpotDisplayName)

    popupMenu:setPosition(point)
    popupMenu:addTo(self)

    popupMenu:setButtonsTapCallback(function(buttonIndex)
        self:dismissPopupMenu(false)
        self._delegate:tappedPopupThreeButtonMenuAtScenicSpotWithName(param.buttonNames[buttonIndex].key, scenicSpotName)
    end)

    local params = boundingBoxCheckCallback(popupMenu:getCascadeBoundingBox())
    popupMenu:setPopDirection(params.popDirection)

    self._currentPopupMenu = popupMenu

    self:_startShowAnimationForMenuNode(params.animationDelay, popupMenu)
end

function PopupMenuLayer:showThreeButtonAtPoint(point, param, scenicSpotName, boundingBoxCheckCallback)

	self:dismissPopupMenu()

    local popupMenu = require("app/views/PopupThreeButton").new()
    popupMenu:setMapEnableDisableTouchFunc(self._mapEnableTouchFunc, self._mapDisableTouchFunc)

    popupMenu:setButtonText(1, param.buttonNames[1].text)
    popupMenu:setButtonText(2, param.buttonNames[2].text)
    popupMenu:setButtonText(3, param.buttonNames[3].text)
    popupMenu:setCaptionText(param.scenicSpotDisplayName)

    popupMenu:setPosition(point)
    popupMenu:addTo(self)

    popupMenu:setButtonsTapCallback(function(buttonIndex)
        self:dismissPopupMenu(false)
        self._delegate:tappedPopupThreeButtonMenuAtScenicSpotWithName(param.buttonNames[buttonIndex].key, scenicSpotName)
    end)

    local params = boundingBoxCheckCallback(popupMenu:getCascadeBoundingBox())
    popupMenu:setPopDirection(params.popDirection)

    self._currentPopupMenu = popupMenu

    self:_startShowAnimationForMenuNode(params.animationDelay, popupMenu)
end

function PopupMenuLayer:deltaMove(delta)
    local currentPosition = cc.p(self:getPosition())
    self:setPosition(cc.pAdd(currentPosition, delta))
end

function PopupMenuLayer:updatePopupMenuItemPosition(position)
    if self._currentPopupMenu then
        self._currentPopupMenu:setPosition(position)
    end
end

return PopupMenuLayer
