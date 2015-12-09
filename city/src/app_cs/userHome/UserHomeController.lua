
-- UserHomeController.lua 程序启动加载资源页面
-- add by star 2015.7.6
-- 加载资源，连接网络，更新系统数据

local UserHomeController = class("UserHomeController", require(QMapGlobal.app.packageRoot .. "/controllers/ViewController"))

QMapGlobal.UserHomeController = nil
-- local userHomeStack = {}
-- QMapGlobal.firstIntoUH = QMapGlobal.firstIntoUH or false

function UserHomeController:ctor( param )
	UserHomeController.super.ctor(self, param)
	self.packageRoot = QMapGlobal.app.packageRoot

    self._viewClassPath = self.packageRoot .. "/userHome/UserHomeView"
    print("加载页面。。。。。。。。")
    QMapGlobal.userHomeStack = QMapGlobal.userHomeStack or {}
    QMapGlobal.UserHomeController = self
    QMapGlobal.UserInfo = QMapGlobal.UserInfo or {}

    self.canClickGuangzhu = false
    self.followState = "uh_add"
    
    self.curUser = param and param.curUser
    print("设置curUser的值。。。。。。")
    dump(self.curUser)
    self._isBack = param and param.isBack
    
    QMapGlobal.userManager = qm.UserManager:getInstance()

    print("UserHome load over.....................................")
end
--13612187954  18610921719
function UserHomeController:viewDidLoad()
    -- print("11222222222222222211111")
	self.view:setDelegate(self)

	print("个人中心主页面。。。。function UserHomeController:viewDidLoad()........")

	local um = qm.UserManager:getInstance()
	local isLogin = false
    if um:userLoginStatus() == UserLoginStatus_loginSuccess then -- 已经登录
        QMapGlobal.UserInfo = {userid = um:userid(), name = um:name(), intro = um:intro(), zone = um:zone(), imglink = um:imglink(), thumblink = um:thumblink()}
        isLogin = true
        if self.curUser and self.curUser.userid and self.curUser.userid == QMapGlobal.UserInfo.userid then
        	self.curUser = nil
        end
    else
        QMapGlobal.UserInfo = nil
        isLogin = false
    end
	
	-- if not QMapGlobal._notFirstIntoUH then
	-- 	QMapGlobal._notFirstIntoUH = true
		
	-- 	self:_login(0)
	-- else
	if not self.curUser or (not self.curUser.userid) or self.curUser.userid == 0 then

		self.view:refreshUI(isLogin, true, QMapGlobal.UserInfo)
	else
		print("其他用户")
		dump(self.curUser)
		-- local um = qm.UserManager:getInstance()
		-- local isLogin = (um:userLoginStatus() == UserLoginStatus_loginSuccess)
		if not self._isBack then
			print("insert curUser value.........")
			table.insert(QMapGlobal.userHomeStack, {userid = self.curUser.userid, name = self.curUser.name, intro = self.curUser.intro, 
				zone = self.curUser.zone, thumblink = self.curUser.thumblink, imglink = self.curUser.imglink})
		end
		self.view:refreshUI( isLogin, false, self.curUser)
	end

	-- end
	self.view:setAllSenicSpotsFlash(true)
	-- print("jiancha curUser的值。。。。。。")
 --    dump(self.curUser)

 	self.view:viewDidLoad()
end

-- 判断当前用户是普通用户还是商家
function UserHomeController:getRole( ... )
	-- body
	local um = qm.UserManager:getInstance()
	return um:role()
end

