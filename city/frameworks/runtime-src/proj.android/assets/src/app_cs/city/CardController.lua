

local CardController = class("CardController", require(QMapGlobal.app.packageRoot .. "/controllers/ViewController"))

function CardController:ctor(param)
	CardController.super.ctor(self, param)

	self.packageRoot = QMapGlobal.app.packageRoot

    self.name = "CardController"
    self._viewClassPath = self.packageRoot.. "/city/CardView"

    self._param = param or {}
    self.cityID = param.cityID
    self.cardID = param.cardID

end

function CardController:viewDidLoad(  )
	self.view:setDelegate(self)

	-- self.view:menuEnterForController("CardController", false, nil)
	-- self.view:setCityName(self.cityName)

	-- local cardDatas = {
	-- 	[1] = {    -- type, 任务2 or 美食1      source, "小编推荐1" or "达人推荐2" or "商家推广3"    
	-- 			name = "大虾烧白菜", type = 0, source = 1, level = 5, mainPicPath = "ui/image/cardTestPic.png", collectCount = 9, isCollect = false,
	-- 			desc = "中华人民共和国的首都、直辖市、国家中心城市，是中国的政治、文化中心，全国重要的交通枢纽和最大空港，国家经济的决策和管理中心，是中华人民共和国中央人民政府和全国人民代表大会的办公所在地。",
	-- 			keyWord = {"静静地的晒太阳1", "晒太阳1", "静静地的晒太阳2", "晒太阳2", "静静地的晒太阳3"}
	-- 	},
	-- 	[2] = {
	-- 			name = "在古城里发呆", type = 1, source = 1, level = 4, mainPicPath = "ui/image/cardTestPic.png", collectCount = 7, isCollect = false,
	-- 			desc = "中华人民共和国的首都、直辖市、国家中心城市，是中国的政治、文化中心，全国重要的交通枢纽和最大空港，国家经济的决策和管理中心，是中华人民共和国中央人民政府和全国人民代表大会的办公所在地。",
	-- 			keyWord = {"静静地的晒太阳1", "晒太阳1", "静静地的晒太阳2", "晒太阳2", "静静地的晒太阳3"}
	-- 	}
	-- }

	local cardDatas = QMapGlobal.cardDatas[self.cityID]

	local cards = cardDatas.cards
	local downloadPath = cc.FileUtils:getInstance():getDownloadPath()
	local path = downloadPath .. "cardImage/" 
	for _, card in pairs(cards) do
		if card.cardid == self.cardID then
			-- dump(card)
			card.mainPicPath = path .. self.cityID .. "_" .. card.cardid ..".png"  
			self.view:setCardPanel(card)

			self.isCollect = card.iscollect or 0
			self.cardType = card.type or 1
			print("当前卡牌的收藏状态。。。。", self.isCollect, card.cardname)
			break
		end
	end
	-- local path = device.writablePath.. "cardImage/" 
	-- for _, card in pairs(cardDatas) do
	-- 	card.mainPicPath = path .. self.cityID .. "_" .. card.cardid ..".png"       --"ui/image/cardTestPic.png"
	-- end
	-- dump(cardDatas)

	self.isCollect = self.isCollect or 0

	self:showBarrage()
end

function CardController:onClose( ... )
	self.navigationController:pop()

	if self._param.callBack then
    	self._param.callBack(self.cardID, self.isCollect )
    end
end

function CardController:onHideBarrage( retainText )
	self.view:closeBarrage(retainText)
end

function CardController:onSendBarrage( strContent )
	if strContent and string.len(strContent) > 0 then
		QMapGlobal.DataManager:addBarrageForCard(self.cityID, self.cardID, strContent, function ( barrageDatas )
			if self and self.view then
				-- self.view:showBarrage(barrageDatas.content)
				self.view:addBarrageData({username = "", userid = 0, content = strContent})
				self.view:closeBarrage(false)
			end
			
		end, function (  )
			-- body
		end)
	end
end

function CardController:onWrite(  )
	-- body
	self.view:showWrite()
end

function CardController:onCollect(  )

	if self.noClick then return end
	self.noClick = true
	
	local isCollect = self.isCollect
	-- print("1111111111", type(isCollect), isCollect)
	if isCollect == 1 then
		isCollect = 0
	else
		isCollect = 1
	end

	-- print("2222222222",type(isCollect), isCollect)
	
	-- -- 1, 收藏，0，取消收藏
	QMapGlobal.DataManager:collectCard(self.cityID, self.cardID, isCollect, function ( collectCount )
		if self then
			self.isCollect = isCollect

			self.view:modCollectCount(collectCount, isCollect, self.cardType)
			self.noClick = false
		end
		
	end, function (  )
		-- body
		self.noClick = false
	end)

end

function CardController:showBarrage(  )
	QMapGlobal.DataManager:getBarrageForCard(self.cityID, self.cardID, function ( barrageDatas )
		print_r(barrageDatas)

		if self and self.view then
			self.view:showBarrage(barrageDatas.content)
		end

	end, function (  )
		-- body
	end)
end

return CardController






