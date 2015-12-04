

local OneMsgDialogController = class("OneMsgDialogController", require("app/controllers/ViewController"))

function OneMsgDialogController:ctor(param)
    OneMsgDialogController.super.ctor(self, param)
    self.name = "OneMsgDialogController"
    self._viewClassPath = "app/citySelection/OneMsgDialogView"
    -- self.superior = param.superior

    -- self.imageDatas = param and param.imageDatas
    -- self.index = param and param.index or 1
end

function OneMsgDialogController:viewDidLoad()
    self.view:setDelegate(self)

    -- self.view:initUI(self.imageDatas, self.index)
end

-- handle events from self.view
function OneMsgDialogController:tapMapLocationItemWithName(itemName)
    print("StartCommentCityViewController:tapMapLocationItemWithName", itemName)
end

-- 返回按钮菜单事件
function OneMsgDialogController:onBack(parameters)
    print("onBack......")
    -- self.superior:removeView(self.view)
    self.navigationController:pop()
end

-- 确定
function OneMsgDialogController:onOK( ... )
    -- self.superior:removeView(self.view)
    self.navigationController:pop()
end

function OneMsgDialogController:onEnter(param)

end 

function OneMsgDialogController:tapMenuButtonWithName(buttonName)
    print("OneMsgDialogController:tapMenuButtonWithName:", buttonName)

end

function OneMsgDialogController:onQuit(parameters)

end

return OneMsgDialogController