function UserHomeController:reLoadView( param )
	print("个人主页刷新。。。。。。。。")
	self:tappedElseWhere()
	-- body
	QMapGlobal.userHomeStack = QMapGlobal.userHomeStack or {}
    QMapGlobal.UserHomeController = self
    QMapGlobal.UserInfo = QMapGlobal.UserInfo or {}

    self.canClickGuangzhu = false

    
    self.curUser = param and param.curUser
    -- print("设置curUser的值。。。。。。")
    -- dump(self.curUser)
    self._isBack = param and param.isBack
    
    QMapGlobal.userManager = qm.UserManager:getInstance()

    print("个人中心主页面。。。。function UserHomeController:viewDidLoad()........")

	local um = qm.UserManager:getInstance()
	local isLogin = false
    if um:userLoginStatus() == UserLoginStatus_loginSuccess then -- 已经登录
    	print("这是测试。。。。。。。。", um:userid())
        QMapGlobal.UserInfo = {userid = um:userid(), name = um:name(), intro = um:intro(), zone = um:zone(), imglink = um:imglink(), thumblink = um:thumblink()}
        isLogin = true
        if self.curUser and self.curUser.userid and self.curUser.userid == QMapGlobal.UserInfo.userid then
        	self.curUser = nil
        end
    else
        QMapGlobal.UserInfo = nil
        isLogin = false
    end

    -- dump(QMapGlobal.UserInfo)
	
	-- if not QMapGlobal._notFirstIntoUH then
	-- 	QMapGlobal._notFirstIntoUH = true
		
	-- 	self:_login(0)
	-- else
	if not self.curUser or (not self.curUser.userid) or self.curUser.userid == 0 then

		self.view:refreshUI(isLogin, true, QMapGlobal.UserInfo)
	else
		print("其他用户")
		dump(self.curUser)
		-- local um = qm.UserManager:getInstance()
		-- local isLogin = (um:userLoginStatus() == UserLoginStatus_loginSuccess)
		if not self._isBack then
			print("insert curUser value.........")
			table.insert(QMapGlobal.userHomeStack, {userid = self.curUser.userid, name = self.curUser.name, intro = self.curUser.intro, 
				zone = self.curUser.zone, thumblink = self.curUser.thumblink, imglink = self.curUser.imglink})
		end
		self.view:refreshUI( isLogin, false, self.curUser)
	end

	-- end
	self.view:setAllSenicSpotsFlash(true)
	-- print("jiancha curUser的值。。。。。。")
 --    dump(self.curUser)
end

-- userInfo = {userid = 0, name = "", intro = "", zone = "", imglink = "", thumblink = ""}
function UserHomeController:openFriendHome(userID, userName, intro, zonename, thumblink, imglink)
	
	print("刷新个人中心。。。。。。。。。2",userID, userName, intro, zonename, thumblink, imglink)
	self.curUser = {userid = userID, name = userName, intro = intro, zone = zonename, thumblink = thumblink, imglink = imglink}
	-- self.view:refresh(userID, userName, intro,zonename, smallImage, bigImage)
	local loginState = false
	local selfHome = false
	dump(self.curUser)

 	QMapGlobal.userManager = qm.UserManager:getInstance()
	-- print("aaaaaaaaaaaaaaaaa", QMapGlobal.userManager:userid(), QMapGlobal.userManager:userLoginStatus())
	if QMapGlobal.userManager:userLoginStatus() == UserLoginStatus_loginSuccess then -- 已经登录
		loginState = true
		if userID == 0 or userID == QMapGlobal.userManager:userid() then
			selfHome = true
			QMapGlobal.UserInfo = {userid = QMapGlobal.userManager:userid(), name = QMapGlobal.userManager:name(), 
				intro = QMapGlobal.userManager:intro(), zone = QMapGlobal.userManager:zone(), 
				imglink = QMapGlobal.userManager:imglink(), thumblink = QMapGlobal.userManager:thumblink()}
			-- self.curUser = QMapGlobal.UserInfo
			-- self.view:refreshUI(state, QMapGlobal.UserInfo)
			self.view:refreshUI(loginState, selfHome, QMapGlobal.UserInfo)
			return
		else
			QMapGlobal.UserInfo = {userid = QMapGlobal.userManager:userid(), name = QMapGlobal.userManager:name(), 
				intro = QMapGlobal.userManager:intro(), zone = QMapGlobal.userManager:zone(), 
				imglink = QMapGlobal.userManager:imglink(), thumblink = QMapGlobal.userManager:thumblink()}
			state = -1
			selfHome = false
			table.insert(QMapGlobal.userHomeStack, {userid = userID, name = userName, intro = intro, zone = zonename, thumblink = thumblink, imglink = imglink})
		end
	else
		print("没有登录。。。。。。。")
		loginState = false
		selfHome = true
		QMapGlobal.UserInfo = {}
		if userID ~= 0  then
			selfHome = false
			table.insert(QMapGlobal.userHomeStack, {userid = userID, name = userName, intro = intro, zone = zonename, thumblink = thumblink, imglink = imglink})
		end
	end
	self.view:refreshUI(loginState, selfHome, self.curUser)
