

local CardView = class("CardView", function()
    return display.newLayer()
end)

function CardView:ctor()
	self.rootLayer = cc.uiloader:load("ui/CardOneLayer.csb")
    self.rootLayer:addTo(self)

    -- self.pnlGround = self.rootLayer:getChildByName"pnlGround"

    -- self._menuLayer = require("app/views/MenuLayer").new()
    -- self.pnlGround:addChild(self._menuLayer, 2)
    self.barrageInfos = {}
    self:initUI()
    self:initEvent()

    self.scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
end

function CardView:setDelegate(delegate)
    self.delegate = delegate
    -- self._menuLayer:setDelegate(delegate)
end

------ menu
function CardView:menuEnterForController(controllerName, animated, menuEnteredCallback)
    -- self._menuLayer:menuEnterForController(controllerName, animated, menuEnteredCallback)
end

function CardView:initUI( ... )
	local backGround = self.rootLayer:getChildByName("backGround")

	self.backGround = backGround

	self.mainCard = backGround:getChildByName("mainCard")
	-- self.pnlQuit = backGround:getChildByName("pnlQuit")
	
	self.barrageBack = self.rootLayer:getChildByName("barrageBack")
	self.pnlWriteBarrage = self.rootLayer:getChildByName("pnlWriteBarrage")

	self.pnlBarrages = self.pnlWriteBarrage:getChildByName"pnlBarrage"
	self.txtTip = self.pnlWriteBarrage:getChildByName"txtTip"
	self.txtWrite = self.pnlWriteBarrage:getChildByName("txtWrite")

	self.pnlColse = self.pnlWriteBarrage:getChildByName"pnlColse"
	self.pnlOK = self.pnlWriteBarrage:getChildByName"pnlOK"

	self.pnlWriteBarrage:setVisible(false)

	-- print_r(self.txtWrite)    -- ccui.TextField
	self.txtWrite:setVisible(false)
	self.txtWrite:setTextColor(cc.c3b(0,0,0))
	self.txtWrite:setPlaceHolderColor(cc.c3b(0,0,0))
	self.txtWrite:setPlaceHolder("")
  
  	local eb = ccui.EditBox:create({width = 980, height = 100}, "Default/Button_Press.png")
   	eb:setAnchorPoint(0.5, 0.5)
    eb:setPosition(cc.p(540, 170))
    eb:setPlaceholderFontName("Arial")
    eb:setPlaceholderFontSize(48)
    eb:setPlaceholderFontColor(cc.c3b(0,0,0))
    eb:setFontName("Arial")
    eb:setReturnType(0)
    eb:setFontSize(48)
    eb:setPlaceHolder("...")
    eb:setFontColor(cc.c3b(0,0,0))
    eb:setInputMode(6)
   -- eb:setInputFlag(inputFlag)
    -- eb:setVisible(false)
    eb:addTo(self.pnlWriteBarrage)
    self.eb = eb
    eb:setContentSize(cc.size(980,100))

    local barrageSize = self.pnlBarrages:getContentSize()
    local barrageX, barrageY = self.pnlBarrages:getPosition()

    local cardScale = display.height/1920
    self.mainCard:setScale(cardScale*1.1 ) --, cardScale*1.1)
    self.mainCard:setPosition(cc.p(540, 1000*cardScale))


    -- self.pnlQuit:setPosition(cc.p(60, 1685*cardScale))

    if device.platform == "android" then
    	self.eb:setVisible(false)
    end

    self.cardScale = cardScale

    self.txtTip:setVisible(true)
end

