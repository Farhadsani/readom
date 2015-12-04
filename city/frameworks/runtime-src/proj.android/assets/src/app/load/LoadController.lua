
-- LoadController.lua 程序启动加载资源页面
-- add by star 2015.5.6
-- 加载资源，连接网络，更新系统数据

local LoadController = class("LoadController", require("app/controllers/ViewController"))

function LoadController:ctor( param )
	LoadController.super.ctor(self, param)
    self._viewClassPath = "app/load/LoadView"
    print("加载页面。。。。。。。。")
end

function LoadController:viewDidLoad()
    -- print("11222222222222222211111")
	self.view:setDelegate(self)
    -- print("3333333333333333333333")
	local function callBack( ... )
        -- self.navigationController:setControllerPathBase("app/citySelection/CitySelectionViewController")
        -- self.navigationController:switchTo( "app/citySelection/CitySelectionViewController", {cityid = 1}, "fade" )
        self.navigationController:switchTo( "app/citySelection/CitySelectionViewController", {}, "fade" )
    end

    local a1 = cc.DelayTime:create(0.5)
    local a2 = cc.CallFunc:create(function()
    --     print("111111111111111111")
			QMapGlobal.DataManager = require("src/app/data/DataManager").new({callBack = callBack})
		end)
    local a3 = cc.Sequence:create(a1, a2)
    self.view:runAction(a3)
end

function LoadController:viewWillUnload()
    self.view:stopAllActions()
end

return LoadController