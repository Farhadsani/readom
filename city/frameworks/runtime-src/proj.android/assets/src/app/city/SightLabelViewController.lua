-- SightLabelViewController.lua 景点标签页面控制器
-- add by star 2015.3.16

local SightLabelViewController = class("SightLabelViewController", require("app/controllers/ViewController"))

function SightLabelViewController:ctor(param)
    SightLabelViewController.super.ctor(self, param)
    self.name = "SightLabelViewController"
    self._viewClassPath = "app/city/SightLabelView.lua"
    self.superior = param.superior
    self.packData = param.packData
    self.cityData = param.cityData
end

function SightLabelViewController:viewDidLoad(  )
    -- body
    self.view:setDelegate(self)
end

-- handle events from self.view
function SightLabelViewController:tapMapLocationItemWithName(itemName)
    print("SightLabelViewController:tapMapLocationItemWithName", itemName)
end

-- 排序
function SightLabelViewController:onSort()

end

-- 点赞
function SightLabelViewController:onAgree( labelID )
    -- body
    QMapGlobal.DataManager:agreeLabel(self.cityData.cityid, self.packData.sightid, labelID)
    self.view:initUI()
end

-- 删除
function SightLabelViewController:onDelete()

end

-- 关闭
function SightLabelViewController:onClose()
    self.navigationController:pop()
end

-- 确定，提交
function SightLabelViewController:onOK()
    local txtLabel = self.view:getLabel()
    -- print("SightLabelViewController:onOK()", txtLabel)
    QMapGlobal.DataManager:addLabelData(self.cityData.cityid, self.packData.sightid, txtLabel)
    self.view:initUI()
end

-- 返回 返回到城市地图主页面
function SightLabelViewController:onBack()
--    self.superior:switchView("MainCityViewController")
end

function SightLabelViewController:tapMenuButtonWithName(buttonName)
    print("PackIntroduceController:tapMenuButtonWithName:", buttonName)

end

return SightLabelViewController