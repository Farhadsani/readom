
local MenuLayer = class("MenuLayer", function()
    return display.newLayer()
end)

function MenuLayer:ctor()
    -- menu consists of top and bottom bars
    local csbMenuBarPathName = "ui/menu/menuBar.csb"
    self._topBar = cc.uiloader:load("ui/menu/topMenuBar.csb")
    self._bottomBar = cc.uiloader:load(csbMenuBarPathName)
    self._suspendBar = cc.uiloader:load("ui/menu/suspendMenuLayer.csb")
    self._barPanelName = "barPanel"
    
    -- layout top, bottom bar
    self._topBar:addTo(self)
    self._bottomBar:addTo(self)
    self._suspendBar:addTo(self)
    self:_setMenuBarsInScreenPosition()

    -- enable touch pass to underlayer
    self:setTouchSwallowEnabled(false)
end

function MenuLayer:_setMenuBarsInScreenPosition()
    self._bottomBar:setPosition(cc.p(0, 0))
    self._barHeight = self._topBar:getChildByName(self._barPanelName):getContentSize().height
    self._topBar:setPosition(cc.p(0, display.height - self._barHeight)) -- 70 or some other value: phone top status bar height
end

function MenuLayer:setDelegate(delegate)
    self._delegate = delegate
end

function MenuLayer:setParentView(view)
    self._parentView = view
end

function MenuLayer:setSuspendVisible( isVisible )
    if self._suspendBar then
        self._suspendBar:setVisible(isVisible)
    end
end

------ menu animation
function MenuLayer:_executeQuitAnimation()
    self._quitOrEnterAnimationInProgress = true

    self._topBarQuitAnimationDone = false
    self:_animateMenuBarMoveTo(self._topBar, cc.p(0, display.height), handler(self, self._topBarQuitDone))

    self._bottomBarQuitAnimationDone = false
    self:_animateMenuBarMoveTo(self._bottomBar, cc.p(0, -self._barHeight), handler(self, self._bottomBarQuitDone))
end

function MenuLayer:_executeEnterAnimation()
    self._quitOrEnterAnimationInProgress = true

    self._topBarEnterAnimationDone = false
    self:_animateMenuBarMoveTo(self._topBar, cc.p(0, display.height-self._barHeight), handler(self, self._topBarEnterDone))

    self._bottomBarEnterAnimationDone = false
    self:_animateMenuBarMoveTo(self._bottomBar, cc.p(0, 0), handler(self, self._bottomBarEnterDone))
end

function MenuLayer:_animateMenuBarMoveTo(menuBar, toPoint, callback)
    local moveTo = cc.MoveTo:create(0.5, toPoint)
    local easeMove = cc.EaseSineInOut:create(moveTo)
    local action = cca.seq({easeMove, cca.callFunc(callback)})
    menuBar:runAction(action)
end

function MenuLayer:_topBarQuitDone()
    self._topBarQuitAnimationDone = true
    self:_quitDoneSync()
end

function MenuLayer:_bottomBarQuitDone()
    self._bottomBarQuitAnimationDone = true
    self:_quitDoneSync()
end

function MenuLayer:_removeAllItems()
    if self._buttons then
        for k, node in pairs(self._buttons) do
            node:removeFromParent()
        end
        self._buttons = nil
    end

    if self._locationLabels then
        for k, node in pairs(self._locationLabels) do
            node:removeFromParent()
        end
        self._locationLabels = nil
    end

    if self._customizedWidgets then
        for k, node in pairs(self._customizedWidgets) do
            node:removeFromParent()
        end
        self._customizedWidgets = nil
    end
end

function MenuLayer:_quitDoneSync()
    if self._topBarQuitAnimationDone and self._bottomBarQuitAnimationDone then
        self:_removeAllItems()
        self._quitOrEnterAnimationInProgress = false
        if self._quitFollowedByEnterAnimation then
            self:_assemblyMenuItemsForController(self._newControllerName)
            self:_executeEnterAnimation()
            self._quitFollowedByEnterAnimation = false
        end
    end
end

