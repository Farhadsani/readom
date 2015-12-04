
-- LoadCityViewController.lua    城市地图场景，开始点评页面控制器

--[[    开始点评页面参数：
parent:   上级控制器指针
cityName : 城市名称
]]--

local LoadCityViewController = class("LoadCityViewController", require("app/controllers/ViewController"))

function LoadCityViewController:ctor(param)
    LoadCityViewController.super.ctor(self, param)
    self.name = "LoadCityViewController"
    self.viewClassPath = "app/city/LoadCityView"
    self.superior = param.superior
    --    self.parentController = param.parent
    --    self.view = require(self.viewClassPath).new()
    --    
    --    self.view:addTo(self.parentController.currentScene)
    --    self.view:setScale(2)
end

-- handle events from self.view
function LoadCityViewController:tapMapLocationItemWithName(itemName)
    print("StartCommentCityViewController:tapMapLocationItemWithName", itemName)
end

-- 返回按钮菜单事件
function LoadCityViewController:onBack(parameters)
    self.superior:switchView("MainCityViewController")
end

function LoadCityViewController:onEnter(param)
    local act = cc.DelayTime:create(2)
    local act1 = cc.CallFunc:create(function()
        self.superior:removeView(self.view)
        self.superior:switchView("BrowseCityViewController")
    end)
    self.view:runAction(cc.Sequence:create(act,act1))
end 



function LoadCityViewController:tapMenuButtonWithName(buttonName)
 
end

function LoadCityViewController:onQuit(parameters)

end

return LoadCityViewController