end

-- userInfo = {userid = 0, name = "", intro = "", zone = "", imglink = "", thumblink = ""}
function UserHomeController:callbackToHome(  )
	dump(QMapGlobal.userHomeStack)
	local um = qm.UserManager:getInstance()
    local isLogin = (um:userLoginStatus() == UserLoginStatus_loginSuccess)
	if #QMapGlobal.userHomeStack > 0 then
		print("设置curUser的值。。。。。。callBack")
		self.curUser = QMapGlobal.userHomeStack[#QMapGlobal.userHomeStack]
        -- 规则上，这肯定是别人家
		QMapGlobal.UserHomeController.view:refreshUI(isLogin, false, self.curUser)
	else
		self.curUser = nil
		if QMapGlobal.UserInfo and QMapGlobal.UserInfo.userid and QMapGlobal.UserInfo.userid > 0 then
			QMapGlobal.UserHomeController.view:refreshUI(isLogin, true, QMapGlobal.UserInfo)
		else
			QMapGlobal.UserHomeController.view:refreshUI(isLogin, true)
		end
	end
	dump(self.curUser)
end
 
function UserHomeController:getCallout(  )
	local userid = QMapGlobal.UserInfo and QMapGlobal.UserInfo.userid
	if self.curUser and self.curUser.userid and self.curUser.userid ~= 0 and self.curUser.userid ~= userid then
		userid = self.curUser.userid
	end
	if not userid or userid == 0 then 
		return 
	end
	QMapGlobal.DataManager:getShoutList(userid, function ( returnData )
		-- {content2="在一起是不是", ctime="2015-08-18 19:46:38", content3="我想我是真的有点大", content1="不要\js", userid=20000017}
		local callouts = {}
		if returnData.content1 and returnData.content1 ~= "" then
			table.insert(callouts, returnData.content1)
		end
		if returnData.content2 and returnData.content2 ~= "" then
			table.insert(callouts, returnData.content2)
		end
		if returnData.content3 and returnData.content3 ~= "" then
			table.insert(callouts, returnData.content3)
		end
		-- dump(callouts)
		if next(callouts) then
			if self.view and self.view.switchCallout then
				self.view:switchCallout(callouts)
			end
		end
		
	end)

	if self:isLogin() and self:isSelfHome() then
		local callouts = {"我是你的小宠物", "我能够帮你挨揍帮你卖萌", "点我教我两句逗B俏皮话吧"}
		self.view:switchCallout(callouts)
	end
end

function UserHomeController:isLogin( ... )
	-- return (QMapGlobal.gameState.userid and QMapGlobal.gameState.userid ~= 0 )
	-- return QMapGlobal.isLogin
	QMapGlobal.userManager = qm.UserManager:getInstance()
	return (QMapGlobal.userManager:userLoginStatus() == UserLoginStatus_loginSuccess)
end

function UserHomeController:isSelfHome( ... )
	if self.curUser and self.curUser.userid and self.curUser.userid ~= 0 then
		if self:isLogin() then
			if self.curUser.userid == QMapGlobal.UserInfo.userid then
				return true   -- 在自己家，已登录
			else
				return false   -- 不在自己家，已登录
			end
		else
			return false    -- 不在自己家，没有登录
		end
	end
	return true  -- 在自己家
end

function UserHomeController:viewWillUnload()
	if self.view then
	    if self.view.viewWillUnload then
		    self.view:viewWillUnload()
		end
	end
    QMapGlobal.UserHomeController = nil
    self.view = nil
end

function UserHomeController:tappedScenicSpotWithNameNoEvent( name , tip)
	if self.curScenicSpotName then
		self:tappedElseWhere()
		return
	end

	self.curScenicSpotName = name
	self.view:setAllSenicSpotsFlash(false)

	self._mapSelectedScenicSpotHighLightAnimationInProgress = true
	self.view:highLightSelectedScenicSpotSprite(true, true,  function (  )
		self._mapSelectedScenicSpotHighLightAnimationInProgress = false
	end, tip)
end

function UserHomeController:tappedScenicSpotWithName( name )
	if self.curScenicSpotName then
		self:tappedElseWhere()
		return
	end

	self.curScenicSpotName = name
	self.view:setAllSenicSpotsFlash(false)

	self._mapSelectedScenicSpotHighLightAnimationInProgress = true
	self.view:highLightSelectedScenicSpotSprite(true, true,  function (  )
		self._mapSelectedScenicSpotHighLightAnimationInProgress = false

		if self.curScenicSpotName == "chest" then     -- 宝箱
			print("当前选择 宝箱")
			self:onCollect()
		elseif self.curScenicSpotName == "desirepond" then   -- 许愿池
			print("当前选择 许愿池")
			self:onUserDetail()
		elseif self.curScenicSpotName == "bigmouthbird" then  -- 大嘴鸟
			print("当前选择 大嘴鸟")
			self:onCallout()
		elseif self.curScenicSpotName == "dock" then        --  码头
			print("当前选择 码头")
			self:onVisit()
		elseif self.curScenicSpotName == "hotball" then     -- 热气球
			print("当前选择 热气球")
			-- self:onCityMap()
			self:onHotBall()
			
		elseif self.curScenicSpotName == "lighthouse" then   -- 灯塔
			print("当前选择 灯塔")   -- 进入好友动态
			self:onFriendTrend()
			
		elseif self.curScenicSpotName == "postbox" then      --信箱
			print("当前选择 信箱")

			self:onMsg()
		elseif self.curScenicSpotName == "stonebase" then      -- 石头人底座
			print("当前选择 石头人底座")
			self:onUserCenter()
		elseif self.curScenicSpotName == "portraitstone" then   -- 石像
			print("当前选择 石像")
			self:onUserCenter()
		elseif self.curScenicSpotName == "aboutstone" then
			print("当前选择 关于")
			self:onAbout()
		end

	end)
end

function UserHomeController:onHotBall(  )
	if not self:isLogin() then
		self:tappedElseWhere()
		return
	end
	if not self:isSelfHome() or self:getRole() == UserRoleType_Store then
		local userID = self.curUser and self.curUser.userid
		if not userID or userID == 0 then
			userID = QMapGlobal.UserInfo and QMapGlobal.UserInfo.userid
		end
		openHotBall(userID, function (  )
			-- body
			self:tappedElseWhere()
		end)
	end
end

-- type:2，直接显示登陆界面，否则测试是否已经登陆，如果没有登陆，为1时，显示登陆界面
function UserHomeController:_login( type )
	userLogin(type, function ( loginResult, userid, username, intro, zonename , thumblink, imglink)  --userTexture)
		if loginResult == 1 then
			-- 登陆成功
			print("登录成功。。", userid, username, intro, zonename )
			QMapGlobal.isLogin = true

			QMapGlobal.UserInfo = {userid = userid, name = username, intro = intro, zone = zonename, imglink = imglink, thumblink = thumblink}
			QMapGlobal.UserHomeController.view:refreshUI(true,true, QMapGlobal.UserInfo)
			QMapGlobal.UserHomeController.view._portraitstone:setVisible(true)
		else
			-- 登陆失败
		end
		QMapGlobal.UserHomeController:tappedElseWhere()
		self.view:showLoginDlg(false)
	end)    -- 用户登录
