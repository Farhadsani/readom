

local StrategyView = class("StrategyView", function()
    return display.newLayer()
end)

function StrategyView:ctor()
	self.rootLayer = cc.uiloader:load("ui/CardLayer.csb")
    self.rootLayer:addTo(self)

    -- self.pnlGround = self.rootLayer:getChildByName"pnlGround"

    -- self._menuLayer = require("app/views/MenuLayer").new()
    -- self.pnlGround:addChild(self._menuLayer, 2)
    self.cardDesignWidth = 800
    self.cardDesignHeight = 1360

    self:initUI()
    self:initEvent()

end

function StrategyView:setDelegate(delegate)
    self.delegate = delegate
    -- self._menuLayer:setDelegate(delegate)
end

------ menu
function StrategyView:menuEnterForController(controllerName, animated, menuEnteredCallback)
    -- self._menuLayer:menuEnterForController(controllerName, animated, menuEnteredCallback)
end

function StrategyView:initUI( ... )
	local backGround = self.rootLayer:getChildByName("pnlGround")
	local pnlTitle = backGround:getChildByName"pnlTitle"
	local pnlButton = backGround:getChildByName"pnlButton"

	self.backGround = backGround
	self.cityName = pnlTitle:getChildByName("cityName")
	self.pnlBack = pnlTitle:getChildByName("pnlBack")
	self.lvCard = backGround:getChildByName"lvCard"
	self.pnlCards = backGround:getChildByName"pnlCards"
	self.btnFood = pnlButton:getChildByName"btnFood"
	self.btnTask = pnlButton:getChildByName"btnTask"
	self.btnCollect = pnlButton:getChildByName"btnCollect"

	local pnlTitleSize = pnlTitle:getContentSize()
	local pnlButtonSize = pnlButton:getContentSize()
	
    pnlTitle:setPosition(cc.p(0, display.height))
	local height = display.height - pnlTitleSize.height - pnlButtonSize.height

    -- local lvCardHeight = height*1000/1320
    local lvCardHeight = height*0.9  
    self.pnlCards:setContentSize(cc.size(display.width, lvCardHeight))
    self.pnlCards:setPosition(cc.p(0, pnlTitleSize.height + height*0.1))   -- display.height*500/1920))
  	
  	self.lvCardScale = (lvCardHeight-90) / self.cardDesignHeight 

 --  	self.pnlCards:setBackGroundColorType(1)
	-- self.pnlCards:setBackGroundColor(cc.c3b(0,255,0))

	-- self.lvCard:setClippingEnabled(false)

	self.pnlBack:setVisible(false)

	print("StrategyView:initUI.1111111111111111")
end

function StrategyView:setCityName( strCityName )
    self.cityName:setString(strCityName)
end

function StrategyView:setClassIcon( index )
    -- body
end

function StrategyView:addItemToClass( index, name, rootPath )
 
end

function StrategyView:setMainPanel( mainPanelData, posPer )

	-- self.lvCard:removeAllChildren()
	
	-- self:addItemToCardPanel(0)

	-- local index = 1
	-- for k, cardData in pairs(mainPanelData) do
		-- print("insert data ....", k)
		-- self:addItemToCardPanel(index, cardData)
		-- index = index + 1
	-- end
	
	-- self:addItemToCardPanel(index)

	-- self.lvCard:setVisible(false)

	-- if posPer and posPer ~= 0 then
	-- 	local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
	--     scheduler.performWithDelayGlobal(function (  )
	--         self.lvCard:jumpToPercentHorizontal(posPer)
	--     end, 0.1)
	-- end
	if self.tv then
		self.tv:removeFromParent()
	end

	local pnlCardsSize = self.pnlCards:getContentSize()
	local tv = cc.TableView:create(pnlCardsSize)
	tv:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
	tv:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tv:setDelegate()
	tv:setPosition(cc.p(0, 0))

	local cardWidth = pnlCardsSize.height * self.cardDesignWidth/self.cardDesignHeight
	local cardHeight = pnlCardsSize.height

	local tableCellTouched = function ( view, cell )
		local cardNode = cell:getChildByName("cardNode")
	    -- print("11111111111111111111", cardNode.dataIndex)
	    self.curCardNode = cardNode
	    self.delegate:onSelCard(cardNode.dataIndex)
	end
	local cellSizeForTable = function ( view, idx )
		
		-- return cardWidth-500, cardHeight-400
		return cardHeight, cardWidth
	end
	local tableCellAtIndex = function ( view, idx )
		-- local self = GUI.GetGUI("StrategyView")
		-- print("tableCellAtIndex...........",idx)
	    local cell = view:dequeueCell()
	    if not cell then
	        cell = cc.TableViewCell:new()
	        local cardNode = cc.uiloader:load("ui/Card.csb")
	        cardNode:setPosition(cc.p(cardWidth/2,cardHeight/2-10))
	        cardNode:setScale(pnlCardsSize.height/self.cardDesignHeight * 0.95)
	        local data = mainPanelData[idx+1]
	        dump(data)
	        self:setCardNode(cardNode, data)
	    	cardNode:addTo(cell)
	    	cardNode:setName("cardNode")
	    	cardNode.dataIndex = data.cardid
	    else
	    	local cardNode = cell:getChildByName("cardNode")
	    	local data = mainPanelData[idx+1]
	    	-- dump(data)
	    	self:setCardNode(cardNode, data)
	    	cardNode.dataIndex = data.cardid
	    end
	    return cell
	end
	local numberOfCellsInTableView = function ( view )
		return #mainPanelData
	end
	tv:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
	tv:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
	tv:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
	tv:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
	tv:reloadData()
	tv:addTo(self.pnlCards)

	self.tv = tv
