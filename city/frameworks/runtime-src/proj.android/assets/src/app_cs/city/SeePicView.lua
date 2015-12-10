
-- seePicView.lua 显示可滑动图片

local SeePicView = class("SeePicView", function()
    return display.newLayer()
end)

function SeePicView:ctor(param)

    self.rootLayer = cc.uiloader:load("ui/SeePicView.csb")
    self.rootLayer:addTo(self)
    
    self.pnlBackGround = self.rootLayer:getChildByName("pnlBackGround")
    self.pvImage = self.pnlBackGround:getChildByName("pvImage")
    self.btnClose = self.pnlBackGround:getChildByName("btnClose")
    
    self.spImageList = {}
    self:initEvents()
end

function SeePicView:setDelegate(delegate)
    self.delegate = delegate
end

function SeePicView:initUI(imageDatas, curIndex)

	local imageCount = #imageDatas
    self.spPointList = {}
	for key, imageData in pairs(imageDatas) do
        local path = imageData.path
        local sp1 = display.newSprite(path)
        local size = sp1:getContentSize()
        local photoSize = self.pvImage:getContentSize()
        local dW = photoSize.width/size.width
        local l = ccui.Layout:create()
        l:setContentSize(photoSize)
        sp1:setScale(dW)
        sp1:setPosition(cc.p(photoSize.width/2,photoSize.height/2))
        sp1:addTo(l)
        self.pvImage:addPage(l)
        
        local spPoint = cc.uiloader:load("ui/MarkPointNode.csb")
        spPoint:setPosition(cc.p(540 + (key - (imageCount+1)/2) * 50, 400))
        local spPic = spPoint:getChildByName("pnlBack"):getChildByName("spPic")
        if key ~= 1 then
            spPic:setTexture("ui/image/graySmall.png")
        end
        table.insert(self.spPointList,spPic)
        spPoint:addTo(self.pnlBackGround)
    end
    self.pvImage:setCustomScrollThreshold(20)

    local index = curIndex
    if index < 1 then index = 1 end
    if index > imageCount then index = imageCount end

    self.pvImage:scrollToPage(index - 1)
end

function SeePicView:initEvents()
	self.pvImage:addEventListener(function(sender, event)
        local index = sender:getCurPageIndex() 
        if self.spPointList and next(self.spPointList) then
            for key, var in ipairs(self.spPointList) do
            	if index + 1 == key then
            	   var:setTexture("ui/image/greenSmall.png")
            	else
            	   var:setTexture("ui/image/graySmall.png")
            	end
            end
        end
    end)

	self.btnClose:addTouchEventListener(function(sender, event)
		-- print("aaaaaaaaaaaaaaa", event)
		if event == 0 then   

	    elseif event == 2 then
	    	self.delegate:onBack()
	    end
        
    end)
    -- self.pnlBackGround:setTouchEnabled(true)
    -- self.pnlBackGround:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.rootHandler))
end

function SeePicView:rootHandler(event) 
	if event.name == "began" then
        return true
    elseif event.name == "ended" then
    print("seepic onback................")
        self.delegate:onBack()
    end
end

function SeePicView:lvHandler(event)
    print_r(event)
end

function SeePicView:addToNode(scene)
    self:addTo(scene)
end

function SeePicView:onEnter()
    print("StartCommentCityView onenter()")
end

function SeePicView:onExit()
    print("StartCommentCityView onExit()")
end

return SeePicView