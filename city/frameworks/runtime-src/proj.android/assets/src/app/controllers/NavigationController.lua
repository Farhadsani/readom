local NavigationController = class("NavigationController")

function NavigationController:ctor(param)
    self._viewControllerStack = {}
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

    local vcPathName = "app/load/LoadController"
    self:switchTo(vcPathName)
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

    local currentViewController = self:_top()
    if currentViewController then
        currentViewController:viewWillUnload()
    end

    local newViewController = self:_createViewController(newViewControllerName, param)
    newViewController:loadView()
    newViewController:viewDidLoad()
    self:_replaceTop(newViewController)

    self._currentScene = display.newScene(newViewController:getName())
    newViewController.view:addTo(self._currentScene)

    transitionStyle = transitionStyle or "fade"
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

return NavigationController