function MenuLayer:_topBarEnterDone()
    self._topBarEnterAnimationDone = true
    self:_enterDoneSync()
end

function MenuLayer:_bottomBarEnterDone()
    self._bottomBarEnterAnimationDone = true
    self:_enterDoneSync()
end

function MenuLayer:_enterDoneSync()
    if self._topBarEnterAnimationDone and self._bottomBarEnterAnimationDone then
        self:_executeEnteredCallback()
        self._quitOrEnterAnimationInProgress = false
    end
end

function MenuLayer:_menuQuit(animated)
    if animated then
        self:_executeQuitAnimation()
    else
        self:_topBarQuitDone()
        self:_bottomBarQuitDone()
    end
end

function MenuLayer:_executeEnteredCallback()
    if self._enteredCallback then
        self._enteredCallback()
        self._enteredCallback = nil
    end
end

function MenuLayer:_menuEnter(animated)
    if animated then
        if self._quitOrEnterAnimationInProgress then
            self._quitFollowedByEnterAnimation = true
        else
            self:_assemblyMenuItemsForController(self._newControllerName)
            self:_executeEnterAnimation()
        end
    else
        self:_assemblyMenuItemsForController(self._newControllerName)
        self:_setMenuBarsInScreenPosition()
        self:_executeEnteredCallback()
    end
end

------ public methods
function MenuLayer:menuQuit(animated)
    self:_menuQuit(animated)
end

function MenuLayer:menuEnterForController(controllerName, animated, enteredCallback)
    if controllerName then
        self._newControllerName = controllerName
        self._enteredCallback = enteredCallback
        self:_menuEnter(animated)
    end
end

function MenuLayer:switchToMenuForController(controllerName, animated, enteredCallback)
    if self._currentControllerName ~= controllerName then
        if self._currentControllerName then -- unload current menu item
            self:_menuQuit(animated)
        end
        if controllerName then
            self._newControllerName = controllerName
            self._enteredCallback = enteredCallback
            self:_menuEnter(animated)
        end
    end
end

------ menu contruction
function MenuLayer:_assignMenuItemsToProperValues()
    -- location labels
    if self._locationLabels then
        for labelName, label in pairs(self._locationLabels) do
            self:_setLocationLabelString(label, self._delegate:getValueForMenuLabelWithName(labelName), true)
        end
    end
    -- widgets
    if self._customizedWidgets then
         for name, widget in pairs(self._customizedWidgets) do
            self:_setWidgetToValue(widget, self._delegate:getValueForCustomizedWidgetWithName(name))
        end       
    end

    if self._locationLabels1 then
        for labelName, label in pairs(self._locationLabels1) do
            self:_setLocationLabel1ToValue(label, self._delegate:getValueForMenuLabelWithName(labelName))
        end
    end
end

function MenuLayer:_assemblyMenuItemsForController(controllerName)
    -- load config
    local itemImageBasePath = QMapGlobal.menuDescription.itemImageBasePath
    local config = QMapGlobal.menuDescription.configForViewControllers[controllerName]
    if config == nil then
        printError("no menu config found for controller: %s", controllerName)
        return
    end

    -- top bar
    if config.topBar and next(config.topBar) then
        self:_assemblyBarItems(itemImageBasePath, config.topBar, self._topBar:getChildByName(self._barPanelName))
    else
        -- printError("menu top bar config data missed or corrupted for controller: %s", controllerName)
    end

    -- bottom bar
    if config.bottomBar and next(config.bottomBar) then
        self:_assemblyBarItems(itemImageBasePath, config.bottomBar, self._bottomBar:getChildByName(self._barPanelName))
    else
        -- printError("menu bottom bar config data missed or corrupted for controller: %s", controllerName)
    end

    if config.suspendBar and next(config.suspendBar) then
        self:_assemblyBarItems(itemImageBasePath, config.suspendBar, self._suspendBar:getChildByName(self._barPanelName))
    end

    -- assign menu item with proper values
    self:_assignMenuItemsToProperValues()

    -- update current controller name
    self._currentControllerName = controllerName
    self._newControllerName = nil
end

