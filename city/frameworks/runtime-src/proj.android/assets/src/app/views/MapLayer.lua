
local MapLayer = class("MapLayer", function()
    return display.newLayer()
end)

function MapLayer:ctor(param)

    -- dump(param)
    -- print("------------------------------")

    self.cityID = param.cityID

    -- map top bottom fill blank margin
    self._topFillMargin = 100
    self._bottomFillMargin = 200
    
    -- map color background
    self._colorBackgroundTop = cc.LayerColor:create(param.top)
    self:addChild(self._colorBackgroundTop, 1)
    self._colorBackgroundBottom = cc.LayerColor:create(param.bottom)
    self._colorBackgroundBottom:setContentSize(cc.size(display.width, display.height/2))
    self:addChild(self._colorBackgroundBottom, 1)

    -- map root from csb
    local downloadPath = cc.FileUtils:getInstance():getDownloadPath()
    -- local csbMapPathName = device.writablePath ..  "map/" .. param.mapName .. "/" .. param.mapName .. ".csb"

    local csbMap = QMapGlobal.resFile.csb.map:gsub("?", param.mapName)
    local csbMapPathName = downloadPath ..  csbMap
    self._mapRoot = cc.uiloader:load(csbMapPathName)
    self._mapRoot:setPosition(cc.p(display.width/2, display.height/2))
    self:addChild(self._mapRoot, 2)

    -- map node(map image sprite)
    self._mapNode = self._mapRoot:getChildByName("map")
    -- local mapPath = device.writablePath .. "map/" .. param.mapName .. "/image/" .. param.mapName .. "map.jpg"
    local jpgMap = QMapGlobal.resFile.image.map:gsub("?", param.mapName)
    local mapPath = downloadPath .. jpgMap
    self._mapNode:setTexture(mapPath)
    
    -- background map mask which apply just above map image
    self._bgMapMask = cc.LayerColor:create(cc.c4b(0, 0, 0, 0))
    local mapContentSize = self._mapNode:getContentSize()
    local maskHeight = mapContentSize.height + (self._topFillMargin + self._bottomFillMargin) * 2
    self._maskOffsetY = self._bottomFillMargin * 2
    self._bgMapMask:setContentSize(cc.size(mapContentSize.width, maskHeight))
    self._bgMapMask:setAnchorPoint(0, 0)
    self._bgMapMask:setPosition(cc.p(0, -self._maskOffsetY))
    self._mapNode:addChild(self._bgMapMask, 1)
    self._bgMapMask:setVisible(false)
    self._bgMapDarkened = false

    -- map locations(contains view spot sprite children)
    self._locations = self._mapNode:getChildByName("locations")
    self._locations:setLocalZOrder(2)
    self:_setupScenicSpotNameToSpriteMap()

    -- locations mask which is above locations layer
    self._locationsMask = cc.LayerColor:create(cc.c4b(0, 0, 0, 0))
    local mapContentSize = self._mapNode:getContentSize()
    self._locationsMask:setContentSize(cc.size(mapContentSize.width, maskHeight))
    self._locationsMask:setAnchorPoint(0, 0)
    self._locationsMask:setPosition(cc.p(0, -self._maskOffsetY))
    self._mapNode:addChild(self._locationsMask, 3)
    self._locationsMask:setVisible(false)
    self._locationsDarkened = false

    -- mark layer
    self._markLayer = require("app/views/MapMarkLayer").new()
    self._markLayer:addTo(self._mapRoot)
    self._markLayer:setMapSpaceToMarkSpaceConvertFunc(function(pointInMapSpace)
        return self._markLayer:convertToNodeSpace(self._locations:convertToWorldSpace(pointInMapSpace))
    end)


    self:addMarkNameLayer()

    -- popup menu layer
    self._popupMenuLayer = require("app/views/PopupMenuLayer").new()
    self._popupMenuLayer:addTo(self._mapRoot)
    self._popupMenuLayer:setMapEnableTouchFunc(function()
        self:setGestureRecognitionEnabled(true)
    end)    
    self._popupMenuLayer:setMapDisableTouchFunc(function()
        self:setGestureRecognitionEnabled(false)
    end)

    -- event handler delegate
    self._delegate = QMapGlobal.app.navigationController.activeViewController
    self:_initEvents()

    -- map scale property init
    self:_calculateZoomLevelScales(3, 2)
    self:_setMapScaleToLevelWithIndex(1, false)
    self:_calculateMapBottomLeftPropertiesAccordingToScale(self._mapNode:getScale())