end

function UserHomeController:onFriendTrend( ... )
	if not self.curUser or not self.curUser.userid or self.curUser.userid == 0 then
		if not QMapGlobal.UserInfo or not QMapGlobal.UserInfo.userid or QMapGlobal.UserInfo.userid == 0 then
			-- self:_login(2)
			-- self.view:showLoginTip("请先登录查看好友动态")
			self:tappedElseWhere(function (  )
				-- self.view:showLoginDlg(true)
				self.view:showLoginTip("请先登录查看好友动态")
			end)
			
			return -- 没有登录
		end
	end
	dump(self.curUser)
	-- local id = (self.curUser and self.curUser.userid) or (QMapGlobal.UserInfo and QMapGlobal.UserInfo.userid)
	local id = (self.curUser and self.curUser.userid)   -- or (QMapGlobal.UserInfo and QMapGlobal.UserInfo.userid)
	if not id or id == 0 then
		id = QMapGlobal.UserInfo and QMapGlobal.UserInfo.userid
	end
	print("好友id的动态", id)
	openFriendTrend(id, function (  )
		self:tappedElseWhere()
	end)
end

function UserHomeController:onCollect( ... )
	if not self.curUser or not self.curUser.userid or self.curUser.userid == 0 then
		if not QMapGlobal.UserInfo or not QMapGlobal.UserInfo.userid or QMapGlobal.UserInfo.userid == 0 then
			-- self:_login(2)
			-- self.view:showLoginTip("请先登录查看个人动态")
			-- self:tappedElseWhere()
			self:tappedElseWhere(function (  )
				-- self.view:showLoginDlg(true)
				self.view:showLoginTip("请先登录查看好友动态")
			end)
			return -- 没有登录
		end
	end
	-- local id = (self.curUser and self.curUser.userid) or (QMapGlobal.UserInfo and QMapGlobal.UserInfo.userid)
	local id = (self.curUser and self.curUser.userid)   -- or (QMapGlobal.UserInfo and QMapGlobal.UserInfo.userid)
	if not id or id == 0 then
		id = QMapGlobal.UserInfo and QMapGlobal.UserInfo.userid
	end
	openCollect(id, function (  )
		-- body
		self:tappedElseWhere()
	end)