function CardView:setCardPanel( cardData )
	-- dump(cardData)
    local cardNode = self.mainCard

    local pnlGround = cardNode:getChildByName"pnlGround"
    local pnlFrame = pnlGround:getChildByName"pnlFrame"
    local pnlMainPic = pnlGround:getChildByName"pnlMainPic"
    local pnlTitle = pnlGround:getChildByName"pnlTitle"
    local cardName = pnlTitle:getChildByName"cardName"
    local pnlStar = pnlGround:getChildByName"pnlStar"
    local spSource = pnlMainPic:getChildByName"spSource"
    -- local cardDesc = pnlGround:getChildByName"cardDesc"
    local svDesc = pnlGround:getChildByName"svDesc"
    local pnlKeyWord = pnlGround:getChildByName"pnlKeyWord"
    local pnlCollect = pnlGround:getChildByName"pnlCollect"
    local pnlWrite = pnlGround:getChildByName"pnlWrite"
    local txtCollect = pnlGround:getChildByName"txtCollect"
    local spCollect = pnlCollect:getChildByName"spCollect"
    self.txtCollect = txtCollect

    cardName:setString(cardData.cardname)
    if cardData.type == 2 then   
	    pnlTitle:setBackGroundImage("ui/image/cardTitle2.png")
	    pnlFrame:setBackGroundImage("ui/image/greenFrame.png")
	else
		pnlFrame:setBackGroundImage("ui/image/greenFrame1.png")
	end
    pnlMainPic:setBackGroundImage(cardData.mainPicPath)

    local spSourcePath = "ui/image/cardSource" .. (cardData.source or 1) .. "_" .. (cardData.type or 1) ..  ".png"
    print("source ..", spSourcePath)
	local fu = cc.FileUtils:getInstance()
    if fu:isFileExist(spSourcePath) then
    	spSource:setTexture(spSourcePath)
    	spSource:setVisible(true)
    else
    	spSource:setVisible(false)
    end

    -- cardDesc:setString(cardData.desc)
    -- cardDesc:setVisible(false)
    txtCollect:setString(cardData.collectcount)

    if cardData.starlevel and cardData.starlevel > 0 then
	    local starCount = cardData.starlevel
	    local starWidth = (starCount-1)*(15+55)/2
	    local starPosX = 300 - starWidth
	    for i = 1, cardData.starlevel do
	    	local spStar = display.newSprite("ui/image/cardStar.png")
	    	spStar:setPosition(cc.p(starPosX + (i-1) * (55+15), 50))
	    	spStar:addTo(pnlStar)
	    end
	end

	svDesc:removeAllChildren()
	local svDescSize = svDesc:getContentSize()
	local descLabel = cc.ui.UILabel.new({
        UILabelType = 2,
        text = cardData.desc,
        font = QMapGlobal.resFile.font.content,      --"Arial",
        size = 36, 
        color = cc.c3b(0, 0, 0), -- 使用纯红色
        align = cc.ui.TEXT_ALIGN_LEFT, 
        valign = cc.ui.TEXT_VALIGN_TOP,
        dimensions = cc.size(svDescSize.width, 0)
    })

    descLabel:setAnchorPoint(cc.p(0,0))
    descLabel:setPosition(cc.p(0,0))
    descLabel:addTo(svDesc)
    local descLabelSize = descLabel:getContentSize()
    svDesc:setInnerContainerSize(descLabelSize)


	local colorList = {
		cc.c3b(255, 153, 72),
		cc.c3b(69, 180, 239),
		cc.c3b(223, 148, 204),
		cc.c3b(108, 191, 110), 
		cc.c3b(166, 158, 255)
	}

	if cardData.label and next(cardData.label) then
		local nextPosX = 10
		local colorIndex = 0
		local nextPosY = nil --130
		local keyWordSize = pnlKeyWord:getContentSize()
		for k, strKeyWord in pairs(cardData.label) do
			colorIndex = colorIndex + 1
			if colorIndex > 5 then colorIndex = 1 end
			local label = cc.ui.UILabel.new({
                UILabelType = 2,
                text = strKeyWord,
                font = QMapGlobal.resFile.font.content,
                size = 36, 
                color = cc.c3b(255, 255, 255), -- 使用纯红色
                align = cc.ui.TEXT_ALIGN_LEFT,
                valign = cc.ui.TEXT_VALIGN_TOP,
                -- dimensions = cc.size(570, 0)
            })
            label:setAnchorPoint(cc.p(0.5, 0.5))
            

            local labelSize = label:getContentSize()

            labelSize.width = labelSize.width + 10
            labelSize.height = labelSize.height + 10

            label:setPosition(cc.p(labelSize.width/2,labelSize.height/2))


            local labelGround = ccui.Layout:create()
            if not nextPosY then 
            	nextPosY = keyWordSize.height - labelSize.height - 5
            end

            local tempX = nextPosX + labelSize.width + 10
            -- print("111", tempX, nextPosX , labelSize.width)
            if tempX > 600 then
            	tempX = 10 + labelSize.width + 10
            	nextPosX = 10
            	nextPosY = nextPosY - labelSize.height - 10   --100
            end

            -- print(strKeyWord, nextPosX, nextPosY)
            labelGround:setPosition(cc.p(nextPosX, nextPosY))
            labelGround:setBackGroundColorType(0)
			-- labelGround:setBackGroundColor(colorList[colorIndex])
			labelGround:setBackGroundImage("ui/image/card_10.png")
			labelGround:setBackGroundImageScale9Enabled(true)
			
			nextPosX = tempX
			-- print("xiayige X", nextPosX)
			labelGround:setContentSize(labelSize)			
            label:addTo(labelGround)
            labelGround:addTo(pnlKeyWord)
		end
	end

	if cardData.iscollect then
		local collectPath = "ui/image/cardCollect" .. (cardData.type or 1) .. "_" .. (cardData.iscollect or 0) ..".png"
		-- if cardData.iscollect == 1 then
		-- 	spCollect:setTexture("ui/image/cardCollect1.png")
		-- else
		-- 	spCollect:setTexture("ui/image/cardCollect.png")
		-- end
		spCollect:setTexture(collectPath)
        local spSize = spCollect:getContentSize()
        local pnlSize = pnlCollect:getContentSize()
        local sW = pnlSize.width/spSize.width
        local sH = pnlSize.height/spSize.height
        local scale =  sW > sH and sW or sH 
        spCollect:setScale(scale)
	end

	self.spCollect = spCollect

	pnlCollect:addTouchEventListener(function(sender, event)
        if event == 2 then
            print("收藏。。。。。。。。。")
            self.delegate:onCollect()
        end
    end)

	pnlWrite:setVisible(false)
	pnlWrite:addTouchEventListener(function(sender, event)
        if event == 2 then
            print("写弹幕。。。。。。。。。")
            -- local text = self.eb:getText()
            -- local text = self.txtWrite:getString()
            self.delegate:onWrite()
        end
    end)
	    
 	-- self.lvCard:insertCustomItem(item, index)
