


QMapGlobal.citySelectionView = nil

local CitySelectionViewController = class("CitySelectionViewController", require("app/controllers/ViewController"))

function CitySelectionViewController:ctor(param)
    CitySelectionViewController.super.ctor(self, param)
    self._viewClassPath = "app/citySelection/CitySelectionView"

    local cityids = QMapGlobal.DataManager:getCityIDList()
    -- print("城市列表的ID。。。。。。。。。。。")
    -- print_r(cityids)
    self:_createCities(cityids, param.cityid)
end

function CitySelectionViewController:_createCities(cityids, cityidOfShowing)
	if cityids and #cityids > 0 then
		self.cityCount = #cityids
		self._cityids = cityids            -- ID列表
		self._cities = self._cities or {}   -- 以cityID为索引，保存城市的数据
		for i = 1, #self._cityids do
			local cityid = self._cityids[i]
			-- self._cities[cityid] = require("app/data/City").new(QMapGlobal.systemData.mapData[cityid])
			local cityData = require("app/data/City").new(QMapGlobal.systemData.mapData[cityid])
			local isDown = QMapGlobal.DataManager:isDown(cityid)
			local clickCount = QMapGlobal.DataManager:getClickCount(cityid)
			-- print("城市排序。。。", cityid, isDown, clickCount)
			table.insert(self._cities, {cityData = cityData, isDown = isDown, clickCount = clickCount})
		end

		self._cities = sequenceSort(self._cities, {{"isDown", 2}, {"clickCount", 2}})   -- 按照isDown字段，升序排列

		if cityidOfShowing then
			-- for i = 1, #self._cityids do
			-- 	self._currentCityIndex = 1
			-- 	if cityidOfShowing == self._cityids[i] then
			-- 		self._currentCityIndex = i
			-- 		break
			-- 	end
			-- end

			for i, cityItem in ipairs(self._cities) do
				local cityData = cityItem.cityData
				if cityData:getCityId() == cityidOfShowing then
					self._currentCityIndex = i
					break
				end
			end
		else
			self._currentCityIndex = 1
		end
		
	else
		printError("invalid or empty cityids")
		self._currentCityIndex = nil
	end
end

function CitySelectionViewController:viewDidLoad()
	self.view:setDelegate(self)
	QMapGlobal.citySelectionView = self.view

	self.view:setCityCount(self.cityCount or 1, self._currentCityIndex)
	-- self.view:createCurrentCityBall()
	-- self.view:cacheNavigation()
	self.view:menuEnterForController(self:getName().."UnloggedIn", false, nil)

	-- 创建city列表
	self.view:createBall(self._cities, self._currentCityIndex)

	self:downloadCityBall()
end

function CitySelectionViewController:onBtnCommand( cityID )
	print("CitySelectionViewController:onBtnCommand  ", cityID)
	for _, item in pairs(self._cities) do
		local cityData = item.cityData
		if cityData:getCityId() == cityID then
			local ballState = cityData:getCityBallState1()

		    if ballState == "Undownloaded" then   -- 下载
		        self:cityBallDownloadTapped(cityID)
		    elseif ballState == "Downloaded" then   -- 进入
		        self:cityBallStartTapped(cityID)
		    elseif ballState == "Update" then    -- 更新
		        self:cityBallUpdateTapped(cityID)
		    else
		    	print(" CitySelectionViewController:onBtnCommand 未知状态", ballState)
		    end
		    break
		end
	end
	-- local cityData = self._cities[index]

end

function CitySelectionViewController:viewWillUnload()
	self.view:setGestureRecognitionEnabled(false)
	QMapGlobal.citySelectionView = nil

	self.view:stopAllActions()
end

function CitySelectionViewController:getValueForMenuLabelWithName(labelName)
	if labelName == "cityName" then
		return self._cities[self._cityids[self._currentCityIndex]]:getDisplayName()
	else
		printError("label not defined: %s", labelName)
		return ""
	end
