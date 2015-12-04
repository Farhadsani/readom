-- SightDescriptionViewController.lua 景点介绍页面控制器
-- add by star 2015.3.11

local SightDescriptionViewController = class("SightDescriptionViewController", require("app/controllers/ViewController"))

function SightDescriptionViewController:ctor(param)
    SightDescriptionViewController.super.ctor(self, param)
    self.name = "SightDescriptionViewController"
    self._viewClassPath = "app/city/SightDescriptionView.lua"
    self.superior = param.superior

    self.packData = param.packData
    self.cityData = param.cityData

    -- dump(self.packData)
end

function SightDescriptionViewController:viewDidLoad(  )
	-- body
	self.view:setDelegate(self)

    QMapGlobal.DataManager:getSightDescription(self.cityData.cityid, self.packData.sightid, function ( sightDesc )
        -- local packData = {}
        self.view:initUI(sightDesc)
    end, function (  )
        self.navigationController:pop()
    end)
end

-- handle events from self.view
function SightDescriptionViewController:tapMapLocationItemWithName(itemName)
    print("SightDescriptionViewController:tapMapLocationItemWithName", itemName)
end

-- 排序
function SightDescriptionViewController:onSort()

end

-- 删除
function SightDescriptionViewController:onDelete()

end

-- 关闭
function SightDescriptionViewController:onClose()
    self.navigationController:pop()
end


-- 返回 返回到城市地图主页面
function SightDescriptionViewController:onBack()
--    self.superior:switchView("MainCityViewController")
end

function SightDescriptionViewController:tapMenuButtonWithName(buttonName)
    print("SightDescriptionViewController:tapMenuButtonWithName:", buttonName)

end

return SightDescriptionViewController














