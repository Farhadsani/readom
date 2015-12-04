
function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
end

local appName = lua_getAppName()
print("appname = ", appName)

if appName == "citystate" then
	require("src/app_cs/common/QMapGlobal")
else
	require("src/app/common/QMapGlobal")
end

-- print("1111111111111111111111111111111")
-- print(bit.bor(1, 2))
-- luabit = require("bit")
-- print(luabit)

-- local idTest = 6064603646874624727
-- print("---------fd-0------")
-- print(idTest)

package.path = package.path .. ";src/"
cc.FileUtils:getInstance():setPopupNotify(false)
if appName == "citystate" then
	QMapGlobal.app = require("app_cs.QMapApp_cs").new()
else
	QMapGlobal.app = require("app.QMapApp").new()
end
QMapGlobal.app:run()
