
local CityViewController = class("CityViewController", require(QMapGlobal.app.packageRoot .. "/controllers/ViewController"))

function CityViewController:ctor(param)
    -- print("444444", os.date())
    self.packageRoot = QMapGlobal.app.packageRoot

    local cityData = QMapGlobal.DataManager:getCityData(param.cityid)

    print("function CityViewController:ctor(param)...................")
    -- dump(cityData)

    param.cityData = cityData
    self.city = require(self.packageRoot .. "/data/City").new(cityData)
    param.mapParam = self.city:getMapSideColors()
    CityViewController.super.ctor(self, param)
    self._viewClassPath = self.packageRoot .. "/city/CityView"
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
    -- print("55555", os.date())
    self.categoryType = param.categoryType or CategoryType_sight
    self.categoryID = param.categoryID
    print("CityViewController:ctor....", self.categoryType, self.categoryID)
end

function CityViewController:reLoadView( param )
    -- body
    -- categoryType = categoryType  categoryType = categoryType, categoryID =
    print("刷新地图。。。。。。function CityViewController:reLoadView( param )")
    
    self.categoryType = param.categoryType
    self.categoryID = param.categoryID
    print("CityViewController:reLoadView...", self.categoryType, self.categoryID)

    self.categoryDatas = {}

    QMapGlobal.DataManager:getCategoryInfo(self.categoryType, self.categoryID, function ( result )
        -- body
        -- dump(result)
        -- param.categoryType, param.categoryID
        self.categoryDatas = result
        self.view:reLoadView({categoryType = param.categoryType, categoryID = param.categoryID, datas = result})
    end, function (  )
        -- body
    end)
    -- self.view:reLoadView(param)

    if self._currentScenarioController then
        self._currentScenarioController:reLoadView(param)
    end
end

function CityViewController:viewDidLoad()
    -- QMapGlobal.DataManager:getSightList(self.cityID, function ( sightDatas )
        -- dump(sightDatas)

    -- local sights = QMapGlobal.DataManager:getSightData(self.cityID)

        -- local sights = QMapGlobal.systemData.mapData[self.cityID].sight or {}
        -- for _, sightData in pairs(sightDatas) do
        --     sights[sightData.sightid] = sightData
        -- end
        -- QMapGlobal.systemData.mapData[self.cityID].sight = sights

    QMapGlobal.gameState.curCityID = self.cityID
    QMapGlobal.DataManager:saveGameState()
        
    self:_attachCityViewToScenarioControllers()
    self:switchMapToScenicSpotsScenario()



    self:reLoadView({categoryType = self.categoryType, categoryID = self.categoryID})
    -- end, function (  )
    --     self:_attachCityViewToScenarioControllers()
    --     self:switchMapToScenicSpotsScenario()
    -- end)
    -- print("function CityViewController:viewDidLoad()")
    -- local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
    -- -- 下载城市特产数据
    -- if QMapGlobal.specialityDatas[self.cityID] then
    --     self.view:setMenuButtonsVisible("shop", true)
    -- else
    --     scheduler.performWithDelayGlobal(function (  )
    --         QMapGlobal.DataManager:getSpecialityDatas(self.cityID, function (  )
    --             if self and self.view then
    --                 self.view:setMenuButtonsVisible("shop", true)
    --             end
    --         end, function (  )
    --             -- body
    --         end)
    --     end, 0.5)
    
    -- end

    -- if QMapGlobal.cardDatas[self.cityID] then
    --     self.view:setMenuButtonsVisible("strategy", true)
    -- end
    -- -- 下载
    -- scheduler.performWithDelayGlobal(function (  )
    --     QMapGlobal.DataManager:getCardDatas(self.cityID, function (  )
    --         if self and self.view then
    --             self.view:setMenuButtonsVisible("strategy", true)
    --         end
    --     end, function (  )
    --         -- body
    --     end)
    -- end, 0.5)

    -- local cityName = self.cityName
    -- local cityID = self.cityID
    -- scheduler.performWithDelayGlobal(function (  )
    --     print("统计城市数据。。。。。。。。。", cityName)
    --     lua_ymOnEvent(cityName)
    --     QMapGlobal.DataManager:setClickCount(cityID)
    -- end, 1)
end

function CityViewController:viewWillUnload()
    -- printf("CityViewController:viewWillUnload")
    self.view:setMapGestureRecognitionEnabled(false)
end

function CityViewController:_initScenarioControllers()
    local path = self.packageRoot .. "/city/scenarioControllers/"
    self._scenarioControllers = self._scenarioControllers or {
        scenicSpotsController = require(path .. "ScenicSpotsController").new(self),
        travelCommentController = require(path .. "TravelCommentController").new(self),
        browseTravelNoteController = require(path .. "BrowseTravelNoteController").new(self),
        planTravelRouteController = require(path .. "PlanTravelRouteController").new(self)
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

    self.navigationController:switchTo(self.packageRoot .. "/userHome/UserHomeController")   --, {cityid = self.city:getCityId()})

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

function CityViewController:onClickSight( sightID, sightName, sightDesc, func )
    print("onclick....", self.categoryType, self.categoryID, sightID)
    -- if self.categoryType and self.categoryType ~= CategoryType_sight then
    --     if self.categoryDatas and next(self.categoryDatas) then
    --         if self.categoryDatas[sightID] then
    --             openCategory(sightID, self.categoryType, self.categoryID, func)
    --             return
    --         end
    --     end
    -- end
    -- else
    if self.categoryType and self.categoryType == CategoryType_sight then
        if QMapGlobal.DataManager:isSight(QMapGlobal.cityID, sightID) then
            openSightIntro(sightID, sightName, sightDesc, func)
        end
    else
        openCategory(sightID, self.categoryType, self.categoryID, func)
    end
    -- end
end

return CityViewController