end

function CitySelectionViewController:getValueForCustomizedWidgetWithName(name)
	if name == "jouneyWidget" then
		-- param format: {cityname = [city name], username = [some one], desc = [user self description], image = [user head image]}
		local userImage = "user/"..QMapGlobal.userData.userInfo.userid..".jpg"
		return {	cityname = "debug", 
					username = "someOne",
					desc = "description", 
					image = userImage
			   }
	else
		printError("widget not defined: %s", name or "nil")
		return nil
	end
end

function CitySelectionViewController:updateCurrentCityBall()
	local newStateOfCurrent = self._cities[self._currentCityIndex]:getCityBallState()
	self.view:updateCurrentCityBall(newStateOfCurrent)
end

function CitySelectionViewController:updateDownloadPercent(cityID, percent)
	local currentCityID = self._cityids[self._currentCityIndex]
	print("percent..", percent, "currentCityID", currentCityID, "cityID", cityID)
	if currentCityID == cityID then
		self.view:updateCurrentCityBall(percent)
	end
end

function CitySelectionViewController:getParamForCurrentCityBall()
	if self._currentCityIndex then
		local curCityID = self._cityids[self._currentCityIndex]
		local ballState, ballImage = self._cities[curCityID]:getCityBallState()
		local cityName = self._cities[curCityID]:getDisplayName()
		local position = "first"
		if self._currentCityIndex == 1 then
			position = "first"
		elseif self._currentCityIndex == #self._cities then
			position = "last"
		else
			position = "center"
		end
		return { key = tostring(curCityID),
	    		 -- ballImage = self._cities[self._currentCityIndex]:getCityBallImage(),
    			 ballState = ballState, ballImage = ballImage,
    			 index = self._currentCityIndex, position = position,
    			 cityName = cityName }
	else
		return nil
	end
end

function CitySelectionViewController:getParamForPreviousCityBall()
	-- print("function CitySelectionViewController:getParamForPreviousCityBall()", self._currentCityIndex)
	if self._currentCityIndex > 1 then
		local prevCityID = self._cityids[self._currentCityIndex - 1]
		local ballState, ballImage = self._cities[prevCityID]:getCityBallState()
		local cityName = self._cities[prevCityID]:getDisplayName()
		return { key = tostring(prevCityID),
	    		 -- ballImage = self._cities[self._currentCityIndex-1]:getCityBallImage(),
    			 ballState = ballState, ballImage = ballImage ,
    			cityName = cityName}
	else
		return nil
	end
end

function CitySelectionViewController:getParamForNextCityBall()
	-- print("function CitySelectionViewController:getParamForNextCityBall()", self._currentCityIndex)
	if self._currentCityIndex < #self._cityids then
		local nextCityID = self._cityids[self._currentCityIndex + 1]
		local ballState, ballImage = self._cities[nextCityID]:getCityBallState()
		local cityName = self._cities[nextCityID]:getDisplayName()
		return { key = tostring(nextCityID),
			     -- ballImage = self._cities[self._currentCityIndex+1]:getCityBallImage(),
    			 ballState = ballState, ballImage = ballImage,cityName = cityName }
	else
		return nil
	end
end

-- 下载完成
function CitySelectionViewController:downloadCompleted(cityID, percent)
	local currentCityID = self._cityids[self._currentCityIndex]
	local previousCityID = self._cityids[self._currentCityIndex-1]
	local nextCityID = self._cityids[self._currentCityIndex+1]

