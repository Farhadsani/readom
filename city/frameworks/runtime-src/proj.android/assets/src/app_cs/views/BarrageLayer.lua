

local BarrageLayer = class("BarrageLayer", function()
    return display.newNode()
end)

function BarrageLayer:ctor(param)
	self._barrageLayer = cc.uiloader:load("ui/BarrageLayer.csb")
    self._barrageLayer:addTo(self)

    self.pnlBtnBarrage = self._barrageLayer:getChildByName("pnlBtnBarrage")
    self.spBarrage = self.pnlBtnBarrage:getChildByName("spBarrage")
    self.pnlBarrages = self._barrageLayer:getChildByName("pnlBarrages")
    self.pnlWriteBarrage = self._barrageLayer:getChildByName("pnlWriteBarrage")

    self.showBarrage = true
    self:initEvent()
    self.scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
    
    -- self:setPosition(cc.p(0,-300))
    -- self:showBarrageContent()
end

function BarrageLayer:setDelegate(delegate)
    self._delegate = delegate
end

function BarrageLayer:initEvent( )
	self.pnlBtnBarrage:addTouchEventListener(function ( sender, event )
		-- print("1111111111111111")
			if event == 2 then
				if self.showBarrage then
					self.spBarrage:setTexture("ui/image/barrageNormal.png")
					self.pnlBarrages:setVisible(false)
					self.pnlWriteBarrage:setVisible(false)
				else
					self.spBarrage:setTexture("ui/image/barragePress.png")
					self.pnlBarrages:setVisible(true)
					self.pnlWriteBarrage:setVisible(true)
				end
				self.showBarrage = not self.showBarrage 
			end
		end)
	self.pnlWriteBarrage:addTouchEventListener(function ( sender, event )
		-- body
		if event == 2 then
			-- print("write barrage............")
			self:endScheduler()
			for _, cell in pairs(self.existCells) do
				cell:pause()
			end
			self._delegate:WriteBarrage(function ( content )
				if content then
					self.barrageInfos = self.barrageInfos or {}
					local text = QMapGlobal.userData.userInfo.name .. "：" .. content
					table.insert(self.barrageInfos, {id = 0, userid = QMapGlobal.userData.userInfo.userid, content = text})
				end
				for _, cell in pairs(self.existCells) do
					cell:resume()
				end
				self:beganScheduler()
			end)
		end
	end)
end

-- function BarrageLayer:resume( ... )
-- 	for _, cell in pairs(self.existCells) do
-- 		cell:resume()
-- 	end
-- 	self:beganScheduler()
-- end

-- 需要的参数
-- local testBarrageInfos = {
-- 	{id = 1, userImage = "user/111.jpg", content = "张三：值得一看"},
-- 	{id = 2, userImage = "user/112.jpg", content = "李四：很好玩，风景优美"},
-- 	{id = 3, userImage = "user/113.jpg", content = "王五：交通方便，值得去"},
-- 	{id = 4, userImage = "user/114.jpg", content = "岚妹子：很漂亮，很有意思"},
-- 	{id = 5, userImage = "user/111.jpg", content = "赵六：不值得一去，太远了"}
-- }

function BarrageLayer:showBarrageContent( )
	self.pnlBarrages:removeAllChildren()
	print("开始显示弹幕信息。。。。。。。。")
	self._delegate:getBarrageData(function ( barrageInfos )
		self.barrageInfos = barrageInfos
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
	end)
	
end

function BarrageLayer:QuitBarrageContent( )
	self:endScheduler()
	self.existCells = {}
	self.lastCells = {}
end

function BarrageLayer:initCell( barrageInfo , row)
	if not barrageInfo then return end
	local cell = cc.uiloader:load("ui/BarrageNode.csb")
	local pnlBackGround = cell:getChildByName("pnlBackGround") 
	local txtComtent = pnlBackGround:getChildByName("txtComtent")
	local pnlImage = pnlBackGround:getChildByName("pnlImage")
	local spImage = pnlImage:getChildByName("spImage")

	txtComtent:setString(barrageInfo.content)
	local userImage = "user/" .. barrageInfo.userid .. ".jpg"
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

	pnlBackGround:setContentSize(cc.size(contentPosX + contentSize.width, cellSize.height))
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

	-- txtComtent:setString(barrageInfo.content)
	local actionSeq = cc.Sequence:create(actionMove,actionFunc)
	cell:addTo(self.pnlBarrages)
	cell:runAction(actionSeq)

	self.lastCells[row] = cell
	table.insert(self.existCells, cell)
	pnlBackGround:addTouchEventListener(function ( sender, event )
		-- print("1111111111111111", event)
			if event == 0 then
				self:endScheduler()
				for _, cell in pairs(self.existCells) do
					cell:pause()
				end
			elseif event == 1 then
			else   -- if event == 2 then
				for _, cell in pairs(self.existCells) do
					cell:resume()
				end
				self:beganScheduler()
			end
		end)
end

function BarrageLayer:endScheduler( ... )
	if self.t1 then
		self.scheduler.unscheduleGlobal(self.t1)
		self.t1 = nil
	end
end

function BarrageLayer:beganScheduler( ... )
	self:endScheduler()
	if self.barrageInfos and next(self.barrageInfos) then
		self.t1 = self.scheduler.scheduleGlobal(function()
			if not self.barrageInfos or not next(self.barrageInfos) then
				self:endScheduler()
				return
			end
			for i = 1, 3 do
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
			    	self:initCell(self.barrageInfos[self.barrageInfoIndex], i-1)
		        	self.barrageInfoIndex = self.barrageInfoIndex + 1
		        end
			end
	    end, 1)
	end
end



return BarrageLayer
