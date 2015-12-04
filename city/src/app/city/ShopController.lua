

local ShopController = class("ShopController", require("app/controllers/ViewController"))

function ShopController:ctor(param)
	ShopController.super.ctor(self, param)
    self.name = "ShopController"
    self._viewClassPath = "app/city/ShopView"

    self._param = param or {}
    self.cityID = param.cityID

    self.curIndex = 1
end

function ShopController:viewDidLoad(  )
	self.view:setDelegate(self)

	local citySName, cityName, specialitydata = QMapGlobal.DataManager:getSpecialityData(self.cityID)

	self.citySName = citySName
	self.cityName = cityName
	
	self.view:setCaption("Q版" .. citySName)

	local classCount = #specialitydata
	dump(specialitydata)
	while classCount < 4 do
		table.insert(specialitydata, {})
		classCount = #specialitydata
	end

	local downloadPath = cc.FileUtils:getInstance():getDownloadPath()
	-- local rootPath = device.writablePath .. "specialitys/" .. cityName .. "/"
	local rootPath = downloadPath .. "specialitys/" .. cityName .. "/"

	local mainPanelData = {}
	mainPanelData.mainPicPath = rootPath .. self.curIndex .. "/mainPic.png"


	for i, item in ipairs(specialitydata) do

		-- device.writablePath .. "specialitys/" .. "guilin" .. "/" .. index  .. "/icon.png"
		if next(item) then
			local path = rootPath .. i .. "/"

			item.mainPicPath = path.. "mainPic.png"     -- 主图片的路径
			item.iconPath = path .. "icon.png"     -- 类别图片
			
			self.view:addItemToClass(i, item.name, item.iconPath)
		
			local tempIndex = i
			QMapGlobal.DataManager:downLoadSpecialityFile(item.icon, "icon.png", path, function (  )
				self:updataUI_ClassIcon(tempIndex)
			end)

			QMapGlobal.DataManager:downLoadSpecialityFile(item.mainimg, "mainPic.png", path, function (  )
				self:updataUI_MainPic(tempIndex)
			end)

			if item.price then
				item.priceContent = item.name .. " ￥:" .. item.price          -- "桂林地图 ￥:20.00"
			end

			item.images = {}
			for j, picItem in ipairs(item.descimgs) do

				QMapGlobal.DataManager:downLoadSpecialityFile(picItem, "image" .. j .. ".png", path, function (  )
					self:updataUI_Images(tempIndex, j)
				end)
				local image = {url = picItem, imagePath = path.."image" .. j .. ".png"}
				-- item.images[j] = image
				table.insert( item.images, image )
			end
			-- item.descimgs = nil

			local descs = item.descs
			if descs and next(descs) then
				for k, descItem in ipairs(descs) do
					descItem.iconPath = rootPath .. i .. "/descIcon" .. k .. ".png"
					if type(descItem.color) == "string" then
						local color = analysisColor(descItem.color)
						descItem.color = cc.c3b(color.r, color.g, color.b)
					end
					
					QMapGlobal.DataManager:downLoadSpecialityFile(descItem.icon, "descIcon" .. k .. ".png", path, function (  )
						self:updataUI_DescIcon(tempIndex, k)
					end)
				end
			end

			-- if i == self.curIndex then
			-- 	dump(item.descs)
			-- 	mainPanelData.descs = descs
			-- end
		else
			self.view:addItemToClass(i)
		end
	end
	self.specialitydata = specialitydata
	-- print_r(self.specialitydata)

	self.view:setMainPanel(specialitydata[self.curIndex])
	-- dump(specialitydata) 

	self.view:setClassState(nil, self.curIndex-1)
end

function ShopController:onClose( ... )
	self.navigationController:pop()

	if self._param.callBack then
    	self._param.callBack()
    end
end

function ShopController:onBuy( ... )
	local url = self.specialitydata[self.curIndex].taobaourl
	lua_showWebView(url)
end

