

local Journey = class("Journey")

function Journey:ctor(cityid, userid, callBack, callBackFail)
	self._userid = userid
	self.callBack = callBack
	self.callBackFail = callBackFail
	self:_pickJouneyDataFromGlobalMapData(cityid, userid)
end

function Journey:_pickJouneyDataFromGlobalMapData(cityid, userid)
	local function getDataSucceed( jouneyData )
		-- print("数据有返回。。。。。。")
		-- dump(jouneyData)
		self._data = jouneyData
		if not self._data then
			print("err, the data is nil")
		end
		if self.callBack then
			self.callBack()
		end
	end
	local function getDataFail( msg )
		print(msg)
		if self.callBackFail then
			self.callBackFail()
		end
	end
	QMapGlobal.DataManager:getOrtherJourney(cityid, getDataSucceed, getDataFail)
	-- print("测试。。。。。。。。。。。。")
	-- dump(self._data)
	-- dump(QMapGlobal.userData.userInfo)
	-- local thisUserInfo = self:_tableFind(QMapGlobal.userData.userInfo, function(obj)
	-- 	dump(obj)
	-- 										return obj.userid == userid
	-- 									 end)
	-- if not thisUserInfo then
	-- 	self._data = self:_tableFind(thisUserInfo, function(obj)
	-- 									return obj.cityid == cityid
	-- 								 end)
	-- end

	-- if not self._data then
	-- 	printf("Warning: jouney data not found for cityid %d and userid %d", cityid, userid)
	-- end
end

function Journey:_tableFind(table, func)
	for _, obj in pairs(table) do
		if func(obj) then
			return obj
		end
	end
	return nil
end

function Journey:getData(  )
	return self._data
end

function Journey:getAuthorImagePath( ... )
	return "user/" .. self._data.userid .. ".jpg"
end

function Journey:getAuthorid( ... )
	return self._data.userid
end

function Journey:getCityID( ... )
	return self._data.cityid
end

function Journey:getTitle()
	return self._data.title
end

function Journey:getUserName( ... )
	return self._data.username
end

function Journey:getDesc( ... )
	return self._data.desc
end

function Journey:getMarks( ... )
	return self._data.journey
end

function Journey:getOrderedSightIds()
	-- print("iiiiiiiiiiiiiiiiiiiiiii")
	-- dump(self._data )
	local sightidOrderList = {}
	-- dump(self._data)
	if self._data then
		table.sort(self._data.journey, function (a, b)
			return a.order < b.order
		end)
-- dump(self._data.journey)
		-- local sightidOrderList = {}
		for index = 1, #self._data.journey do
			sightidOrderList[index] = self._data.journey[index].sightid
		end
	end
	return sightidOrderList
end

function Journey:_getSightDataForSightId(sightid)
	return 	self:_tableFind(self._data.journey, function(obj)
				return obj.sightid == sightid
			end)
end

function Journey:getOrderedImageIdsForSightId(sightid)
	local imageIds = {}
	local images = self:_getSightDataForSightId(sightid).image
	for index = 1, #images do
		imageIds[index] = images[index].img_name
	end
	return imageIds
end

function Journey:_getRelativePathForImage(sightid, imageName)
	-- path format: [cityid]/[sightid]/[userid]/[journeyid]/[markid]/[imageid].jpg
	-- local path =    tostring(self._data.cityid) .. "/"
	-- 			 .. tostring(self._data.userid) .. "/"
	-- 			 .. tostring(self._data.journeyid) .. "/"
	-- 			 -- .. tostring(sightid) .. "/"
	-- 			 .. tostring(self:_getSightDataForSightId(sightid).markid) .. "/"
	-- 			 .. tostring(imageid) .. ".jpg"

	local downloadPath = cc.FileUtils:getInstance():getDownloadPath()
	-- local path = device.writablePath.. "temp/" 
	local path = downloadPath .. "temp/" 
				.. self._data.cityid .. "/" 
				.. self._data.userid .."/" 
				.. imageName

	return path
end

-- function Journey:getUrlImagePath( )
-- 	local 
-- end

function Journey:getThumbnailPathForImage(sightid, imageName)
	-- path format: img/journey/thumbnail/[relativePath]
	-- return "img/journey/thumb/" .. self:_getRelativePathForImage(sightid, imageid)
	return self:_getRelativePathForImage(sightid, imageName)
end

function Journey:getFullSizePathForImage(sightid, imageName)
	-- path format: img/journey/full/[relativePath]
	-- return "img/journey/full/" .. self:_getRelativePathForImage(sightid, imageid)
	return self:_getRelativePathForImage(sightid, imageName)
end

return Journey
