
-- SeePicController.lua    
-- add by star 2015.4.8

-- imageData = {
--     {path = ""},
--     {},
-- }

-- 测试。。。图片显示层的调用方式如下。。。
-- local param = {index = 1}  -- 当前显示的位置
-- param.imageDatas = {
--     {path = "img/journey/thumb/1/112/1/3/1.jpg"},
--     {path = "img/journey/thumb/1/112/1/3/2.jpg"},
--     {path = "img/journey/thumb/1/112/1/3/3.jpg"},
--     {path = "img/journey/thumb/1/112/1/3/4.jpg"},
--     {path = "img/journey/thumb/1/112/1/3/5.jpg"},
--     {path = "img/journey/thumb/1/112/1/3/6.jpg"},
--     {path = "img/journey/thumb/1/112/1/3/7.jpg"},
--     {path = "img/journey/thumb/1/112/1/3/8.jpg"},

-- }
-- self._parentController.superior:addView("SeePicController", param)

local SeePicController = class("SeePicController", require("app/controllers/ViewController"))

function SeePicController:ctor(param)
    SeePicController.super.ctor(self, param)
    self.name = "SeePicController"
    self._viewClassPath = "app/city/SeePicView"
    self.superior = param.superior

    self.imageDatas = param and param.imageDatas
    self.index = param and param.index or 1
end

function SeePicController:viewDidLoad()
    self.view:setDelegate(self)

    self.view:initUI(self.imageDatas, self.index)
end

-- handle events from self.view
function SeePicController:tapMapLocationItemWithName(itemName)
    print("StartCommentCityViewController:tapMapLocationItemWithName", itemName)
end

-- 返回按钮菜单事件
function SeePicController:onBack(parameters)
    print("onBack......")
    -- self.superior:removeView(self.view)
    self.navigationController:pop()
end

-- 确定
function SeePicController:onOK( ... )
    -- self.superior:removeView(self.view)
    self.navigationController:pop()
end

function SeePicController:onEnter(param)

end 

function SeePicController:tapMenuButtonWithName(buttonName)
    print("SeePicController:tapMenuButtonWithName:", buttonName)

end

function SeePicController:onQuit(parameters)

end

return SeePicController
