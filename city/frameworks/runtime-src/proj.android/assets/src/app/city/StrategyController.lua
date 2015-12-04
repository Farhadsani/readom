

local StrategyController = class("StrategyController", require("app/controllers/ViewController"))

function StrategyController:ctor(param)
	StrategyController.super.ctor(self, param)
    self.name = "StrategyController"
    self._viewClassPath = "app/city/StrategyView"

    self._param = param or {}
    self.cityID = param.cityID
    self.cityName = param.cityName

    self.curIndex = param.index or 1

    self.curType = param.type or 0  -- 全部显示
    self.posPer = param.posPer or 0
end

function StrategyController:viewDidLoad(  )
	self.view:setDelegate(self)

	-- self.view:menuEnterForController("StrategyController", false, nil)
	self.view:setCityName(self.cityName)

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

	-- local cardDatas = QMapGlobal.cardDatas[self.cityID].cards
	-- local path = device.writablePath.. "cardImage/" 
	-- for _, card in pairs(cardDatas) do
	-- 	card.mainPicPath = path .. self.cityID .. "_" .. card.cardid ..".png"       --"ui/image/cardTestPic.png"
	-- end
	-- dump(cardDatas)

	-- self.view:setMainPanel(cardDatas)
	-- print("star11111111111111111", "type = ", self.curType, "index = " , self.curIndex)
	self:refreshData(self.posPer)

	self.view:setButtonType(self.curType)
end

function StrategyController:onSelCard( cardID )
	-- local per = self.view:getListViewPosPercent()
	-- print("当前的位置是。。", per)

	-- self.navigationController:pop()

	-- if self._param.callBack then
 --    	self._param.callBack({cardID = cardID, type = self.curType, index = self.curIndex, posPer = per})
 --    end

 	local callBack = function ( cardID, isCollect )
 		local cardDatas = QMapGlobal.cardDatas[self.cityID]
		local cards = cardDatas.cards
		local card = cards[cardID]
 		self.view:setIsCollectData(cardID, isCollect, card.collectcount)
 		self.view:setVisible(true)
 	end

	self.navigationController:push("CardController", {cityID = self.cityID, cardID = cardID, callBack = callBack}) 
	self.view:setVisible(false)

	-- self._parentController.navigationController:push("StrategyController", param)
	-- self.navigationController:switchTo("CardController", { })
end

function StrategyController:onClose( ... )
	self.navigationController:pop()

	if self._param.callBack then
    	self._param.callBack()
    end
end

function StrategyController:onFood( callBack )
	-- body
	if self.curType ~= 1 then
		self.curType = 1  -- 美食
	else
		self.curType = 0
	end
	if callBack then callBack(self.curType ~= 1) end
	self:refreshData()
end

function StrategyController:onTask( callBack )
	-- body
	if self.curType ~= 2 then
		self.curType = 2    -- 任务
	else
		self.curType = 0
	end
	if callBack then callBack(self.curType ~= 2) end
	self:refreshData()
end

function StrategyController:onCollect( callBack )
	-- body
	if self.curType ~= -1 then
		self.curType = -1   -- 收藏
	else
		self.curType = 0
	end
	if callBack then callBack(self.curType ~= -1) end
	self:refreshData()
end

function StrategyController:refreshData( posPer )
	-- dump(QMapGlobal.cardDatas[self.cityID])
	local showDatas = {}
	if QMapGlobal.cardDatas and QMapGlobal.cardDatas[self.cityID] then
		local cardDatas = QMapGlobal.cardDatas[self.cityID].cards

		local downloadPath = cc.FileUtils:getInstance():getDownloadPath()
		-- local path = device.writablePath.. "cardImage/" 
		local path = downloadPath .. "cardImage/" 
		for _, card in pairs(cardDatas) do
			print("-----------------------------")
			dump(card)
			card.mainPicPath = path .. self.cityID .. "_" .. card.cardid ..".png"       --"ui/image/cardTestPic.png"
			if self.curType == 0 then
				table.insert(showDatas, card)
			elseif self.curType == -1 then
				if card.iscollect and card.iscollect == 1 then
					table.insert(showDatas, card)
				end
			else
				if self.curType == card.type then
					table.insert(showDatas, card)
				end
			end
		end
		dump(showDatas)
		showDatas = sequenceSort(showDatas, {{"collectcount", 2}, {"starlevel", 2}})   -- 降序序排列
		self.view:setMainPanel(showDatas, posPer)
		-- dump(QMapGlobal.cardDatas[self.cityID])
	end

end

return StrategyController