end

function CardView:showBarrage( barrageData )
	self.pnlBarrages:removeAllChildren()
	self.barrageInfos = barrageData
	if not self.barrageInfos then 
		print("no barrage data......")
		return 
	end
	
	self.pnlBarragesSize = self.pnlBarrages:getContentSize()

	self.barrageInfoIndex = 1
	local row = 0
	self:endScheduler()
	self.lastCells = {}
	self.existCells = {}

	self:beganScheduler()
end

function CardView:initEvent(  )

	-- self.pnlQuit:addTouchEventListener(function(sender, event)
 --        if event == 2 then
 --            print("关闭。。。。。。。。。")
 --            self.delegate:onClose()
 --        end
 --    end)

	self.pnlColse:addTouchEventListener(function(sender, event)
        if event == 2 then
            print("关闭。。。。。。。。。")
            self.delegate:onHideBarrage(false)
        end
    end)

	self.pnlOK:addTouchEventListener(function(sender, event)
        if event == 2 then
        	local text = self.eb:getText()
            -- local text = self.txtWrite:getString()
            text = string.trim(text)
            if string.len(text) > 0 then
            	self.delegate:onSendBarrage(text)
            else
            	-- self.txtWrite:DetachWithIME()
            	self.eb:touchDownAction(nil, 2)
            end
        end
    end)

    self.barrageBack:addTouchEventListener(function(sender, event)
        if event == 2 then
            print("关闭。。。。。。。。。")
            self.delegate:onHideBarrage(true)
        end
    end)

    self.backGround:addTouchEventListener(function(sender, event)
        if event == 2 then
            print("关闭。。。。。。。。。")
            self.delegate:onClose()
        end
    end)

    self.eb:registerScriptEditBoxHandler(function ( event )
    	-- print("self.eb 事件。。。。。。")
    	-- print_r(event)
    	-- print("end ................")

    	if device.platform == "android" then
    		if event == "return" then
    		
	    		self.eb:setVisible(true)
    		elseif event == "began"then
    			self.eb:setVisible(false)
	    	end
    	end
    end)

 --    self:setKeypadEnabled(true)
 --    self:addNodeEventListener(cc.KEYPAD_EVENT, function(event)
 --    	print("cardView    -------------------------")
	--     print_r(event)
	-- end)

	-- local node = display.newNode()
	-- node:addNodeEventListener(cc.KEYPAD_EVENT, function(event)
	-- 	print("-------------------------")
	--     print(event.name)
	--     print_r(event)
	-- end)
	-- node:addTo(self)
end

