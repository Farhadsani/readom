
-- LoadCityView.lua 城市场景，地图主界面

--[[    主页面参数：
cityName : 城市名称
]]--

local LoadCityView = class("LoadCityView", function()
    return display.newLayer()
end)

function LoadCityView:ctor(param)
    self:initUI()
    self:initEvents()
end

function LoadCityView:setDelegate(delegate)
    self.delegate = delegate
--    self.mapLayer.delegate = delegate
--    self.menuLayer.delegate = delegate
end

function LoadCityView:initUI()
    -- map layer
--    self.mapLayer = require("app/views/MapLayer").new({mapName = "qingdao"})
--    self.mapLayer:addTo(self)

    local rootLayer = cc.uiloader:load("ui/LoadLayer.csb")
    rootLayer:addTo(self)
--
--    -- menu layer
--    self.menuLayer = require("app/views/MenuLayer").new()
--    self.menuLayer:addTo(self)
end

function LoadCityView:initEvents()
--    self:setTouchEnabled(true)
--    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.mapHandler))
end

function LoadCityView:mapHandler(event)
    print("CitySelectionView...... click...")

    if event.name == "began" then
        return true

    elseif event.name == "moved" then

    elseif event.name == "ended" then
        self.delegate:cityTapped("CitySelectionView", {cityName = "qingdao"})
    end
end

function LoadCityView:addToNode(scene)
    self:addTo(scene)
end

function LoadCityView:onEnter()
    print("CitySelectionView onenter()")
end

function LoadCityView:onExit()
    print("CitySelectionView onExit()")
end

return LoadCityView
