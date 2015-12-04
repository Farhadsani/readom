
local PackJudgeLayer = class("PackJudgeLayer",function ()
    return display.newLayer()
end)

function PackJudgeLayer:ctor(param)
    self.rootLayer = cc.CSLoader:createNode(Stone.resFile.csb.packJudgeView)
--    cc.uiloader:
    --    self.rootLayer:setScale(0.8)
    self.rootLayer:addTo(self)

    local pnlPackJudge = self.rootLayer:getChildByName("pnlPackJudge")
    local pnlCaption = pnlPackJudge:getChildByName("pnlCaption")
    local pnlContent = pnlCaption:getChildByName("pnlContent")
    
--    local editBox = cc.ui.UIInput:new({
--        x = 200,
--        y = 500,
----        size = cc.size(400,27)
--    }):addTo(pnlCaption)
    
--    local lvContent = ccui.ListView:new()
--    local size = pnlContent:getContentSize()
--    print(size.width, size.height)
--    lvContent:setContentSize(size)
--    lvContent:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)  --         Direction.)
    
--    lvContent:addTo(pnlContent)
--    print("1111111111111111111")
--    print(pnlContent)
--    print_r(pnlContent)
--    print("222222222222222222")
--    print_r(pnlCaption)
--    ccui.Layout
--    ccui.ListView
--    local itemx = ccui.Layout.new()
    
--    pnlContent:pushBackDefaultItem()
--    local item = ccui.Layout:create()
--    local custom_button = ccui.Button:create("res/back.png", "res/back.png")
--    pnlContent:insertCustomItem(custom_button, 0)
    
--    local cell = cc.CSLoader:createNode("PackJudgeCell.csb")
--    cell:addTo(pnlContent)
--    
--    
--    local cell1 = cc.CSLoader:createNode("PackJudgeCell.csb")
--    cell1:addTo(pnlContent)
      
--    local item0 = ccui.ListView:getItem(0)
--    local item1 = ccui.ListView:getItem(1)
--    print_r(item0)
--    print_r(item1)
--    pnlContent:addChild(cell)
--    pnlContent:addChild(cell1)

--    cc.ui.
    for i = 1, 10, 1 do
    
        
----        local item = UIListViewItem:new()
--        ccui.
        local cell = cc.CSLoader:createNode(Stone.resFile.csb.packJudgeCell)   
        cell:setScale(0.5)
--        print("qqqqqq", i)
        local p = cell:getChildByName("Panel_1")
        local t = p:getChildByName("Text_1")
        t:setString("这是第"..i.."个")
        local item = ccui.Layout:create()
        item:setContentSize(300,100)
        cell:addTo(item)
--        
--        local custom_button = ccui.Button:create("res/back.png", "res/back.png")
        pnlContent:insertCustomItem(item, i-1)   -- 此处不能直接添加cell节点
        
--        local btn = ccui.Button.new()
        
--        ccui.Text:new({
--            UILabelType = 2, text = "Hello, World", size = 64})
--            :align(display.CENTER, display.cx, display.cy)
--            :addTo(pnlContent)
--        item:
--        cell:addTo(item)
--        print_r(cell)
--        lvContent:newItem()
--        cell:setScale(0.5)
--        cell:setPosition(cc.p(0, 0))
--        cell:addTo(pnlContent)
--        lvContent:addContent(cell)
--        btn:addTo(pnlContent)
    end
    
    local btnClose = pnlCaption:getChildByName("btnClose")
    btnClose:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            Stone.curScene:removeLayer(self)
        end
    end)
    
--    btnClose:onButtonClicked(function(event)
--        if not rankView:isItemInViewRect(btnClose) then
--            print("CCSSample4Scene button not in view rect")
--            return
--        end

--        print("CCSSample4Scene button click")
--        -- dump(event, "event:")
--    end)
    local btnIntroduce = pnlCaption:getChildByName("btnIntroduce")
    btnIntroduce:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            Stone.curScene:removeLayer(self)
            Stone.curScene:addLayer("PackInfoLayer", param)
        end
    end)
end

function PackJudgeLayer:onEnter()
end

function PackJudgeLayer:onExit()
end

return PackJudgeLayer

