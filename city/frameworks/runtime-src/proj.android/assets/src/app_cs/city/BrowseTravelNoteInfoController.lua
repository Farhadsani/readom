
-- BrowseTravelNoteInfoController.lua
-- 浏览游记详情页面
local BrowseTravelNoteInfoController = class("BrowseTravelNoteInfoController", require("app/controllers/ViewController"))

function BrowseTravelNoteInfoController:ctor(param)
    BrowseTravelNoteInfoController.super.ctor(self, param)
    self.name = "BrowseTravelNoteInfoController"
    self._viewClassPath = "app/city/BrowseTravelNoteInfoView"
    self.superior = param.superior
    self.packData = param.packData
    self.cityData = param.cityData
    self.curOrder = param.order

    self.journey = param.journey
    -- print("当前处于BrowseTravelNoteInfoController中。。。。。。。。")
    -- dump(self.journey)
end

function BrowseTravelNoteInfoController:viewDidLoad(  )
    -- body
    self.view:setDelegate(self)

    local a1 = cc.DelayTime:create(0.001)
    local a2 = cc.CallFunc:create(function()
            self.view:initUI()
        end)
    local a3 = cc.Sequence:create({a1,a2})
    self.view:runAction(a3)
    
end

-- handle events from self.view
function BrowseTravelNoteInfoController:tapMapLocationItemWithName(itemName)
    print("BrowseTravelNoteInfoController:tapMapLocationItemWithName", itemName)
end

-- 排序
function BrowseTravelNoteInfoController:onSort()

end

-- 删除
function BrowseTravelNoteInfoController:onDelete()

end

-- 关闭
function BrowseTravelNoteInfoController:onClose()
    self.navigationController:pop()
end

function BrowseTravelNoteInfoController:onShowImages( markID, index )
    local marks = self.journey:getMarks()
    for _,mark in pairs(marks) do
        if mark.markid == markID then
            local images = mark.image
            local param = {index = index}
            param.imageDatas = {}
            for _,image in pairs(images) do
                local path = self.journey:getThumbnailPathForImage( mark.sightid, image.imgname)
                table.insert(param.imageDatas, {path = path})
            end

            self.superior:addView("SeePicController", param)
            break
        end
    end
    
end

-- 确定，提交
function BrowseTravelNoteInfoController:onOK()
    local txtLabel = self.view:getLabel()
    -- print("BrowseTravelNoteInfoController:onOK()", txtLabel)
    local labelDatas = QMapGlobal.ortherData.labelData[self.cityData.name][self.packData.name] or {}
    local isFind = false
    for key, var in ipairs(labelDatas) do
        if var.label == txtLabel then
            var.count = var.count + 1
            isFind = true
        end
    end
    if not isFind then
        table.insert(labelDatas, {label = txtLabel, count = 1})
    end
end

-- 返回 返回到城市地图主页面
function BrowseTravelNoteInfoController:onBack()
--    self.superior:switchView("MainCityViewController")
end

function BrowseTravelNoteInfoController:tapMenuButtonWithName(buttonName)
    print("BrowseTravelNoteInfoController:tapMenuButtonWithName:", buttonName)

end

return BrowseTravelNoteInfoController