end

function StrategyView:setIsCollectData(cardID, isCollect, collectcount)
	if self.curCardNode then
		if self.curCardNode.dataIndex == cardID then
			local pnlGround = self.curCardNode:getChildByName"pnlGround"
			local pnlCollect = pnlGround:getChildByName"pnlCollect"
			local spCollect = pnlCollect:getChildByName"spCollect"
			local txtCollect = pnlGround:getChildByName"txtCollect"

			txtCollect:setString(collectcount)
			if isCollect == 1 then
				spCollect:setTexture("ui/image/cardCollect1.png")
			else
				spCollect:setTexture("ui/image/cardCollect.png")
			end
            local spSize = spCollect:getContentSize()
            local pnlSize = pnlCollect:getContentSize()
            local sW = pnlSize.width/spSize.width
            local sH = pnlSize.height/spSize.height
            local scale =  sW > sH and sW or sH 
            spCollect:setScale(scale)

		end
	end
end

function StrategyView:setCardNode( cardNode, cardData )
	
    if cardData then
	    local pnlGround = cardNode:getChildByName"pnlGround"
	    local pnlMainPic = pnlGround:getChildByName"pnlMainPic"
	    local pnlTitle = pnlGround:getChildByName"pnlTitle"
	    local cardName = pnlTitle:getChildByName"cardName"
	    local pnlStar = pnlGround:getChildByName"pnlStar"
	    local spSource = pnlMainPic:getChildByName"spSource"
	    local svDesc = pnlGround:getChildByName"svDesc"
	    local pnlKeyWord = pnlGround:getChildByName"pnlKeyWord"
	    local pnlCollect = pnlGround:getChildByName"pnlCollect"
	    local pnlWrite = pnlGround:getChildByName"pnlWrite"
	    local txtCollect = pnlGround:getChildByName"txtCollect"
	    local spCollect = pnlCollect:getChildByName"spCollect"

	    cardName:setString(cardData.cardname)
	    if cardData.type == 1 then   
		    pnlTitle:setBackGroundImage("ui/image/cardTitle1.png")
		else
			pnlTitle:setBackGroundImage("ui/image/cardTitle2.png")
		end
	    pnlMainPic:setBackGroundImage(cardData.mainPicPath)
	    local spSourcePath = "ui/image/cardSource" .. (cardData.source or 1) ..  ".png"
		local fu = cc.FileUtils:getInstance()
	    if fu:isFileExist(spSourcePath) then
	    	spSource:setTexture(spSourcePath)
	    	spSource:setVisible(true)
	    else
	    	spSource:setVisible(false)
	    end
	    -- cardDesc:setString(cardData.desc)
	    txtCollect:setString(cardData.collectcount)

	    if cardData.starlevel and cardData.starlevel > 0 then
	    	if cardData.starlevel > 5 then
	    		cardData.starlevel = 5 
	    	end
	    	pnlStar:removeAllChildren()
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
	        font = "Arial",
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
			pnlKeyWord:removeAllChildren()
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
	                font = "Arial",
	                size = 36, 
	                color = cc.c3b(255, 255, 255), -- 使用纯红色
	                align = cc.ui.TEXT_ALIGN_LEFT,
	                valign = cc.ui.TEXT_VALIGN_TOP,
	                -- dimensions = cc.size(570, 0)
	            })
	            label:setAnchorPoint(cc.p(0.5, 0.5))
	            -- label:setPosition(cc.p(0,0))

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
	            labelGround:setBackGroundColorType(1)
				labelGround:setBackGroundColor(colorList[colorIndex])
				
				nextPosX = tempX
				-- print("xiayige X", nextPosX)
    			labelGround:setContentSize(labelSize)			
	            label:addTo(labelGround)
	            labelGround:addTo(pnlKeyWord)
			end
		end

		if cardData.iscollect then
			if cardData.iscollect == 1 then
				-- pnlCollect:setBackGroundImage("ui/image/cardCollect1.png")
				spCollect:setTexture("ui/image/cardCollect1.png")
			else
				-- pnlCollect:setBackGroundImage("ui/image/cardCollect.png")
				spCollect:setTexture("ui/image/cardCollect.png")
			end
			-- pnlCollect:setBackGroundImageScale9Enabled(true)
   --          pnlCollect:setClippingEnabled(true)
            -- pnlCollect:setBackGroundImageCapInsets
            local spSize = spCollect:getContentSize()
            local pnlSize = pnlCollect:getContentSize()
            local sW = pnlSize.width/spSize.width
            local sH = pnlSize.height/spSize.height
            local scale =  sW > sH and sW or sH 
            spCollect:setScale(scale)
		end
	    
		-- item:setTouchEnabled(true)
	 --    item:addTouchEventListener(function(sender, event)
	 --        if event == 2 then
	 --            print("当前点击了。。。。。。。。。", cardData.cardid, cardData.cardname)
	 --            self.delegate:onSelCard(cardData.cardid)
	 --        end
	 --    end)

	end

