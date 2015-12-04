
local MapMarkLayer = class("MapMarkLayer", function()
    return display.newNode()
end)

function MapMarkLayer:ctor(param)

    -- scenic spot points
    self._pickedPointDataListInMapSpace = {}

    -- load sprite
    local imageName = "ui/image/map_mark.png"
    display.addSpriteFrames("ui/image/map_mark.plist", imageName)

    -- -- reserve frames to avoid purge in memory warning
    -- self:_reserveSpriteFrames()

    -- lines, numbers, photos
    self._linesNode = display.newBatchNode(imageName) --display.newNode()
    self._numbersNode = display.newNode()
    self._photosNode = display.newNode()
    self:addChild(self._linesNode, 1)
    self:addChild(self._photosNode, 2)
    self:addChild(self._numbersNode, 3)

    -- presentation mode
    self.presentationMode = {
        PRESENT_MODE_NIL        = 0,
        PRESENT_TRAVEL_NOTE     = 1,
        PRESENT_TRAVEL_PLAN     = 2,
        currentMode             = 0      
    }

    -- default presentation mode
    self:setPresentationMode(self.presentationMode.PRESENT_TRAVEL_NOTE)

    -- event
    self:_initEvents()
end

function MapMarkLayer:_reserveSpriteFrames()
    self._emptyDotSprite = display.newSprite("#map_mark_empty_dot.png.png")
    self._unroundedSegmentSprite = display.newSprite("#map_mark_line_segment_unrounded.png")
    self._roundedSegmentSprite = display.newSprite("#map_mark_line_segment_rounded.png.png")

    self._numberDotSprite = display.newSprite("#map_mark_number_dot.png")
    self._extensionLineSprite = display.newSprite("#map_mark_photo_thumbnail_extension_line.png")
    self._photoBorderSprite = display.newSprite("#map_mark_photo_thumbnail_image_border.png")
    self._photoDefaultSprite = display.newSprite("#map_mark_photo_thumbnail_image_default.png")

    -- self._emptyDotSprite:setVisible(false)
    -- self._unroundedSegmentSprite:setVisible(false)
    -- self._roundedSegmentSprite:setVisible(false)

    -- self._numberDotSprite:setVisible(false)
    -- self._extensionLineSprite:setVisible(false)
    -- self._photoBorderSprite:setVisible(false)
    -- self._photoDefaultSprite:setVisible(false)


    self._reserveSpritesNode = display.newNode()
    self._reserveSpritesNode:addTo(self)

    self._emptyDotSprite:addTo(self._reserveSpritesNode)
    self._unroundedSegmentSprite:addTo(self._reserveSpritesNode)
    self._roundedSegmentSprite:addTo(self._reserveSpritesNode)

    self._numberDotSprite:addTo(self._reserveSpritesNode)
    self._extensionLineSprite:addTo(self._reserveSpritesNode)
    self._photoBorderSprite:addTo(self._reserveSpritesNode)
    self._photoDefaultSprite:addTo(self._reserveSpritesNode)

    self._reserveSpritesNode:setVisible(false)
end

function MapMarkLayer:setPresentationMode(mode)
    if self.presentationMode.currentMode ~= mode then
        self.presentationMode.currentMode = mode
        if mode == self.presentationMode.PRESENT_TRAVEL_NOTE then
            self._refreshFunction = self._refreshTravelNotePresentation
        elseif mode == self.presentationMode.PRESENT_TRAVEL_PLAN then
            self._refreshFunction = self._refreshTravelPlanPresentation
        end
        self:clear()
    end
end

function MapMarkLayer:_refreshTravelNotePresentation()
    self:_updatePointListInMarkSpace()
    self:_drawMarkLinesWithDashStyle(false)
    self:_drawMarkPhotos()
    self:_drawMarkNumbers()
end

function MapMarkLayer:_refreshTravelPlanPresentation()
    self:_updatePointListInMarkSpace()
    self:_drawMarkLinesWithDashStyle(true)
    self:_drawMarkNumbers()
