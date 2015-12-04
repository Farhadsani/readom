local QMapScene = class("QMapScene", function()
    return display.newScene("QMapScene")
end)

function QMapScene:ctor()
    -- Stone.curScene = self
end

function QMapScene:switchToLayer(layer)
    -- 加载层之前，先删除原来的层
    if self.curLayer then
        print("delete old layer")
        self:removeLayer(self.curLayer)
    end

    self:addChild(layer)
    self.curLayer = layer
end

function QMapScene:addLayer(layerName, param) 
    local newlayer = Stone.app:createView(layerName, param)
    newlayer:addTo(self)
end

function QMapScene:removeLayer(layer)
    layer:removeFromParent(true)
    layer = nil
end

return QMapScene