end

function StrategyView:addItemToCardPanel( index, cardData )
	
	local lvSize = self.lvCard:getContentSize()


	local scaleTemp = display.height/1920
	local item = ccui.Layout:create()
	-- item:setBackGroundColorType(1)
	-- item:setBackGroundColor(cc.c3b(0,255,255))
    -- item:setContentSize(cc.size(280*scaleTemp,1000))

    local cardWidth = lvSize.height * 800/self.cardDesignHeight
    item:setContentSize(cc.size((display.width-cardWidth-40)/2, lvSize.height))

    if cardData then
    	-- dump(cardData)
    	-- item:setContentSize(cc.size(560*scaleTemp,1000))
    	item:setContentSize(cc.size(cardWidth,lvSize.height))
	    local cardNode = cc.uiloader:load("ui/Card.csb")
	    cardNode:addTo(item)
	    cardNode:setPosition(cc.p(cardWidth/2, lvSize.height/2))
	    -- cardNode:setScale(self.lvCardScale)
	    cardNode:setScale(lvSize.height/self.cardDesignHeight)

	    local pnlGround = cardNode:getChildByName"pnlGround"
	    local pnlMainPic = pnlGround:getChildByName"pnlMainPic"
	    local pnlTitle = pnlGround:getChildByName"pnlTitle"
	    local cardName = pnlTitle:getChildByName"cardName"
	    local pnlStar = pnlGround:getChildByName"pnlStar"
	    local spSource = pnlMainPic:getChildByName"spSource"
	    local cardDesc = pnlGround:getChildByName"cardDesc"
	    local pnlKeyWord = pnlGround:getChildByName"pnlKeyWord"
	    local pnlCollect = pnlGround:getChildByName"pnlCollect"
	    local pnlWrite = pnlGround:getChildByName"pnlWrite"
	    local txtCollect = pnlGround:getChildByName"txtCollect"
	    local spCollect = pnlCollect:getChildByName"spCollect"

	    cardName:setString(cardData.cardname)
	    if cardData.type == 2 then   
		    pnlTitle:setBackGroundImage("ui/image/cardTitle2.png")
		end
	    pnlMainPic:setBackGroundImage(cardData.mainPicPath)
	    local spSourcePath = "ui/image/cardSource" .. (cardData.source or 1) ..  ".png"
		local fu = cc.FileUtils:getInstance()
	    if fu:isFileExist(spSourcePath) then
	    	spSource:setTexture(spSourcePath)
	    	spSource:setVisible(true)
	    else
	    	spSource:setVisible(false)
	    end
	    cardDesc:setString(cardData.desc)
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
	                font = "Arial",
	                size = 36, 
	                color = cc.c3b(255, 255, 255), -- 使用纯红色
	                align = cc.ui.TEXT_ALIGN_LEFT,
	                valign = cc.ui.TEXT_VALIGN_TOP,
	                -- dimensions = cc.size(570, 0)
	            })
	            label:setAnchorPoint(cc.p(0, 0))
	            label:setPosition(cc.p(0,0))

	            local labelSize = label:getContentSize()
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
	            labelGround:setBackGroundColorType(1)
				labelGround:setBackGroundColor(colorList[colorIndex])
				
				nextPosX = tempX
				-- print("xiayige X", nextPosX)
    			labelGround:setContentSize(labelSize)			
	            label:addTo(labelGround)
	            labelGround:addTo(pnlKeyWord)
			end
		end

		if cardData.iscollect then
			if cardData.iscollect == 1 then
				-- pnlCollect:setBackGroundImage("ui/image/cardCollect1.png")
				spCollect:setTexture("ui/image/cardCollect1.png")
			else
				-- pnlCollect:setBackGroundImage("ui/image/cardCollect.png")
				spCollect:setTexture("ui/image/cardCollect.png")
			end
			-- pnlCollect:setBackGroundImageScale9Enabled(true)
   --          pnlCollect:setClippingEnabled(true)
            -- pnlCollect:setBackGroundImageCapInsets
            local spSize = spCollect:getContentSize()
            local pnlSize = pnlCollect:getContentSize()
            local sW = pnlSize.width/spSize.width
            local sH = pnlSize.height/spSize.height
            local scale =  sW > sH and sW or sH 
            spCollect:setScale(scale)
		end
	    
		item:setTouchEnabled(true)
	    item:addTouchEventListener(function(sender, event)
	        if event == 2 then
	            print("当前点击了。。。。。。。。。", cardData.cardid, cardData.cardname)
	            self.delegate:onSelCard(cardData.cardid)
	        end
	    end)

	end

 	self.lvCard:insertCustomItem(item, index)
