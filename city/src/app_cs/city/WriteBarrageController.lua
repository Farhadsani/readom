
-- WriteBarrageController.lua    写弹幕
-- add by star 2015.4.20

local WriteBarrageController = class("WriteBarrageController", require("app/controllers/ViewController"))

function WriteBarrageController:ctor(param)
    WriteBarrageController.super.ctor(self, param)
    self.name = "WriteBarrageController"
    self._viewClassPath = "app/city/WriteBarrageView"
    self.superior = param.superior
    --    self.parentController = param.parent
    --    self.view = require(self.viewClassPath).new()
    --    
    --    self.view:addTo(self.parentController.currentScene)
    --    self.view:setScale(2)
    self.cityid = param.cityid
    self.sightid = param.sightid
    self.callBack = param.callBack
end

function WriteBarrageController:viewDidLoad()
    self.view:setDelegate(self)
end

-- handle events from self.view
function WriteBarrageController:tapMapLocationItemWithName(itemName)
    print("StartCommentCityViewController:tapMapLocationItemWithName", itemName)
end

-- 返回按钮菜单事件
function WriteBarrageController:onBack(parameters)
                
    self.navigationController:pop()
    if self.callBack then
        self.callBack()
    end
end

-- 确定
function WriteBarrageController:onOK( ... )
    local labelInfo = self.view:getBarrageInfo()  
    -- 向数据库添加记录
    -- local param = {cityid = self.cityid, sightid = self.markData.sightid, title = "桂林之行", upload = false, 
    --     utime = "", mark = markInfo.mark, markid = self.markid, image = self.imageList}
    -- -- dump(param)
    -- QMapGlobal.DataManager:addJourney(param)
    if labelInfo and type(labelInfo) == "string" then
        string.trim(labelInfo)
        if string.len(labelInfo) > 0 then
            QMapGlobal.DataManager:addLabelData(self.cityid, self.sightid, labelInfo, function (  )
                self.navigationController:pop()
                if self.callBack then
                    self.callBack(labelInfo)
                end
            end, function ( errMsg )
                local function onButtonClicked(event)
                    if event.buttonIndex == 1 then
                        device.cancelAlert()
                    end
                end

                device.showAlert("error", errMsg, {"close"}, onButtonClicked)

            end)
        end
    end
end

function WriteBarrageController:onEnter(param)

end 

function WriteBarrageController:tapMenuButtonWithName(buttonName)
    print("WriteBarrageController:tapMenuButtonWithName:", buttonName)

end

function WriteBarrageController:onQuit(parameters)

end

return WriteBarrageController
