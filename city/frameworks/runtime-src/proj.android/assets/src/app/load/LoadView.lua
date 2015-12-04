
-- LoadView.lua 程序启动加载界面
-- add by star 2015.5.6

local LoadView = class("LoadView", function()
    return display.newLayer()
end)

function LoadView:ctor(param)
    -- background
    -- self._background = display.newSprite("ui/LoadLayer.csb")
    -- self._background:setPosition(cc.p(display.width/2, display.height/2))
    -- self._background:setScale(2)
    self.rootNode = cc.uiloader:load("ui/LoadLayer.csb")
    self:addChild(self.rootNode, 1)

    self.pnlBackGround = self.rootNode:getChildByName("pnlBackGround") 

    self.sp1 = self.pnlBackGround:getChildByName("sp1")
    self.sp2 = self.pnlBackGround:getChildByName("sp2")
    self.sp3 = self.pnlBackGround:getChildByName("sp3")

    local action = cc.CSLoader:createTimeline("ui/LoadAni.csb");   
	self.sp1:runAction(action);   
	    
	-- //播放动画  
	-- //从第0帧到20帧循环播放  
	action:gotoFrameAndPlay(0, 50, true);

	local size = self.sp2:getContentSize()

	local a1_1 = cc.MoveTo:create(20, cc.p(-1628, 364.8))
	local a1_2 = cc.CallFunc:create(function()
			self.sp2:setPosition(cc.p(1628, 364.8))
		end)
	local a1_3 = cc.MoveTo:create(20, cc.p(0, 364.8))

	local a2_1 = cc.MoveTo:create(40, cc.p(-1628, 364.8))
	
	local a2_2 = cc.CallFunc:create(function()
			self.sp3:setPosition(cc.p(1628, 364.8))		
		end)

	local seq1 = cc.Sequence:create(a1_1, a1_2, a1_3)
	local seq2 = cc.Sequence:create(a2_1, a2_2 )
	
	local f1 = cc.RepeatForever:create(seq1)
	local f2 = cc.RepeatForever:create(seq2)
	
	self.sp2:runAction(f1)
	self.sp3:runAction(f2)

end

function LoadView:setAniate(  )
	-- body
end

function LoadView:setDelegate(delegate)
    self._delegate = delegate
    -- self._menuLayer:setDelegate(delegate)
end



return LoadView
