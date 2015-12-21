
require("config")
require("cocos.init")
require("framework.init")

local appPath = "src/app_cs/"
require(appPath .. "common/QMapGlobal")
require(appPath .. "common/Util")
require(appPath .. "common/QMapAction")
require(appPath .. "resData/resFile")
require(appPath .. "resData/mapData")
-- QMapGlobal.DataManager = require(appPath .. "data/DataManager").new()   -- 移动到加载页中
require(appPath .. "resData/menuDescription")

local QMapApp = class("QMapApp", cc.mvc.AppBase)

function QMapApp:ctor()
    QMapApp.super.ctor(self, "cityState", "app_cs")

    -- local ncPathName = self.packageRoot .. "/controllers/NavigationController"
    -- print("ncPathName = ", ncPathName)
    -- self.navigationController = require(ncPathName).new()

	-- print("这是程序启动之前的测试。。。。。。。。。。")
 --    print(cc.FileUtils:getInstance():getDownloadPath())
end

function QMapApp:run()
	-- print("路径。。。。。。。。。。。。。")
 --    dump(cc.FileUtils:getInstance():getSearchPaths())
    print("lua is running.........")
    
    cc.FileUtils:getInstance():addSearchPath("res/")
    -- cc.FileUtils:getInstance():addSearchPath(device.writablePath)

    local ncPathName = self.packageRoot .. "/controllers/NavigationController"
    print("ncPathName = ", ncPathName)
    self.navigationController = require(ncPathName).new()

-- print("路径。。。。。。。。。。。。。")
--     dump(cc.FileUtils:getInstance():getSearchPaths())
    self.navigationController:switchToDefaultViewController()
end

return QMapApp