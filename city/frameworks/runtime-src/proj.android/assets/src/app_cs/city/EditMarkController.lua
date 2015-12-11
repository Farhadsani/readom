
-- EditMarkController.lua    城市地图场景，编辑mark界面，不是列表界面
-- add by star 2015.4.8

local EditMarkController = class("EditMarkController", require("app/controllers/ViewController"))

function EditMarkController:ctor(param)
    EditMarkController.super.ctor(self, param)
    self.name = "EditMarkController"
    self._viewClassPath = "app/city/EditMarkView"
    self.superior = param.superior
    --    self.parentController = param.parent
    --    self.view = require(self.viewClassPath).new()
    --    
    --    self.view:addTo(self.parentController.currentScene)
    --    self.view:setScale(2)
    self.cityid = param.cityid
    self.markid = param.markid
    self.sightid = param.sightid

    self.imageID = 1   -- 记录新添加的图片的ID
    self.imageIndex = 1

    self.imageList = {}
    self.imageDelList = {}  -- 需要被删除的图片ID
    self.imageSelList = {}

    local fu = cc.FileUtils:getInstance()  
    self.imagePath = "img/journey/full/".. self.cityid .. "/" .. self.sightid .."_" .. self.markid .. "_"
    -- self.fullImagePath = fu:getWritablePath() .. self.imagePath

    self.fullImagePath = fu:getDownloadPath() .. self.imagePath

    self.onRefreshCallBack = param.onRefresh
end

function EditMarkController:viewDidLoad()
    self.view:setDelegate(self)

    local journeyData = QMapGlobal.userData.userInfo.journeys[self.cityid]
    local markDatas = journeyData.journey
    self.markData = nil
    for _, markData in pairs(markDatas) do
        if markData.markid == self.markid then
            self.markData = markData
            break                                                                                                                                                                                                           
        end
    end

    if self.markData then
        local fu = cc.FileUtils:getInstance()
        local cityData = QMapGlobal.systemData.mapData[self.cityid]
        local sightName = cityData.sight[self.markData.sightid].cname
        local images = {}
        local image_ = self.markData.image
        if image_ and next(image_) then
            -- local imagePath = fu:getWritablePath() .. "img/journey/full/".. self.cityid .. "/" .. self.markData.sightid .. "/" 
            for k,v in pairs(image_) do
                local path = self.fullImagePath .. v.id .. ".jpg"
                table.insert(images, {path = path, ctime = v.ctime, id = v.id})
                table.insert(self.imageList, {id = v.id, ctime = v.ctime, path = path})
                local vID = tonumber(v.id)
                if self.imageID <= vID then
                    self.imageID = vID + 1    -- 此处取当前ID的最大值加1最为下一个ID，后面的ID只能增加
                end
                self.imageIndex = self.imageIndex + 1
            end
        end

        local uiParam = {sightName = sightName, mark = self.markData.mark, images = self.imageList}
        self.view:initUI(uiParam)
    end
end

-- handle events from self.view
function EditMarkController:tapMapLocationItemWithName(itemName)
    print("StartCommentCityViewController:tapMapLocationItemWithName", itemName)
end

-- 返回按钮菜单事件
function EditMarkController:onBack(parameters)
    self.navigationController:pop()
end

-- 添加图片
function EditMarkController:onAddImage( ... )
    -- 图片的存储路径
    -- /img/journey/full/[cityid]/[sightid]/[userid]/[journeyid]/[markid]/[imageid].jpg
 
    local fu = cc.FileUtils:getInstance()
    local imagePath =  self.imagePath .. self.imageID 
    print("当前产生的图片路径是。。。。",imagePath)

    qm.ImagePicker.pickImage(3, imagePath, handler(self, self.showAddImage), 0.8, true, cc.size(500, 500))
end

function EditMarkController:showAddImage(succeeded)
    -- print("function AddSightRemarkViewController:showAddImage( ... )", succeeded)
    if succeeded then
        -- local fu = cc.FileUtils:getInstance()
        local imagePath =  self.fullImagePath .. self.imageID .. ".jpg"
        self.view:showAddImage(imagePath, self.imageID,  self.imageID)
        table.insert(self.imageList, {id = self.imageID, ctime = "", path = imagePath})
        self.imageID = self.imageID + 1 
    end
end

function EditMarkController:selectImage( imageID, callBack )
    for k, imageid in pairs(self.imageSelList) do
        if imageID == imageid then
            table.remove(self.imageSelList, k)
            if callBack then callBack(false) end
            return 
        end
    end
    table.insert(self.imageSelList, imageID)
    if callBack then  callBack(true) end
end

-- 删除图片
function EditMarkController:onDelImage(  )
    if self.imageSelList and next(self.imageSelList) then
        for _, imageID in pairs(self.imageSelList) do
            for k, imageData in pairs(self.imageList) do
                if imageData.id == imageID then
                    table.remove(self.imageList, k)
                    -- 需要删除对应的本地文件
                    table.insert(self.imageDelList, imageData.id)
                    break
                end
            end
        end
    end
    dump(self.imageList)
    self.view:initImages(self.imageList)   
end

-- 确定
function EditMarkController:onOK( ... )
    local markInfo = self.view:getMarkInfo()  
    -- 向数据库添加记录
    local param = {cityid = self.cityid, sightid = self.markData.sightid, title = "桂林之行", upload = false, 
        utime = "", mark = markInfo.mark, markid = self.markid, image = self.imageList}
    -- dump(param)
    QMapGlobal.DataManager:addJourney(param)
 
    -- self.superior:removeView(self.view)
    self.navigationController:pop()

    for _,imageid in pairs(self.imageDelList) do
        local imagePath =  self.fullImagePath .. imageid .. ".jpg"
        local fu = cc.FileUtils:getInstance()
        print("删除文件。。。", imagePath)
        fu:removeFile(imagePath)  -- 删除文件
    end

    if self.onRefreshCallBack then
        self.onRefreshCallBack()
    end

    self.navigationController:pop()
end

--删除
function EditMarkController:onDelMark(  )
    -- 由数据管理删除数据
    QMapGlobal.DataManager:removeMark(self.cityid, self.markid)
    if self.onRefreshCallBack then
        self.onRefreshCallBack()
    end
    -- self.superior:removeView(self.view)
    self.navigationController:pop()
end

function EditMarkController:onEnter(param)

end 

function EditMarkController:tapMenuButtonWithName(buttonName)
    print("EditMarkController:tapMenuButtonWithName:", buttonName)

end

function EditMarkController:onQuit(parameters)

end

return EditMarkController
