QMapGlobal = QMapGlobal or {}
QMapGlobal.TouchAffectRange = 25
QMapGlobal.app = nil
QMapGlobal.gameState = QMapGlobal.gameState or {}
QMapGlobal.gameState.ver = lua_getAppVersion() or "1.0.0"

QMapGlobal.gameState.userid = 0
QMapGlobal.gameState.pw = ""

QMapGlobal.isLogin = false

QMapGlobal.cityID = 140100                -- 当前城市ID
QMapGlobal.cityName = "taiyuan"       -- 当前城市的名称
QMapGlobal.cityShowName = "太原"      -- 当前城市显示名称
QMapGlobal.serverUrl = "http://citystate.shitouren.com/" --太原测试服务器
QMapGlobal.cityTColor = "D4B762FF"
QMapGlobal.cityBColor = "D4B762FF"

-- local url = "http://test.shitouren.com/api/user/signin"

-- QMapGlobal.userManager = qm.UserManager:getInstance()

UserLoginStatus_isInLogining = 0
UserLoginStatus_loginSuccess = 1
UserLoginStatus_loginFailed = 2
UserLoginStatus_loginOut = 3

SpaceType_sight = 2   -- 景点
SpaceType_road = 1    -- 街道
SpaceType_area = 0    -- 片区

-- 用户类型
UserRoleType_Normal = 0   -- 普通用户
UserRoleType_Store = 1    -- 商家

-- 
CategoryType_sight = 0     --景点（默认情况, 点击全部情况)
CategoryType_social = 1    --社交指数
CategoryType_hotTag = 2    --热门标签
CategoryType_consume = 3   --消费指数
