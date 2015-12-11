
-- 根控制器，控制场景切换

local NavigationController = class("NavigationController")

function NavigationController:ctor(param)
    self._viewControllerStack = {}
    userLogin(type, function ( loginResult, userid, username, intro, zonename , thumblink, imglink)  --userTexture)
        if loginResult == 1 then
            -- 登陆成功
            print("登录成功。。", userid, username, intro, zonename )
            QMapGlobal.isLogin = true

            QMapGlobal.UserInfo = {userid = userid, name = username, intro = intro, zone = zonename, imglink = imglink, thumblink = thumblink}
        end
    end)    -- 用户登录
    self:registToUserHome()
    self:registToMap()
end

function NavigationController:setControllerPathBase(pathBase)
    self._controllerPathBase = pathBase
end

function NavigationController:clearContollerPathBase()
    self._controllerPathBase = nil
end

function NavigationController:switchToDefaultViewController()
	-- local vcPathName = "app/citySelection/CitySelectionViewController"
 --    self:switchTo(vcPathName, {cityid = 1}, "fade")

    -- local vcPathName = "app/load/LoadController"
    -- local vcPathName = "app/userHome/UserHomeController"
    self:switchTo(vcPathName)

    -- local function callBack( ... )
    --     -- self.navigationController:setControllerPathBase("app/citySelection/CitySelectionViewController")
    --     -- self.navigationController:switchTo( "app/citySelection/CitySelectionViewController", {cityid = 1}, "fade" )
        
    --     self.navigationController:switchTo( "app/userHome/UserHomeController", {}, "fade" )
    --     -- self.navigationController:switchTo( "app/citySelection/CitySelectionViewController", {}, "fade" )
    -- end

    -- -- local a1 = cc.DelayTime:create(1.0)
    -- -- local a2 = cc.CallFunc:create(function()
    -- --     print("111111111111111111")
    --         QMapGlobal.DataManager = require("src/app/data/DataManager").new({callBack = callBack})
    --     -- end)
    -- -- local a3 = cc.Sequence:create(a1, a2)
    -- -- self.view:runAction(a3)
end

function NavigationController:_createViewController(newViewControllerName, param)

    local controllerPath = self._controllerPathBase and (self._controllerPathBase .. newViewControllerName) or newViewControllerName

    local newViewController
    if param then
        newViewController = require(controllerPath).new(param)
    else
        newViewController = require(controllerPath).new()
    end
    
    return newViewController
end

function NavigationController:switchTo(newViewControllerName, param, transitionStyle)
    transitionStyle = transitionStyle or "fade"

    local currentViewController = self:_top()
    if currentViewController then
        currentViewController:viewWillUnload()
    end

    if not newViewControllerName then
        local _TempScene = display.newScene("nilscene")
        display.newLayer():addTo(_TempScene)
        display.replaceScene(_TempScene, transitionStyle, 0.5, nil)
        self._currentScene = nil
        return
    end
    

    local newViewController = self:_createViewController(newViewControllerName, param)
    newViewController:loadView()
    newViewController:viewDidLoad()
    self:_replaceTop(newViewController)

    self._currentScene = display.newScene(newViewController:getName())
    newViewController.view:addTo(self._currentScene)

    
    display.replaceScene(self._currentScene, transitionStyle, 0.5, nil)
end

function NavigationController:_push(newViewController, transitionStyle)
    table.insert(self._viewControllerStack, newViewController)

    newViewController:loadView()
    newViewController:viewDidLoad()
    newViewController.view:addTo(self._currentScene)
end

function NavigationController:push(newViewControllerName, param, transitionStyle)
    local newViewController = self:_createViewController(newViewControllerName, param)
    self:_push(newViewController, transitionStyle)
end

function NavigationController:pop(transitionStyle)
    if #self._viewControllerStack > 0 then

        local topViewController = self._viewControllerStack[#self._viewControllerStack]

        topViewController:viewWillUnload()
        topViewController:unloadView()

        table.remove(self._viewControllerStack, #self._viewControllerStack)
    end
end

function NavigationController:_top()
    if #self._viewControllerStack > 0 then
        return self._viewControllerStack[#self._viewControllerStack]
    end
    return nil
end

function NavigationController:_replaceTop(viewController)
    if #self._viewControllerStack > 0 then
        table.remove(self._viewControllerStack, #self._viewControllerStack)
    end

    if viewController then
        table.insert(self._viewControllerStack, viewController)
    end
end

function NavigationController:registToMap( ... )
    openMap(function (  )
        QMapGlobal.app.navigationController:switchTo( "app/citySelection/CitySelectionViewController", {}, "fade" )
    end)
end

function NavigationController:registToUserHome( ... )
    refreshUserCenter(function ( userid, username, intro, zonename , thumblink, imglink )
        -- QMapGlobal.userManager = qm.UserManager:getInstance()
        -- if QMapGlobal.userManager:userLoginStatus() == UserLoginStatus_loginSuccess then -- 已经登录
        --     QMapGlobal.UserInfo = {userid = QMapGlobal.userManager:userid(), name = QMapGlobal.userManager:name(), 
        --             intro = QMapGlobal.userManager:intro(), zone = QMapGlobal.userManager:zone(), 
        --             imglink = QMapGlobal.userManager:imglink(), thumblink = QMapGlobal.userManager:thumblink()}
        -- else
        --     QMapGlobal.UserInfo = nil
        -- end
        print("open user home.....")
        -- if not _testFD then
        local curUser = {userid = userid, name = username, intro = intro, zone = zonename, thumblink = thumblink, imglink = imglink}
        QMapGlobal.app.navigationController:switchTo( "app/userHome/UserHomeController", {curUser = curUser}, "fade" )
        --     _testFD = true
        -- end
    end)

    registBackToUserHome(function (  )
        print("back to home......")
        -- local curUser = {userid = userid, name = username, intro = intro, zone = zonename, thumblink = thumblink, imglink = imglink}
        local curUser = nil
        if QMapGlobal.userHomeStack and next(QMapGlobal.userHomeStack) then
            curUser = QMapGlobal.userHomeStack[#QMapGlobal.userHomeStack]
            -- dump(curUser)
        end
        QMapGlobal.app.navigationController:switchTo( "app/userHome/UserHomeController", {curUser = curUser, isBack = true}, "fade" )
    end)
end

return NavigationController