-- print("cityID = ", cityID)
-- dump(self._cities)
	-- local imagePath = self._cities[cityID]:getCityBallImage()
	-- print("下载完成了，路径是。。。", imagePath)

	display.addSpriteFrames("ui/image/loadimage.plist",  "ui/image/loadimage.png")

	if percent == "completed" then		

		-- if self and self.view then
		-- 	self.view:downloadCompleted(cityID)
		-- end

		if QMapGlobal.citySelectionView then
			QMapGlobal.citySelectionView:downloadCompleted(cityID)
		end
		-- self.view:setBallSprite(tostring(cityID), imagePath)
		-- self.view:updateCityBall(tostring(cityID), "Downloaded")
	else
		-- if self and self.view then
		-- 	self.view:downloading(cityID, percent)
		-- end

		if QMapGlobal.citySelectionView then
			QMapGlobal.citySelectionView:downloading(cityID, percent)
		end


		-- local fu = cc.FileUtils:getInstance()
	 -- 	if fu:isFileExist(imagePath) then  -- 球
	 --        self.view:setBallSprite(tostring(cityID), imagePath)
	 --    end
		-- self.view:updateCityBall(tostring(cityID), percent)
	end
end

function CitySelectionViewController:setBallDark( isDark )
	local cityID = self._cityids[self._currentCityIndex]
	self.view:setBallDark(tostring(cityID), isDark)
end

function CitySelectionViewController:cityBallDownloadTapped(cityID)

	printf("download tapped")

	display.addSpriteFrames("ui/image/loadimage.plist",  "ui/image/loadimage.png")

	-- local cityID = self._cityids[self._currentCityIndex]
	-- self.view:updateCityBall(tostring(cityID), 0)
	-- QMapGlobal.DataManager:getMapFile(cityID, handler(self, self.updateDownloadPercent), handler(self, self.downloadCompleted))
	self.view:downloadCity(cityID)
	QMapGlobal.DataManager:downloadMapFiles(cityID,  handler(self, self.downloadCompleted), function (  )
		-- self.view:updateCityBall(tostring(cityID), "Undownloaded")
		-- device.cancelAlert()
		-- device.showAlert("下载失败!", "请检查网络后重试！", {"关闭"}, function ( event )
  --           if event.buttonIndex == 1 then
  --               device.cancelAlert()
                
  --           end
  --       end)

		self.navigationController:push("app/citySelection/OneMsgDialogController")

        self.view:setBallDownLoad(cityID)
	end)
end

function CitySelectionViewController:cityBallStartTapped(cityID)

	-- device.openURL("http://www.baidu.com")
	-- device.openURL("tel:123-456-7890")

	-- do return end
	-- local cityID = self._cityids[self._currentCityIndex]

	local cityName = QMapGlobal.systemData.mapData[cityID] and QMapGlobal.systemData.mapData[cityID].name
	if cityName then
		-- self.view:setPVEnable(false)
		-- local cityMapPath = device.writablePath .. "map/" ..cityName .. "/image/" .. cityName .. "map.jpg"
		
		-- display.addImageAsync(cityMapPath, function (  )
		-- print("图片加载成功。。。", cityMapPath)
		self.view:beganning(cityID)
		print("function CitySelectionViewController:cityBallStartTapped(cityID)", cityID)
		local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
		scheduler.performWithDelayGlobal(function (  )
			print("开始加载地图。。。。。")
			local downloadPath = cc.FileUtils:getInstance():getDownloadPath()
			local cityMapPath = downloadPath .. "map/" ..cityName .. "/image/" .. cityName 
			display.addImageAsync(cityMapPath .. "map.jpg", function ( ... )
				print("load map over..............")
    			display.addSpriteFrames(cityMapPath ..".plist", cityMapPath .. ".png", function (  )
    				print("add plist over..............")
    	-- 			self.navigationController:setControllerPathBase("app/city/")
					-- self.navigationController:switchTo(	"CityViewController", { cityid = cityID } )
    			end)
			end)

			scheduler.performWithDelayGlobal(function (  )
				-- body
				self.navigationController:setControllerPathBase("app/city/")
				self.navigationController:switchTo(	"CityViewController", { cityid = cityID } )
			end, 0.3)

		end, 0.2)
		-- end)
	else
		print("no this city info ,id is ", cityID)
	end
	
end

