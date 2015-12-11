
local IntroduceLayer = class("IntroduceLayer", function()
    return display.newLayer()
end)

function IntroduceLayer:ctor(param)

	self._mainLayer = cc.uiloader:load(QMapGlobal.resFile.csb.IntroduceNode)
    self._mainLayer:addTo(self)

    self.backGround = self._mainLayer:getChildByName("pnlBack2")
    self.pnlMainView = self.backGround:getChildByName("pnlMainView")
    self.lvContent = self.pnlMainView:getChildByName("lvContent")
    self.pnlTitle = self.backGround:getChildByName("pnlTitle")
    self.txtSightName = self.pnlTitle:getChildByName("txtSightName")
    self.spMark = self.pnlTitle:getChildByName("spMark")

    self.pnlTitle:setPosition(cc.p(40, display.height-395))
    self.pnlMainView:setContentSize(1000, display.height-565)
    self.lvContent:setContentSize(cc.size(940, display.height-565-50))

    local spPointR = self.pnlMainView:getChildByName("spPointR")
    local spPointL = self.pnlMainView:getChildByName("spPointL")

    spPointR:setPosition(cc.p(100, display.height-565 - 25))
    spPointL:setPosition(cc.p(900, display.height-565 - 25))

    -- self.backGround = ccui.Layout:create()
    -- self.backGround:setContentSize(cc.size(display.width, display.height))
    -- self.backGround:setPosition(cc.p(0,0))
    -- self.backGround:setBackGroundColorType(1)
    -- self.backGround:setBackGroundColor(cc.c3b(0,0,0))
    -- self.backGround:setBackGroundColorOpacity(60)
    -- self.backGround:addTo(self)

    -- self.listView = ccui.ListView:create()
    -- self.listView:setContentSize(cc.size(display.width, display.height*0.6))
    -- self.listView:setPosition(cc.p(0,0))
    -- self.listView:setBackGroundColorType(1)
    -- self.listView:setBackGroundColor(cc.c3b(241,241,241))

    -- self.listView:addTo(self)
end

function IntroduceLayer:setDelegate(delegate)
    self._delegate = delegate
end

function IntroduceLayer:setMainCell( strSightName, strDesc )
    local mainCell = ccui.Layout:create()
    mainCell:setContentSize(cc.size(display.width, 200))
    mainCell:setBackGroundColorType(1)
    mainCell:setBackGroundColor(cc.c3b(255,0,0))
    self.listView:insertCustomItem(mainCell, 0)

    local mainPic = display.newSprite("ui/image/intro_1.png")
    mainPic:setPosition(cc.p(40, 130))
    mainPic:addTo(mainCell)

    local sightName = cc.ui.UILabel.new({
        UILabelType = 2,
        text = strSightName,
        font =  QMapGlobal.resFile.font.content,   --"Zapfino",  --"Arial",
        size = 36, 
        color = cc.c3b(77, 77, 77), -- 使用纯红色
        align = cc.ui.TEXT_ALIGN_LEFT, 
        valign = cc.ui.TEXT_VALIGN_TOP,
        dimensions = cc.size(470, 30)
    })
    sightName:setAnchorPoint(cc.p(0,1))
    sightName:addTo(bkNode)

    return mainCell
end

function IntroduceLayer:onInit( introData )

	dump(introData)

	self.txtSightName:setString(introData.name)

    local titleSize = self.pnlTitle:getContentSize()
    local sightNameSize = self.txtSightName:getContentSize()
    local markSize = self.spMark:getContentSize()
    local titleW = sightNameSize.width + markSize.width + 15
    local tX = (titleSize.width-titleW)/2
    local tY = titleSize.height/2
    self.spMark:setPosition(cc.p(tX, tY))
    self.txtSightName:setPosition(cc.p(tX + markSize.width + 15, tY))


	self.lvContent:removeAllChildren()
    -- self.listView:removeAllChildren()

    -- local mainCell = self:setMainCell(introData.name)
    -- self.listView:insertCustomItem(mainCell, 0)

    -- dump(introData.intros)
    local i = 0
    local lastPnlLine = nil
	for key, text in pairs(introData.intros) do
        if type(text) == "table" then 
            i = i+1
            local cell = cc.CSLoader:createNode(QMapGlobal.resFile.csb.IntroduceCell) 
             
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

            caption:setFontName(QMapGlobal.resFile.font.caption)

            local label = cc.ui.UILabel.new({
            --     })
            -- local ui = require(cc.PACKAGE_NAME .. ".ui")
            -- local label = ui.newTTFLabel({
                UILabelType = 2,
                text = text.content,
                font =  QMapGlobal.resFile.font.caption,   --"Zapfino",  --"Arial",
                size = 36, 
                color = cc.c3b(147, 205, 86), -- 使用纯红色
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

            bkNode:setContentSize(cc.size(900, bkNodeHeight))

            label:setPosition(cc.p(350, bkNodeHeight-50))
            caption:setPosition(cc.p(160, bkNodeHeight-75))
            pnlImage:setPosition(cc.p(35, bkNodeHeight-75))
            
            local captionData = QMapGlobal.systemData.sightDescCaption[tonumber(text.descid)] or {}
            caption:setString(captionData.caption or "")
            -- caption:setColor(captionData.color or cc.c3b(255,255,255))
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

            pnlImage:setPosition(cc.p(75, size.height/2))
            caption:setPosition(cc.p(160, size.height/2))
            
            local item = ccui.Layout:create()
            cell:setPosition(cc.p(size.width/2, size.height/2)) 
            item:setContentSize(size)
            -- item:setContentSize(cc.size(size.width, contentSize.height))
            cell:addTo(item)
            self.lvContent:insertCustomItem(item, key-1)
            -- self.listView:insertCustomItem(item, key)
        end
    end

    if lastPnlLine then
        lastPnlLine:setVisible(false)
    end

    self.backGround:addTouchEventListener(function(sender, event)
        if event == 2 then
            print("关闭。。。。。。。。。")
            self._delegate:tappedElseWhere()
        end
    end)
end

function IntroduceLayer:showAction( isShow )
    local time = 0.3
    if isShow then
        self:setVisible(true)
        self.backGround:setPosition(cc.p(0, display.height))
        local a1 = cc.MoveTo:create(time, cc.p(0, 0))
        local a2 = cc.EaseOut:create(a1, time)
        self.backGround:runAction(a2)
    else
        self.backGround:setPosition(cc.p(0, 0))
        local a1 = cc.MoveTo:create(time, cc.p(0, display.height))
        local a2 = cc.EaseIn:create(a1, time)
        local a3 = cc.CallFunc:create(function()
            self:setVisible(false)
        end)
        local a4 = cc.Sequence:create(a2, a3)
        self.backGround:runAction(a4)
    end
    
end

return IntroduceLayer