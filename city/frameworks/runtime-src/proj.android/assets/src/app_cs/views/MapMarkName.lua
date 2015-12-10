

local maskedSprite = function( textureSprite )
    local maskSprite = display.newSprite("ui/image/mapMark/mapmark_2.png")
    local maskSize = maskSprite:getContentSize()
    local renderTexture = cc.RenderTexture:create(maskSize.width, maskSize.height)

    renderTexture:setPosition(cc.p(cc.p(textureSprite:getContentSize().width / 2, textureSprite:getContentSize().height / 2)))
    
    -- maskSprite:setPosition(cc.p(maskSize.width / 2, maskSize.height / 2))
    maskSprite:setPosition(cc.p(textureSprite:getContentSize().width / 2, textureSprite:getContentSize().height / 2));

    -- maskSprite:setBlendFunc(GL_ONE, GL_ZERO);
    -- textureSprite:setBlendFunc(GL_DST_ALPHA, GL_ZERO);

    maskSprite:setBlendFunc(GL_ONE, GL_ONE);
    textureSprite:setBlendFunc(GL_ONE, GL_ONE);
    
    renderTexture:begin()
    
    maskSprite:visit()
    textureSprite:visit()
    
    renderTexture:endToLua()

    local retval = display.newSprite(renderTexture:getSprite():getTexture())
    retval:setFlippedY(true)
    return retval
end


local MapMarkName = class("MapMarkName", function()
    return display.newNode()
end)

function MapMarkName:ctor(param)

    
end

function MapMarkName:setDelegate(delegate)
    self._delegate = delegate
end

-- 19 = {
--         "style" = 0   -- 0表示景点名称， 1表示指数数据
--         "cname"  = "西山公园",
--         "pos" = { "x" = -846.58679199219, "y" = 201.48828125      }
--         "sprite" = userdata: 0x1423c0e38
--    }

function MapMarkName:showName( datas )
    -- dump(datas)
    self:removeAllChildren()
    if datas and next(datas) then
        for k, data in pairs(datas) do
            local item
            if data.style == 1 then
                item = self:createPicItem(data)
            else
                item = self:createItem(data)
            end
            data.item = item
        end
    end
    self.datas = datas
end

function MapMarkName:getMarkBackImage( style, width )
    local allImages = {
        [1] = { {w = 627, h = 147, i = 15}, {w = 585, h = 147, i = 14}, {w = 543, h = 147, i = 13}, {w = 501, h = 147, i = 12}, {w = 459, h = 147, i = 11}, 
            {w = 417, h = 147, i = 10}, {w = 375, h = 147, i = 9}, {w = 333, h = 147, i = 8}, {w = 315, h = 147, i = 7}, 
            {w = 285, h = 147, i = 6}, {w = 240, h = 147, i = 5}, {w = 210, h = 147, i = 4},
            {w = 180, h = 147, i = 3}, {w = 150, h = 147, i = 2}, {w = 135, h = 147, i = 1} },
        [2] = { {w = 210, h = 147, i = 3}, {w = 150, h = 147, i = 2}, {w = 105, h = 147, i = 1} }
    }

    local images = allImages[style]
    if images and next(images) then
        for i, image in ipairs(images) do
            if width >= image.w then
                return {width = image.w, height = image.h, index = image.i, style = style}
            end
        end
    end
    return {width = 210, height = 147, index = 4, style = 1}
end

function MapMarkName:createPicItem( dataInfo )
    -- dump(data)
    local data = dataInfo.data
    local namePanel = cc.LayerColor:create(cc.c4b(0, 255, 0, 0))    -- ccui.Layout:create()
    local picCount = data.count or 0
    local showCount = picCount
    if showCount > 3 then
        showCount = 3
    end
    local images = {[1] = {w = 150, h = 156}, [2] = {w = 210, h = 156}, [3] = {w = 255, h = 156}}
    local imagePath = "ui/image/mapMark/mapmark2_" .. showCount .. ".png"
    if showCount ~= 0 then
        local item = ccui.Layout:create()
        item:setBackGroundImage(imagePath)
        item:setBackGroundImageScale9Enabled(true)
        item:setContentSize(cc.size(images[showCount].w, images[showCount].h))
        item:setAnchorPoint(cc.p(0.5, 0))

        local label = cc.ui.UILabel.new({
            UILabelType = 2,
            text = tostring(picCount),
            font = QMapGlobal.resFile.font.caption,
            size = 48, 
            color = cc.c3b(100, 76, 67), -- 使用纯红色
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            -- dimensions = cc.size(570, 0)
        })
        label:setAnchorPoint(cc.p(0.5,0.5))

        local pnlPic = ccui.Layout:create()
        pnlPic:setBackGroundColorType(0)
        pnlPic:setBackGroundColor(cc.c3b(255,255,255))
        pnlPic:setContentSize(cc.size(images[showCount].w-50, 50))
        pnlPic:setAnchorPoint(cc.p(0.5,0.5))
        pnlPic:setPosition(cc.p(images[showCount].w/2, images[showCount].h-35))

        local fu = cc.FileUtils:getInstance()
        local downloadPath = fu:getDownloadPath()
        local categoryPicPath = downloadPath .. "temp/categoryPic/"

        local fu = cc.FileUtils:getInstance()
        for i = 1, showCount do
            local spPath = categoryPicPath .. data.imgFiles[i]

            if fu:isFileExist(spPath) then
                local sp = display.newSprite(spPath)
                local spSize = sp:getContentSize()
                sp:setAnchorPoint(cc.p(0.5, 0.5))
                sp:setPosition(cc.p(60*(i-1) + 20, 25))
                -- local sp1 = lua_maskedSprite(sp)
                -- local sp1 = maskedSprite(sp)
                local scaleX = 50/spSize.width
                local scaleY = 50/spSize.height
                local scale = scaleX < scaleY and  scaleX or scaleY
                sp:setScale(scale)
                sp:addTo(pnlPic)
            end
        end

        label:setPosition(cc.p(60*showCount+20,25))
        label:addTo(pnlPic)

        pnlPic:addTo(item)

        item:setTouchEnabled(true)
        item:addTouchEventListener(function ( sender, event )
            if event == 0 then
 
            elseif event == 2 then
                print("click ", data.cname)
                self._delegate:onClickMapMarkName(SpaceType_area, dataInfo.regionID)
            end
        end)

        item:addTo(namePanel)
        namePanel:setContentSize(cc.size(50, 50))
        namePanel:setPosition(dataInfo.pos)
    end
    namePanel:addTo(self)

    return namePanel
