
-- StartCommentCityView.lua 城市场景 开始点评页面

local StartCommentCityView = class("StartCommentCityView", function()
    return display.newLayer()
end)

function StartCommentCityView:ctor(param)

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
    
    self.menuLayer.labels["cityName"]:setString(self.cityData.cName)
end

function StartCommentCityView:setDelegate(delegate)
    self.delegate = delegate
    self.mapLayer.delegate = delegate
    self.menuLayer.delegate = delegate
end

function StartCommentCityView:initUI()

end

function StartCommentCityView:initEvents()

end

function StartCommentCityView:mapHandler(event)

end

function StartCommentCityView:addToNode(scene)
    self:addTo(scene)
end

function StartCommentCityView:onEnter()
    print("StartCommentCityView onenter()")
end

function StartCommentCityView:onExit()
    print("StartCommentCityView onExit()")
end

function StartCommentCityView:showMsg(strMsg)
    local msg = cc.uiloader:load("ui/oneBtnMsg.csb")
    local pnlBG = msg:getChildByName("pnlBG")
    local txtMsg = pnlBG:getChildByName("txtMsg")
    local btnOK = pnlBG:getChildByName("btnOK")
    txtMsg:setString(strMsg)
    msg:setPosition(cc.p(display.width/2,display.height/2))
    msg:addTo(self)
    btnOK:addTouchEventListener(function(sender, event)
        if event == 2 then
            --            print("简介。。。。。。。。。")
            self:closeMsg(msg)
        end
    end)
--    msg:setTouchSwallowEnabled(false)

    self.menuLayer.buttons["back"]:setButtonEnabled(false)
    self.menuLayer.buttons["edit"]:setButtonEnabled(false)
    self.menuLayer.buttons["publish"]:setButtonEnabled(false)
    return msg
end

function StartCommentCityView:closeMsg(node)
    node:removeFromParent()
    self.menuLayer.buttons["back"]:setButtonEnabled(true)
    self.menuLayer.buttons["edit"]:setButtonEnabled(true)
    self.menuLayer.buttons["publish"]:setButtonEnabled(true)
end

function StartCommentCityView:showPackMenu(param)
    if self.menu then
        self.menu:removeFromParent()
    end
    self.menu = cc.uiloader:load("ui/menu/OneBtnNode.csb")
    self.menu:setPosition(cc.p(display.width/2, display.height/2))
    self.menu:addTo(self)
    
-- 景点的名称
    self.menu:getChildByName("packName"):setString(param.packName)
    -- 简介
    self.menu:getChildByName("pnlBG"):addTouchEventListener(function(sender, event)
--        print(event)
        if event == 2 then
            print("点评。。。。。。。。。")
            self.delegate:onComment()
            self.menu:removeFromParent()
            self.menu = nil
        end
    end)
end

return StartCommentCityView