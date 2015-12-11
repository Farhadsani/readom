
-- MainCityView.lua 城市场景，地图主界面

--[[    主页面参数：
cityName : 城市名称
]]--

local MainCityView = class("MainCityView", function()
    return display.newLayer()
end)

function MainCityView:ctor(param)
    self.cityData = param.cityData
    self:initUI()
    self:initEvents()
end

function MainCityView:setDelegate(delegate)
    self.delegate = delegate
	self.menuLayer.delegate = delegate
    self.mapLayer:setDelegate(delegate)
end

function MainCityView:initUI()
    -- map layer
--<<<<<<< HEAD
--    self.mapLayer = require("app/views/MapLayer").new({mapName = "guilin"})
--=======
    self.mapLayer = require("app/views/MapLayer").new({mapName = self.cityData.name})
--    self.mapLayer:setScale(2)
-->>>>>>> fangdong
    self.mapLayer:addTo(self)

    -- menu layer
    self.menuLayer = require("app/views/MenuLayer").new()
    self.menuLayer:addTo(self)
    
    self.menuLayer.labels["cityName"]:setString(self.cityData.cname)
end

function MainCityView:initEvents()
--    self:setTouchEnabled(true)
--    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.mapHandler))
end

function MainCityView:mapHandler(event)
    print("CitySelectionView...... click...")

    if event.name == "began" then
        return true

    elseif event.name == "moved" then
       
    elseif event.name == "ended" then
        self.delegate:cityTapped("CitySelectionView", {cityName = self.cityData.name})
    end
end

function MainCityView:showPackMenu(param)
    if self.menu then
        self.menu:removeFromParent()
    end
    self.menu = cc.uiloader:load("ui/menu/mainCityVIewMenu.csb")
    self.menu:setPosition(cc.p(display.width/2, display.height/2))
    self.menu:addTo(self)
    
    -- 景点的名称
    self.menu:getChildByName("txtName"):setString(param.packName)
    -- 简介
    self.menu:getChildByName("pnlBackGround"):getChildByName("btnIntroduce"):addTouchEventListener(function(sender, event)
--        print(event)
        if event == 2 then
            print("简介。。。。。。。。。")
            self.delegate:onIntroduce()
            self.menu:removeFromParent()
            self.menu = nil
        end
    end)
    -- 标签
    self.menu:getChildByName("pnlBackGround"):getChildByName("btnLabel"):addTouchEventListener(function(sender, event)
        if event == 2 then
            print("简介。。。。。。。。。")
            self.delegate:onLabel()
            self.menu:removeFromParent()
            self.menu = nil
        end
    end)
    -- 评论
    self.menu:getChildByName("pnlBackGround"):getChildByName("btnComment"):addTouchEventListener(function(sender, event)
        if event == 2 then
            print("简介。。。。。。。。。")
            self.delegate:onComment()
            self.menu:removeFromParent()
            self.menu = nil
        end
    end)
end

function MainCityView:addToNode(scene)
    self:addTo(scene)
end

function MainCityView:onEnter()
    print("CitySelectionView onenter()")
end

function MainCityView:onExit()
    print("CitySelectionView onExit()")
end

return MainCityView
