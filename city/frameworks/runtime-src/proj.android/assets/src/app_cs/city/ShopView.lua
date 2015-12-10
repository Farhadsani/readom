

local ShopView = class("ShopView", function()
    return display.newLayer()
end)

function ShopView:ctor()
	self.rootLayer = cc.uiloader:load("ui/ShopLayer.csb")
    self.rootLayer:addTo(self)

    self:initUI()
    self:initEvent()
end

function ShopView:setDelegate(delegate)
    self.delegate = delegate
end

function ShopView:initUI( ... )
	local backGround = self.rootLayer:getChildByName("backGround")
	local pnlTitle = backGround:getChildByName("pnlTitle")

    self.backGround = backGround

	self.btnBack = pnlTitle:getChildByName("btnBack")
    self.pnlBack = pnlTitle:getChildByName("pnlBack")
    self.txtCaption = pnlTitle:getChildByName("txtCaption")

    self.lvClass = backGround:getChildByName("lvClass")
    self.lvMainBack = backGround:getChildByName("lvMainBack")
    self.lvMain = self.lvMainBack:getChildByName("lvMain")

    self.mainPic = self.lvMain:getChildByName("mainPic1"):getChildByName("mainPic")
    local pnlBtn = self.lvMain:getChildByName("pnlBtn")
    self.btnBuy = pnlBtn:getChildByName("btnBuy")
    self.pnlStar = pnlBtn:getChildByName("pnlStar")

    self.pnlDescs = self.lvMain:getChildByName"pnlDescs"
    self.pnlImages = self.lvMain:getChildByName"pnlImages"

    local pnlTitleSize = pnlTitle:getContentSize()
    pnlTitle:setPosition(cc.p(0, display.height - pnlTitleSize.height))

    local x,y = self.lvMainBack:getPosition()
    local lvMainSize = self.lvMainBack:getContentSize()
    self.lvMainBack:setContentSize(cc.size(lvMainSize.width, display.height - y - pnlTitleSize.height))
    self.lvMain:setContentSize(cc.size(lvMainSize.width-80, display.height - y - pnlTitleSize.height-80))

    self.btnL = backGround:getChildByName"btnL"
    self.btnR = backGround:getChildByName"btnR"

    self.pnlPrice = self.mainPic:getChildByName"pnlPrice"
    self.txtPrice = self.pnlPrice:getChildByName"txtPrice"

    -- local Text_3 = pnlBtn:getChildByName("Text_3")
    -- print("uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu")
    -- print_r(Text_3)

    self.pnlBack:setVisible(false)
end

function ShopView:setCaption( strCaption )
    self.txtCaption:setString(strCaption)
end

function ShopView:setClassIcon( index )
    -- body
end

function ShopView:addItemToClass( index, name, rootPath )
    local item = ccui.Layout:create()
    item:setContentSize(cc.size(200,320))

    local imageNode = ccui.Layout:create()
    imageNode:setName("imageNode")
    imageNode:setContentSize(cc.size(200,200))
    -- local spBack = ccui.Layout
    if name then
        imageNode:setBackGroundImage("ui/image/shopClassBack.png")
    else
        imageNode:setBackGroundImage("ui/image/shopClassBackNull.png")
    end
    imageNode:setBackGroundImageScale9Enabled(true)
    imageNode:setClippingEnabled(true)

    -- local rootPath = device.writablePath .. "specialitys/" .. "guilin" .. "/" .. index  .. "/icon.png"
    local fu = cc.FileUtils:getInstance()
    if rootPath and fu:isFileExist(rootPath) then
        local sp = display.newSprite(rootPath)
        sp:setName("icon")
        sp:setPosition(cc.p(100,100))
        sp:addTo(imageNode)
        local pnlSize = imageNode:getContentSize()
        local spSize = sp:getContentSize()
        local sW = pnlSize.width/spSize.width
        local sH = pnlSize.height/spSize.height
        local scale =  sW > sH and sW or sH 
        sp:setScale(scale*0.9)
    end

    imageNode:addTo(item)
    imageNode:setPosition(cc.p(0, 120))

    if name then
        local txtName = ccui.Text:create()
        txtName:setPosition(cc.p(100, 75))
        txtName:addTo(item)
        txtName:setString(name)
        txtName:setFontSize(40)
    
        item:setTouchEnabled(true)
        item:addTouchEventListener(function(sender, event)
            if event == 2 then
                print("当前点击了。。。。。。。。。", index)
                self.delegate:onSelClass(index)
            end
        end)
    end

    local itemGray = ccui.Layout:create()
    itemGray:setContentSize(cc.size(200,200))
    itemGray:setPosition(cc.p(0, 120))
    itemGray:setBackGroundColorType(1)
    itemGray:setBackGroundColor(cc.c3b(0,0,0))
    itemGray:setBackGroundColorOpacity(60)
    itemGray:setName("itemGray")
    itemGray:addTo(item)
    itemGray:setVisible(false)

    self.lvClass:insertCustomItem(item, index-1)
