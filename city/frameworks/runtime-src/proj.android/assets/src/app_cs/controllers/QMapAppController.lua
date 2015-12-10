-- NavigationController 根控制器，控制各个场景的调度

local NavigationController = class("NavigationController")

function NavigationController:ctor(param)
    self.curController = nil
end

function NavigationController:switchToDefaultViewController()
	local vcPathName = "app/citySelection/CitySelectionViewController"
	local param = {arg="test"}
    self:switchTo(vcPathName, nil)	
end

function NavigationController:switchTo(newControllerName, param)
    -- 当前控制器退出
    local oldController = self.curController
    
    local ctrlParam = param or {}
    ctrlParam.superior = self   -- 增加上级控制器参数，根控制器是所有场景控制器的上级控制器
    -- 实例化新的场景控制器
    self.curController = require(newControllerName).new(ctrlParam)
    self.curController:run()
    
    -- 通知旧的控制器该退出了，清理其场景
    if oldController then 
        oldController:Quit()
    end
end

function  NavigationController:startUp(param)
    -- 开始运行，直接进入城市地图场景  ，传入参数位城市ID。
    local ncPathName = "app/controllers/QCitySceneController"
    self:switchTo(ncPathName, {cityid= 1})
end

return NavigationController