function CardView:initCell( barrageInfo , row )
	if not barrageInfo then return end
	local cell = cc.uiloader:load("ui/BarrageNode.csb")
	local pnlBackGround = cell:getChildByName("pnlBackGround") 
	local txtComtent = pnlBackGround:getChildByName("txtComtent")
	local pnlImage = pnlBackGround:getChildByName("pnlImage")
	local spImage = pnlImage:getChildByName("spImage")

	txtComtent:setString(barrageInfo.content)
	local userImage = "user/" .. barrageInfo.userid .. ".png"
	spImage:setTexture(userImage)
	
	local spSize = spImage:getContentSize()
    local pnlSize = pnlImage:getContentSize()
    local sW = pnlSize.width/spSize.width
    local sH = pnlSize.height/spSize.height
    local scale =  sW > sH and sW or sH 
    spImage:setScale(scale)

	local contentSize = txtComtent:getContentSize()
	local contentPosX, contentPosY = txtComtent:getPosition()
	local cellSize = pnlBackGround:getContentSize()

	pnlBackGround:setContentSize(cc.size(contentPosX + contentSize.width + 20, cellSize.height))
	local preCell = self.lastCells[row]
	local cellX = self.pnlBarragesSize.width
	if preCell then
		local preX,preY = preCell:getPosition()
		local pnlPreBackGround = preCell:getChildByName("pnlBackGround") 
		local cellPreSize = pnlPreBackGround:getContentSize()
		if cellX < preX + cellPreSize.width + 50 then
			cellX = preX + cellPreSize.width + 50
		end
		-- cell:setPosition(cc.p(preX + cellPreSize.width + 20, row * 90))
	end
	cell:setPosition(cc.p(cellX, row * 110))

	local time = (cellX + contentPosX + contentSize.width + self.pnlBarragesSize.width)/100
	-- local time = 10
	-- local actionMove = cc.MoveTo:create(time, cc.p(-(contentPosX + contentSize.width), row* 90))
	-- local actionMove = cc.MoveBy:create(10, cc.p(-contentPosX - contentSize.width - cellX, 0))
	local actionMove = cc.MoveBy:create(10, cc.p(-2500, 0))
	local actionFunc = cc.CallFunc:create(function()
		table.removebyvalue(self.existCells, cell, true)
	    cell:removeFromParent()
	end)

	pnlBackGround:setSwallowTouches(false)

	-- txtComtent:setString(barrageInfo.content)
	local actionSeq = cc.Sequence:create(actionMove,actionFunc)
	cell:addTo(self.pnlBarrages)
	cell:runAction(actionSeq)

	self.lastCells[row] = cell
	table.insert(self.existCells, cell)

end

function CardView:endScheduler( ... )
	if self.t1 then
		self.scheduler.unscheduleGlobal(self.t1)
		self.t1 = nil
	end
end

function CardView:beganScheduler( ... )
	self:endScheduler()
	-- print("11111111111111111111")
	if self.barrageInfos and next(self.barrageInfos) then
		-- print("222222222222222222222")
		self.t1 = self.scheduler.scheduleGlobal(function()
			if not self or not self.barrageInfos or not next(self.barrageInfos) then
				if self and self.endScheduler then
					self:endScheduler()
				end
				return
			end
			self.txtTip:setVisible(false)
			for i = 1, 2 do
				local barrageInfo = self.barrageInfos[self.barrageInfoIndex]
				if not barrageInfo then 
					self.barrageInfoIndex = 1
					barrageInfo = self.barrageInfos[self.barrageInfoIndex]
				end
				local preCell = self.lastCells[i-1]
				local toNext = true
				if preCell then
					local preX,preY = preCell:getPosition()
					if preX > self.pnlBarragesSize.width then
						toNext = false
					end
				end
				if toNext then
			    	self:initCell(barrageInfo, i-1)
		        	self.barrageInfoIndex = self.barrageInfoIndex + 1
		        end
			end
	    end, 1)
	end
end

function CardView:showWrite(  )
	-- body
	self.barrageBack:setVisible(true)
	local h = display.height * 0.7 -- 1100*0.9   --self.cardScale
	if device.platform == "android" then
		h = display.height * 0.5 + 230 + 30
	end
	local a1 = cc.MoveTo:create(0.7, cc.p(0, h))
	-- print("这个时候的高度是", h)
	local a2 = cc.EaseSineIn:create(a1)
	local a3 = cc.CallFunc:create(function (  )
		self.eb:touchDownAction(nil, 2)
		-- self.eb:setVisible(false)
		-- self.txtWrite:attachWithIME()
	end)
	self.pnlWriteBarrage:runAction(cc.Sequence:create(a2, a3))
end

function CardView:closeBarrage( retainText)
	-- body
	if not retainText then
		self.eb:setText("")
		-- self.txtWrite:setString("")
	end
	self.barrageBack:setVisible(false)
	local a1 = cc.MoveTo:create(1, cc.p(0, 0))
	local a2 = cc.EaseSineOut:create(a1)
	self.pnlWriteBarrage:runAction(a2)
end

function CardView:addBarrageData( strContent )
	if not next(self.barrageInfos) then
		table.insert(self.barrageInfos, strContent)
	 	self:showBarrage(self.barrageInfos)
	else
	 	table.insert(self.barrageInfos, strContent)
	end
	
end

function CardView:modCollectCount( count , isCollect, cardType)
	self.txtCollect:setString(count)

	-- if isCollect == 1 then
	-- 	-- 
	-- 	self.spCollect:setTexture("ui/image/cardCollect1.png")
	-- else
	-- 	self.spCollect:setTexture("ui/image/cardCollect.png")
	-- end
	local collectPath = "ui/image/cardCollect" .. cardType .. "_" .. isCollect ..".png"
	self.spCollect:setTexture(collectPath)
end

return CardView














