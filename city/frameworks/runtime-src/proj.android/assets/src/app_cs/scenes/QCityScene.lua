
-- QCityScene.lua add star 2015.3.5 城市地图场景

local QCityScene = class("QCityScene", function()
    return display.newScene("QCityScene")
end)

function QCityScene:ctor()
-- Stone.curScene = self
end

function QCityScene:switchToLayer(layer)
    -- 加载层之前，先删除原来的层
    if self.curLayer then
        print("delete old layer")
        self:removeLayer(self.curLayer)
    end

    self:addChild(layer)
    self.curLayer = layer
end

function QCityScene:addLayer(layer, param) 
    local newlayer = Stone.app:createView(layer, param)
    newlayer:addTo(self)
end

function QCityScene:removeLayer(layer)
    layer:removeFromParent(true)
    layer = nil
end

return QCityScene
