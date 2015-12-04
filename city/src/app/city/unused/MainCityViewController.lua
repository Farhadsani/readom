
-- MainCityViewController.lua 城市场景 主界面控制器

--[[    主页面参数：
parent:   上级控制器指针
cityName : 城市名称
]]--

local MainCityViewController = class("MainCityViewController", require("app/controllers/ViewController"))

function MainCityViewController:ctor(param)
    MainCityViewController.super.ctor(self, param)
    self.name = "MainCityViewController"
    self.viewClassPath = "app/city/MainCityView"
    self.superior = param.superior
    self.cityData = param.cityData
    self.curPackData = nil
end

-- handle events from self.view
function MainCityViewController:tapMapLocationItemWithName(itemName)
    print("CityViewController:tapMapLocationItemWithName", itemName)
    local packDatas = self.cityData.sight
    if not packDatas then
        printError("没有景点数据")
        return
    end
    for key, pack in pairs(packDatas) do
    	if pack.name == itemName then
           self.curPackData = pack
    	   break  
    	end
    end
    if self.curPackData then
        self.view:showPackMenu({packName = self.curPackData.cname})
    end     
end

function MainCityViewController:onEnter(param)
	
end 

-- 返回 ，主界面的返回将切换场景回退到全国地图场景
function MainCityViewController:onBack()

end

-- 游记，进行编辑点评，发布点评等
function MainCityViewController:onBrowse()
    self.superior:switchView("StartCommentCityViewController")
end

-- 开始， 查看别人的游记
function MainCityViewController:onStar()
    self.superior:addView("LoadCityViewController")
end

-- 行程，进行行程计划
function MainCityViewController:onPlan()
    self.superior:switchView("TravelNoteController")
end

function MainCityViewController:tapMenuButtonWithName(buttonName)
    print("StartCommentCityViewController:tapMenuButtonWithName:", buttonName)
    if buttonName == "browse" then
        self:onBrowse()
    elseif buttonName == "star" then
        self:onStar()
    elseif buttonName == "plan" then
        self:onPlan()
    elseif buttonName == "back" then
        self:onBack()
    end
end

-- 简介
function MainCityViewController:onIntroduce()
    self.superior:addView("PackIntroduceController", {packData = self.curPackData})
end


-- 标签
function MainCityViewController:onLabel()
    self.superior:addView("PackLabelViewController", {packData = self.curPackData})
end


-- 评论
function MainCityViewController:onComment()
    self.superior:addView("PackCommentViewController", {packData = self.curPackData})
end

return MainCityViewController