end

function MapLayer:addMarkNameLayer( ... )
    if not self._markNameLayer then
        self._markNameLayer = require("app/views/MapMarkName").new()
        self._markNameLayer:addTo(self._mapRoot)
    end

    self.nameLayerIsShow = false
    self.prohibitNameLayerShow = false

    local datas = {}
    local allSprites = self._locations:getChildren()
    if allSprites then
        for k, sprite in pairs(allSprites) do
            local x,y = sprite:getPosition()
            local newPos = self._markNameLayer:convertToNodeSpace(self._locations:convertToWorldSpace(cc.p(x,y)))

            local showName = QMapGlobal.DataManager:getShowNameForSight( self.cityID, tonumber(sprite:getName()))
            table.insert(datas, {cname = showName, pos = newPos, sprite = sprite})
        end
    end
    self._markNameLayer:setMapSpaceToMarkSpaceConvertFunc(function(pointInMapSpace)
        return self._markNameLayer:convertToNodeSpace(self._locations:convertToWorldSpace(pointInMapSpace))
    end)

    self._markNameLayer:showName(datas)
    self._markNameLayer:setNameVisible(false)
end

function MapLayer:setDelegate(delegate)
    self._delegate = delegate
    self._markLayer:setDelegate(delegate)
    self._popupMenuLayer:setDelegate(delegate)
end

function MapLayer:setMarkLayerVisible(visible)
    self._markLayer:setVisible(visible)
end

------ scenic spots map(name -> sprite)
function MapLayer:_setupScenicSpotNameToSpriteMap()
    self._scenicSpotsNameToSpriteMap = self._scenicSpotsNameToSpriteMap or {}
    local allSprites = self._locations:getChildren()
    for k, sprite in pairs(allSprites) do
        self._scenicSpotsNameToSpriteMap[sprite:getName()] = sprite
    end
end

------ pop up menu
function MapLayer:getSelectedScenicSpot()
    return self._selectedScenicSpot
end

function MapLayer:_updatePopupMenu()
    if self._selectedScenicSpot then
        self._popupMenuLayer:updatePopupMenuItemPosition(self:_convertSelectedScenicSpotPositionToPopupMenuLayer())
    end
end

function MapLayer:_popupMenuItemBoundingCheck(boundingBox)

    local rectBLPoint = cc.p(boundingBox.x, boundingBox.y)
    local rectTRPoint = cc.p(rectBLPoint.x + boundingBox.width, rectBLPoint.y + boundingBox.height)

    local leftRightMargin = 20
    local topMargin = 300
    local bottomMargin = 400
    local mapMoveDelta = { x = 0, y = 0}

    local needXMoveAnimation = true
    if rectBLPoint.x < 0 then
        mapMoveDelta.x = -rectBLPoint.x + leftRightMargin
    elseif rectTRPoint.x > display.width then
        mapMoveDelta.x = display.width - rectTRPoint.x - leftRightMargin
    else
        needXMoveAnimation = false
    end

    local needYMoveAnimation = true
    local popDir = "top"
    if rectBLPoint.y < bottomMargin then
        mapMoveDelta.y = -rectBLPoint.y + bottomMargin
    elseif rectTRPoint.y > display.height - topMargin then
        mapMoveDelta.y = display.height - rectTRPoint.y - topMargin
        if self._mapCurrentSBLPosition.y + mapMoveDelta.y < self._mapSBLMinY then
            mapMoveDelta.y = (self._mapSBLMinY - self._mapCurrentSBLPosition.y) * 0.6
            popDir = "bottom"
        end

    else
        needYMoveAnimation = false
    end

    local moveAnimationTime = 0
    if (needXMoveAnimation or needYMoveAnimation) then
        moveAnimationTime = 0.3
        self:_startMapDeltaAnimation(moveAnimationTime, mapMoveDelta)
    end
    return { animationDelay = moveAnimationTime, popDirection = popDir }
end

function MapLayer:_convertSelectedScenicSpotPositionToPopupMenuLayer()
    local scenicSpotPositionWS = self._locations:convertToWorldSpace(cc.p(self._selectedScenicSpot:getPosition()))
    return self._popupMenuLayer:convertToNodeSpace(scenicSpotPositionWS)