function ShopController:onSelClass( index )

	self.view:setClassState(self.curIndex-1, index-1)

	self.curIndex = index
	self.view:setMainPanel(self.specialitydata[self.curIndex])

	-- self.view:setMainP
end

function ShopController:updataUI_ClassIcon( index )
	local data = self.specialitydata[index]
	if data and data.iconPath and self and self.view then
		self.view:updataUI_ClassIcon(index-1, data.iconPath)
	end
		
end

function ShopController:updataUI_MainPic( index )
	if index ~= self.curIndex then return end
	local data = self.specialitydata[index]
	if data and data.mainPicPath and self and self.view  then
		self.view:updataUI_MainPic(index-1, data.mainPicPath)
	end
end

function ShopController:updataUI_Images( mainIndex, sIndex )
	if mainIndex ~= self.curIndex then return end
	local data = self.specialitydata[mainIndex]
	if data and data.images  and self and self.view then
		local image = data.images[sIndex] 
		if image and image.imagePath then
			self.view:updataUI_Images(mainIndex-1,sIndex, image.imagePath)
		end
	end
end

function ShopController:updataUI_DescIcon( mainIndex, sIndex )
	if mainIndex ~= self.curIndex then return end
	local data = self.specialitydata[mainIndex]
	if data and data.descs then
		local desc = data.descs[sIndex] 
		if desc and desc.iconPath and self and self.view  then
			self.view:updataUI_DescIcon(mainIndex-1,sIndex, desc.iconPath)
		end
	end
end

return ShopController