function CitySelectionViewController:cityBallUpdateTapped( cityID )
	printf("Update tapped")

	-- local cityID = self._cityids[self._currentCityIndex]
	-- QMapGlobal.DataManager:getMapFile(cityID, handler(self, self.updateDownloadPercent), handler(self, self.downloadCompleted))

	self.view:downloadCity(cityID)   ----
	QMapGlobal.DataManager:downloadMapFiles(cityID,  handler(self, self.downloadCompleted), function (  )
		-- device.cancelAlert()
		-- device.showAlert("下载失败!", "请检查网络后重试！", {"关闭"}, function ( event )
  --           if event.buttonIndex == 1 then
  --               device.cancelAlert()
                
  --           end
  --       end)
		-- self.view:updateCityBall(tostring(cityID), "Update")
		self.navigationController:push("app/citySelection/OneMsgDialogController")
        self.view:setBallUpdate(cityID)
	end)
end

function CitySelectionViewController:tappedPreviousButton()
	-- print("11111111111111111111111")
	self.view:navigateToPreviousBall()
end

function CitySelectionViewController:tappedNextButton()
	-- print("2222222222222222222222")
	self.view:navigateToNextBall()
end


function CitySelectionViewController:didMoveToPrevious()
	if (self._currentCityIndex > 1) then
		self._currentCityIndex = self._currentCityIndex - 1

	end
end

function CitySelectionViewController:didMoveToNext()
	if self._currentCityIndex < #self._cityids then
		self._currentCityIndex = self._currentCityIndex + 1
	end
end

function CitySelectionViewController:createCityBallFile( cityID )
	local cityBallUrl = QMapGlobal.tempCityBall[cityID]
	if cityBallUrl and next(cityBallUrl) then
		local url = cityBallUrl.ballUrl
		local name = cityBallUrl.name
		local fu = cc.FileUtils:getInstance()
		local downloadPath = fu:getDownloadPath()
		local ballPath = downloadPath .. "map/" .. name .. "/image/"
		fu:createDirectory(ballPath)
		ballPath = ballPath .. name .. "ball.png"
		if not fu:isFileExist(ballPath) then
			-- print(ballPath, "1111111111111111111")
			QMapGlobal.DataManager:downloadBallFile(url, ballPath, function (  )
				QMapGlobal.tempCityBall[cityID] = nil
	        end, function (  )
	            -- body
	        end)
		end
	end
end

function CitySelectionViewController:downloadCityBall( ... )
	if not QMapGlobal.tempCityBall then return end
	local cityBallFiles = {}
	for id, cityBall in pairs(QMapGlobal.tempCityBall) do
		cityBall.ID = id
		table.insert(cityBallFiles, cityBall)
	end


	local downLoadFile
    downLoadFile = function ( )
        if #cityBallFiles > 0 then -- 还有未下载
            local item = cityBallFiles[1]
            local url = item.ballUrl
			local name = item.name
			local id = item.ID
			local fu = cc.FileUtils:getInstance()
			local downloadPath = fu:getDownloadPath()
			local ballPath = downloadPath .. "map/" .. name .. "/image/"
			fu:createDirectory(ballPath)
			ballPath = ballPath .. name .. "ball.png"
			print("ball, ", ballPath)
			if not fu:isFileExist(ballPath) then 
	            QMapGlobal.DataManager:downloadBallFile(url, ballPath, function (  )
	                table.remove(cityBallFiles, 1)
	                QMapGlobal.tempCityBall[id] = nil
	                downLoadFile()
	            end, function (  )
	            	table.remove(cityBallFiles, 1)   -- 失败了，直接去下载下一个
	            end, function ( precent )

	            end)
	        else
	        	table.remove(cityBallFiles, 1)
	        	QMapGlobal.tempCityBall[id] = nil
	        	downLoadFile()
	        end
        else   -- 下载完成
        end
    end

    if #cityBallFiles > 0 then
        downLoadFile()
    end
end

return CitySelectionViewController
