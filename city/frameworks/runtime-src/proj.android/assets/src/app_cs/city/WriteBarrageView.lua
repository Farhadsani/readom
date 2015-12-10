

-- WriteBarrageView.lua 写弹幕
-- add by star 2015.4.20

local WriteBarrageView = class("WriteBarrageView", function()
    return display.newLayer()
end)

function WriteBarrageView:ctor(param)

    self.cityid = param.cityid
    self.sightid = param.sightid

    self.rootLayer = cc.uiloader:load("ui/WriteBarrageLayer.csb")
    self.rootLayer:addTo(self)
    
    self.pnlBackGround = self.rootLayer:getChildByName("pnlBackGround")
    self.pnlBtnBack = self.pnlBackGround:getChildByName("pnlBtnBack")
    self.btnOK = self.pnlBtnBack:getChildByName("btnOK")
    self.txtContent = self.pnlBtnBack:getChildByName("txtContent")    
    self.btnBack = self.pnlBackGround:getChildByName("btnClose")
    print_r(self.txtContent)
    self:initEvents()
end

function WriteBarrageView:setDelegate(delegate)
    self.delegate = delegate
end

function WriteBarrageView:initUI(param)
end

function WriteBarrageView:initEvents()
    self.btnBack:setSwallowTouches(false)
    self.btnOK:setSwallowTouches(false)
    self.btnBack:addTouchEventListener(function(sender, event)
        if event == 2 then
            print("关闭。。。。。。。。。")
            -- self.txtContent:detachWithIME(true)
            self.delegate:onBack()
        end
    end)

    self.btnOK:addTouchEventListener(function(sender, event)
        if event == 2 then
            print("确定。。。。。。。。。")
            self.delegate:onOK()
        end
    end)
end

-- 返回本页面的点评信息
function WriteBarrageView:getBarrageInfo()
    return self.txtContent:getString() 
end

function WriteBarrageView:lvHandler(event)
    print_r(event)
end

function WriteBarrageView:addToNode(scene)
    self:addTo(scene)
end

function WriteBarrageView:onEnter()
    print("StartCommentCityView onenter()")
end

function WriteBarrageView:onExit()
    print("StartCommentCityView onExit()")
end

return WriteBarrageView