end

function MapMarkLayer:refresh()
    display.addSpriteFrames("ui/image/map_mark.plist", "ui/image/map_mark.png")
    self:_refreshFunction()
end

function MapMarkLayer:clear()
    self._pickedPointDataListInMapSpace = {}
    self:_removeMarkAll()
end

function MapMarkLayer:setDelegate(delegate)
    self._delegate = delegate
end

function MapMarkLayer:setMapSpaceToMarkSpaceConvertFunc(func)
    self.mapSpaceToMarkSpaceConvertFunc = func
end

function MapMarkLayer:_removeMarkLines()
    self._linesNode:removeAllChildren()
end

function MapMarkLayer:_removeMarkNumbers()
    self._numbersNode:removeAllChildren()
end

function MapMarkLayer:_removeMarkPhotos()
    self._photosNode:removeAllChildren()
end

function MapMarkLayer:_removeMarkAll()
    self._linesNode:removeAllChildren()
    self._numbersNode:removeAllChildren()
    self._photosNode:removeAllChildren()
end

------ mark lines
function MapMarkLayer:_createHorizontalSolidLineNode(lineLength)

    local lineSprite = display.newSprite("#map_mark_line_segment_unrounded.png")

    local originalLength = lineSprite:getContentSize().width
    local scaleRatio = lineLength / originalLength
    lineSprite:setAnchorPoint(cc.p(0, 0.5))
    lineSprite:setScale(scaleRatio, 0.6)
    lineSprite:setColor(cc.c3b(0, 217, 217))
    lineSprite:setOpacity(100)

    return lineSprite
end

function MapMarkLayer:_createHorizontalDashLineNode(lineLength)

    local segmentGroup = display.newSprite("#map_mark_empty_dot.png")

    local dashSegmentSprite = display.newSprite("#map_mark_line_segment_rounded.png")
    dashSegmentSprite:setColor(cc.c3b(0, 217, 217))
    dashSegmentSprite:setAnchorPoint(cc.p(0, 0.5))

    segmentGroup:addChild(dashSegmentSprite)

    local factor = 1.4
    local segmentLength = dashSegmentSprite:getContentSize().width
    local segmentCount = math.floor(lineLength / segmentLength / factor)

    for i = 1, segmentCount - 1 do
        duplicatedSprite = display.newSprite(dashSegmentSprite:getSpriteFrame())
        duplicatedSprite:setColor(cc.c3b(0, 217, 217))
        duplicatedSprite:setAnchorPoint(cc.p(0, 0.5))
        duplicatedSprite:setPosition(cc.p(segmentLength * factor * i, 0))
        segmentGroup:addChild(duplicatedSprite)
    end

    segmentGroup:setScale(1.0, 0.6)

    return segmentGroup
end

function MapMarkLayer:_drawMarkLineBetweenPoints(point1, point2, isDashStyle)

    if point1.x == point2.x and point1.y == point2.y then
        return
    end

    local distance = cc.pGetLength(cc.pSub(point2, point1))

    local v1 = cc.p(math.abs(point2.x - point1.x), 0)
    local v2 = cc.p(point2.x - point1.x, point2.y - point1.y)

    local v1Length = v1.x
    local rotationAngle = math.acos(cc.pDot(v1, v2) / (distance * v1Length))

    if point2.y > point1.y then
        rotationAngle = -rotationAngle
    end

    local lineNode = nil
    if isDashStyle then
        lineNode = self:_createHorizontalDashLineNode(distance)
    else
        lineNode = self:_createHorizontalSolidLineNode(distance)
    end

    lineNode:setPosition(point1)
    lineNode:setRotation(rotationAngle * 180 / 3.14159269)

    self._linesNode:addChild(lineNode)
end