end

function MapLayer:showPopupSingleButtonMenuForSelectedScenicSpot(param)
    if not self._selectedScenicSpot then
        printError("popup comment menu unexpected, no selected scenic spot")
    else
        local popupPoint = self:_convertSelectedScenicSpotPositionToPopupMenuLayer()
        dump(param)
        self._popupMenuLayer:showSingleButtonAtPoint(popupPoint, param, self._selectedScenicSpot:getName(),
                                                     handler(self, self._popupMenuItemBoundingCheck))
    end
end

function MapLayer:showPopupTwoButtonMenuForSelectedScenicSpot(param)
    if not self._selectedScenicSpot then
        printError("popup comment menu unexpected, no selected scenic spot")
    else
        local popupPoint = self:_convertSelectedScenicSpotPositionToPopupMenuLayer()
        self._popupMenuLayer:showTwoButtonAtPoint(popupPoint, param, self._selectedScenicSpot:getName(),
                                                    handler(self, self._popupMenuItemBoundingCheck))
    end
end

function MapLayer:showPopupThreeButtonMenuForSelectedScenicSpot(param)
    if not self._selectedScenicSpot then
        printError("popup comment menu unexpected, no selected scenic spot")
    else
        local popupPoint = self:_convertSelectedScenicSpotPositionToPopupMenuLayer()
        self._popupMenuLayer:showThreeButtonAtPoint(popupPoint, param, self._selectedScenicSpot:getName(),
                                                    handler(self, self._popupMenuItemBoundingCheck))
    end
end

function MapLayer:dismissPopupMenu()
    self._popupMenuLayer:dismissPopupMenu()
end

------ scenic spots breathing flash
function MapLayer:setAllSenicSpotsFlash(flashed)

    if self._allSenicSpotsFlash ~= flashed then
        -- print("&&&&&&&&&&&&&&&*******")
        local children = self._locations:getChildren()
        if flashed then
            for k, node in pairs(children) do
                -- print("&&&&&&&&&&&&&&&&&&")
                QMapGlobal.Action:startTintColorFlashAnimation(node, cc.c3b(160, 160, 160), 1.5)
            end
        else
            for k, node in pairs(children) do
                QMapGlobal.Action:stopTintColorFlashAnimation(node)
            end
        end

        self._allSenicSpotsFlash = flashed
    end
end

------ background map mask
function MapLayer:_bgMapMaskToTransparentDone()
    self._bgMapMask:setVisible(false)
    self._bgMapDarkened = false
end

function MapLayer:_bgMapMaskToDarkDone()
    self._bgMapDarkened = true
end

function MapLayer:_setNodeToDark(node, dark, animated, toDarkCallback, toTransparentCallback)
    if animated then
        if dark then
            node:setVisible(true)
            QMapGlobal.Action:startFadeToAnimation(node, 150/255, 0.4, 0.2, toDarkCallback)
        else
            QMapGlobal.Action:startFadeToAnimation(node, 0, 0.4, 0.2, toTransparentCallback)
        end
    else
        if dark then
            node:setVisible(true)
            node:setOpacity(150)
            toDarkCallback()
        else
            node:setOpacity(0)
            toTransparentCallback()
        end
    end
end

function MapLayer:setBackgroundMapToDark(dark, animated)
    self:_setNodeToDark(self._bgMapMask, dark, animated,
                        handler(self, self._bgMapMaskToDarkDone),
                        handler(self, self._bgMapMaskToTransparentDone))
end

------ locations mask and view spot sprite show above locations mask
function MapLayer:_locationsMaskChangeDarknessDoneCallback()
    if self._locationsMaskAnimationCallback then
        self._locationsMaskAnimationCallback()
    end
end

function MapLayer:_locationsMaskToTransparentDone()
    self._locationsMask:setVisible(false)
    self._locationsMask:removeAllChildren()
    self._locationsMaskHasScenicSpotSpriteAdded = false
    self._locationsDarkened = false
    self:_locationsMaskChangeDarknessDoneCallback()
end

function MapLayer:_locationsMaskToDarkDone()
    self._locationsDarkened = true
    self:_locationsMaskChangeDarknessDoneCallback()
end

