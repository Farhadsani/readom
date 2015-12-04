
require("config")
require("cocos.init")
require("framework.init")

require("src/app/common/QMapGlobal")
require("src/app/common/Util")
require("src/app/common/QMapAction")
require("src/app/resData/resFile")
require("src/app/resData/mapData")
-- QMapGlobal.DataManager = require("src/app/data/DataManager").new()   -- 移动到加载页中
require("src/app/resData/menuDescription")


local QMapApp = class("QMapApp", cc.mvc.AppBase)

function QMapApp:ctor()
    QMapApp.super.ctor(self)

    local ncPathName = self.packageRoot .. "/controllers/NavigationController"
    self.navigationController = require(ncPathName).new()

	-- print("这是程序启动之前的测试。。。。。。。。。。")
 --    print(cc.FileUtils:getInstance():getDownloadPath())
end

function QMapApp:run()
	-- print("路径。。。。。。。。。。。。。")
 --    dump(cc.FileUtils:getInstance():getSearchPaths())
    
    cc.FileUtils:getInstance():addSearchPath("res/")
    cc.FileUtils:getInstance():addSearchPath(device.writablePath)

-- print("路径。。。。。。。。。。。。。")
--     dump(cc.FileUtils:getInstance():getSearchPaths())
    self.navigationController:switchToDefaultViewController()
end

return QMapApp