function MapMarkLayer:_drawMarkLinesWithDashStyle(isDashStyle)
    self:_removeMarkLines()
    if #self._pointListInMarkSpace >= 2 then
        local index = 1
        while index < #self._pointListInMarkSpace do
            self:_drawMarkLineBetweenPoints(self._pointListInMarkSpace[index], 
                                            self._pointListInMarkSpace[index + 1],
                                            isDashStyle)
            index = index + 1
        end
    end
end

------ mark numbers
function MapMarkLayer:_drawMarkNumbers()
    self:_removeMarkNumbers()
    if #self._pointListInMarkSpace > 0 then
        local index = 1
        while index <= #self._pointListInMarkSpace do
            local point = self._pointListInMarkSpace[index]
            local numberSprite = require("app/views/MapMarkNumber").new()
            numberSprite:setNumber(index)
            numberSprite:setPosition(point)
            index = index + 1
            self._numbersNode:addChild(numberSprite, 2)
        end
    end
end

------ mark photos
function MapMarkLayer:_drawMarkPhotos()
    self:_removeMarkPhotos()
    if #self._pointListInMarkSpace > 0 then
        local index = 1
        while index <= #self._pointListInMarkSpace do
            local point = self._pointListInMarkSpace[index]
            local thumbnailPath = self._pickedPointDataListInMapSpace[index].imagePath
            local scenicSpotName = self._pickedPointDataListInMapSpace[index].key
            local photoSprite = require("app/views/MapMarkPhotoThumbnail").new(scenicSpotName, thumbnailPath)
            photoSprite:setPhotoLayoutPosition(photoSprite.PHOTO_LAYOUT_AT_TOP)
            photoSprite:setPosition(point)
            index = index + 1
            self._photosNode:addChild(photoSprite, 1)
        end
    end
end

------ scenic spot point maintenance
function MapMarkLayer:addPointDataFromMapSpace(pointKey, aPoint, anImagePath)
    local nextIndex = #self._pickedPointDataListInMapSpace + 1
    self._pickedPointDataListInMapSpace[nextIndex] = { key = pointKey, point = aPoint, imagePath = anImagePath }
end

function MapMarkLayer:removePointWithKey(key)
    for index = 1, #self._pickedPointDataListInMapSpace do
        if self._pickedPointDataListInMapSpace[index].key == key then
            table.remove(self._pickedPointDataListInMapSpace, index)
            break
        end
    end
end

function MapMarkLayer:_updatePointListInMarkSpace()
    self._pointListInMarkSpace = {}
    local index = 1
    while index <= #self._pickedPointDataListInMapSpace do
        local pointInMapSpace = self._pickedPointDataListInMapSpace[index].point
        local pointInMarkSpace = self.mapSpaceToMarkSpaceConvertFunc(pointInMapSpace)
        self._pointListInMarkSpace[index] = pointInMarkSpace
        index = index + 1
    end
end

function MapMarkLayer:deltaMove(delta)
    local currentPosition = cc.p(self:getPosition())
    self:setPosition(cc.pAdd(currentPosition, delta))
end

------ event handle
function MapMarkLayer:_initEvents()
    self:setTouchSwallowEnabled(false)
    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self._touchHandler))
end

function MapMarkLayer:_whichPhotoContainPoint(point)
    local children = self._photosNode:getChildren()
    for k, node in pairs(children) do
        if node:photoBoundingBoxContainPoint(point) then
            return node
        end
    end
    return nil
end

function MapMarkLayer:_touchHandler(event)

    local point = cc.p(event.x, event.y)

    if event.name == "began" then
        self._photoTouched = self:_whichPhotoContainPoint(point)
        if self._photoTouched then
            self._photoStillTouched = true
            return true
        end
        return false
        
    elseif event.name == "moved" then
        if not self._photoTouched:photoBoundingBoxContainPoint(point) then
            self._photoStillTouched = false
        end

    elseif event.name == "ended" then
        if self._photoStillTouched then
            self._delegate:tappedPhotoThumbnailWithScenicSpothName(self._photoTouched:getScenicSpotName())
        end
        self._photoTouched = nil
        self._photoStillTouched = false
    end
end

return MapMarkLayer
