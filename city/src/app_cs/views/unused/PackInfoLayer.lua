
local PackInfoLayer = class("PackInfoLayer",function ()
    return display.newLayer()
end)

function PackInfoLayer:ctor(param)
    self.rootLayer = cc.CSLoader:createNode(Stone.resFile.csb.packInfoView)
--    self.rootLayer:setScale(0.8)
    self.rootLayer:addTo(self)
    
    local packInfoPanel = self.rootLayer:getChildByName("packInfoPanel")
    local pnlBtn = packInfoPanel:getChildByName("pnlBtn")
    local btnClose = pnlBtn:getChildByName("btnClose")
    local btnJudge = pnlBtn:getChildByName("btnJudge")
    
    btnClose:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            Stone.curScene:removeLayer(self)
        end
    end)
    
    btnJudge:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            Stone.curScene:removeLayer(self)
            Stone.curScene:addLayer("PackJudgeLayer", param)
        end
    end)
    
    local pnlInfo = pnlBtn:getChildByName("pnlInfo")
    local mainPic = pnlInfo:getChildByName("spMainPic")
    local txtDesc = pnlInfo:getChildByName("txtDesc")
    
--    print(param.cityname, param.index)
    txtDesc:setString(cityData[param.cityname][param.index].desc)
end

function PackInfoLayer:onEnter()
end

function PackInfoLayer:onExit()
end

return PackInfoLayer