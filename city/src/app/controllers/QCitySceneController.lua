-- QCitySceneController.lua add star 2015.3.6

-- 城市场景控制器，加载城市地图等层。。

local QCitySceneController = class("QCitySceneController")

function QCitySceneController:ctor(param)
    self.parentController = param.superior   -- 获取上级控制器
    
    self:initData(param.cityid)  -- 初始化数据
    
    self.cityName = self.cityData.cname
    print("this city is "..self.cityName)
    self.currentScene = require("app/scenes/QCityScene").new()
    self.curController = nil    
end


---------------------------
--@param
--@return
function QCitySceneController:initData(cityID)
    type(cityID)

	if not cityID then 
	   printError("缺少城市ID")
       return
	end

    self.cityData = QMapGlobal.systemData.mapData[cityID]

--	for key, value in pairs(datas) do
----	   print(value.id)
--        if tonumber(value.cityid) == tonumber(cityID) then
--            self.cityData = value
--		  break
--		end
--	end
    if not self.cityData then
        printError("no city data, city ID is ".. cityID)
	end
end

function QCitySceneController:switchToDefaultViewController()
--    local vcPathName = "app/citySelection/CitySelectionViewController"
--    local param = {arg="test"}
--    self:switchTo(vcPathName, nil)  
end

-- 场景开始运行
function QCitySceneController:run(param)
    -- 加载场景需要的资源
--    self:switchView("app/city/MainCityViewController", {cityname = "qingdao", parent = self})
    self:switchView("CitySelectionViewController", {parent = self})
    -- 将自己管理的场景加载进来
    display.replaceScene(self.currentScene, "moveInR", 0.5, nil)
end

-- 场景退出时需要执行的操作
function QCitySceneController:quit(param)
	
end

-- 场景内部添加层
function QCitySceneController:addView(newViewControllName, param)
    newViewControllName = "app/citySelection/".. newViewControllName
    
    
    local newViewControllerParam = param or {}  -- {cityName = self.cityName, parent = self}
    newViewControllerParam.cityName = self.cityName
    newViewControllerParam.cityData = self.cityData  -- 城市数据
    newViewControllerParam.superior = self
    local viewCtrl = require(newViewControllName).new(newViewControllerParam)
    
    viewCtrl:loadView()
    viewCtrl:viewDidLoad()
    viewCtrl.view:addTo(self.currentScene)
    viewCtrl:onEnter()
end

-- 场景内部切换层  ,参数：场景的文件名， 附加参数
function QCitySceneController:switchView(newViewControllName, param)
   
    newViewControllName = "app/citySelection/".. newViewControllName
    
    -- 当前视图控制器退出
    local oldController = self.curController
    
    local newViewControllerParam = param or {}  
    newViewControllerParam.cityData = self.cityData  -- 城市数据
    newViewControllerParam.superior = self           -- 上级控制器设置为自己
    -- 实例化新的场景控制器
--    print("/..........", newViewControllName)
    self.curController = require(newViewControllName).new(newViewControllerParam)
--    print("11111111111111111111111")
    if not self.curController then   -- 返回nil时，说明当前场景无法处理该视图切换，提交给上级控制器
        slef.parentController:switchTo()
        return 
    end
    
    self.curController:loadView()

    -- 通知旧的控制器该退出了
    if oldController then 
        self:removeView(oldController.view)
        oldController:onQuit()
    end
    
    self.curController.view:addTo(self.currentScene)
    self.curController:viewDidLoad()
    self.curController:onEnter()
end

-- 场景
function QCitySceneController:removeView(view)
	view:removeFromParent()
-- print("场景移除层。。。。。。", self.curController.name)
-- dump(self.curController)
    -- if self.curController.reLoad then
    --     self.curController:reLoad()
    -- end
end

---- 场景控制器无法处理的情况返回给根控制器
--function QCitySceneController:parentHandle(param)
--	if self.parentController then
--        self.parentController:startUP()
--	end
--end

return QCitySceneController