function MapLayer:_setLocationsMaskToDark(dark, animated)
    if self._locationsDarkened ~= dark then
        self:_setNodeToDark(self._locationsMask, dark, animated,
                            handler(self, self._locationsMaskToDarkDone),
                            handler(self, self._locationsMaskToTransparentDone))
    else
        if dark then
            self:_locationsMaskToDarkDone()
        else
            self:_locationsMaskToTransparentDone()
        end
    end
end

function MapLayer:_addSenicSpotCloneAboveLocationsMask(sprite)
    local duplicatedSprite = display.newSprite(sprite:getSpriteFrame())
    local posX, posY = sprite:getPosition()
    duplicatedSprite:setPosition(cc.p(posX, posY + self._maskOffsetY))
    duplicatedSprite:setName(sprite:getName())
    self._locationsMask:addChild(duplicatedSprite)
end

function MapLayer:_clearScenicSpotAboveLocationMask(sprite, animated)
    if animated then
        local fadeOut = cc.FadeOut:create(0.2)
        local fadeOutDone = cc.CallFunc:create(function()
            sprite:removeFromParent()
        end)
        sprite:runAction(cc.Sequence:create(fadeOut, fadeOutDone))
    else 
        sprite:removeFromParent()
    end
    self._locationsMaskHasScenicSpotSpriteAdded = false
end

function MapLayer:clearScenicSpotWithNameAboveLocationMask(spriteName, animated)
    local children = self._locationsMask:getChildren()
    for k, node in pairs(children) do
        if spriteName == node:getName() then
            self:_clearScenicSpotAboveLocationMask(node, animated)
            return
        end
    end
end

function MapLayer:_addSelectedScenicSpotSpriteAboveLocationMask()
    if not self._locationsMaskHasScenicSpotSpriteAdded then
        self:_addSenicSpotCloneAboveLocationsMask(self._selectedScenicSpot)
        self._locationsMaskHasScenicSpotSpriteAdded = true
    end
end

function MapLayer:highLightSelectedScenicSpotSprite(highLighted, animated, callback)
    if self._selectedScenicSpot then
        self._locationsMaskAnimationCallback = callback
        if highLighted then
            self:_setLocationsMaskToDark(true, animated)
            self:_addSelectedScenicSpotSpriteAboveLocationMask()
        else
            self:_setLocationsMaskToDark(false, animated)
        end
    end
end

------ mark layer: plan travel route
function MapLayer:setMarkLayerPresentationTravelPlan()
    self._markLayer:setPresentationMode(self._markLayer.presentationMode.PRESENT_TRAVEL_PLAN)
end

function MapLayer:setMarkLayerPresentationTravelNote()
    self._markLayer:setPresentationMode(self._markLayer.presentationMode.PRESENT_TRAVEL_NOTE)
end

function MapLayer:addSelectedScenicSpotToRoutePlan()
    if self._selectedScenicSpot then
        self._markLayer:addPointDataFromMapSpace(self._selectedScenicSpot:getName(), cc.p(self._selectedScenicSpot:getPosition()))
        self._markLayer:refresh()
    end
end

function MapLayer:removeSelectedScenicSpotFromRoutePlan()
    if self._selectedScenicSpot then
        self._markLayer:removePointWithKey(self._selectedScenicSpot:getName())
        self._markLayer:refresh()
    end
end

function MapLayer:clearAllMarks()
    self._markLayer:clear()
end

function MapLayer:addScenicSpotsNamesToTravelPlan(scenicSpotNames)
    if not scenicSpotNames then
        return
    end

    for index =1, #scenicSpotNames do
        local scenicSpotName = tostring(scenicSpotNames[index])
        local point = cc.p(self._scenicSpotsNameToSpriteMap[scenicSpotName]:getPosition())
        self._markLayer:addPointDataFromMapSpace(scenicSpotName, point)
    end
    self._markLayer:refresh()
end

function MapLayer:addScenicSpotsDataToTravelNote(data)
    dump(data)
    if not data then
        return
    end
-- print("11111111111111111111111111")
    for index = 1, #data do
        local point = cc.p(self._scenicSpotsNameToSpriteMap[data[index].scenicSpotName]:getPosition())
        self._markLayer:addPointDataFromMapSpace(data[index].scenicSpotName, point, data[index].imagePath)
    end
    self._markLayer:refresh()
