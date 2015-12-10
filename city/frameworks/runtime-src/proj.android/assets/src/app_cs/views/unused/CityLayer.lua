
-- CityLayer.lua 


local CityLayer = class("CityLayer",function ()
	return display.newLayer()
end)

function CityLayer:ctor(param)

    self.rootLayer = cc.CSLoader:createNode(Stone.resFile.csb.cityMapView)
    
    self.rootLayer:setScale(0.8)
    self.rootLayer:addTo(self)
--    aaa({  "topPanel"
--        })
    self.param = param
    print("CityLayer:ctor")
    print_r(param)
    
    self.cityData = cityData[param.cityname]
    
    self:AnalysisNode({"spMap", "topPanel"})
    
    local spMap = self.rootLayer:getChildByName("mapPanel"):getChildByName("spMap")
    print(Stone.resFile.csb.commentNode)
    self.packDlg = cc.CSLoader:createNode(Stone.resFile.csb.commentNode)

    self.packDlg:setVisible(false)
    self.packDlg:setScale(0.75)
    
--    cc.gl
    self:initUI()
    self:initEvents()
    
    self.packDlg:addTo(spMap)
    
    local topPanel = self.rootLayer:getChildByName("topPanel")
--    topPanel:setPosition(cc.p(0, 500))  
--    local topH = topPanel:getContentSize()
    local topH = topPanel:getBoundingBox()
--    print(display.widthInPixels, "/",display.heightInPixels)
--    print(display.width, "/", display.height)
--    print(topH.height)
    local scaleDisplay = display.widthInPixels/display.width
    local h = display.heightInPixels/scaleDisplay
--    print(scaleDisplay, "/",h, "/", h - topH.height*scaleDisplay)
--    topPanel:setPosition(cc.p(0, (h - topH.height*scaleDisplay)/0.8))  
    
--    local mapPanel = self.rootLayer:getChildByName("mapPanel")
--    local mapPanelSize = mapPanel:getContentSize()
--    mapPanelSize.height = (h - topH.height*scaleDisplay)/0.8
--    mapPanel:setContentSize(mapPanelSize)

    
end

function CityLayer:AnalysisNode(nodeList)
    
    self.rootNode = self.rootLayer
--    self.mapPanel = self.rootLayer:getChildByName("mapPanel")
    self.node = {}
    for _ , name in ipairs(nodeList) do
        self.rootNode:enumerateChildren("//"..name, function (node)
--            node:setVisible(false)
            self.node[name] = node
        end)
    end
end

function CityLayer:initUI()
    local mapPanel = self.rootLayer:getChildByName("mapPanel")
    local mapNode = mapPanel:getChildByName("spMap")
    self.mapMarkList = {}
    local linePoint = {}
--    for i , var in ipairs(self.cityData) do
--        local tasklNode = cc.CSLoader:createNode(Stone.resFile.csb.taskNode)
--        local spMainPic = tasklNode:getChildByName("spMainPic")
--        local spBackPic = tasklNode:getChildByName("spBack")
--        
----        local frameBack = display.newSpriteFrame(var.picBack)
----        spBackPic:setSpriteFrame(frameBack)
--        spBackPic:setTexture("map/"..var.picBack)
--        
----        local framePic = display.newSpriteFrame(var.pic)
----        spMainPic:setSpriteFrame(framePic)
--        spMainPic:setTexture("map/"..var.pic)
--        
--        local picSize = spMainPic:getContentSize()
--        tasklNode:setContentSize(picSize)
--        tasklNode:ignoreAnchorPointForPosition(false)
--        tasklNode:setAnchorPoint(0.5, 0.5)
--        tasklNode:setPosition(var.pos)
--        table.insert(linePoint, {var.pos.x, var.pos.y})
----        local blinkAct -- = cc.Blink:create(1.2,1)
----        local a1 = cc.FadeIn:create(2)
----        local a3 = cc.DelayTime:create(0.9)
----        local a2 = cc.FadeOut:create(1.1)
----        local blinkAct = cc.Sequence:create({a1, a3,a2})
--    
----        if i % 2 == 0 then
----            blinkAct = cc.Blink:create(1.2,1)
----        else
--        local a1 = cc.FadeIn:create(1)
--        local a4 = cc.EaseSineOut:create(a1)
----            cc.EaseSin
----        local a3 = cc.DelayTime:create(0.2)
--        local a2 = cc.FadeOut:create(1)
--        local a5 = cc.EaseSineIn:create(a2)
--        local blinkAct = cc.Sequence:create({a4,a5})
----        end
--        
----        cc.c
--    
--        local ract = cc.RepeatForever:create(blinkAct)
----        transition.fadeIn()
----        transition.sequence()
--        tasklNode:setScale(1)
--        
--		tasklNode:addTo(mapNode)
--		table.insert(self.mapMarkList,tasklNode)
--        spMainPic:runAction(ract)
--	end
--	
--    local shape3 = display.newPolygon(linePoint, {borderColor = cc.c4f(1.0, 0.0, 0.0, 1.0), borderWidth = 1})
--    display.(table,number)
--    shape3:addTo(mapNode)

