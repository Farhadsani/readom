
-- LoadController.lua 程序启动加载资源页面
-- add by star 2015.5.6
-- 加载资源，连接网络，更新系统数据

local LoadController = class("LoadController", require("app_cs/controllers/ViewController"))

function LoadController:ctor( param )
	LoadController.super.ctor(self, param)
    self._viewClassPath = "app_cs/load/LoadView"
    print("加载页面。。。。。。。。")

    self.categoryType = param.categoryType
    self.categoryID = param.categoryID
    print("111111111111111111111")
end

function LoadController:viewDidLoad()
    -- print("11222222222222222211111")
    print("function LoadController:viewDidLoad()")
	self.view:setDelegate(self)
    -- print("3333333333333333333333")
 --    self.view:setPercent( 50 )
 -- do return end
    -- 更新数据，异步下载
    QMapGlobal.DataManager = require( "app_cs/data/DataManager").new()

    -- 下载完毕，加载地图场景
    local function callBack( ... )
        -- self.navigationController:setControllerPathBase("app/citySelection/CitySelectionViewController")
        -- self.navigationController:switchTo( "app/citySelection/CitySelectionViewController", {cityid = 1}, "fade" )
        
        -- self.navigationController:switchTo( "app_cs/userHome/UserHomeController", {}, "fade" )
        -- self.navigationController:switchTo( "app/citySelection/CitySelectionViewController", {}, "fade" )

        local fu = cc.FileUtils:getInstance()
        local downloadPath = fu:getDownloadPath()

        local cityName = QMapGlobal.cityName
        local mapPath = QMapGlobal.resFile.image.map:gsub("?", cityName)

        local path = downloadPath .. mapPath
        if not fu:isFileExist(path) then
            path = "res/ui/" .. mapPath
        end

        self.view:setPercent( 98 )
        display.addImageAsync(path, function ( ... )
            self.view:setPercent( 99 )
            -- print("22222", os.date())

            local sightPath = QMapGlobal.resFile.image.sights:gsub("?", cityName)
            local plistPath = QMapGlobal.resFile.image.sightplist:gsub("?", cityName)

            local path1 = downloadPath .. sightPath
            local path2 = downloadPath .. plistPath

            if not fu:isFileExist(path1) or not fu:isFileExist(path2) then
                path1 = "res/ui/" .. sightPath
                path2 = "res/ui/" .. plistPath
            end

            display.addSpriteFrames(path2, path1, function (  )
                -- print("33333", os.date())
                self.view:setPercent( 100 )
                -- print("add plist over..............")
                -- if device.platform ~= "android" then
                    -- QMapGlobal.app.navigationController:setControllerPathBase(self.packageRoot .. "/city/")
                    local param = { cityid = QMapGlobal.cityID , categoryType = self.categoryType, categoryID = self.categoryID}
                    QMapGlobal.app.navigationController:switchTo( "citymap",  param)
                -- end
            end)
        end)
    end

    QMapGlobal.DataManager:initSystemData(function (  )
       if QMapGlobal.DataManager:mapHasNewVer(QMapGlobal.cityID) then   -- 下载。。。。

           QMapGlobal.DataManager:downloadMapFiles(QMapGlobal.cityID, function ( cityid, progress )
                -- body
               if type(progress) == "number" then
                   self.view:setPercent( progress * 0.98 )
               elseif type(progress) == "string" then
                   -- self.view:setPercent( 98 )
                   callBack()
               end

           end, function (  )
                -- body
               callBack()
           end)
       else
            callBack()
       end
    end)
    
	

  --   local a1 = cc.DelayTime:create(3.0)
  --   local a2 = cc.CallFunc:create(function()
  --   --     print("111111111111111111")
		-- 	-- QMapGlobal.DataManager = require("src/app_cs/data/DataManager").new({callBack = callBack})
  --           if callBack then
  --               callBack()
  --           end
		-- end)
  --   local a3 = cc.Sequence:create(a1, a2)
  --   self.view:runAction(a3)
end

function LoadController:viewWillUnload()
    self.view:stopAllActions()
end

return LoadController