end

------ zoom levels and zoom anmation
function MapLayer:zoomTest()
    if self._fixedZoomLevelScalesIndex == #self._fixedZoomLevelScales then
        self:_setMapScaleToLevelWithIndex(1, true)
    else
        self:zoomIn()
    end
end

function MapLayer:zoomIn()
    if self._fixedZoomLevelScalesIndex < #self._fixedZoomLevelScales then
        self:_setMapScaleToLevelWithIndex(self._fixedZoomLevelScalesIndex + 1, true)
    end
end

function MapLayer:zoomOut()
    if self._fixedZoomLevelScalesIndex > 1 then
        self:_setMapScaleToLevelWithIndex(self._fixedZoomLevelScalesIndex - 1, true)
    end
end

function MapLayer:_mapMoveAnimationTick(tickTime)
    local tickSegment = tickTime - self._mapMoveDeltaParams.lastTick
    self:_addMapPositionDelta(cc.p(self._mapMoveDeltaParams.moveDelta.x * tickSegment,
                                   self._mapMoveDeltaParams.moveDelta.y * tickSegment))
    self._mapMoveDeltaParams.lastTick = tickTime
end

function MapLayer:_startMapDeltaAnimation(duration, delta)
    self:stopActionByTag(501)
    self._mapMoveDeltaParams = self._mapMoveDeltaParams or {}
    self._mapMoveDeltaParams.moveDelta = delta
    self._mapMoveDeltaParams.lastTick = 0
    local moveDeltaAction = qm.QMapActionInterval:create(duration, handler(self, self._mapMoveAnimationTick))
    moveDeltaAction:setTag(501)
    self:runAction(moveDeltaAction)
end

function MapLayer:_mapScaleAnimationTick(tickTime)
    self:_setMapScale(self.mapScaleParams.startScale + self.mapScaleParams.scaleDelta * tickTime)
end

function MapLayer:_startMapScaleToAnimation(duration, scaleTo)
    self:stopActionByTag(500)
    self.mapScaleParams = self.mapScaleParams or {}
    self.mapScaleParams.startScale = self._mapNode:getScale()
    self.mapScaleParams.scaleDelta = scaleTo - self.mapScaleParams.startScale
    local scaleMapAction = qm.QMapActionInterval:create(duration, handler(self, self._mapScaleAnimationTick))
    scaleMapAction:setTag(500)
    self:runAction(scaleMapAction)
end

function MapLayer:_calculateZoomLevelScales(fixedLevelCount, maxScale)

    if fixedLevelCount < 1 then
        printError("zoom level count must not be less than 1")
        return
    end

    self._fixedZoomLevelScales = {}
    self._fixedZoomLevelScalesIndex = 0

    if fixedLevelCount == 1 then
        self._fixedZoomLevelScales[1] = maxScale
        return
    end

    local mapSize = self._mapNode:getContentSize()
    if mapSize.width <= display.width or mapSize.height <= display.height then
        self._fixedZoomLevelScales[1] = maxScale
    else
        local hRatio = display.width / mapSize.width
        local vRatio = display.height / mapSize.height

        -- first level
        local index = 1
        local firstLevelScale = hRatio < vRatio and vRatio or hRatio
        self._fixedZoomLevelScales[index] = firstLevelScale

        -- second level to second-last level if any
        if fixedLevelCount > 2 then
            local scaleRatio = math.pow(maxScale/firstLevelScale, 1.0/(fixedLevelCount-1))
            local zoomLevel = 2
            while zoomLevel < fixedLevelCount do
                self._fixedZoomLevelScales[index+1] = scaleRatio * self._fixedZoomLevelScales[index]
                index = index + 1
                zoomLevel = zoomLevel + 1
            end
        end

        -- last level
        self._fixedZoomLevelScales[index+1] = maxScale
    end
end