function MenuLayer:_assemblyBarItems(itemImageBasePath, barConfig, barPanel)
    -- add every items to bar
    for itemPositionName, itemConfig in pairs(barConfig) do

        local item = nil

        if itemConfig.type == "Button" then
            item = self:_createPushButton(itemImageBasePath, itemConfig)

        elseif itemConfig.type == "LocationLabel" then
            item = self:_createLocationLabel(itemConfig)

        elseif itemConfig.type == "LocationLabel1" then
            item = self:_createLocationLabel1(itemConfig)

        elseif itemConfig.type == "CustomizedWidget" then
            item = self:_createCustomizedWidget(itemConfig)

        end
 
        local itemInBarPositionNode = barPanel:getChildByName(itemPositionName)
        local x,y = itemInBarPositionNode:getPosition()
        if itemConfig.varHeight then
            y = y * display.height/1920
        end
        item:setPosition(cc.p(x,y))
        item:addTo(barPanel)

        if itemConfig.disVisible then
            item:setVisible(false)
        end
        -- if following line uncommented, the position nodes deleted and can't found when switching menu
        -- itemInBarPositionNode:removeFromParent()
    end
end

function MenuLayer:_createPushButton(itemImageBasePath, itemConfig)
    local buttonStateImages = {}
    local buttonImageNameHeading = itemImageBasePath .. itemConfig.name

    buttonStateImages.normal = buttonImageNameHeading .. "Normal.png"
    buttonStateImages.pressed = buttonImageNameHeading .. "Press.png"
    buttonStateImages.disabled = buttonImageNameHeading .. "Disable.png"
    
    local pushButton = cc.ui.UIPushButton.new(buttonStateImages, {scale9 = true})
    pushButton:setName(itemConfig.name)
    pushButton:setScale(itemConfig.btnScale or 1.5)
    pushButton:setButtonEnabled(itemConfig.initEnabled)
    pushButton:onButtonClicked(handler(self, self._barButtonClicked))
    --UIButton.PRESSED_EVENT: "PRESSED_EVENT"
    --UIButton.RELEASE_EVENT: "RELEASE_EVENT"
    pushButton:addEventListener("PRESSED_EVENT", handler(self, self._menuButtonPressed))
    pushButton:addEventListener("RELEASE_EVENT", handler(self, self._menuButtonReleased))

    self._buttons = self._buttons or {}
    self._buttons[itemConfig.name] = pushButton
    
    if itemConfig.caption and string.len(itemConfig.caption) > 0 then

        local caption = cc.ui.UILabel.new({ UILabelType = 2, text = itemConfig.caption, size = 30 })
        caption:setName("caption")

        caption:setScale(itemConfig.fontScale or 1)

        if itemConfig.captionPos == "R" then
            caption:align(display.RIGHT_CENTER, 180, 0)
        else
            caption:align(display.TOP_CENTER, 0, itemConfig.fontY or (-80))
        end
        caption:addTo(pushButton)
    end

    return pushButton
end

function MenuLayer:_createLocationLabel(itemConfig)

    local labelNode = cc.uiloader:load(itemConfig.csbFile)

    self._locationLabels = self._locationLabels or {}
    self._locationLabels[itemConfig.name] = labelNode

    return labelNode
end

function MenuLayer:_setLocationLabelString(label, stringValue, updateLayout)
    local textLabel = label:getChildByName("textLabel")
    textLabel:setString(stringValue)
    if updateLayout then
        local boundingBox = label:getCascadeBoundingBox()
        label:setContentSize(cc.size(boundingBox.width, 0))
        label:setAnchorPoint(cc.p(0.5, 0.5))
    end
end

function MenuLayer:setLocationLabelString(labelName, stringValue)
    local label = self._locationLabels[labelName]

    if not label then
        printError("menu layer: no label found with name: %s", labelName)
        return
    end
    self:_setLocationLabelString(label, stringValue, true)
end

function MenuLayer:setButtonEnabled(buttonName, enabled)
    local button = self._buttons[buttonName]
    -- dump(self._buttons)
    if not button then
        print("menu layer: no button found with name: %s", buttonName)
        return
    end

    local buttonCaption = button:getChildByName("caption")
    if buttonCaption then
        if enabled then
            buttonCaption:setOpacity(255)
        else
            buttonCaption:setOpacity(150)
        end
    end

    button:setButtonEnabled(enabled)