end

function MapMarkName:createItem( data )
    -- dump(data)
    local namePanel = ccui.Layout:create()
    if data.isSight then
        local label = cc.ui.UILabel.new({
            UILabelType = 2,
            text = data.cname,
            font = QMapGlobal.resFile.font.caption,
            size = 48, 
            color = cc.c3b(100, 76, 67), -- 使用纯红色
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            -- dimensions = cc.size(570, 0)
        })
        -- print("...............")

        label:setAnchorPoint(cc.p(0.5,0.5))
        
        local sizeLabel = label:getContentSize()

        local height = sizeLabel.height + 20
        local width = sizeLabel.width + 60

        local imageInfo = self:getMarkBackImage(1, width)
        -- print("111111111", width, imageInfo.index)
        local imagePath = "ui/image/mapMark/mapmark1_" .. imageInfo.index .. ".png"
        -- local imagePath = "ui/image/mapMark/mapmark" .. "1_7.png"

        local item = ccui.Layout:create()
        item:setBackGroundImage(imagePath)
        item:setBackGroundImageScale9Enabled(true)
        -- item:setBackGroundImageCapInsets(cc.rect(3,0,3,0))

        label:addTo(item)
        -- item:setContentSize(cc.size(width, height))
        item:setContentSize(cc.size(imageInfo.width, imageInfo.height))
        label:setPosition(cc.p(imageInfo.width/2, imageInfo.height/2 +40))

        item:setAnchorPoint(cc.p(0.5, 0))

        item:setTouchEnabled(true)
        item:addTouchEventListener(function ( sender, event )
            if event == 0 then
 
            elseif event == 2 then
                print("click ", data.cname)
                self._delegate:onClickMapMarkName(SpaceType_sight, data.regionID)
            end
        end)
        
        
        namePanel:setContentSize(cc.size(1, 1))
        namePanel:setPosition(data.pos)
        
        item:addTo(namePanel)
    end
    namePanel:addTo(self)

    return namePanel
end

function MapMarkName:createItem1( data )
    local namePanel = ccui.Layout:create()

    local item = ccui.Layout:create()
    item:setBackGroundImage("ui/image/sightNameBack4.png")
    item:setBackGroundImageScale9Enabled(true)
    -- item:setBackGroundImageCapInsets(cc.rect(3,0,3,0))

    local label = cc.ui.UILabel.new({
        UILabelType = 2,
        text = data.cname,
        font = QMapGlobal.resFile.font.content,
        size = 48, 
        color = cc.c3b(255, 255, 255), -- 使用纯红色
        align = cc.ui.TEXT_ALIGN_CENTER,
        valign = cc.ui.TEXT_VALIGN_CENTER,
        -- dimensions = cc.size(570, 0)
    })

    label:setAnchorPoint(cc.p(0.5,0.5))
    label:addTo(item)
    local sizeLabel = label:getContentSize()
    -- print_r(sizeLabel)
    local height = sizeLabel.height + 20
    local width = sizeLabel.width + 50
    item:setContentSize(cc.size(width, height))
    label:setPosition(cc.p(width/2, height/2 +5))

    item:setAnchorPoint(cc.p(0.5, 0))
    
    local sp = display.newSprite("ui/image/sightNameP1.png")
    sp:setAnchorPoint(cc.p(0.5, 0))
    sp:setPosition(cc.p(0, 0))
    local spSize = sp:getContentSize()
    sp:addTo(namePanel)

    item:setPosition(cc.p(0, spSize.height))
    
    namePanel:setContentSize(cc.size(1, 1))
    namePanel:setPosition(data.pos)
    
    item:addTo(namePanel)
    namePanel:addTo(self)

    return namePanel
end

function MapMarkName:setNameVisible( bVisible )
    self:setVisible(bVisible)
end

-- function MapMarkName:setProhibitShow( isShow )
--     self.prohibitShow = isShow
--     if isShow then
--         self:setVisible(false)
--     end
-- end

function MapMarkName:refresh( ... )
    -- body
    -- dump(self.datas)
    if self.datas and next(self.datas) then
        for k, data in pairs(self.datas) do
            local pos = cc.p(data.sprite:getPosition())
            data.item:setPosition(self.mapSpaceToMarkSpaceConvertFunc(pos))
        end
    end
end

function MapMarkName:deltaMove(delta)
    local currentPosition = cc.p(self:getPosition())
    self:setPosition(cc.pAdd(currentPosition, delta))
end

function MapMarkName:setMapSpaceToMarkSpaceConvertFunc(func)
    self.mapSpaceToMarkSpaceConvertFunc = func
end

return MapMarkName