end

function UserHomeController:onCallout( ... )
	if not self.curUser or not self.curUser.userid or self.curUser.userid == 0 then
		if not QMapGlobal.UserInfo or not QMapGlobal.UserInfo.userid or QMapGlobal.UserInfo.userid == 0 then
			-- self:_login(2)
			-- self.view:showLoginTip("请先登录编辑喊话内容")
			-- self:tappedElseWhere()
			self:tappedElseWhere(function (  )
				-- self.view:showLoginDlg(true)
				self.view:showLoginTip("请先登录查看好友动态")
			end)
			return -- 没有登录
		end
	end
	if self.curUser and self.curUser.userid and self.curUser.userid ~= 0 and self.curUser.userid ~= QMapGlobal.UserInfo.userid then
		-- 在别人家，打他
		-- self.curScenicSpotName:setTexture("ui/image/userHome/bigmouthbird_1.png")
		self:tappedElseWhere()
		QMapGlobal.DataManager:SendPetMsg(self.curUser.userid, "揍了你的宠物");
		self.view:hitBird()
		
	else
		-- 在自己家
		openCallout(function ( string1, string2, string3 )
			print("in lua...", string1, string2, string3)
			self:tappedElseWhere()

			-- QMapGlobal.callout = {}
			local callouts = {}
			if string1 and string1 ~= "" then
				table.insert(callouts, string1)
			end
			if string2 and string2 ~= "" then
				table.insert(callouts, string2)
			end
			if string3 and string3 ~= "" then
				table.insert(callouts, string3)
			end
			if next(callouts) then
				self.view:switchCallout(callouts)
			end
		end)
	end
end

function UserHomeController:SendPetMsg(  )
	QMapGlobal.DataManager:SendPetMsg(self.curUser.userid, "揍了你的宠物")

	local callouts = {"啊啊啊，我主人哪里得罪你了", "轻点~~"}
	-- self.view:switchCallout(callouts)
	self.view:showCalloutTip(callouts)
end

function UserHomeController:onUserDetail( ... )
	if not self.curUser or not self.curUser.userid or self.curUser.userid == 0 then
		if not QMapGlobal.UserInfo or not QMapGlobal.UserInfo.userid or QMapGlobal.UserInfo.userid == 0 then
			-- self:_login(2)
			-- self.view:showLoginTip("请先登录查看个人详情")
			-- self:tappedElseWhere()
			self:tappedElseWhere(function (  )
				-- self.view:showLoginDlg(true)
				self.view:showLoginTip("请先登录查看好友动态")
			end)
			return -- 没有登录
		end
	end
	local id = (self.curUser and self.curUser.userid)   -- or (QMapGlobal.UserInfo and QMapGlobal.UserInfo.userid)
	if not id or id == 0 then
		id = QMapGlobal.UserInfo and QMapGlobal.UserInfo.userid
	end
	print("function UserHomeController:onUserDetail( ... )", id)
	openDetail(id, function (  )
		-- body
		self:tappedElseWhere()
	end)
end

