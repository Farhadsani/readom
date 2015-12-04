
function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
end

require("src/app/common/QMapGlobal")

package.path = package.path .. ";src/"
cc.FileUtils:getInstance():setPopupNotify(false)
QMapGlobal.app = require("app.QMapApp").new()
QMapGlobal.app:run()
