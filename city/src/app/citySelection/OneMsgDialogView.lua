


local OneMsgDialogView = class("OneMsgDialogView", function()
    return display.newLayer()
end)

function OneMsgDialogView:ctor(param)

    self.rootLayer = cc.uiloader:load("ui/DialogLayer.csb")
    self.rootLayer:addTo(self)
    
    self.backGround = self.rootLayer:getChildByName("backGround")
    self.dialogBackGround = self.backGround:getChildByName"dialogBackGround"
    self.txtTip = self.dialogBackGround:getChildByName("txtTip")
    self.btnOK = self.dialogBackGround:getChildByName("btnOK")
    
    self:initEvents()
end

function OneMsgDialogView:setDelegate(delegate)
    self.delegate = delegate
end

function OneMsgDialogView:initUI(imageDatas, curIndex)

end

function OneMsgDialogView:initEvents()

	self.btnOK:addTouchEventListener(function(sender, event)
		-- print("aaaaaaaaaaaaaaa", event)
		if event == 0 then   

	    elseif event == 2 then
	    	self.delegate:onBack()
	    end
        
    end)
    -- self.pnlBackGround:setTouchEnabled(true)
    -- self.pnlBackGround:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.rootHandler))
end

function OneMsgDialogView:rootHandler(event) 
	if event.name == "began" then
        return true
    elseif event.name == "ended" then
    print("seepic onback................")
        self.delegate:onBack()
    end
end

function OneMsgDialogView:lvHandler(event)
    print_r(event)
end

function OneMsgDialogView:addToNode(scene)
    self:addTo(scene)
end

function OneMsgDialogView:onEnter()
    print("StartCommentCityView onenter()")
end

function OneMsgDialogView:onExit()
    print("StartCommentCityView onExit()")
end

return OneMsgDialogView