function UserHomeController:onMsg( ... )
	if not self.curUser or not self.curUser.userid or self.curUser.userid == 0 then
		if not QMapGlobal.UserInfo or not QMapGlobal.UserInfo.userid or QMapGlobal.UserInfo.userid == 0 then
			-- self:_login(2)
			-- self.view:showLoginTip("请先登录查看消息")
			self:tappedElseWhere(function (  )
				-- body
				self.view:showLoginTip("请先登录查看好友动态")
			end)
			return -- 没有登录
		end
	end
	if self.curUser and self.curUser.userid and self.curUser.userid ~= 0 and self.curUser.userid ~= QMapGlobal.UserInfo.userid then
		-- 发送邮件
		openSendMail(self.curUser.userid, function (  )
			-- body
			self:tappedElseWhere()
		end)
	else
		-- 显示自己的邮件
		openMail(function (  )
			-- body
			self:tappedElseWhere()
			self:callbackToHome()
		end)
	end
end

function UserHomeController:onVisit(  )
	-- dump(self)
	-- dump(self.curUser)
	-- dump(QMapGlobal.UserInfo)
	local id, name, intro, zone, thumblink, imglink
	if self.curUser and self.curUser.userid  and self.curUser.userid ~= 0 then
		id = self.curUser.userid or 0
		name = self.curUser.name or ""
		intro = self.curUser.intro or ""
		zone = self.curUser.zone or ""
		thumblink = self.curUser.thumblink or ""
		imglink = self.curUser.imglink or ""
	else 
		id = QMapGlobal.UserInfo and QMapGlobal.UserInfo.userid or 0
		name = QMapGlobal.UserInfo and QMapGlobal.UserInfo.name or ""
		intro = QMapGlobal.UserInfo and QMapGlobal.UserInfo.intro or ""
		zone = QMapGlobal.UserInfo and QMapGlobal.UserInfo.zone or ""
		thumblink = QMapGlobal.UserInfo and QMapGlobal.UserInfo.thumblink or ""
		imglink = QMapGlobal.UserInfo and QMapGlobal.UserInfo.imglink or ""
	end
	print("出访的参数", id, name, intro, zone, thumblink, imglink)
	openBuddy(id, name, intro, zone, thumblink, imglink, function (  )
		print("出访返回。。。。。。。。")

		-- self:tappedElseWhere()
		self:callbackToHome()
	end)
end

function UserHomeController:onTopic( topicID )
	topicID = topicID or 0
	openTopic(topicID, function (  )
		-- body
		self:tappedElseWhere()
	end)
end

function UserHomeController:onSelTopichot(index)
	local topic = QMapGlobal.topicHotData[index]
	-- topic.topicid
end

function UserHomeController:onAbout(  )
	openAbout(function (  )
		-- body
		self:tappedElseWhere()
	end)
end

function UserHomeController:onCityMap( ... )

	-- dump(self.curUser)
	-- dump(QMapGlobal.UserInfo)
	if self.curUser and self.curUser.userid ~= 0 then
		return
	end
	local curCityID = QMapGlobal.gameState.curCityID or 0
	if curCityID > 0 then
		-- local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
		-- scheduler.performWithDelayGlobal(function (  )
			print("开始加载地图。。。。。")
			local cityName = QMapGlobal.systemData.mapData[curCityID] and QMapGlobal.systemData.mapData[curCityID].name
			local downloadPath = cc.FileUtils:getInstance():getDownloadPath()
			local cityMapPath = downloadPath .. "map/" ..cityName .. "/image/" .. cityName 
			display.addImageAsync(cityMapPath .. "map.jpg", function ( ... )
				print("load map over..............")
    			display.addSpriteFrames(cityMapPath ..".plist", cityMapPath .. ".png", function (  )
    				print("add plist over..............")
    				if device.platform ~= "android" then
	    				self.navigationController:setControllerPathBase( self.packageRoot .. "/city/")
						self.navigationController:switchTo(	"CityViewController", { cityid = curCityID } )
					end
    			end)
			end)

			if device.platform == "android" then
				scheduler.performWithDelayGlobal(function (  )
					-- body
					self.navigationController:setControllerPathBase(self.packageRoot .. "/city/")
					self.navigationController:switchTo(	"CityViewController", { cityid = curCityID } )
				end, 1)
			end

		-- end, 0.2)
	else
		self.navigationController:switchTo( self.packageRoot .. "/citySelection/CitySelectionViewController", {}, "fade" )
	end
end


