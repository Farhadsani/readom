-- TravelNoteView star 2015.3.5
-- 行程页面的视图


local TravelNoteView = class("TravelNoteView", function()
    return display.newLayer()
end)

function TravelNoteView:ctor(param)

    self.cityData = param.cityData
    -- map layer
--<<<<<<< HEAD
--    self.mapLayer = require("app/views/MapLayer").new({mapName = "qingdao"})
--=======
    self.mapLayer = require("app/views/MapLayer").new({mapName = self.cityData.name})
--    self.mapLayer:setPosition(cc.p(display.width/2, display.height/2))
--    self.mapLayer:setScale(2)
-->>>>>>> fangdong
    self.mapLayer:addTo(self)

    -- menu layer
    self.menuLayer = require("app/views/MenuLayer").new()
    self.menuLayer:addTo(self)
    
    
    self:initUI()
    self:initEvents()
end

function TravelNoteView:setDelegate(delegate)
    self.delegate = delegate
    self.mapLayer.delegate = delegate
    self.menuLayer.delegate = delegate
end

function TravelNoteView:initUI()
    
end

function TravelNoteView:initEvents()
    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.mapHandler))
end

function TravelNoteView:mapHandler(event)
    print("CitySelectionView...... click...")

    if event.name == "began" then
        return true

    elseif event.name == "moved" then

    elseif event.name == "ended" then
        
    end
end

function TravelNoteView:addToNode(scene)
    self:addTo(scene)
end

function TravelNoteView:onEnter()
    print("CitySelectionView onenter()")
end

function TravelNoteView:onExit()
    print("CitySelectionView onExit()")
end

function TravelNoteView:showPackMenu(param)
    if self.menu then
        self.menu:removeFromParent()
    end
    self.menu = cc.uiloader:load("ui/menu/OneBtnNode.csb")
    self.menu:setPosition(cc.p(display.width/2, display.height/2))
    self.menu:addTo(self)

    -- 景点的名称
    self.menu:getChildByName("packName"):setString(param.packName)
    local pnlBG = self.menu:getChildByName("pnlBG")
    pnlBG:getChildByName("btnCaption"):setString(param.caption)
    -- 简介
    pnlBG:addTouchEventListener(function(sender, event)
        --        print(event)
        if event == 2 then
            print("采集。。。。。。。。。")
--            self.delegate:onCollect()
            param.func(param.node)
            self.menu:removeFromParent()
            self.menu = nil
        end
    end)
end

function TravelNoteView:refresh(data)
    if self.numList then
        for key, numNode in pairs(self.numList) do
            numNode:removeFromParent(true)
        end
    end
    self.numList = {}
    if data and next(data) then
        for key, item in pairs(data) do
            local numNode = cc.uiloader:load("ui/numMarkNode.csb")
            local num = numNode:getChildByName("pnlBG"):getChildByName("txtNum")
            num:setString(key)
            
            numNode:setPosition(cc.p(display.width/2, display.height/2 + key*10))
            numNode:addTo(self)
            table.insert(self.numList,numNode)
        end
    end
end

return TravelNoteView