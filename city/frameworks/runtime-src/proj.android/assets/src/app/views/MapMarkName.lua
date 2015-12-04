
local MapMarkName = class("MapMarkName", function()
    return display.newNode()
end)

function MapMarkName:ctor(param)

    
end

function MapMarkName:showName( datas )
    self:removeAllChildren()
    if datas and next(datas) then
        for k, data in pairs(datas) do
            local item = self:createItem(data)
            data.item = item
        end
    end
    self.datas = datas
end

function MapMarkName:createItem( data )
    local namePanel = ccui.Layout:create()

    local item = ccui.Layout:create()
    item:setBackGroundImage("ui/image/sightNameBack1.png")
    item:setBackGroundImageScale9Enabled(true)
    -- item:setBackGroundImageCapInsets(cc.rect(3,0,3,0))

    local label = cc.ui.UILabel.new({
        UILabelType = 2,
        text = data.cname,
        font = "Arial",
        size = 36, 
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
    label:setPosition(cc.p(width/2, height/2))

    item:setAnchorPoint(cc.p(0.5, 0))
    

    local sp = display.newSprite("ui/image/sightNameP.png")
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
    if self.datas and next(self.datas) then
        for k,data in pairs(self.datas) do
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
