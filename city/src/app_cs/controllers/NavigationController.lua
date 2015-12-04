
-- 根控制器，控制场景切换

local NavigationController = class("NavigationController")

local ControllerList = {
    citymap = "/city/CityViewController",
    userhome = "/userHome/UserHomeController",
    loading = "/load/LoadController"
}

function NavigationController:ctor(param)
    print("..................")
    -- dump(QMapGlobal)

    self.packageRoot = QMapGlobal.app.packageRoot

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

    -- local controllerPath = self._controllerPathBase and (self._controllerPathBase .. newViewControllerName) or newViewControllerName
    local controllerPath = self.packageRoot .. ControllerList[newViewControllerName]
    local newViewController = require(controllerPath).new(param)
    
    return newViewController
end

function NavigationController:switchTo(newViewControllerName, param, transitionStyle)

    local currentViewController = self:_top()  
    -- dump(currentViewController)

    if currentViewController and currentViewController.__sceneSymbol == newViewControllerName then
        print("NavigationController:switchTo, reLoadView")
        currentViewController:reLoadView(param)
        return 
    end

    transitionStyle = transitionStyle or "fade"

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
    newViewController.__sceneSymbol = newViewControllerName
    newViewController:loadView()
    newViewController:viewDidLoad()
    self:_replaceTop(newViewController)

    self._currentScene = display.newScene(newViewController:getName())
    newViewController.view:addTo(self._currentScene)

    
    display.replaceScene(self._currentScene, transitionStyle, 0.5, nil)

    print(newViewControllerName .. " load over in NavigationController........")
    
    sceneLoadOver(newViewControllerName)
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

 --    *@params:indexType：指数类型（景点、社交指数、热门标签、消费指数）
 --    *@params:indexId：指数的Id
 -- *
 -- *        indexType = 0 ：景点（默认情况，点击全部情况，此时indexId=nil）
 -- *        indexType = 1 ：社交指数
 -- *        indexType = 2 ：热门标签
 -- *        indexType = 3 ：消费指数
    openMap(function ( categoryType , categoryID )
        if self.categoryType and self.categoryType == categoryType then
            if not categoryID or string.len(categoryID) == 0 then
                categoryID = self.categoryID
            end
        end
        self.categoryType = categoryType
        self.categoryID = categoryID
        
        if not QMapGlobal.loadover then   -- 没有加载loading ,先加载loading
            QMapGlobal.loadover = true
            QMapGlobal.app.navigationController:switchTo( "loading", { cityid = 1 , categoryType = categoryType, categoryID = categoryID} )
            return 
        end
        print("openMap.........", categoryType , categoryID )
        -- categoryType = 0
        -- categoryID = 2
        
        print("11111", os.date())
        display.addImageAsync("res/ui/map/taiyuan/image/taiyuanmap.jpg", function ( ... )
            print("22222", os.date())
            display.addSpriteFrames("res/ui/map/taiyuan/image/taiyuan.plist", "res/ui/map/taiyuan/image/taiyuan.png", function (  )
                print("33333", os.date())
                -- print("add plist over..............")
                -- if device.platform ~= "android" then
                    QMapGlobal.app.navigationController:setControllerPathBase(self.packageRoot .. "/city/")
                    QMapGlobal.app.navigationController:switchTo( "citymap", { cityid = QMapGlobal.cityID , categoryType = categoryType, categoryID = categoryID} )
                -- end
            end)
        end)

    end)
end


function NavigationController:registToUserHome( ... )
    openUserHome(function ( userid, username, intro, zonename , thumblink, imglink )
        print("open user home.....", userid, username, intro, zonename , thumblink, imglink)
        -- if not _testFD then
        QMapGlobal.app.navigationController:setControllerPathBase("")
        local curUser = {userid = userid, name = username, intro = intro, zone = zonename, thumblink = thumblink, imglink = imglink}
        local ncPathName = self.packageRoot .. "/userHome/UserHomeController" 
        QMapGlobal.app.navigationController:switchTo( "userhome", {curUser = curUser}, "fade" )

    end)

    -- 刷新个人中心界面
    refreshUserCenter(function ( userid )
        -- body
        local currentViewController = QMapGlobal.app.navigationController:_top()
        if currentViewController and currentViewController.__sceneSymbol == "userhome" then
            currentViewController:reLoadView({curUser = {userid = userid}})
        end
    end)

    registBackToUserHome(function ( preUserID )
        print("in lua back to home......", preUserID)
        -- local curUser = {userid = userid, name = username, intro = intro, zone = zonename, thumblink = thumblink, imglink = imglink}
        local curUser = nil
        if QMapGlobal.userHomeStack and next(QMapGlobal.userHomeStack) then
            local userTemp = QMapGlobal.userHomeStack[#QMapGlobal.userHomeStack]
            -- dump(curUser)
            if preUserID and preUserID ~= 0 then
                if preUserID == userTemp.userid then
                    table.remove(QMapGlobal.userHomeStack)
                    if QMapGlobal.userHomeStack and next(QMapGlobal.userHomeStack) then
                        userTemp = QMapGlobal.userHomeStack[#QMapGlobal.userHomeStack]
                    end
                end
            end
            curUser = userTemp
        end
        QMapGlobal.app.navigationController:setControllerPathBase("")
        local ncPathName = self.packageRoot .. "/userHome/UserHomeController" 
        QMapGlobal.app.navigationController:switchTo( "userhome", {curUser = curUser, isBack = true}, "fade" )
    end)
end

return NavigationController