-- userInfo = {userid = 0, name = "", intro = "", zone = "", imglink = "", thumblink = ""}
function UserHomeController:onUserCenter( ... )

	local id, name, intro, zone, thumblink, imglink
	if self.curUser and self.curUser.userid and self.curUser.userid ~= 0 then
		id = self.curUser.userid or 0
		name = self.curUser.name or ""
		intro = self.curUser.intro or ""
		zone = self.curUser.zone or ""
		thumblink = self.curUser.thumblink or ""
		imglink = self.curUser.imglink or ""
	else 
		id = QMapGlobal.UserInfo and QMapGlobal.UserInfo.userid or 0
		name = QMapGlobal.UserInfo and QMapGlobal.UserInfo.name or ""
		intro = QMapGlobal.UserInfo and QMapGlobal.UserInfo.intro or ""
		zone = QMapGlobal.UserInfo and QMapGlobal.UserInfo.zone or ""
		thumblink = QMapGlobal.UserInfo and QMapGlobal.UserInfo.thumblink or ""
		imglink = QMapGlobal.UserInfo and QMapGlobal.UserInfo.imglink or ""
	end

	if self.curUser  and self.curUser.userid and self.curUser.userid ~= 0 then
		print("显示别人的个人信息")
		openUserCenter(id, name, intro, zone, thumblink, imglink, function (  )
			-- body
			self:tappedElseWhere()
		end)
	else
		if not self:isLogin() then
			print("没有登录。。。。。")
			self:_login(1)
		else
			print("自己的登录信息。。。。。")
			openUserCenter(id, name, intro, zone, thumblink, imglink, function ( newIntro, newZone )
				-- body
				QMapGlobal.UserInfo.intro = newIntro;
				QMapGlobal.UserInfo.zone = newZone;
				self.view:refreshUI(true,true, QMapGlobal.UserInfo)
				self:tappedElseWhere()
			end)
		end
	end
	
end

function UserHomeController:goBack( )
	-- body
	-- dump(QMapGlobal.userHomeStack)
	table.remove(QMapGlobal.userHomeStack)
	-- dump(QMapGlobal.userHomeStack)
	-- 返回到原生部分
	-- self.view:refresh(userID, userName)
	goback()
end

function UserHomeController:tappedElseWhere( callBackFunc )
	-- self.curScenicSpotName = nil
	-- self.view:setAllSenicSpotsFlash(true)
	self.view.pnlLoginTip:setVisible(false)
	self.view:clearScenicSpotWithNameAboveLocationMask(self._scenicSpotNameOfCurrentPopup, false)
	self._scenicSpotNameOfCurrentPopup = nil
	-- self.view:dismissMapPopupMenu()
	self.view:highLightSelectedScenicSpotSprite(false, true, function (  )
		self.view:setAllSenicSpotsFlash(true)
		self._mapSelectedScenicSpotHighLightAnimationInProgress = false
		if callBackFunc then
			callBackFunc()
		end
	end)
	self.curScenicSpotName = nil
end

function UserHomeController:_mapSelectedScenicSpotHighLightOff()
	self.view:setMapAllSenicSpotsFlash(true)
	self._mapSelectedScenicSpotHighLightAnimationInProgress = false
end

-- 向下滑动，打开话题
function UserHomeController:onMove( ... )
	QMapGlobal.UserHomeController = nil
	self:onTopic()
	QMapGlobal.app.navigationController:switchTo( nil, {}, "fade" )   -- 这个代码加的好恶心啊
end

