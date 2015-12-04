-- QMapSceneController.lua  add star 2015.3.6
 
-- 全国地图控制器，显示整个地球等层

local QMapSceneController = class("QMapSceneController")

function QMapSceneController:ctor(param)
    -- 严格意义上，每个Controller对应一个Scene(View)，介于性能考虑，目前用不着每个Controller
    -- 做一个Scene，用Layer也可以表示MVC中View的概念，Scene可被认为是一个View的Container
    --    self.currentScene = display.newScene("QMapScene")
    self.currentScene = require(param.sceneName):new()
    self.activeViewController = nil
end

function QMapSceneController:switchToDefaultViewController()
    local vcPathName = "app/citySelection/    "
    local param = {arg="test"}
    self:switchTo(vcPathName, nil)  
end


-- 
function  QMapSceneController:startUP(parameters)

    self:switchTo()
end


return QMapSceneController
