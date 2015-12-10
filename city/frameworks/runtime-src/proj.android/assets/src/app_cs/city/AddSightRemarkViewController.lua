-- AddSightRemarkViewController.lua 添加评论页面控制器
-- add by star 2015.3.11

local AddSightRemarkViewController = class("AddSightRemarkViewController", require("app/controllers/ViewController"))

function AddSightRemarkViewController:ctor(param)
    AddSightRemarkViewController.super.ctor(self, param)
    self._viewClassPath = "app/city/AddSightRemarkView.lua"
    self.superior = param.superior

    self.cityid = tonumber(param.cityid)
    self.packid = tonumber(param.packid)

    self.imageID = 1

    self.markID = QMapGlobal.DataManager:getMarkID(self.cityid)   -- 先产生一个ID

    -- self.imagePath = 
end

function AddSightRemarkViewController:getName()
	return self.__cname
end

function AddSightRemarkViewController:viewDidLoad()
	self.view:setDelegate(self)
    local mapData = QMapGlobal.systemData.mapData
    local city = mapData[self.cityid]
    if not city then
        printInfo("the pack is nil, cityid = ".. self.cityid )
        return
    end
    local packName = city.sight[self.packid] and city.sight[self.packid].cname
    if not packName then
        printInfo("the pack is nil, cityid = ".. self.cityid .. " , packid = " .. self.packid)
    end
    local journeyData = QMapGlobal.DataManager:getJourney(self.cityid)
    local markDatas = journeyData.journey
    local markData_1 = nil
    if markDatas and next(markDatas) then
        for _, markData in pairs(markDatas) do
            if markData.sightid == self.packid then
                markData_1 = markData
                break
            end
        end
    end
    self.view:initUI({packName = packName, markData = markData_1})
end

-- handle events from self.view
function AddSightRemarkViewController:tapMapLocationItemWithName(itemName)
    print("PackIntroduceController:tapMapLocationItemWithName", itemName)
end

-- 排序
function AddSightRemarkViewController:onSort()

end

-- 删除
function AddSightRemarkViewController:onDelete()

end

-- 调用摄像头或读取相册添加照片
function AddSightRemarkViewController:onAddImage( )
    -- 图片的存储路径
    -- /img/journey/full/[cityid]/[sightid]/[userid]/[journeyid]/[markid]/[imageid].jpg
 
    local fu = cc.FileUtils:getInstance()
    local imagePath =  "img/journey/full/".. self.cityid .. "/" .. self.packid .. "_" .. self.markID .. "_" .. self.imageID 
    -- print(imagePath)

    qm.ImagePicker.pickImage(3, imagePath, handler(self, self.showAddImage), 0.8, true, cc.size(500, 500))
    
    
end

function AddSightRemarkViewController:showAddImage(succeeded)
    -- print("function AddSightRemarkViewController:showAddImage( ... )", succeeded)
    if succeeded then
        local fu = cc.FileUtils:getInstance()
        local imagePath =  "img/journey/full/".. self.cityid .. "/" .. self.packid .. "_" .. self.markID .. "_" .. self.imageID .. ".jpg"
        -- self.view:showAddImage(fu:getWritablePath() ..imagePath, self.imageID)
        self.view:showAddImage(fu:getDownloadPath() ..imagePath, self.imageID)

        
        self.imageID = self.imageID + 1
    end
end

-- 关闭
function AddSightRemarkViewController:onClose()
    self.navigationController:pop()
end

-- 确定
function AddSightRemarkViewController:onOK()
    local markInfo = self.view:getMarkInfo()  
    -- 向数据库添加记录
    local param = {cityid = self.cityid, sightid = self.packid, title = "桂林之行", upload = false, 
        utime = "", mark = markInfo.mark, image = markInfo.image}
    -- dump(param)
    QMapGlobal.DataManager:addJourney(param)
    -- self.superior:removeView(self.view)
    self.navigationController:pop() 
end

-- 返回 返回到城市地图主页面
function AddSightRemarkViewController:onBack()
--    self.superior:switchView("MainCityViewController")
end

function AddSightRemarkViewController:tapMenuButtonWithName(buttonName)
    print("PackIntroduceController:tapMenuButtonWithName:", buttonName)


end

function AddSightRemarkViewController:onEnter()
    -- body
end

function AddSightRemarkViewController:onQuit()
    -- body
end

return AddSightRemarkViewController
