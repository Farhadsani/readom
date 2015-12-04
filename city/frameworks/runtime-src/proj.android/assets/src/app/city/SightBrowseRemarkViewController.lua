-- SightBrowseRemarkViewController.lua 景点标签页面控制器
-- add by star 2015.3.16

local SightBrowseRemarkViewController = class("SightBrowseRemarkViewController", require("app/controllers/ViewController"))

function SightBrowseRemarkViewController:ctor(param)
    SightBrowseRemarkViewController.super.ctor(self, param)
    self.name = "SightBrowseRemarkViewController"
    self._viewClassPath = "app/city/SightBrowseRemarkView.lua"
    self.superior = param.superior
    self.packData = param.packData
    self.cityData = param.cityData
    -- print("function SightBrowseRemarkViewController:ctor(param) self.superior.....", self.superior)
end

function SightBrowseRemarkViewController:viewDidLoad(  )
    -- body
    self.view:setDelegate(self)

    QMapGlobal.DataManager:getSightJourney(self.cityData.cityid, self.packData.sightid, function ( markData )
        self.view:initUI(markData)
    end)
end

-- handle events from self.view
function SightBrowseRemarkViewController:tapMapLocationItemWithName(itemName)
    print("SightBrowseRemarkViewController:tapMapLocationItemWithName", itemName)
end

-- 排序
function SightBrowseRemarkViewController:onSort()

end

-- 删除
function SightBrowseRemarkViewController:onDelete()

end

-- 关闭
function SightBrowseRemarkViewController:onClose()
    self.navigationController:pop()
end

-- 确定，提交
function SightBrowseRemarkViewController:onOK()
    -- local txtLabel = self.view:getLabel()
    -- -- print("SightBrowseRemarkViewController:onOK()", txtLabel)
    -- local labelDatas = QMapGlobal.ortherData.labelData[self.cityData.name][self.packData.name] or {}
    -- local isFind = false
    -- for key, var in ipairs(labelDatas) do
    --     if var.label == txtLabel then
    --         var.count = var.count + 1
    --         isFind = true
    --     end
    -- end
    -- if not isFind then
    --     table.insert(labelDatas, {label = txtLabel, count = 1})
    -- end
end

function SightBrowseRemarkViewController:onShowImages( comment, cityID, index )
    -- body
    local param = {index = index}
    param.imageDatas = {}
    local images = comment.image
    for _,image in pairs(images) do
        local path = "img/journey/thumb/" .. tostring(self.cityData.cityid) .. "/"
                 .. tostring(comment.userid) .. "/"
                 .. tostring(comment.journeyid) .. "/"
                 -- .. tostring(sightid) .. "/"
                 .. tostring(comment.markid) .. "/"
                 .. tostring(image.id) .. ".jpg"
        table.insert(param.imageDatas, {path = path})
    end
                -- self.superior:addView("SeePicController", param)
    self.navigationController:push("SeePicController", param)    

end

-- 返回 返回到城市地图主页面
function SightBrowseRemarkViewController:onBack()
--    self.superior:switchView("MainCityViewController")
end

function SightBrowseRemarkViewController:tapMenuButtonWithName(buttonName)
    print("SightBrowseRemarkViewController:tapMenuButtonWithName:", buttonName)

end

return SightBrowseRemarkViewController