end

function ShopView:setMainPanel( mainPanelData )
    if not mainPanelData or not next(mainPanelData) then return end

    -- local pnlContentHeight = 570
    local fu = cc.FileUtils:getInstance()

    if mainPanelData.mainPicPath and fu:isFileExist(mainPanelData.mainPicPath) then
        self.mainPic:setBackGroundImage(mainPanelData.mainPicPath)
    else
        self.mainPic:setBackGroundImage("ui/image/shopMainPic.png")
    end

    if mainPanelData.priceContent then
        self.pnlPrice:setVisible(true)
        self.txtPrice:setString(mainPanelData.priceContent)
        local pSize = self.txtPrice:getContentSize()
        self.pnlPrice:setContentSize(cc.size(pSize.width + 40, 100))
    else

        self.pnlPrice:setVisible(false)
    end

    local level = math.floor(mainPanelData.level)
    for i = 1, level do
        local sp = display.newSprite("ui/image/star1.png")
        sp:setPosition(cc.p(i*50, 60))
        sp:setScale(2)
        sp:addTo(self.pnlStar)
    end
    mainPanelData.level = tonumber(mainPanelData.level)
    if level < mainPanelData.level then
        local sp = display.newSprite("ui/image/star2.png")
        sp:setPosition(cc.p((level+1)*50, 60))
        sp:setScale(2)
        sp:addTo(self.pnlStar)
    end


    self.pnlDescs:removeAllChildren()
    local descs = mainPanelData.descs
    if descs and next(descs) then
        local itemCount = #descs
        -- local content = ccui.Layout:create()
        -- self.pnlDescs:setContentSize(cc.size(800,80*itemCount))

        local curHeight = 0

        for i,item in ipairs(descs) do
            local itemNode = cc.uiloader:load("ui/ShopDescItem.csb")
            itemNode:setName("descItem"..i)
            itemNode:setPosition(cc.p(0, curHeight )) --80*(itemCount-i)))
            local pnlBack = itemNode:getChildByName("pnlBack")
            pnlBack:setClippingEnabled(false)
            local txtTitle = pnlBack:getChildByName("txtTitle")
            local txtContent = pnlBack:getChildByName("txtContent")
            local pnlIcon = pnlBack:getChildByName("pnlIcon")
            local spIcon = pnlIcon:getChildByName"spIcon"

            txtTitle:setFontName(QMapGlobal.resFile.font.caption)
            
            print(item.title, item.content)
            txtContent:setString(item.content)
            txtContent:ignoreContentAdaptWithSize(false); 
            txtContent:setTextAreaSize(cc.size(200, 100))

            -- pnlBack:setBackGroundColorType(1)
            -- if i == 1 then
            --     pnlBack:setBackGroundColor(cc.c3b(0,255,255))
            -- elseif i == 2 then
            --     pnlBack:setBackGroundColor(cc.c3b(0,255,0))
            -- elseif i == 3 then
            --     pnlBack:setBackGroundColor(cc.c3b(255,0,255))
            -- end

            -- local size = txtContent:getContentSize()
            -- local asize = txtContent:getTextAreaSize()
            -- print("......................")
            -- print_r(size)
            -- print_r(asize)

            -- ui.newTTFLabel
            -- txtContent
            -- txtContent:setPosition(cc.p(400,40))
            -- txtContent:setLineBreakWithoutSpace(true)
            -- txtContent:setMaxLineWidth(150)

            txtContent:setVisible(false)

            local label = cc.ui.UILabel.new({
            -- local ui = require(cc.PACKAGE_NAME .. ".ui")
            -- -- cc.ui.UILabel()
            -- local label = ui.newTTFLabel({
                UILabelType = 2,
                text = item.content,
                font = QMapGlobal.resFile.font.content,   --"Arial",
                size = 36, 
                color = cc.c3b(0, 0, 0), -- 使用纯红色
                align = cc.ui.TEXT_ALIGN_LEFT,
                valign = cc.ui.TEXT_VALIGN_TOP,
                dimensions = cc.size(630, 0)
            })
            -- label:setPosition(cc.p(236,60))
            label:setAnchorPoint(cc.p(0,1))
            label:addTo(pnlBack)
            local sizeLabel = label:getContentSize()
            print_r(sizeLabel)

            local pnlBackHeight = sizeLabel.height + 19*2
            pnlBack:setContentSize(cc.size( 860, pnlBackHeight))

            print("sizeLabel.height = ", sizeLabel.height , "curHeight = ", curHeight)
            curHeight = pnlBackHeight + curHeight

            pnlIcon:setPosition(cc.p(0, pnlBackHeight - 32-8))
            txtTitle:setPosition(cc.p(149, pnlBackHeight - (22.5+17.5)))
            label:setPosition(cc.p(236, pnlBackHeight - 19))

            txtTitle:setString(item.title)
            -- local color = item.color
            txtTitle:setColor(item.color)
            
            if fu:isFileExist(item.iconPath) then 
                -- pnlIcon:setBackGroundImage(item.iconPath)
                spIcon:setTexture(item.iconPath)
                spIcon:setVisible(true)

                local spSize = spIcon:getContentSize()
                local pnlSize = pnlIcon:getContentSize()
                local sW = pnlSize.width/spSize.width
                local sH = pnlSize.height/spSize.height
                local scale =  sW > sH and sW or sH 
                spIcon:setScale(scale)
 
             else
                spIcon:setVisible(false)
            end
            itemNode:addTo(self.pnlDescs)
        end
        -- self.lvMain:insertCustomItem(self.pnlDescs:, 2)

        print("curHeight = ", curHeight)
        self.pnlDescs:setContentSize(cc.size(860,curHeight )) -- 80*itemCount))

        -- pnlContentHeight = pnlContentHeight + curHeight
    end
    

    self.pnlImages:removeAllChildren()
    local images = mainPanelData.images
    -- images = nil
    -- dump(images)
    if images and next(images) then
        -- images[2] = nil
        -- images[3] = nil
        -- images[4] = nil
        -- images[5] = nil
        local itemCount = #images
        -- print(itemCount, ".......")
        self.pnlImages:retain()
        -- self.pnlImages:removeFromParent()
        self.lvMain:removeItem(3)
        self.pnlImages:setContentSize(cc.size(860, 430*itemCount))
        
        for i, item in ipairs(images) do
            local imagePath = item.imagePath
            local pnlImage = ccui.Layout:create()
            pnlImage:setName("pnlImage"..i)
            pnlImage:setContentSize(cc.size(860, 400))
            if fu:isFileExist(imagePath) then
                pnlImage:setBackGroundImage(imagePath)
            else
                pnlImage:setBackGroundImage("ui/image/shopMainPic.png")
            end
            pnlImage:setBackGroundImageScale9Enabled(true)
            pnlImage:setClippingEnabled(true)
            pnlImage:addTo(self.pnlImages)
            pnlImage:setPosition(cc.p(0, 430*(i-1)))

        end

        -- self.pnlImages:setBackGroundColorType(1)
        -- self.pnlImages:setBackGroundColor(cc.c3b(0,255,255))

        self.lvMain:insertCustomItem(self.pnlImages, 3)
        self.pnlImages:release()

        -- pnlContentHeight = pnlContentHeight + 430*itemCount
    end

    
