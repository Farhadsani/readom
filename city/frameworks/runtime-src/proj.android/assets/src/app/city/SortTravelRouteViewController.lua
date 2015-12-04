
-- SortTravelRouteViewController.lua    城市地图场景，行程排序页面控制器
-- add by star 2015.3.19

--[[    开始点评页面参数：
parent:   上级控制器指针
cityName : 城市名称
]]--

local SortTravelRouteViewController = class("SortTravelRouteViewController", require("app/controllers/ViewController"))

function SortTravelRouteViewController:ctor(param)
    SortTravelRouteViewController.super.ctor(self, param)
    self.name = "SortTravelRouteViewController"
    self._viewClassPath = "app/city/SortTravelRouteView"
    self.superior = param.superior
    --    self.parentController = param.parent
    --    self.view = require(self.viewClassPath).new()
    --    
    --    self.view:addTo(self.parentController.currentScene)
    --    self.view:setScale(2)
    self.cityid = param.cityid
    self.onQuitCallback = param.onQuitCallback
end

function SortTravelRouteViewController:viewDidLoad()
    self.view:setDelegate(self)
end

-- handle events from self.view
function SortTravelRouteViewController:tapMapLocationItemWithName(itemName)
    print("StartCommentCityViewController:tapMapLocationItemWithName", itemName)
end

-- 返回按钮菜单事件  返回到行程页面
function SortTravelRouteViewController:onBack(parameters)
    self.navigationController:pop()
    self.onQuitCallback()
end

function SortTravelRouteViewController:onAlterOrder( itineraryList )
    -- print("function SortTravelRouteViewController:onAlterOrder( itineraryList )")
    -- print_r(itineraryList)
    local itinerarys = {}
    for _,itinerary in pairs(itineraryList) do
        table.insert(itinerarys, {sightid = tonumber(itinerary.sightid), order = itinerary.index})
    end
    -- print_r(itinerarys)
    QMapGlobal.DataManager:alterItineraryOrder(itinerarys, self.cityid)
end

-- 编辑事件
function SortTravelRouteViewController:onEdit()

end

-- 发布
function SortTravelRouteViewController:onPublish()

end

-- 点评
function SortTravelRouteViewController:onComment()
end

-- 删除一条记录
function SortTravelRouteViewController:onDel( sightID )
    -- body
    -- 删除数据库中行程记录
    QMapGlobal.DataManager:delItinerary(self.cityid, sightID)

    self.view:onInit()
end

function SortTravelRouteViewController:onEnter(param)

end 

-- function SortTravelRouteViewController:tapMenuButtonWithName(buttonName)
    -- print("SortTravelRouteViewController:tapMenuButtonWithName:", buttonName)
--    if buttonName == "edit" then
--        self:onEdit()
--    elseif buttonName == "publish" then
--        self:onPublish()
--    elseif buttonName == "back" then
--        self:onBack()
--    end
-- end

function SortTravelRouteViewController:onQuit(parameters)

end

return SortTravelRouteViewController
