
local CityViewController = class("CityViewController", require("app/controllers/ViewController"))

function CityViewController:ctor(param)
    param.cityData = QMapGlobal.systemData.mapData[param.cityid]
    self.city = require("app/data/City").new(QMapGlobal.systemData.mapData[param.cityid])
    param.mapParam = self.city:getMapSideColors()
    CityViewController.super.ctor(self, param)
    self._viewClassPath = "app/city/CityView"
    -- self.superior = param.parent
    -- self.cityData = QMapGlobal.systemData.mapData[cityid]
    self.cityName = self.city:getMapName()

    self.cityID = param.cityid

    -- print("统计城市数据。。。。。。。。。", cityName)
    -- lua_ymOnEvent(cityName)

    -- QMapGlobal.DataManager:setClickCount(self.cityID)
    
    -- print("当前进入的城市是。。。", cityName)

    -- local downloadPath = cc.FileUtils:getInstance():getDownloadPath()
    -- self.path = device.writablePath .. "map/" .. cityName .. "/image/" .. cityName
    -- self.path = downloadPath .. "map/" .. cityName .. "/image/" .. cityName
    -- display.addSpriteFrames(self.path ..".plist", self.path .. ".png")

    -- self.cityName = cityName
    
    self:_initScenarioControllers()
end

function CityViewController:viewDidLoad()
    -- QMapGlobal.DataManager:getSightList(self.cityID, function ( sightDatas )
        -- dump(sightDatas)

    local sights = QMapGlobal.DataManager:getSightData(self.cityID)

        -- local sights = QMapGlobal.systemData.mapData[self.cityID].sight or {}
        -- for _, sightData in pairs(sightDatas) do
        --     sights[sightData.sightid] = sightData
        -- end
        -- QMapGlobal.systemData.mapData[self.cityID].sight = sights

    QMapGlobal.gameState.curCityID = self.cityID
    QMapGlobal.DataManager:saveGameState()
        
    self:_attachCityViewToScenarioControllers()
    self:switchMapToScenicSpotsScenario()
    -- end, function (  )
    --     self:_attachCityViewToScenarioControllers()
    --     self:switchMapToScenicSpotsScenario()
    -- end)
    print("function CityViewController:viewDidLoad()")
    local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
    -- 下载城市特产数据
    if QMapGlobal.specialityDatas[self.cityID] then
        self.view:setMenuButtonsVisible("shop", true)
    else
        scheduler.performWithDelayGlobal(function (  )
            QMapGlobal.DataManager:getSpecialityDatas(self.cityID, function (  )
                if self and self.view then
                    self.view:setMenuButtonsVisible("shop", true)
                end
            end, function (  )
                -- body
            end)
        end, 0.5)
    
    end

    if QMapGlobal.cardDatas[self.cityID] then
        self.view:setMenuButtonsVisible("strategy", true)
    end
    -- 下载
    scheduler.performWithDelayGlobal(function (  )
        QMapGlobal.DataManager:getCardDatas(self.cityID, function (  )
            if self and self.view then
                self.view:setMenuButtonsVisible("strategy", true)
            end
        end, function (  )
            -- body
        end)
    end, 0.5)

    local cityName = self.cityName
    local cityID = self.cityID
    scheduler.performWithDelayGlobal(function (  )
        print("统计城市数据。。。。。。。。。", cityName)
        lua_ymOnEvent(cityName)
        QMapGlobal.DataManager:setClickCount(cityID)
    end, 1)
end

function CityViewController:viewWillUnload()
    -- printf("CityViewController:viewWillUnload")
    self.view:setMapGestureRecognitionEnabled(false)
end

function CityViewController:_initScenarioControllers()
    self._scenarioControllers = self._scenarioControllers or {
        scenicSpotsController = require("app/city/scenarioControllers/ScenicSpotsController").new(self),
        travelCommentController = require("app/city/scenarioControllers/TravelCommentController").new(self),
        browseTravelNoteController = require("app/city/scenarioControllers/BrowseTravelNoteController").new(self),
        planTravelRouteController = require("app/city/scenarioControllers/PlanTravelRouteController").new(self)
    }
end

function CityViewController:_attachCityViewToScenarioControllers(cityView)
    for k, controller in pairs(self._scenarioControllers) do
        controller:attachView(self.view)
    end
end

function CityViewController:_switchScenarioControllerTo(newScenarioController)
    if self._currentScenarioController ~= newScenarioController then
        
        if self._currentScenarioController then
            self._currentScenarioController:quit()
        end
        if newScenarioController then
            newScenarioController:enter()
        end
        self._currentScenarioController = newScenarioController
    end
end

function CityViewController:switchBackToCitySelection()
    self.navigationController:clearContollerPathBase()
    -- self.navigationController:switchTo("app/citySelection/CitySelectionViewController", {cityid = self.city:getCityId()})

    self.navigationController:switchTo("app/userHome/UserHomeController")   --, {cityid = self.city:getCityId()})



    local downloadPath = cc.FileUtils:getInstance():getDownloadPath()
    -- self.path = device.writablePath .. "map/" .. cityName .. "/image/" .. cityName
    local path = downloadPath .. "map/" .. self.cityName .. "/image/" .. self.cityName
    display.removeSpriteFramesWithFile(path ..".plist", path .. ".png")


end

function CityViewController:switchMapToScenicSpotsScenario()
    -- printf("------switchMapToScenicSpotsScenario")
    self:_switchScenarioControllerTo(self._scenarioControllers.scenicSpotsController)
end

function CityViewController:switchMapToCommentScenario()
    -- printf("------switchMapToCommentScenario")
    self:_switchScenarioControllerTo(self._scenarioControllers.travelCommentController)
end

function CityViewController:switchMapToTravelNoteScenario()
    -- printf("------switchMapToTravelNoteScenario")
    self:_switchScenarioControllerTo(self._scenarioControllers.browseTravelNoteController)
end

function CityViewController:switchMapToTravelPlanScenario()
    -- printf("------switchMapToTravelPlanScenario")
    self:_switchScenarioControllerTo(self._scenarioControllers.planTravelRouteController)
end

return CityViewController