--    local drawNode = cc.DrawNode:create()
--    drawNode:drawQuadBezier(cc.p(100, 150), cc.p(500,300), cc.p(500, 650), 1, cc.c4f(0,0,0,1))
    --drawNode:drawCubicBezier(cc.p(100, 150), cc.p(500,650), cc.p(300, 650), cc.p(800, 150), 500, cc.c4f(0,0,0,1))
--    drawNode:drawSegment(cc.p(100, 150), cc.p(500,650),20,cc.c4f(0,0,0,1))
--    drawNode:addTo(mapNode)
end

function CityLayer:initEvents()

    local topPanel = self.rootLayer:getChildByName("topPanel")
    local mapPanel = self.rootLayer:getChildByName("mapPanel")
    local bottomPanel = self.rootLayer:getChildByName("bottomPanel")
    local btn = topPanel:getChildByName("btnBack")
    --    btn:addTargetWithActionForControlEvents(cc.NODE_TOUCH_EVENT, function(event)
    --        print("btn event........")
    --    end)
    --    btn:addTouchEventListener(function(event)
    --        print("left menu pressed")
    --        print_r(event)
    --    end)
    if btn then
        btn:addTouchEventListener(handler(self, self.btnEvent))
    end
    


    self.rootLayer:setTouchEnabled(true)
    self.rootLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.rootHandler))
    
--    topPanel:setTouchEnabled(true)
--    topPanel:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.topHandler))
--     bottomPanel:setTouchEnabled(true)
--    bottomPanel:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.bottomHandler))
--    mapPanel:setTouchEnabled(true)
--    mapPanel:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.mapHandler))
    
--    print("star 1.........")
    --    self.rootLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    --        print("node event........")
    --    end)
end

function CityLayer:mapHandler(event)
    local mapPanel = self.rootLayer:getChildByName("mapPanel")
    local mapNode = mapPanel:getChildByName("spMap")
    local pt = cc.p(event.x, event.y)
    pt = mapPanel:convertToNodeSpace(pt)
--    print("mapPanel...",pt.x, pt.y)
    
    --    pt = mapNode:convertToNodeSpace(pt)
    --    print("mapNode...",pt.x, pt.y)
--    print_r(event)
    if event.name == "began" then
        self.beginX = pt.x
        self.beginY = pt.y
        
        self.bX = pt.x
        self.bY = pt.y
        return true
    elseif event.name == "moved" then 
        local dX = pt.x - self.beginX
        local dY = pt.y - self.beginY
        mapNode:setPosition(cc.pAdd( cc.p(mapNode:getPosition()), cc.p(dX, dY)))
        self.beginX = pt.x
        self.beginY = pt.y
    elseif event.name == "ended" then
        local box = mapNode:getBoundingBox()
        local boxPanel = mapPanel:getBoundingBox()
--        print_r(box)
        local dx = 0  
        local dy = 0
        if box.x + box.width < boxPanel.width then dx = boxPanel.width -box.width - box.x end
        if box.y + box.height < boxPanel.height then dy = boxPanel.height-box.height - box.y end
        if box.x > 0 then dx = -box.x end
        if box.y > 0 then dy = -box.y end

        mapNode:setPosition(cc.pAdd( cc.p(mapNode:getPosition()), cc.p(dx, dy)))  
        
        local selPack = false
        if pt.x - self.bX < 3 and pt.x - self.bX > -3 and pt.y - self.bY < 3 and pt.y - self.bY > -3 then
            local pt1 = cc.p(event.x, event.y)
            local pt1 = mapNode:convertToNodeSpace(pt1)
            for key, var in ipairs(self.mapMarkList) do
                local markBox1 = var:getBoundingBox()
                local sp = var:getChildByName("Sprite_1")
                if cc.rectContainsPoint(markBox1, pt1) then
                    print("hit mark........", key)

