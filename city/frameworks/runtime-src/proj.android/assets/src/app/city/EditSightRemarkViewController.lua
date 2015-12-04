
-- EditSightRemarkViewController.lua    城市地图场景，开始点评页面控制器
-- add by star 2015.3.9

--[[    开始点评页面参数：
parent:   上级控制器指针
cityName : 城市名称
]]--

local EditSightRemarkViewController = class("EditSightRemarkViewController", require("app/controllers/ViewController"))

function EditSightRemarkViewController:ctor(param)
    EditSightRemarkViewController.super.ctor(self, param)
    self.name = "EditSightRemarkViewController"
    self._viewClassPath = "app/city/EditSightRemarkView"
    self.superior = param.superior
    --    self.parentController = param.parent
    --    self.view = require(self.viewClassPath).new()
    --    
    --    self.view:addTo(self.parentController.currentScene)
    --    self.view:setScale(2)
    self.cityid = param.cityid
end

function EditSightRemarkViewController:viewDidLoad()
    self.view:setDelegate(self)
end

-- handle events from self.view
function EditSightRemarkViewController:tapMapLocationItemWithName(itemName)
    print("StartCommentCityViewController:tapMapLocationItemWithName", itemName)
end

-- 返回按钮菜单事件
function EditSightRemarkViewController:onBack(parameters)
    self.navigationController:pop()
end

-- 编辑点评
function EditSightRemarkViewController:onEdit( markid , sightid)
    print("function EditSightRemarkViewController:onEdit( ... )")
    -- self.superior:addView("EditMarkController", {cityid = self.cityid, markid = markid, onRefresh = function ( ... )
    --     self:onRefresh()
    -- end})
    self.navigationController:push("EditMarkController", {cityid = self.cityid, markid = markid, sightid = sightid, onRefresh = function ( ... )
        self:onRefresh()
    end}) 
end

-- 修改顺序
function EditSightRemarkViewController:onAlterOrder( journeyList )
    -- print("function EditSightRemarkViewController:onAlterOrder....")
    -- print_r(journeyList)

    local journeys = {}
    for _,journey in pairs(journeyList) do

        table.insert(journeys, {order = journey.journey.order, markid = tonumber(journey.journey.markid), index = journey.index})
    end
    QMapGlobal.DataManager:alterMarkOrder(journeys, self.cityid)
end

function EditSightRemarkViewController:onEnter(param)

end 

function EditSightRemarkViewController:tapMenuButtonWithName(buttonName)
    print("EditSightRemarkViewController:tapMenuButtonWithName:", buttonName)

end

function EditSightRemarkViewController:onQuit(parameters)

end

function EditSightRemarkViewController:onRefresh( )
    print("function EditSightRemarkViewController:onRefresh( )")
    self.view:initUI()
end

return EditSightRemarkViewController
