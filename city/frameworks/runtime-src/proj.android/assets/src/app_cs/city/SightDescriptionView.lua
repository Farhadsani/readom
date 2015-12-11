
-- SightDescriptionView.lua   景点介绍页面
-- add by star 2015.3.11

local SightDescriptionView = class("SightDescriptionView", function()
    return display.newLayer()
end)

function SightDescriptionView:ctor(param)

    -- map layer
    self.rootNode = cc.uiloader:load("ui/IntroduceLayer.csb")
    self.rootNode:setPosition(cc.p(0, 0))
    self.rootNode:addTo(self)
    
    self.pnlBackGround = self.rootNode:getChildByName("pnlBackGround")
    self.txtPackName = self.pnlBackGround:getChildByName("txtPackName")
    self.pvPhoto = self.pnlBackGround:getChildByName("pvPhoto")
    self.lvIntroduce = self.pnlBackGround:getChildByName("lvIntroduce")
    self.close = self.rootNode:getChildByName("btnClose")

    self.packData = param.packData
    self.cityData = param.cityData

    -- dump(self.packData)
    
    -- self:initUI(self.packData)
    self.txtPackName:setString("")
    self:initEvents()
end

function SightDescriptionView:setDelegate(delegate)
    self.delegate = delegate
end

function SightDescriptionView:initUI(packData)
    -- local packData = self.packData

    -- QMapGlobal.DataManager:getSightDescription(self.cityData.cityid, packData.sightid, function ( sightDesc )
    --     print_r(sightDesc)
    -- end)


    -- print_r(packData)
    self.txtPackName:setString(packData.cname)
    local imageCount = #packData.imgs
    self.spPointList = {}

    local downloadPath = cc.FileUtils:getInstance():getDownloadPath()

    for key, imageName in pairs(packData.imgs) do
        -- local path = device.writablePath .. "map/"..self.cityData.name.."/sightImage/".. packData.sightid .. "/"..imageName.index..".jpg"
        local path = downloadPath .. "map/"..self.cityData.name.."/sightImage/".. packData.sightid .. "/"..imageName.index..".jpg"
        -- local path = device.writablePath.."1.jpg"
        -- print("这是最新的路径。。。。", path)
        local sp1 = display.newSprite(path)
        local size = sp1:getContentSize()
        local photoSize = self.pvPhoto:getContentSize()
        local dW = photoSize.width/size.width
        local l = ccui.Layout:create()
        l:setContentSize(photoSize)
        sp1:setScale(dW)
        sp1:setPosition(cc.p(photoSize.width/2,photoSize.height/2))
        sp1:addTo(l)
        self.pvPhoto:addPage(l)
        
        
        local spPoint = cc.uiloader:load("ui/MarkPointNode.csb")
        spPoint:setPosition(cc.p(500 + (key - (imageCount+1)/2) * 50, 650))
        local spPic = spPoint:getChildByName("pnlBack"):getChildByName("spPic")
        if key ~= 1 then
            spPic:setTexture("ui/image/graySmall.png")
        end
        table.insert(self.spPointList,spPic)
        spPoint:addTo(self.pnlBackGround)
    end
    self.pvPhoto:setCustomScrollThreshold(20)
--    local count = #packData.introduce.image
--    for i=1, count, 1 do
--    	
--    end
    
    for key, text in pairs(packData.desc) do
        local cell = cc.CSLoader:createNode("ui/IntroduceCell.csb") 
         
--        cell:setScale(0.5)
        --        print("qqqqqq", i)
--        local p = cell:getChildByName("Panel_1")
--        local t = p:getChildByName("Text_1")
--        t:setString("这是第"..i.."个")
        local bkNode = cell:getChildByName("pnlBKNode")
        local caption = bkNode:getChildByName("txtCaption")
        local content = bkNode:getChildByName("txtContent")
        local sp = bkNode:getChildByName("pnlImage"):getChildByName("spImage")
        
        caption:setString(QMapGlobal.systemData.sightDescCaption[tonumber(text.descid)])
        content:setString(text.content)
--        sp:setTag(tag)
        sp:setTexture("systemPic/systempic"..text.descid..".png")
        
        local size = bkNode:getContentSize()
        local item = ccui.Layout:create()
        cell:setPosition(cc.p(size.width/2, size.height/2)) 
        item:setContentSize(size)
        cell:addTo(item)
        self.lvIntroduce:insertCustomItem(item, key-1)
    end

end

function SightDescriptionView:initEvents()
--    self:setTouchEnabled(true)
--    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.mapHandler))
    self.close:addTouchEventListener(function(sender, event)
        if event == 2 then
            -- print("关闭。。。。。。。。。")
            self.delegate:onClose()
        end
    end)
    
    self.pvPhoto:addEventListener(function(sender, event)
--        print("self.pvPhoto:addEventListener......")
--        print_r(sender)
--        print_r(event)
        local index = sender:getCurPageIndex() 
        -- print("index = ", index)
        
        if self.spPointList and next(self.spPointList) then
            for key, var in ipairs(self.spPointList) do
            	if index + 1 == key then
            	   var:setTexture("ui/image/greenSmall.png")
            	else
            	   var:setTexture("ui/image/graySmall.png")
            	end
            end
        end
    end)
end

function SightDescriptionView:mapHandler(event)
    -- print("CitySelectionView...... click...")

    if event.name == "began" then
        return true

    elseif event.name == "moved" then

    elseif event.name == "ended" then
        
    end
end

function SightDescriptionView:addToNode(scene)
    self:addTo(scene)
end

function SightDescriptionView:onEnter()
    print("CitySelectionView onenter()")
end

function SightDescriptionView:onExit()
    print("CitySelectionView onExit()")
end

return SightDescriptionView
