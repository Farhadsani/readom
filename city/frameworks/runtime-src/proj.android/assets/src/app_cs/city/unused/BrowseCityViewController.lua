
-- BrowseCityViewController.lua 城市场景 游记页面控制器

--[[    主页面参数：
parent:   上级控制器指针
cityName : 城市名称
]]--

local BrowseCityViewController = class("BrowseCityViewController", require("app/controllers/ViewController"))

function BrowseCityViewController:ctor(param)
    BrowseCityViewController.super.ctor(self, param)
    self.name = "BrowseCityViewController"
    self.viewClassPath = "app/city/BrowseCityView"
    self.superior = param.superior
    self.cityData = param.cityData
end

-- handle events from self.view
function BrowseCityViewController:tapMapLocationItemWithName(itemName)
    print("BrowseCityViewController:tapMapLocationItemWithName", itemName)
end

function BrowseCityViewController:onEnter(param)

end 

-- 返回 ，返回到城市地图主页面
function BrowseCityViewController:onReturn()
    self.superior:switchView("MainCityViewController")
end

-- 收集， 收集本篇游记
function BrowseCityViewController:onCollect()
    -- userid， authorid， cityid， journeyid
    
    local param = {cityid = self.cityData.cityid, authorid = 1, journeyid = 0}
    local callBack = function(state, data)
        local node = self.view:showMsg("已收藏")
        local act = cc.DelayTime:create(2)
        local act1 = cc.CallFunc:create(function()
            self.view:closeMsg(node)
        end)
        self.view:runAction(cc.Sequence:create(act,act1))
        
        QMapGlobal.DataManager:collectData(param)
    end
    -- 收藏游记
    QMapGlobal.DataManager:requestData("collectJourney", param, callBack)
    
end

-- 下一篇游记
function BrowseCityViewController:onNext()
    -- 向服务器获取数据
    -- send  cityid = self.cityData.cityid
    -- resv  authorid, cityid, journeyid
    -- 获取游记
    local param = {cityid = self.cityData.cityid}
    local callBack = function(state, data)
        local paramTest = {cityname = "桂林", username = "star", desc = "上天入地唯我独尊"}
        self.view:onRefresh(paramTest)
    end
    QMapGlobal.DataManager:requestData("getJourney", param, callBack)
end


function BrowseCityViewController:tapMenuButtonWithName(buttonName)
    print("BrowseCityViewController:tapMenuButtonWithName:", buttonName)
    if buttonName == "return" then
        self:onReturn()
    elseif buttonName == "collect" then
        self:onCollect()
    elseif buttonName == "next" then
        self:onNext()
    end
end

return BrowseCityViewController