function MapLayer:_setMapScaleToLevelWithIndex(levelIndex, animated)
    -- print("1111111111111")
    if levelIndex < 1 or levelIndex > #self._fixedZoomLevelScales then
        printError("invalid level index: %d, index must be in [%d, %d]", levelIndex, 1, #self._fixedZoomLevelScales)
        return
    end

    if self._fixedZoomLevelScalesIndex ~= levelIndex then

        if animated then
            self:_startMapScaleToAnimation(0.2, self._fixedZoomLevelScales[levelIndex])
        else
            self:_setMapScale(self._fixedZoomLevelScales[levelIndex])
        end

--         starIndex = (starIndex or 0) + 1
--         print("11111111111111111111111", starIndex)
-- print( self._fixedZoomLevelScales[levelIndex])
        self._fixedZoomLevelScalesIndex = levelIndex
        self._mapInFixedZoomLevel = true
    end
end

------ map set scale, position
function MapLayer:_guardMapScaleAssign(newScale)
    -- guard scale
    local minScale = self._fixedZoomLevelScales[1]
    local maxScale = self._fixedZoomLevelScales[#self._fixedZoomLevelScales]
    if newScale > maxScale then
        newScale = maxScale
    elseif newScale < minScale then
        newScale = minScale
    end

    -- update zoom index
    if #self._fixedZoomLevelScales > 1 then
        for index = 2, #self._fixedZoomLevelScales do
            floorScale = self._fixedZoomLevelScales[index-1]
            ceilingScale = self._fixedZoomLevelScales[index]
            midScale = floorScale + (ceilingScale - floorScale) * 0.5
            if newScale >= midScale then
                self._fixedZoomLevelScalesIndex = index
            else
                self._fixedZoomLevelScalesIndex = index - 1
                break
            end
        end
    end

    -- print("111111111", newScale)
    -- if newScale > (maxScale + minScale)/2 then

    -- end

    -- -- local s = (maxScale - minScale)/2 + minScale
    -- local s = (maxScale + minScale)/2 

    -- -- print(newScale , s, maxScale, minScale, (maxScale + minScale)/4)
    -- if self.prohibitNameLayerShow then
    --     self._markNameLayer:setNameVisible(false)
    -- else
    --     self._markNameLayer:setNameVisible(newScale > s)
    -- end

    -- self.nameLayerIsShow = (newScale > s)

    -- set scale
    self:_setMapScale(newScale)
end

function MapLayer:_setMapScale(newScale)
    local currentScale = self._mapNode:getScale()
    if newScale ~= currentScale then
        self._mapNode:setScale(newScale)
        self:_calculateMapBottomLeftPropertiesAccordingToScale(newScale)
        self._mapInFixedZoomLevel = false


        local minScale = self._fixedZoomLevelScales[1]
        local maxScale = self._fixedZoomLevelScales[#self._fixedZoomLevelScales]
        -- local s = (maxScale - minScale)/2 + minScale
        local s = (maxScale + minScale)/2 

        -- print(newScale , s, maxScale, minScale, (maxScale + minScale)/4)
        if self.prohibitNameLayerShow then
            self._markNameLayer:setNameVisible(false)
        else
            self._markNameLayer:setNameVisible(newScale > s)
        end

        self.nameLayerIsShow = (newScale > s)

    end
end

function MapLayer:_calculateMapBottomLeftPropertiesAccordingToScale(scale)

    -- calculate map screen size
    local mapScreenSize = self._mapNode:getContentSize()
    mapScreenSize.width = mapScreenSize.width * scale
    mapScreenSize.height = mapScreenSize.height * scale
    self._mapScreenSize = mapScreenSize

    -- calculate SBL(screen bottom left) bound
    if mapScreenSize.width <= display.width then -- cannot move horizontally
        self._mapSBLMinX = -mapScreenSize.width / 2
        self._mapSBLMaxX = self._mapSBLMinX
    else
        self._mapSBLMinX = display.width / 2 - mapScreenSize.width
        self._mapSBLMaxX = -display.width / 2
    end

    if mapScreenSize.height <= display.height then -- cannot move vertically
        self._mapSBLMinY = -mapScreenSize.height / 2
        self._mapSBLMaxY = self._mapSBLMinY
    else
        self._mapSBLMinY = display.height / 2 - mapScreenSize.height
        self._mapSBLMaxY = -display.height / 2
    end

    -- apply margin
    self._mapSBLMinY = self._mapSBLMinY - self._topFillMargin
    self._mapSBLMaxY = self._mapSBLMaxY + self._bottomFillMargin

    -- calculate SBL(screen bottom left) position
    local currentX, currentY = self._mapNode:getPosition()
    local currentAnchor = self._mapNode:getAnchorPoint()
    local newSBLPosition = cc.p(currentX - self._mapScreenSize.width * currentAnchor.x,
                                currentY - self._mapScreenSize.height * currentAnchor.y)
    self._mapScaleUpdated = true
    self:_guardSBLPositionAssign(newSBLPosition)
end

function MapLayer:_guardSBLPositionAssign(newSBLPosition)
    -- SBL: screen bottom left
    if newSBLPosition.x < self._mapSBLMinX then
        newSBLPosition.x = self._mapSBLMinX
    elseif newSBLPosition.x > self._mapSBLMaxX then
        newSBLPosition.x = self._mapSBLMaxX
    end

    if newSBLPosition.y < self._mapSBLMinY then
        newSBLPosition.y = self._mapSBLMinY
    elseif newSBLPosition.y > self._mapSBLMaxY then
        newSBLPosition.y = self._mapSBLMaxY
    end

    local currentAnchor = self._mapNode:getAnchorPoint()
    -- SBA: screen-based anchor
    local newSBAPosition = cc.p(currentAnchor.x * self._mapScreenSize.width + newSBLPosition.x,
                                currentAnchor.y * self._mapScreenSize.height + newSBLPosition.y)
    self._mapNode:setPosition(newSBAPosition)

    if self._mapScaleUpdated then
        self._markLayer:refresh()
        self._markNameLayer:refresh()
        self:_updatePopupMenu()
        self._mapScaleUpdated = false
    else
        local delta = cc.pSub(newSBLPosition, self._mapCurrentSBLPosition)
        self._markLayer:deltaMove(delta)
        self._popupMenuLayer:deltaMove(delta)
        self._markNameLayer:deltaMove(delta)
    end

    self._mapCurrentSBLPosition = newSBLPosition
end

function MapLayer:_addMapPositionDelta(delta)
    -- SBL: screen bottom left
    local newSBLPosition = cc.pAdd(self._mapCurrentSBLPosition, delta)
    self:_guardSBLPositionAssign(newSBLPosition)
end

function MapLayer:_setMapAnchorToPoint(pointInMap)
    local size = self._mapNode:getContentSize()
    local newAnchorPoint = cc.p(pointInMap.x / size.width, pointInMap.y / size.height)

    local currentAnchor = self._mapNode:getAnchorPoint()
    local x, y = self._mapNode:getPosition()

    local newAnchorBasedPosition = cc.p(self._mapCurrentSBLPosition.x + newAnchorPoint.x * self._mapScreenSize.width,
                                        self._mapCurrentSBLPosition.y + newAnchorPoint.y * self._mapScreenSize.height)

    self._mapNode:setAnchorPoint(newAnchorPoint)
    self._mapNode:setPosition(newAnchorBasedPosition)
end

------ event handle
function MapLayer:setGestureRecognitionEnabled(enabled)
    print("手势操作。。。。", enabled)
    self._gestureRecognizer:setEnabled(enabled)
end

function MapLayer:_initEvents()
    self._gestureRecognizer = qm.GestureRecognizer:create()
    self._gestureRecognizer:addGestureBeganCallback(handler(self, self._gestureBegan))
    self._gestureRecognizer:addSingleTapCallback(handler(self, self._singleTap))
    self._gestureRecognizer:addDoubleTapCallback(handler(self, self._doubleTap))
    self._gestureRecognizer:addPanCallback(handler(self, self._mapMoved))
    self._gestureRecognizer:addDoubleFingersTapCallback(handler(self, self._doubleFingersTap))
    self._gestureRecognizer:addPinchCallback(handler(self, self._pinch))
    self._gestureRecognizer:addPanEndedCallback(handler(self, self._mapMoveEnded))
    self._gestureRecognizer:applyToNode(self)
    self._gestureRecognizer:addTo(self)
end

function MapLayer:_whichItemContainPoint(point)
    local pointInMapSpace = self._locations:convertToNodeSpace(point)
    local children = self._locations:getChildren()
    -- print("............................")
    -- print_r(children)
    -- print("11111111111111111111111111111")
    local nodeRect
    for i=#children,1,-1 do
        local node = children[i]
    --     print(i)
    -- end
    -- for k, node in pairs(children) do
        nodeRect = node:getBoundingBox()
        if cc.rectContainsPoint(nodeRect, pointInMapSpace) then
            return node
        end
    end
    return nil
end

function MapLayer:_mapMoved(deltaX, deltaY)
    self:_addMapPositionDelta(cc.p(deltaX, deltaY))
end

function MapLayer:_mapInertialAnimationTick(tickTime)
    local tickSegment = tickTime - self._mapInertialMoveParams.lastTick
    self:_addMapPositionDelta(cc.p(self._mapInertialMoveParams.velocity.x * tickSegment * self._mapInertialMoveParams.duration ,
                                   self._mapInertialMoveParams.velocity.y * tickSegment * self._mapInertialMoveParams.duration))

    if self._mapInertialMoveParams.velocity.x ~= 0 then
        local newVx = self._mapInertialMoveParams.velocity.x + self._mapInertialMoveParams.deceleration.x
        self._mapInertialMoveParams.velocity.x = (newVx * self._mapInertialMoveParams.velocity.x) <= 0 and 0 or newVx
    end

    if self._mapInertialMoveParams.velocity.y ~= 0 then
        local newVy = self._mapInertialMoveParams.velocity.y + self._mapInertialMoveParams.deceleration.y
        self._mapInertialMoveParams.velocity.y = (newVy * self._mapInertialMoveParams.velocity.y) <= 0 and 0 or newVy
    end

    self._mapInertialMoveParams.lastTick = tickTime

    if self._mapInertialMoveParams.velocity.x == 0 and self._mapInertialMoveParams.velocity.y == 0 then
        self:stopActionByTag(502)
    end
end

function MapLayer:_mapMoveEnded(vX, vY)
    
    self:stopActionByTag(502)

    if vX~= 0 or vY~= 0 then
        local deceleration = 90
        self._mapInertialMoveParams = self._mapInertialMoveParams or { deceleration = {} }
        self._mapInertialMoveParams.velocity = cc.p(vX, vY)
        local vLen = cc.pGetLength(self._mapInertialMoveParams.velocity)
        self._mapInertialMoveParams.deceleration.x = -vX / vLen * deceleration;
        self._mapInertialMoveParams.deceleration.y = -vY / vLen * deceleration;
        self._mapInertialMoveParams.lastTick = 0
        self._mapInertialMoveParams.duration = 2.0
        local inertialMoveAction = qm.QMapActionInterval:create(self._mapInertialMoveParams.duration, handler(self, self._mapInertialAnimationTick))
        inertialMoveAction:setTag(502)
        self:runAction(inertialMoveAction)
    end
end

function MapLayer:_gestureBegan()
    self:stopActionByTag(502)
end

function MapLayer:_singleTap(x, y)
    self._itemTapped = self:_whichItemContainPoint(cc.p(x, y))
    if (self._itemTapped) then
        self._selectedScenicSpot = self._itemTapped
        self._delegate:tappedScenicSpotWithName(self._itemTapped:getName())
    else
        self._delegate:tappedElseWhere()
        self._selectedScenicSpot = nil
    end
end

function MapLayer:_doubleTap(x, y)
-- print("MapLayer:_doubleTap(x, y)")
    -- starIndex = (starIndex or 0) + 1
    -- print("1111111111111111", starIndex)
    
    local pointInMapSpace = self._mapNode:convertToNodeSpace(cc.p(x, y))
    self:_setMapAnchorToPoint(pointInMapSpace)
    self:zoomIn()
end

function MapLayer:_doubleFingersTap(x, y)
    -- print("MapLayer:_doubleFingersTap(x, y)")
    local pointInMapSpace = self._mapNode:convertToNodeSpace(cc.p(x, y))
    self:_setMapAnchorToPoint(pointInMapSpace)
    self:zoomOut()
end

function MapLayer:_pinch(x, y, distanceRatio)
    -- print("MapLayer:_pinch(x, y, distanceRatio)")
    local pointInMapSpace = self._mapNode:convertToNodeSpace(cc.p(x, y))
    self:_setMapAnchorToPoint(pointInMapSpace)
    self:_guardMapScaleAssign(self._mapNode:getScale() * distanceRatio)
end

function MapLayer:introduceWillShow( show )
    -- self._markNameLayer:setProhibitShow(show)
    self.prohibitNameLayerShow = show
    if show then
        self._markNameLayer:setNameVisible(false) 
    else
        self._markNameLayer:setNameVisible(self.nameLayerIsShow) 
    end
end

return MapLayer
