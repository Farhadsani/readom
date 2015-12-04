
local IntroduceLayer = class("IntroduceLayer", function()
    return display.newLayer()
end)

function IntroduceLayer:ctor(param)

	self._mainLayer = cc.uiloader:load("ui/IntroduceNode1.csb")
    self._mainLayer:addTo(self)

    self.backGround = self._mainLayer:getChildByName("pnlBackGround")
    self.lvContent = self.backGround:getChildByName("lvContent")
    self.txtSightName = self.backGround:getChildByName("txtSightName")
end

function IntroduceLayer:setDelegate(delegate)
    self._delegate = delegate
end

function IntroduceLayer:onInit( introData )
	-- dump(introData)
	self.txtSightName:setString(introData.name)
	self.lvContent:removeAllChildren()

    -- dump(introData.intros)
    local i = 0
    local lastPnlLine = nil
	for key, text in pairs(introData.intros) do
        i = i+1
        local cell = cc.CSLoader:createNode("ui/IntroduceCell1.csb") 
         
        local bkNode = cell:getChildByName("pnlBKNode")
        -- bkNode:setClippingEnabled(false)
        local caption = bkNode:getChildByName("txtCaption")
        local content = bkNode:getChildByName("txtContent")
        local pnlImage = bkNode:getChildByName("pnlImage")
        local spImage = pnlImage:getChildByName"spImage"
        local pnlLine = bkNode:getChildByName"pnlLine"
        lastPnlLine = pnlLine
        -- print("aaaaaaaaaaaaaaaaaaaaaaaaaa")
        -- print_r(content)   -- ccui.Text

        -- content:ignoreContentAdaptWithSize(false); 
        -- content:setSize(cc.size(400, 250)); 
        
        -- content:setTextAreaSize(cc.size(200, 0))

        -- if i % 2 == 0 then
        --     bkNode:setBackGroundColor(cc.c3b(0,255,255))
        -- else
        --     bkNode:setBackGroundColor(cc.c3b(255,0,255))
        -- end

        local label = cc.ui.UILabel.new({
        --     })
        -- local ui = require(cc.PACKAGE_NAME .. ".ui")
        -- local label = ui.newTTFLabel({
            UILabelType = 2,
            text = text.content,
            font = "Arial",
            size = 36, 
            color = cc.c3b(0, 0, 0), -- 使用纯红色
            align = cc.ui.TEXT_ALIGN_LEFT, 
            valign = cc.ui.TEXT_VALIGN_TOP,
            dimensions = cc.size(470, 0)
        })

        label:setAnchorPoint(cc.p(0,1))
        label:addTo(bkNode)

        local sizeLabel = label:getContentSize()
        -- print_r(sizeLabel)

        local bkNodeHeight = sizeLabel.height + 100
        if bkNodeHeight < 150 then bkNodeHeight = 150 end

        bkNode:setContentSize(cc.size(850, bkNodeHeight))

        label:setPosition(cc.p(350, bkNodeHeight-50))
        caption:setPosition(cc.p(160, bkNodeHeight-75))
        pnlImage:setPosition(cc.p(35, bkNodeHeight-75))
        
        local captionData = QMapGlobal.systemData.sightDescCaption[tonumber(text.descid)] or {}
        caption:setString(captionData.caption or "")
        caption:setColor(captionData.color or cc.c3b(255,255,255))
        content:setString(text.content)
        content:setVisible(false)
        -- local contentSize = content:getTextAreaSize()
        -- print_r(contentSize)
        -- print(content:getStringLength())
--        sp:setTag(tag)
        -- sp:setTexture("systemPic/systempic"..text.descid..".png")

        -- pnlImage:setBackGroundImage("systemPic/systempic"..text.descid..".png")

        spImage:setTexture("systemPic/systempic"..text.descid..".png")

        local spSize = spImage:getContentSize()
        local pnlSize = pnlImage:getContentSize()
        local sW = pnlSize.width/spSize.width
        local sH = pnlSize.height/spSize.height
        local scale =  sW > sH and sW or sH 
        spImage:setScale(scale)

        
        local size = bkNode:getContentSize()
        local item = ccui.Layout:create()
        cell:setPosition(cc.p(size.width/2, size.height/2)) 
        item:setContentSize(size)
        -- item:setContentSize(cc.size(size.width, contentSize.height))
        cell:addTo(item)
        self.lvContent:insertCustomItem(item, key-1)
    end

    if lastPnlLine then
        lastPnlLine:setVisible(false)
    end
end

return IntroduceLayer