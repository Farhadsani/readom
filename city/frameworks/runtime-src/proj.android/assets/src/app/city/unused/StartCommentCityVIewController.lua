
-- StartCommentCityViewController.lua    城市地图场景，开始点评页面控制器

--[[    开始点评页面参数：
parent:   上级控制器指针
cityName : 城市名称
]]--
--print("222222222222222222222")
local StartCommentCityViewController = class("StartCommentCityViewController", require("app/controllers/ViewController"))

function StartCommentCityViewController:ctor(param)
    print("StartCommentCityViewController:ctor(param)  into......")
    StartCommentCityViewController.super.ctor(self, param)
    self.name = "StartCommentCityViewController"
    self.viewClassPath = "app/city/StartCommentCityView"
    self.superior = param.superior
    self.cityData = param.cityData
    --    self.parentController = param.parent
    --    self.view = require(self.viewClassPath).new()
    --    
    --    self.view:addTo(self.parentController.currentScene)
    --    self.view:setScale(2)
    self.curPackData = nil
end

-- handle events from self.view
function StartCommentCityViewController:tapMapLocationItemWithName(itemName)
    print("StartCommentCityViewController:tapMapLocationItemWithName", itemName)
    local packDatas = self.cityData.sight
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

-- 返回按钮菜单事件
function StartCommentCityViewController:onBack(parameters)
    self.superior:switchView("MainCityViewController")
end

-- 编辑事件
function StartCommentCityViewController:onEdit()
    self.superior:switchView("EditCommentCityViewController")
end

-- 发布
function StartCommentCityViewController:onPublish()
    self.view:showMsg("发布后别人将能浏览到你的游记")
end

-- 点评  ,点击景点是弹出的菜单
function StartCommentCityViewController:onComment()
    self.superior:addView("AddCommentController", {packName = self.curPackData.cname})
end

function StartCommentCityViewController:onEnter(param)

end 



function StartCommentCityViewController:tapMenuButtonWithName(buttonName)
    print("StartCommentCityViewController:tapMenuButtonWithName:", buttonName)
    if buttonName == "edit" then
        self:onEdit()
    elseif buttonName == "publish" then
        self:onPublish()
    elseif buttonName == "back" then
        self:onBack()
    end
end

function StartCommentCityViewController:onQuit(parameters)
	
end

return StartCommentCityViewController