end

function StrategyView:initEvent(  )
	self.pnlBack:addTouchEventListener(function(sender, event)
        if event == 2 then
            print("关闭。。。。。。。。。")
            self.delegate:onClose()
        end
    end)

    self.btnFood:addTouchEventListener(function(sender, event)
        if event == 2 then
            print("选择美食。。。。。。。。。")
            self.delegate:onFood(function ( isEnabled )
            	-- body
            	self:setButtonEnabled(self.btnFood, isEnabled)
            	self:setButtonEnabled(self.btnTask, true)
            	self:setButtonEnabled(self.btnCollect, true)
            end)

            
        end

    end)

    self.btnTask:addTouchEventListener(function(sender, event)
        if event == 2 then
            print("选择任务。。。。。。。。。")
            self.delegate:onTask(function ( isEnabled )
            	self:setButtonEnabled(self.btnFood, true)
            	self:setButtonEnabled(self.btnTask, isEnabled)
            	self:setButtonEnabled(self.btnCollect, true)
            end)

            
        end

    end)

    self.btnCollect:addTouchEventListener(function(sender, event)
        if event == 2 then
            print("选择收藏。。。。。。。。。")
            self.delegate:onCollect(function ( isEnabled )
            	self:setButtonEnabled(self.btnFood, true)
            	self:setButtonEnabled(self.btnTask, true)
            	self:setButtonEnabled(self.btnCollect, isEnabled)
            end)

            
        end

    end)

    self.backGround:addTouchEventListener(function(sender, event)
        if event == 2 then
            print("关闭。。。。。。。。。")
            self.delegate:onClose()
        end
    end)

 --    self:setKeypadEnabled(true)
 --    self:addNodeEventListener(cc.KEYPAD_EVENT, function(event)
 --    	print("StrategyView    -------------------------")
	--     print_r(event)
	-- end)

    -- self.lvCard:
end

function StrategyView:getListViewPosPercent( )
	local innerContainer = self.lvCard:getInnerContainer()
	local innerSize = innerContainer:getContentSize() 
	local lvCardSize = self.lvCard:getContentSize()
	local innerPosX, innerPosY =innerContainer:getPosition()

	-- print("111111111111111111111111111111")
	-- print_r(innerSize)
	-- print_r(lvCardSize)
	-- print(innerPosX, innerPosY)
	-- print("222222222222222222222222222222")

	local dH = innerSize.width - lvCardSize.width
	-- print("dH = ", dH)
	if dH == 0 or innerPosX == 0 then return 0 end
	return -innerPosX*100/dH
end

function StrategyView:setButtonEnabled( btn, isEnabled )
	-- btn:setTouchEnabled(isEnabled)
 --    btn:setEnabled(isEnabled)
    btn:setBright(isEnabled)
end

function StrategyView:setButtonType(btnType)
	if btnType == 1 then
		self:setButtonEnabled(self.btnFood, false)
	elseif btnType == 2 then
		self:setButtonEnabled(self.btnTask, false)
	elseif btnType == -1 then
		self:setButtonEnabled(self.btnCollect, false)
	end
end

return StrategyView














