
local PageTableView = class("PageTableView", function()
    return display.newLayer()
end)

function PageTableView:ctor( param )

	self.scrollTop = 208
	self.scrollHeight = 208
	self.scrollWidth = 152
	self.cellHeight = 52
	self.cellNums = 2

	
	self.container = display.newColorLayer(ccc4(10, 20, 30, 10))
    self.container:setTouchEnabled(true)
    self.container:setPosition(ccp(1, 0))
    self.container:setTouchSwallowEnabled(false)
    self.container:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self:onCellCallback(event.name, event.x, event.y)
    end)
	self.widgetContainer = display.newSprite()    
    :align(display.LEFT_BOTTOM, 0, 0) 
    :addTo(self.container)

    self.scrollView = CCScrollView:create()
    self.scrollView:setContentSize(CCSizeMake(0, 0)) -- 設置內容大小
    self.scrollView:setViewSize(CCSizeMake(self.scrollWidth, self.scrollHeight)) -- 設置可見大小
    self.scrollView:setPosition(ccp(100, 100)) -- 設置位置
    self.scrollView:setContainer(self.container) -- 設置容器
    self.scrollView:setDirection(kCCScrollViewDirectionVertical) -- 設置滾動方向
    self.scrollView:setClippingToBounds(true) -- 設置剪切
    self.scrollView:setBounceable(true)  -- 設置彈性效果
    self.scrollView:setDelegate(this) -- 註冊為自身
    self:addChild(self.scrollView)

    self.scrollView:registerScriptHandler(scrollView2DidScroll, CCScrollView.kScrollViewScroll)

end

function PageTableView:onCellCallback(event, x, y)
    if event == "began" then
        self.bolTouchEnd = false
        return true
    elseif event == "ended" then
        self.bolTouchEnd = true
    end
end

function PageTableView:scrollView2DidScroll()
    if self.bolTouchEnd == true then
        self.bolTouchEnd = false
        local offy = self.layerContainer:getPositionY()
        local miny = self.scrollHeight-self.cellNums*self.cellHeight
        if offy < 0 and offy > miny then
            local item = -(math.abs(offy)%self.cellHeight)
            if item <= -self.cellHeight/2 then
                if offy < self.preOffy then
                    item = offy-item-self.cellHeight 
                else
                    item = offy-item-self.cellHeight
                end
            else
                item = offy-item
            end
            self.scrollView:setContentOffset(ccp(1, item), true)
        end
    end
end


return PageTableView