-- print(pnlContentHeight, "qqqqqqqqqqqqqqqqq")
--     self.lvMain:setInnerContainerSize(cc.size(900, 1180)) -- pnlContentHeight))
    -- self.lvMain:setBackGroundColorType(1)
    -- self.lvMain:setBackGroundColor(cc.c3b(0,255,0))

    -- local innerCon = self.lvMain:getInnerContainer()
    -- innerCon:setBackGroundColorType(1)
    -- innerCon:setBackGroundColor(cc.c3b(255,0,0))
    self.lvMain:scrollToTop(1, true)
-- print("000000000000000000000")
    -- print_r(self.lvMain:getInnerContainerSize())
end

function ShopView:initEvent(  )
	-- self.btnBack:addTouchEventListener(function(sender, event)
 --        if event == 2 then
 --            print("关闭。。。。。。。。。")
 --            self.delegate:onClose()
 --        end
 --    end)

    self.pnlBack:addTouchEventListener(function(sender, event)
        if event == 2 then
            print("关闭。。。。。。。。。")
            self.delegate:onClose()
        end
    end)

    self.btnBuy:addTouchEventListener(function(sender, event)
        if event == 2 then
            print("购买。。。。。。。。。")
            self.delegate:onBuy()
        end
    end)

    self.backGround:addTouchEventListener(function(sender, event)
        if event == 2 then
            print("关闭。。。。。。。。。")
            self.delegate:onClose()
        end
    end)

    -- self.lvClass:addTouchEventListener(function (sender, event) 
    --     -- print_r(event)
    --     if event == 2 then
    --         print_r(event)
    --         local selIndex = self.lvClass:getCurSelectedIndex()
    --         print("当前选中的是。。。。", selIndex)
    --     end
    -- end)

    self.btnL:addTouchEventListener(function ( sender, event )
        local innerContainer = self.lvClass:getInnerContainer()
        local innerSize = innerContainer:getContentSize() 
        local lvCardSize = self.lvClass:getContentSize()
        local dH = innerSize.width - lvCardSize.width

        local innerPosX, innerPosY = innerContainer:getPosition()

        innerPosX = innerPosX + 200
        local per = 0
        if dH == 0 or innerPosX == 0 then return end 
        per = -innerPosX*100 / dH

        self.lvClass:scrollToPercentHorizontal(per, 1, true)
    end)

    self.btnR:addTouchEventListener(function ( sender, event )

        local innerContainer = self.lvClass:getInnerContainer()
        local innerSize = innerContainer:getContentSize() 
        local lvCardSize = self.lvClass:getContentSize()
        local dH = innerSize.width - lvCardSize.width

        local innerPosX, innerPosY = innerContainer:getPosition()

        innerPosX = innerPosX - 200
        local per = 0
        if dH == 0 or innerPosX == 0 then return end 
        per = -innerPosX*100 / dH

        self.lvClass:scrollToPercentHorizontal(per, 1, true)
    end)