end

function MenuLayer:setButtonVisible(buttonName, visible)
    local button = self._buttons[buttonName]
    -- dump(self._buttons)
    if not button then
        print("menu layer: no button found with name: %s", buttonName)
        return
    end

    local buttonCaption = button:getChildByName("caption")
    -- if buttonCaption then
    --     if enabled then
    --         buttonCaption:setOpacity(255)
    --     else
    --         buttonCaption:setOpacity(150)
    --     end
    -- end

    button:setVisible(visible)
end

function MenuLayer:_setWidgetToValue(widget, valueParam)

    local pnlCaption = widget:getChildByName("pnlCaption")
    
    local txtCityName = pnlCaption:getChildByName("txtCityName")
    local pnlImage = pnlCaption:getChildByName("pnlImage")
    local txtuserName = pnlCaption:getChildByName("txtuserName")
    local txtDesc = pnlCaption:getChildByName("txtDesc")

    txtCityName:setString(valueParam.cityname)
    txtuserName:setString(valueParam.username)
    txtDesc:setString(valueParam.desc)
    
    local stencilNode = cc.Sprite:create("ui/image/wBGCircle.png")    --模板 
    stencilNode:setScale(2)
    local clipNode = cc.ClippingNode:create()
    clipNode:setStencil(stencilNode)
    clipNode:setAnchorPoint(0.5, 0.5)
    clipNode:setPosition(cc.p(90 , 90 ))
    clipNode:setAlphaThreshold(0)
    local sp1 = cc.Sprite:create(valueParam.image)
    sp1:addTo(clipNode)
    clipNode:addTo(pnlImage)
end

function MenuLayer:_setLocationLabel1ToValue(widget, valueParam)
    local pnlBG = widget:getChildByName"pnlBG"
    local txtCityName = pnlBG:getChildByName"txtCityName"

    txtCityName:setString(valueParam)

    local posX, posY = widget:getPosition()
    widget:setPosition(cc.p(display.width, posY))

    local size = txtCityName:getContentSize()
    pnlBG:setContentSize(cc.size(size.width + 60, size.height))

    txtCityName:setPosition(cc.p(size.width + 40, size.height/2))
    
end

function MenuLayer:setWidgetValue(widgetName, valueParam)
    
    local widget = self._customizedWidgets[widgetName]
    if not widget then
        printError("menu layer: no customized widget found with name: %s", widgetName or "nil")
        return
    end

    self:_setWidgetToValue(widget, valueParam)
end

function MenuLayer:setLocationLabel1(widgetName, valueParam)
    
    local widget = self._locationLabels1[widgetName]
    if not widget then
        printError("menu layer: no customized widget found with name: %s", widgetName or "nil")
        return
    end

    self:_setLocationLabel1ToValue(widget, valueParam)
end

function MenuLayer:_createCustomizedWidget(itemConfig)

    local customizedNode = cc.uiloader:load(itemConfig.csbFile)

    self._customizedWidgets = self._customizedWidgets or {}
    self._customizedWidgets[itemConfig.name] = customizedNode

    return customizedNode
end

function MenuLayer:_createLocationLabel1(itemConfig)

    local customizedNode = cc.uiloader:load(itemConfig.csbFile)

    self._locationLabels1 = self._locationLabels1 or {}
    self._locationLabels1[itemConfig.name] = customizedNode

    return customizedNode
end

function MenuLayer:_menuButtonPressed()
    if self._parentView then
        self._parentView:setMapGestureRecognitionEnabled(false)
    end
end

function MenuLayer:_menuButtonReleased()
    if self._parentView then
        self._parentView:setMapGestureRecognitionEnabled(true)
    end
end

function MenuLayer:_barButtonClicked(event)
    if not self._quitOrEnterAnimationInProgress then
        self._delegate:tapMenuButtonWithName(event.target:getName())
    end
end

return MenuLayer