--                    self.packDlg:setVisible(true)
                    selPack = true
                    self.packDlg:setPosition(cityData.qingdao[key].pos)
                    local infoPanel = self.packDlg:getChildByName("infoPanel")
                    local packName = infoPanel:getChildByName("packName")
                    packName:setString(cityData.qingdao[key].name)
                    local btnPackInfo = infoPanel:getChildByName("btnPackInfo")
                    local btnCollect = infoPanel:getChildByName("btnCollect")
                    
                    btnPackInfo:addTouchEventListener(function(sender, eventType)
--                        print("btnPackInfo....", cityData.qingdao[key].name)
--                        print_r(eventType)
                        if eventType == ccui.TouchEventType.ended then
--                            Stone.curScene:loadLayer("PackInfoLayer", {cityname = "qingdao"})
                            Stone.curScene:addLayer("PackInfoLayer", {cityname = "qingdao", index = key})
--                              Stone.fireEvent("")
--                                Stone.fireEvent("click", {cityname = "qingdao", index = key})
                        end
                    end)
                    btnCollect:addTouchEventListener(function(sender, eventType)
                        print("btnCollect....", cityData.qingdao[key].name)
                        table.insert(TravelLine["qingdao"], key)
                    end)
                    
                    break
                end 
            end
        end 
--        if not selPack then
        self.packDlg:setVisible(selPack)
--        end
    end
end

function CityLayer:topHandler(event) 
    local topPanel = self.rootLayer:getChildByName("topPanel")
    local back = topPanel:getChildByName("spBack")
    local pt = cc.p(event.x, event.y)
    pt = topPanel:convertToNodeSpace(pt)
    local backBox = back:getBoundingBox()
    if event.name == "began" then
        return true
    elseif event.name == "ended" then
        if cc.rectContainsPoint(backBox, pt) then
            print("hit back........")
            --
        end
    end
end

function CityLayer:bottomHandler(event) 
--    print("CityLayer:bottomHandler")
    local bottomPanel = self.rootLayer:getChildByName("bottomPanel")
    local spRead = bottomPanel:getChildByName("spRead")
--    local spCollect = bottomPanel:getChildByName("spCollect")
    local spTravel = bottomPanel:getChildByName("spTravel")
    
    local pt = cc.p(event.x, event.y)
    pt = bottomPanel:convertToNodeSpace(pt)
    local readBox = spRead:getBoundingBox()
--    local collectBox = spCollect:getBoundingBox()
    local travelBox = spTravel:getBoundingBox()
    if event.name == "began" then
        return true
    elseif event.name == "ended" then
        if cc.rectContainsPoint(readBox, pt) then
            print("read........")
--        elseif cc.rectContainsPoint(collectBox, pt) then
--            print("collect........")
        elseif cc.rectContainsPoint(travelBox, pt) then
            print("travel........")
            
        end
    end
end

function CityLayer:rootHandler(event) 
--    print("rootHandler...............")
--    print_r(event)
    
    local mapPanel = self.rootLayer:getChildByName("mapPanel")
    local topPanel = self.rootLayer:getChildByName("topPanel")
    local bottomPanel = self.rootLayer:getChildByName("bottomPanel")
    local mapNode = mapPanel:getChildByName("spMap")
    
    local pt = cc.p(event.x, event.y)
    pt = self.rootLayer:convertToNodeSpace(pt)
--    print("root...",pt.x, pt.y)
    local topBox = topPanel:getBoundingBox()
    local bottomBox = bottomPanel:getBoundingBox()
--    r = cc.rect(1,1,1,1)
--    if topPanel:hitTest(pt, false) then
--        print("top hit.....")
--    elseif bottomPanel:hitTest(pt, false) then
--        print("bottom hit.....")
--    else
--        print("map hit.....")
--    end 
    
    if cc.rectContainsPoint(topBox, pt) then
--        print("top hit.....")
        return self:topHandler(event)
    elseif cc.rectContainsPoint(bottomBox, pt) then
--        print("bottom hit.....")
        return self:bottomHandler(event)
    else
--        print("map hit.....")
        return self:mapHandler(event)
    end
    
--    
--    print("mapHandler end...............")
end

function CityLayer:btnEvent(sender, eventType)
    print("btnHandler...............")
    --    print_r(event)
    print_r(eventType)
    --    print(tolua.type(event))
    --    local b = ccui.Button:new()
    --    sender:setVisible(false)
    if eventType == 0 then   

    elseif eventType == 2 then
    end

    print("btnHandler end...............")
end

function CityLayer:onEnter()
end

function CityLayer:onExit()
end

return CityLayer