local QMapAction = {
    NODE_SCALE_ACTION_TAG = 100,
    SPRITE_FADE_ACTION_TAG = 200,
    SPRITE_TINT_ACTION_TAG = 300
}

QMapGlobal.Action = QMapAction

function QMapAction.appendCallbackToAction(action, callback, actionTag)
    if callback then
        local returnAction = cca.seq({action, cca.callFunc(callback)})
        returnAction:setTag(actionTag)
        return returnAction
    else
        action:setTag(actionTag)
        return action
    end
end

function QMapAction:startToAnimation(node, param)
    node:stopActionByTag(param.actionTag)
    local currentValue = param.getValueFunction(node)
    if currentValue ~= param.toValue then
        local valueDelta = math.abs(param.toValue - currentValue)
        local timeFraction = param.actionDurationMax * valueDelta / param.valueDeltaMax
        local action = param.createActionFunction(timeFraction, param.toValue)
        local wrapedAction = self.appendCallbackToAction(action, param.actionCallback, param.actionTag)
        node:runAction(wrapedAction) 
    else
        if param.actionCallback then param.actionCallback() end
    end
end

function QMapAction.print(param)
    for k, v in pairs(param) do
        print(k..":  ", v)
    end
end

function QMapAction:startFadeToAnimation(sprite, toOpacity, opacityDeltaMax, durationMax, callback)
    local param = {
        actionTag = self.SPRITE_FADE_ACTION_TAG,
        getValueFunction = function(node) return node:getOpacity()/255 end,
        createActionFunction = cca.fadeTo,
        toValue = toOpacity,
        valueDeltaMax = opacityDeltaMax,
        actionDurationMax = durationMax,
        actionCallback = callback
    }
    self:startToAnimation(sprite, param)
end

function QMapAction:stopFadeAnimation(srpite)
    sprite:stopActionByTag(self.SPRITE_FADE_ACTION_TAG)
end

function QMapAction:startScaleToAnimation(node, toScale, scaleDeltaMax, durationMax, callback)
    local param = {
        actionTag = self.NODE_SCALE_ACTION_TAG,
        getValueFunction = function(node) return node:getScale() end,
        createActionFunction = cca.scaleTo,
        toValue = toScale,
        valueDeltaMax = scaleDeltaMax,
        actionDurationMax = durationMax,
        actionCallback = callback
    }
    self:startToAnimation(node, param)
end

function QMapAction:stopScaleAnimation(node)
    node:stopActionByTag(self.NODE_SCALE_ACTION_TAG)
end

function QMapAction:startTintColorFlashAnimation(node, toTintColor, cycleDuration)
    node:stopActionByTag(self.SPRITE_TINT_ACTION_TAG)
    local tintTo = cc.TintTo:create(cycleDuration/2, toTintColor.r, toTintColor.g, toTintColor.b)
    local tintBack = cc.TintTo:create(cycleDuration/2, 255, 255, 255)
    local sequence = cc.Sequence:create(tintTo, tintBack)
    local repeatFlash = cc.RepeatForever:create(sequence)
    repeatFlash:setTag(self.SPRITE_TINT_ACTION_TAG)
    node:runAction(repeatFlash)
end

function QMapAction:stopTintColorFlashAnimation(node)
    node:stopActionByTag(self.SPRITE_TINT_ACTION_TAG)
    if node:getColor().r < 255 then
        local tintBack = cc.TintTo:create(0.2, 255, 255, 255)
        tintBack:setTag(self.SPRITE_TINT_ACTION_TAG)
        node:runAction(tintBack)
    end
end

return QMapAction
