QMapGlobal = QMapGlobal or {}
QMapGlobal.TouchAffectRange = 25
QMapGlobal.app = nil
QMapGlobal.gameState = QMapGlobal.gameState or {}
QMapGlobal.gameState.ver = lua_getAppVersion() or "1.0.0"

QMapGlobal.gameState.userid = 0
QMapGlobal.gameState.pw = ""

QMapGlobal.isLogin = false

-- QMapGlobal.userManager = qm.UserManager:getInstance()

UserLoginStatus_isInLogining = 0
UserLoginStatus_loginSuccess = 1
UserLoginStatus_loginFailed = 2
UserLoginStatus_loginOut = 3