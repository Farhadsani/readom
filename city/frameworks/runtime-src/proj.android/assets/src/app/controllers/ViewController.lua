local ViewController = class("ViewController")

function ViewController:ctor(param)
    self.navigationController = QMapGlobal.app.navigationController
    self._param = param
    self._viewClassPath = nil
end

function ViewController:getName()
	return self.__cname
end

function ViewController:loadView()
-- printf("ViewController:loadView: %s, view's delegate should be set in sub view controller's viewDidLoad", self._viewClassPath)
-- dump(self._param)
    self.view = require(self._viewClassPath).new(self._param)
end

function ViewController:viewDidLoad()
	-- printf("ViewController:viewDidLoad called")
    
end

function ViewController:viewWillUnload()
	-- body
end

function ViewController:unloadView()
    self.view:onExit()
    self.view:cleanup()
    self.view:removeFromParent()
    self.view = nil
end

function ViewController:onEnter( ... )
	-- body
end

return ViewController