-- {
-- 	[1] = { 
-- 			descs={
-- 					[1]={
-- 							title="美味等级", descid=1, color="FF7577", iconPath="/var/mobile/Containers/Data/Application/D0CA402D-0EBB-4F73-80BC-ECDC359E1834/Documents/specialitys/guilin/1/descIcon1.png", 
-- 							content="鲜辣香醇，辣度适中", icon="http://static.shitouren.com/group1/M00/00/08/0g6asVVdWMiAMzzVAAAC_sxD3W8354.png"
-- 						}, 
-- 					[2]={
-- 							title="送礼等级", descid=2, color="00D1C7", iconPath="/var/mobile/Containers/Data/Application/D0CA402D-0EBB-4F73-80BC-ECDC359E1834/Documents/specialitys/guilin/1/descIcon2.png", 
-- 							content="辣椒爱好者", icon="http://static.shitouren.com/group1/M00/00/08/0g6asVVdWMiAB54HAAACt1zJUcs513.png"
-- 						}, 
-- 					[3]={
-- 							title="性价比", descid=3, color="80A1FF", iconPath="/var/mobile/Containers/Data/Application/D0CA402D-0EBB-4F73-80BC-ECDC359E1834/Documents/specialitys/guilin/1/descIcon3.png", 
-- 							content="桂林三宝之一，有百年左右的历史", icon="http://static.shitouren.com/group1/M00/00/08/0g6asVVdWMiAJtAsAAACpLEC_MM719.png"
-- 						}
-- 				}, 
-- 			pid=1, 
-- 			images={
-- 						[1]={
-- 								imagePath="/var/mobile/Containers/Data/Application/D0CA402D-0EBB-4F73-80BC-ECDC359E1834/Documents/specialitys/guilin/1/image1.png", 
-- 								url="http://static.shitouren.com/group1/M00/00/08/0g6asVVb_r2ADZK_AADX6gZXw_E788.png"
-- 							}, 
-- 						[2]={
-- 								imagePath="/var/mobile/Containers/Data/Application/D0CA402D-0EBB-4F73-80BC-ECDC359E1834/Documents/specialitys/guilin/1/image2.png", 
-- 								url="http://static.shitouren.com/group1/M00/00/08/0g6asVVb_r2AbxICAADr8Bwl1wA217.png"
-- 							}
-- 					}, 
-- 			descimgs={
-- 						[1]="http://static.shitouren.com/group1/M00/00/08/0g6asVVb_r2ADZK_AADX6gZXw_E788.png", 
-- 						[2]="http://static.shitouren.com/group1/M00/00/08/0g6asVVb_r2AbxICAADr8Bwl1wA217.png"
-- 					}, 
-- 			taobaourl="http://detail.tmall.com/item.htm?spm=a230r.1.14.16.KJyzQS&id=43432074281&cm_id=140105335569ed55e27b&abbucket=19", 
-- 			name="辣椒酱", 
-- 			mainPicPath="/var/mobile/Containers/Data/Application/D0CA402D-0EBB-4F73-80BC-ECDC359E1834/Documents/specialitys/guilin/1/mainPic.png", 
-- 			level=5, 
-- 			icon="http://static.shitouren.com/group1/M00/00/08/0g6asVVb_r2AScKmAAAWnQ2LOtU941.png", 
-- 			mainimg="http://static.shitouren.com/group1/M00/00/08/0g6asVVb_r2APax_AAEnaklIJZY787.png"
-- 		}, 
-- 	[2]={
-- 			descs={
-- 					[1]={
-- 							title="美味等级", descid=1, color="FF7577", iconPath="/var/mobile/Containers/Data/Application/D0CA402D-0EBB-4F73-80BC-ECDC359E1834/Documents/specialitys/guilin/2/descIcon1.png", 
-- 							content="辣中有甜，甜中喷香", icon="http://static.shitouren.com/group1/M00/00/08/0g6asVVdWMiAMzzVAAAC_sxD3W8354.png"
-- 						}, 					
-- 					[2]={
-- 							title="送礼等级", descid=2, color="00D1C7", iconPath="/var/mobile/Containers/Data/Application/D0CA402D-0EBB-4F73-80BC-ECDC359E1834/Documents/specialitys/guilin/2/descIcon2.png", 
-- 							content="辣椒爱好者、发酵豆制品爱好者", icon="http://static.shitouren.com/group1/M00/00/08/0g6asVVdWMiAB54HAAACt1zJUcs513.png"
-- 						}, 
-- 					[3]={
-- 							title="性价比", descid=3, color="80A1FF", iconPath="/var/mobile/Containers/Data/Application/D0CA402D-0EBB-4F73-80BC-ECDC359E1834/Documents/specialitys/guilin/2/descIcon3.png", 
-- 							content="桂林豆腐乳历史悠久，颇负盛名，是传统特产“桂林三宝”之一", icon="http://static.shitouren.com/group1/M00/00/08/0g6asVVdWMiAJtAsAAACpLEC_MM719.png"
-- 						}
-- 				}, 
-- 			pid=2, 
-- 			images={
-- 					[1]={
-- 							imagePath="/var/mobile/Containers/Data/Application/D0CA402D-0EBB-4F73-80BC-ECDC359E1834/Documents/specialitys/guilin/2/image1.png", 
-- 							url="http://static.shitouren.com/group1/M00/00/08/0g6asVVb_r2AJbxTAADr8Bwl1wA943.png"
-- 						}
-- 					}, 
-- 			descimgs={
-- 						[1]="http://static.shitouren.com/group1/M00/00/08/0g6asVVb_r2AJbxTAADr8Bwl1wA943.png"
-- 			}, 
-- 			taobaourl="http://item.taobao.com/item.htm?spm=a230r.1.14.141.eXCMNO&id=10251702453&ns=1&abbucket=12#detail", name="腐乳", mainPicPath="/var/mobile/Containers/Data/Application/D0CA402D-0EBB-4F73-80BC-ECDC359E1834/Documents/specialitys/guilin/2/mainPic.png", level=4, icon="http://static.shitouren.com/group1/M00/00/08/0g6asVVb_r2AQpqIAAAUqlcnk9M330.png", mainimg="http://static.shitouren.com/group1/M00/00/08/0g6asVVb_r2AUFDoAAEnaklIJZY839.png"}
-- }





