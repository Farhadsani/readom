
local City = class("City")

function City:ctor(cityDataLuaTable)
	self._data = cityDataLuaTable
end

function City:getCityId()
	return self._data.cityid
end

function City:getMapName()
	return self._data.name
end

function City:getMapSideColors()

	-- print("-----------------------------")
	-- print_r(self._data)
	-- tColor={z=255, b=235, g=199, r=105}
	local top = self._data.tColor or {z=255, b=255, g=255, r=255}
	local bottom = self._data.bColor or {z=255, b=255, g=255, r=255}
-- bgcolorend
	return {
		top = cc.c4b(top.r, top.g, top.b, top.z),
		bottom = cc.c4b(bottom.r, bottom.g, bottom.b, bottom.z)
	}
	-- if self._data.name == "qingdao" then
	-- 	return { top = cc.c4b(154, 204, 141, 255), bottom = cc.c4b(96, 197, 236, 255)}
	-- elseif self._data.name == "guilin" then
	-- 	return { top = cc.c4b(211, 229, 163, 255), bottom = cc.c4b(211, 229, 163, 255)}
	-- elseif self._data.name == "changsha" then
	-- 	return { top = cc.c4b(210, 223, 151, 255), bottom = cc.c4b(210, 223, 151, 255)}
	-- end
end

function City:getCityBallImage()
	local fu = cc.FileUtils:getInstance()
	local downloadPath = fu:getDownloadPath()
	-- return device.writablePath .. "map/" .. self._data.name .. "/image/" .. self._data.name .. "ball.png"
	local image = downloadPath .. "map/" .. self._data.name .. "/image/" .. self._data.name .. "ball.png"
	if not fu:isFileExist(image) then
		image = "ui/image/city_ball_" .. self._data.name .. ".png"
		if not fu:isFileExist(image) then
			image = "ui/image/city_ball_default.png"
		end
	end
	return image
end

function City:getCityBallState1( ... )
	-- local fu = cc.FileUtils:getInstance()
	-- local downloadPath = fu:getDownloadPath()
	local state = QMapGlobal.DataManager:getDownloadState(self._data.cityid)

	return state
end

function City:getCityBallState()
	-- "NonDefined"
	-- "Undownloaded"   -- 未下载
	-- "Downloading"    -- 下载中
	-- "Downloaded"     -- 已下载
	-- "Remarked"       -- 有评论未发布
	-- "Published"      -- 发布
	
	-- if false then   ---如果未下载
	-- 	state = "Undownloaded"
	-- elseif true then   -- 如果正在下载
	-- 	state = .....
	-- else  -- 已经下载完成
		-- state = QMapGlobal.DataManager:getJourneyState(self._data.cityid)
		-- print("当前城市ID is ", self._data.cityid, " name is ", self._data.cname, " state is ", state)
		-- if state == "NoRemark" then state = "Undownloaded" end
	-- end
	local fu = cc.FileUtils:getInstance()
	local downloadPath = fu:getDownloadPath()
	local state = QMapGlobal.DataManager:getDownloadState(self._data.cityid)
	-- if state == "Undownloaded" then
	-- 	image = "ui/image/city_ball_default.png"
	-- else
	-- 	-- image = device.writablePath .. "map/" .. self._data.name .. "/image/" .. self._data.name .. "ball.png"
	-- 	image = downloadPath .. "map/" .. self._data.name .. "/image/" .. self._data.name .. "ball.png"
	-- end

	local image = downloadPath .. "map/" .. self._data.name .. "/image/" .. self._data.name .. "ball.png"
	if not fu:isFileExist(image) then
		image = "ui/image/city_ball_" .. self._data.name .. ".png"
		if not fu:isFileExist(image) then
			image = "ui/image/city_ball_default.png"
		end
	end

	return state,image

	-- return "Undownloaded"
end

function City:getDisplayName()
	return "Q版" .. self._data.cname
end

function City:getShowName( ... )
	return self._data.cname
end

function City:getSightData(sightid)
	sightid = tonumber(sightid)
	dump(self._data)
	for _, sight in pairs(self._data.sight) do
		if sight.sightid == sightid then
			return sight
		end
	end
	-- for index = 1, #self._data.sight do
	-- 	if self._data.sight[index] and self._data.sight[index].sightid == sightid then
	-- 		return self._data.sight[index]
	-- 	end
	-- end
	return nil
end

function City:getSightDisplayName(sightid)
	local sightData = self:getSightData(sightid)
	if sightData then
		return sightData.cname
	else
		return nil
	end
end

return City