function UserHomeController:onGuanzhu( ... )
	-- body
	-- 关注好友要求登陆
	if not QMapGlobal.UserInfo or not QMapGlobal.UserInfo.userid or QMapGlobal.UserInfo.userid == 0 then
		self.view:showLoginDlg(true)
		return -- 没有登录
	end

	print("关注", self.canClickGuangzhu)
	if not self.canClickGuangzhu then return end
	-- 当前处于好友的个人中心
	-- print("function UserHomeController:onGuanzhu( ... )")
	if self.curUser and self.curUser.userid and self.curUser.userid ~= 0 and self.curUser.userid ~= QMapGlobal.UserInfo.userid then
		local userid = self.curUser.userid

		-- local isFollow = "follow"
		if self.followState == "uh_gz" or self.followState == "uh_hf" then  -- 取消关注
			-- 提示。。。
			print("取消关注。。。。。。。。。")
			device.showAlert("确定不再关注此好友？", "点击确定不再关注此人", {"取消", "确定"}, function ( event )
                if event.buttonIndex == 2 then
                    self:follow("unfollow", userid)
                elseif event.buttonIndex == 1 then
                	device.cancelAlert()
                end
            end)
			-- isFollow = "unfollow"
		else
			self:follow("follow", userid)
		end
		-- QMapGlobal.DataManager:follow(isFollow, userid, function ( returnData )
		-- 	-- print("1111111111111111111111")
		-- 	dump(returnData)
		-- 	if returnData.type == 0 or returnData.type == 2 then      -- 没有关系  -- 粉丝
		-- 		self.canClickGuangzhu = true
		-- 		self.followState = "uh_add"
		-- 		self.view:changeGZSprite("uh_add2")
		-- 	elseif returnData.type == 1 then    -- 关注
		-- 		self.canClickGuangzhu = true
		-- 		self.followState = "uh_gz"
		-- 		self.view:changeGZSprite("uh_gz2")
		-- 	elseif returnData.type == 3 then    -- 互粉
		-- 		self.canClickGuangzhu = true
		-- 		self.followState = "uh_hf"
		-- 		self.view:changeGZSprite("uh_hf2")
		-- 	end
		-- end, function (  )
		-- 	-- body
		-- end)
	end
end

function UserHomeController:follow( isFollow, userID )
	QMapGlobal.DataManager:follow(isFollow, userID, function ( returnData )
		-- print("1111111111111111111111")
		-- dump(returnData)
		if returnData.type == 0 or returnData.type == 2 then      -- 没有关系  -- 粉丝
			self.canClickGuangzhu = true
			self.followState = "uh_add"
			self.view:changeGZSprite("uh_add2")
		elseif returnData.type == 1 then    -- 关注
			self.canClickGuangzhu = true
			self.followState = "uh_gz"
			self.view:changeGZSprite("uh_gz2")
		elseif returnData.type == 3 then    -- 互粉
			self.canClickGuangzhu = true
			self.followState = "uh_hf"
			self.view:changeGZSprite("uh_hf2")
		end
	end, function (  )
		-- body
	end)
end

-- 显示首页
function UserHomeController:onMainPage( ... )
	print("function UserHomeController:onMainPage( ... ).....")
	-- body

	-- 通知原生程序
	onMainPage(function (  )
		-- body
	end)   

	self.view:setAllSenicSpotsFlash(false)
	self.curUser = nil
	QMapGlobal.userHomeStack = {}
	if QMapGlobal.UserInfo and QMapGlobal.UserInfo.userid and QMapGlobal.UserInfo.userid > 0 then
		self.view:refreshUI(true,true, QMapGlobal.UserInfo)
	else
		self.view:refreshUI(false, true)
	end
	self.view:setAllSenicSpotsFlash(true)

end

function UserHomeController:getFollowState( ... )
	-- body
	print("获取关注状态。。。。")
	local userid = 0 --QMapGlobal.UserInfo.userid
	if self.curUser and self.curUser.userid and self.curUser.userid ~= 0 then
		if QMapGlobal.UserInfo and QMapGlobal.UserInfo.userid and self.curUser.userid ~= QMapGlobal.UserInfo.userid then 
			userid = self.curUser.userid
		end
	end
	if not userid or userid == 0 then 
		return     
	end
	print("获取关注状态。。。。", userid, QMapGlobal.UserInfo.userid)
	QMapGlobal.DataManager:isFollow(userid, function ( returnData )
		print("关注状态")
		dump(returnData)
		if returnData.type == 0 or returnData.type == 2 then
			self.canClickGuangzhu = true
			self.followState = "uh_add"
			self.view:changeGZSprite("uh_add2")
		elseif returnData.type == 3 then
			self.canClickGuangzhu = true
			self.followState = "uh_hf"
			self.view:changeGZSprite("uh_hf2")
		elseif returnData.type == 1 then
			self.canClickGuangzhu = true
			self.followState = "uh_gz"
			self.view:changeGZSprite("uh_gz2")
		end		
	end, function (  )
		-- body
	end)
end

function UserHomeController:clickBtnGuanzhu(isDown)
	
	if isDown then 
		self.view:changeGZSprite(self.followState .. "1")
	else
		self.view:changeGZSprite(self.followState .. "2")
	end
end

return UserHomeController

