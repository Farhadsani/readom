local MapMarkPhotoThumbnail = class("MapMarkPhotoThumbnail", function()
    return display.newNode()
end)

------ photo layout position
MapMarkPhotoThumbnail.PHOTO_LAYOUT_AT_TOP 		= 1
MapMarkPhotoThumbnail.PHOTO_LAYOUT_AT_BOTTOM	= 2
MapMarkPhotoThumbnail.PHOTO_LAYOUT_AT_LEFT		= 3
MapMarkPhotoThumbnail.PHOTO_LAYOUT_AT_RIGHT		= 4

function MapMarkPhotoThumbnail:ctor(scenicSpotName, photoThumbnailFileName)

	-- scenic spot name
	if scenicSpotName == nil then
		printError("argument \"scenicSpotName\" must not be nil")
        return
	end
	self._scenicSpotName = scenicSpotName

	local imageName = "ui/image/map_mark.png"
    display.addSpriteFrames("ui/image/map_mark.plist", imageName)

	-- extension line sprite
	self._extensionLine = display.newSprite("#map_mark_photo_thumbnail_extension_line.png")
	self._extensionLine:setAnchorPoint(cc.p(0, 0.5))
	self._extensionLine:setScaleX(5)
	self:addChild(self._extensionLine)

	-- photo border sprite
	local lineContentSize = self._extensionLine:getContentSize()
	self._photoBorder = display.newSprite("#map_mark_photo_thumbnail_image_border.png")
	self._photoBorderSize = self._photoBorder:getContentSize()
	self._photoBorder:setPosition(cc.p(lineContentSize.width*self._extensionLine:getScaleX() + self._photoBorderSize.width / 2, 0))
	self:addChild(self._photoBorder)

	-- photo image sprite
	local imageFileName = photoThumbnailFileName or "#map_mark_photo_thumbnail_image_default.png"

	if not cc.FileUtils:getInstance():isFileExist(imageFileName) then
		print("imageFileName", imageFileName, " not exist!")
		imageFileName = "#map_mark_photo_thumbnail_image_default.png"
	end
	
-- imageFileName = "#map_mark_photo_thumbnail_extension_line.png"
-------------- demo purpose only: should not be the final version
print("--------------------------")
print(imageFileName)
local tmp = display.newSprite(imageFileName)
local contentSize = tmp:getContentSize()

local x, y, squareLen
if contentSize.width < contentSize.height then
	squareLen = contentSize.width
	x = 0
	y = (contentSize.height - contentSize.width) / 2
else
	squareLen = contentSize.height
	x = (contentSize.width - contentSize.height) /  2
	y = 0
end
local scale = 100 / squareLen
print("图片的大小。。。", scale, squareLen, x, y, contentSize.height , contentSize.width)
self._photoThumbnail = display.newSprite(imageFileName, cc.rect(x, y, squareLen, squareLen))   --cc.Sprite:create
self._photoThumbnail:setScale(scale)



	-- local stencilNode = display.newRect(cc.rect(0,0,100,100))   --cc.Sprite:create("ui/image/wBGCircle.png")    --模板 
 --    stencilNode:setScale(2)
 --    local clipNode = cc.ClippingNode:create()
 --    clipNode:setStencil(stencilNode)
 --    clipNode:setAnchorPoint(0.5, 0.5)
 --    clipNode:setPosition(cc.p(60 , 60 ))
 --    clipNode:setAlphaThreshold(0)
 --    clipNode:setInverted(false)
 --    -- local sp1 = cc.Sprite:create(valueParam.image)
 --    self._photoThumbnail:addTo(clipNode)
 --    clipNode:addTo(self._photoBorder)

------------------------------------------------------------

	-- uncomment this line after demo
	--self._photoThumbnail = display.newSprite(imageFileName)
	self._photoThumbnail:setPosition(cc.p(self._photoBorderSize.width/2, self._photoBorderSize.height/2))
	self._photoBorder:addChild(self._photoThumbnail)

	-- set default photo layout position
	self:setPhotoLayoutPosition(self.PHOTO_LAYOUT_AT_RIGHT)

	-- display.removeSpriteFramesWithFile("ui/image/map_mark.plist", imageName)
end

function MapMarkPhotoThumbnail:setPhotoThumbnail(scenicSpotName, photoFileName)
	self._scenicSpotName = scenicSpotName
	local frame = display.newSpriteFrame(photoFileName)
	self._photoThumbnail:setDisplayFrame(photoFileName)
end

function MapMarkPhotoThumbnail:getScenicSpotName()
	return self._scenicSpotName
end

function MapMarkPhotoThumbnail:_doLayoutRelatedCalculation(layoutPostion)

	if layoutPostion == self.PHOTO_LAYOUT_AT_TOP then

		self._rotation = -90

	elseif layoutPostion == self.PHOTO_LAYOUT_AT_BOTTOM then

		self._rotation = 90

	elseif layoutPostion == self.PHOTO_LAYOUT_AT_LEFT then

		self._rotation = 180

	elseif layoutPostion == self.PHOTO_LAYOUT_AT_RIGHT then

		self._rotation = 0
	end
end

function MapMarkPhotoThumbnail:setPhotoLayoutPosition(layoutPostion)

	self:_doLayoutRelatedCalculation(layoutPostion)

	self:setRotation(self._rotation)
	self._photoBorder:setRotation(-self._rotation)
end

function MapMarkPhotoThumbnail:photoBoundingBoxContainPoint(point)
	local localPoint = self:convertToNodeSpace(point)
	return cc.rectContainsPoint(self._photoBorder:getBoundingBox(), localPoint)
end

return MapMarkPhotoThumbnail