end

-- function ShopView:getListViewPosPercent( )
--     local innerContainer = self.lvClass:getInnerContainer()
--     local innerSize = innerContainer:getContentSize() 
--     local lvCardSize = self.lvClass:getContentSize()
--     local innerPosX, innerPosY = innerContainer:getPosition()

--     local dH = innerSize.width - lvCardSize.width
--     -- print("dH = ", dH)
--     if dH == 0 or innerPos == 0 then return 0 end
--     return -innerPosX*100/dH
-- end

function ShopView:updataUI_ClassIcon(index, path)
    local item = self.lvClass:getItem(index)
    if item then
        local imageNode = item:getChildByName("imageNode")
        if imageNode then
            local sp = imageNode:getChildByName("icon")
            if sp then
                sp:removeFromParent()
            end
            sp = display.newSprite(path)
            sp:setName("icon")
            sp:setPosition(cc.p(100,100))
            sp:addTo(imageNode)
            local pnlSize = imageNode:getContentSize()
            local spSize = sp:getContentSize()
            local sW = pnlSize.width/spSize.width
            local sH = pnlSize.height/spSize.height
            local scale =  sW > sH and sW or sH 
            sp:setScale(scale*0.9)
        end
    end
end

function ShopView:updataUI_MainPic( index, path )
    self.mainPic:setBackGroundImage(path)
end

function ShopView:updataUI_Images( index,sIndex, path )
    local image = self.pnlImages:getChildByName("pnlImage"..sIndex)
    image:setBackGroundImage(path)
end

function ShopView:updataUI_DescIcon( index,sIndex, path )
    local item = self.pnlDescs:getChildByName("descItem"..sIndex)
    if item then
        local pnlBack = item:getChildByName("pnlBack")
        if pnlBack then
            local pnlIcon = pnlBack:getChildByName("pnlIcon")
            if pnlIcon then
                local spIcon = pnlIcon:getChildByName"spIcon"
                if spIcon then
                    spIcon:setTexture(path)
                    spIcon:setVisible(true)

                    local spSize = spIcon:getContentSize()
                    local pnlSize = pnlIcon:getContentSize()
                    local sW = pnlSize.width/spSize.width
                    local sH = pnlSize.height/spSize.height
                    local scale =  sW > sH and sW or sH 
                    spIcon:setScale(scale)
                end
                -- pnlIcon:setBackGroundImage(path)
            end
        end
    end
end

function ShopView:setClassState( oldSelIndex, newSelIndex )
    if oldSelIndex then
        local oldItem = self.lvClass:getItem(oldSelIndex)
        -- oldItem:setOpacity(255)
        local itemGray = oldItem:getChildByName("itemGray")
        itemGray:setVisible(false)
    end
    local newItem = self.lvClass:getItem(newSelIndex)
    -- newItem:setOpacity(100)
    -- newItem:setVisible(false)
    local itemGray = newItem:getChildByName("itemGray")
    itemGray:setVisible(true)
end

return ShopView














