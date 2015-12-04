
local BGColors = {
    cc.c3b(255,225, 92),
    cc.c3b(92, 192, 255),
    cc.c3b(255,202, 247)
}

local CitySelectionView = class("CitySelectionView", function()
    return display.newLayer()
end)

function CitySelectionView:ctor(param)
    -- background
    -- self._background = display.newSprite("ui/image/city_ball_view_background.png")
    -- self._background:setPosition(cc.p(display.width/2, display.height/2))

    self._background = ccui.Layout:create()

    self:createBG()

    -- self._background:setBackGroundColorType(2)
    -- self._background:setBackGroundColorVector(cc.p(1, 0))   
    -- self._background:setBackGroundColor( cc.c3b(255,225, 92), cc.c3b(69,255, 242))
    -- self._background:setBackGroundColorOpacity(255)

    self._background:setContentSize(cc.size(display.width , display.height))
    -- self._background:setScale(2)
    self:addChild(self._background, 1)
    local backSize = self._background:getBoundingBox()
    -- print("11111111111111111")
    -- print_r(backSize)
    -- self._background:setPosition(cc.p(backSize.width/2 , display.height/2))
    self._background:setPosition(cc.p(0 , 0))
    self.backSize = backSize

    -- local widthD = (backSize.width - display.width)/

    -- city balls group
    -- self._cityBallsNode = display.newNode()
    -- self._cityBallsNode:setPosition(cc.p(display.width / 2, display.height / 2))
    -- self:addChild(self._cityBallsNode, 1)
    -- self._recentSnapPosition = cc.p(self._cityBallsNode:getPosition())


    self:createUI()

    -- menu layer
    -- self._menuLayer = require("app/views/MenuLayer").new()
    -- self:addChild(self._menuLayer, 2)
-- print("1111111111111111111111")
    -- middle navigation buttons
    -- self:_createMiddleNavButtons()
-- print("222222222222222222222")
    -- init gesture
    -- self:_initEvents()
-- print("3333333333333333333")
    self._accumulatedDeltaX = 0
    self._elasticFactor = 1.0

    -- self._menuLayer:setVisible(false)
end

function CitySelectionView:createBG(  )
    local layerCount = #BGColors - 1

    self.bgLayers = {}
    local layerWidth = display.width/layerCount 
    for i = 1, layerCount do
        local bgLayer = ccui.Layout:create()

        bgLayer:setBackGroundColorType(2)
        bgLayer:setBackGroundColorVector(cc.p(1, 0))   
        bgLayer:setBackGroundColor( BGColors[i], BGColors[i+1])
        bgLayer:setBackGroundColorOpacity(255)

        bgLayer:addTo(self._background)

        self.bgLayers[i] = bgLayer

        bgLayer:setContentSize(cc.size( layerWidth , display.height))
        bgLayer:setPosition(cc.p((i-1) * layerWidth, 0) )

    end
end

function CitySelectionView:setBGSize(  )

    local groundWidth = display.width * #self.cityDatas
    local layerWidth = groundWidth/(#self.bgLayers ) 

    -- print("宽度分别是。。。。", groundWidth, layerWidth)
    self._background:setContentSize(cc.size(groundWidth, display.height))

    for k, bgLayer in pairs(self.bgLayers) do
        bgLayer:setContentSize(cc.size(layerWidth, display.height))
        bgLayer:setPosition(cc.p((k-1) * (layerWidth) , 0) )
    end
end

function CitySelectionView:createUI(  )
    -- local tvLayer = ccui.Layout:create()
    -- tvLayer:setContentSize(cc.size(1080, 1080))
    -- tvLayer:setPosition(cc.p(0, (display.height-1080)/2))
    -- -- tvLayer:addTo(self)
    -- self:addChild(tvLayer, 3)
    -- self.tvLayer = tvLayer

    local pv = ccui.PageView:create()
    pv:setContentSize(cc.size(display.width, display.height))
    pv:setPosition(cc.p(0, 0))
    self:addChild(pv, 2)
    pv:setCustomScrollThreshold(10)
    self.pv = pv

    self.pv:addEventListener(function(sender, event)

        local index = sender:getCurPageIndex() 
        local page = sender:getPage(index)
        local cellBall = page:getChildByName("cellBall")
        local backGround = cellBall:getChildByName"backGround"
        local spBall = backGround:getChildByName"spBall"

        local ballImage = self.cityDatas[index+1].cityData:getCityBallImage()
        spBall:setTexture(ballImage)



        -- if index == 0 then
        --     self._previousButton:setVisible(false)
        --     self._nextButton:setVisible(true)
        -- elseif index == #self.cityDatas-1 then
        --     self._previousButton:setVisible(true)
        --     self._nextButton:setVisible(false)
        -- else
        --     self._previousButton:setVisible(true)
        --     self._nextButton:setVisible(true)
        -- end

        local backSize = self._background:getBoundingBox()

        -- print("背景的大小。。。。。。。。。")
        -- print_r(backSize)
        if #self.cityDatas == 0 then return end
        local offsetWidth = (backSize.width - display.width)/#self.cityDatas
        -- if self.actionBG then
            self._background:stopActionByTag(101)
        -- end

        local move1 = cc.MoveTo:create(0.4, cc.p( - display.width*index, 0))
        local cb = cc.CallFunc:create(function (  )
            local x,y = self._background:getPosition()
            if x > self.backSize.width/2  then
                self._background:setPosition(0, 0)
            end
        end)
        local seq = cc.Sequence:create(move1, cb)
        seq:setTag(101)
        self._background:runAction(seq)

    end)
end

function CitySelectionView:setPVEnable( isEnable )
    if self and self.pv then
        self.pv:setEnabled(isEnable)
    end
end

function CitySelectionView:createBall( cityDatas , index)
    -- dump(cityDatas)
    local pvSize = self.pv:getContentSize()
    self.cityDatas = cityDatas

    self:setBGSize()

    -- self._background:setContentSize(cc.size(display.width * #cityDatas, display.height))

    self.ballList = {}
    for k,cityData in pairs(cityDatas) do
        -- print(k,v)

        local cellBall = cc.uiloader:load("ui/cityBall.csb")
        cellBall:setPosition(cc.p(pvSize.width/2,pvSize.height/2))

        -- cellBall:setVisible(false)
        local pageCell = cellBall:getChildByName"pageCell"
        local spCloud = pageCell:getChildByName"spCloud"
        self:setBallData(cellBall, cityData.cityData)
        pageCell:setContentSize(cc.size(pvSize.width, pvSize.height))

        local spSize = spCloud:getContentSize()
        local sW = pvSize.width/spSize.width
        local sH = pvSize.height/spSize.height
        local scale =  sW > sH and sW or sH 
        spCloud:setScale(scale)

        local item = ccui.Layout:create()
        item:setContentSize(cc.size(pvSize.width, pvSize.height))
        cellBall:addTo(item)
        cellBall:setName("cellBall")
        self.pv:addPage(item)

        local cityID = cityData.cityData:getCityId()
        self.ballList[cityID] = cellBall
    end
    self.pv:scrollToPage(index-1)
end

function CitySelectionView:setBallData( cellBall, cityData )
    -- body
    -- dump(cityData)
    
    local backGround = cellBall:getChildByName"backGround"
    local spBall = backGround:getChildByName"spBall"
    local txtCityName = backGround:getChildByName"txtCityName"
    local btnBack = backGround:getChildByName"btnBack"
    local spBtn = btnBack:getChildByName"spBtn"
    local waitting2 = backGround:getChildByName"waitting2"
    local waitting = backGround:getChildByName"waitting"
    local txtNum = waitting:getChildByName"txtNum"

    -- local cityName = cityData:getDisplayName()
    local cityName = cityData:getShowName()
    txtCityName:setString(cityName)
    local ballImage = cityData:getCityBallImage()
    spBall:setTexture(ballImage)
    local r1 = cc.RotateBy:create(1, 10)
    local act = cc.RepeatForever:create(r1)
    spBall:runAction(act)

    local action = cc.CSLoader:createTimeline("ui/dlWaittingNode.csb");   
    waitting:runAction(action);   
    action:gotoFrameAndPlay(0, 60, true);
    waitting:setVisible(false)

    local action2 = cc.CSLoader:createTimeline("ui/dlWaittingNode2.csb");   
    waitting2:runAction(action2);   
    action2:gotoFrameAndPlay(0, 55, true);
    waitting2:setVisible(false)

    local ballState = cityData:getCityBallState1()
    if type(ballState) == "number" then
        btnBack:setVisible(false)
        waitting2:setVisible(false)
        waitting:setVisible(true)

        txtNum:setString(ballState.."%")
    else
        btnBack:setVisible(true)
        waitting2:setVisible(false)
        waitting:setVisible(false)
        if ballState == "Undownloaded" then
            spBtn:setTexture("ui/image/city_ball_button_download.png")
        elseif ballState == "Downloaded" then
            spBtn:setTexture("ui/image/city_ball_button_start.png")
        elseif ballState == "Update" then
            spBtn:setTexture("ui/image/city_ball_button_update.png")
        else
            print(" no state ")
        end
    end

    local cityIDTemp = cityData:getCityId()
    btnBack:addTouchEventListener(function(sender, event)
        print("CitySelectionView:setBallData", event)
        if event == 2 then
            self._delegate:onBtnCommand(cityIDTemp)
        end
    end)
end

function CitySelectionView:downloadCity( cityID )
    local cellBall = self.ballList[cityID] 
    if cellBall then
        local a1 = cc.TintTo:create(0.5, 98,98,98)
        -- cellBall:runAction(a1)

        local backGround = cellBall:getChildByName"backGround"
        local spBall = backGround:getChildByName"spBall"
        local btnBack = backGround:getChildByName"btnBack"
        local waitting2 = backGround:getChildByName"waitting2"
        local waitting = backGround:getChildByName"waitting"
        local txtNum = waitting:getChildByName"txtNum"
        spBall:runAction(a1)
        btnBack:setVisible(false)
        waitting2:setVisible(false)
        waitting:setVisible(true)
        txtNum:setString("0%")
    end
end

function CitySelectionView:downloading( cityID , percent)
    local cellBall = self.ballList[cityID] 
    if cellBall then
        local backGround = cellBall:getChildByName"backGround"
        local btnBack = backGround:getChildByName"btnBack"
        local waitting2 = backGround:getChildByName"waitting2"
        local waitting = backGround:getChildByName"waitting"
        local txtNum = waitting:getChildByName"txtNum"
        btnBack:setVisible(false)
        waitting2:setVisible(false)
        waitting:setVisible(true)
        txtNum:setString(percent.."%")
    end
end

function CitySelectionView:beganning( cityID )
    local cellBall = self.ballList[cityID] 
    if cellBall then
        self:setPVEnable(false)

        local a1 = cc.TintTo:create(0.5, 98,98,98)
        -- cellBall:runAction(a1)
        local backGround = cellBall:getChildByName"backGround"
        local spBall = backGround:getChildByName"spBall"
        local btnBack = backGround:getChildByName"btnBack"
        local waitting2 = backGround:getChildByName"waitting2"
        local waitting = backGround:getChildByName"waitting"
        local txtNum = waitting:getChildByName"txtNum"
        spBall:runAction(a1)
        btnBack:setVisible(false)
        waitting2:setVisible(true)
        waitting:setVisible(false)

    end
end

function CitySelectionView:downloadCompleted( cityID )
    local cellBall = self.ballList[cityID] 
    if cellBall then
        local a1 = cc.TintTo:create(0.5, 255,255,255)
        -- cellBall:runAction(a1)
        local backGround = cellBall:getChildByName"backGround"
        local spBall = backGround:getChildByName"spBall"
        local btnBack = backGround:getChildByName"btnBack"
        local waitting2 = backGround:getChildByName"waitting2"
        local waitting = backGround:getChildByName"waitting"
        local txtNum = waitting:getChildByName"txtNum"
        local spBtn = btnBack:getChildByName"spBtn"
        spBall:runAction(a1)
        btnBack:setVisible(true)
        spBtn:setTexture("ui/image/city_ball_button_start.png")
        waitting2:setVisible(false)
        waitting:setVisible(false)

    end
end

function CitySelectionView:setBallDownLoad( cityID )
    local cellBall = self.ballList[cityID] 
    if cellBall then
        local a1 = cc.TintTo:create(0.5, 255,255,255)
        -- cellBall:runAction(a1)
        local backGround = cellBall:getChildByName"backGround"
        local spBall = backGround:getChildByName"spBall"
        local btnBack = backGround:getChildByName"btnBack"
        local waitting2 = backGround:getChildByName"waitting2"
        local waitting = backGround:getChildByName"waitting"
        local txtNum = waitting:getChildByName"txtNum"
        local spBtn = btnBack:getChildByName"spBtn"
        spBall:runAction(a1)
        btnBack:setVisible(true)
        spBtn:setTexture("ui/image/city_ball_button_download.png")
        waitting2:setVisible(false)
        waitting:setVisible(false)
    end
end

function CitySelectionView:setBallUpdate( cityID )
    local cellBall = self.ballList[cityID] 
    if cellBall then
        local a1 = cc.TintTo:create(0.5, 255,255,255)
        -- cellBall:runAction(a1)
        local backGround = cellBall:getChildByName"backGround"
        local spBall = backGround:getChildByName"spBall"
        local btnBack = backGround:getChildByName"btnBack"
        local waitting2 = backGround:getChildByName"waitting2"
        local waitting = backGround:getChildByName"waitting"
        local txtNum = waitting:getChildByName"txtNum"
        local spBtn = btnBack:getChildByName"spBtn"
        spBall:runAction(a1)
        btnBack:setVisible(true)
        spBtn:setTexture("ui/image/city_ball_button_update.png")
        waitting2:setVisible(false)
        waitting:setVisible(false)
    end
end

function CitySelectionView:setCityCount( cityCount , cityIndex)
    local backSize = self._background:getBoundingBox()
    self.widthD = (backSize.width - display.width)/cityCount
    self.cityCount = cityCount

    -- self._background:setPosition(cc.p(backSize.width/2 - self.widthD * (cityIndex-1), display.height/2))
end

function CitySelectionView:setDelegate(delegate)
    self._delegate = delegate
    -- self._menuLayer:setDelegate(delegate)
end

function CitySelectionView:setBallSprite(strCityID, imagePath )
    -- print("into CitySelectionView:setBallSprite", strCityID)
    if self._cityBallsCache[strCityID] then
        -- print("设置路径。。。。CitySelectionView:setBallSprite", imagePath)
        self._cityBallsCache[strCityID]:setBallSprite(imagePath)
    end
end

------ menu
function CitySelectionView:menuEnterForController(controllerName, animated, menuEnteredCallback)
    self._menuLayer:menuEnterForController(controllerName, animated, menuEnteredCallback)
end

function CitySelectionView:updateCityBall( strCityID, newState)
    if self._cityBallsCache[strCityID] then
        self._cityBallsCache[strCityID]:update(newState)
    end
end

function CitySelectionView:setBallDark( strCityID, isDark )
    if self._cityBallsCache[strCityID] then
        self._cityBallsCache[strCityID]:setDark(isDark)
    end
end

function CitySelectionView:updateCurrentCityBall(cityID, newState)
    self._cityBallsCache[self._currentBallKey]:update(newState)
end

function CitySelectionView:updatePreviousCityBall(newState)
    self._cityBallsCache[self._currentBallKey]:update(newState)
end

function CitySelectionView:updateNextCityBall(newState)
    self._cityBallsCache[self._currentBallKey]:update(newState)
end

------ city ball
function CitySelectionView:_createCurrentCityBall(param)
    self._currentBallKey = param.key
    local ball = self:_cacheCityBall(param)
    ball:setDelegate(self._delegate)
    ball:addTo(self._cityBallsNode)
end


-- 初始化小球界面
function CitySelectionView:createCurrentCityBall()
    local param = self._delegate:getParamForCurrentCityBall()
    -- dump(param)
    if param then
        self:_createCurrentCityBall(param)
        if param.position == "first" then
            -- print("this ball is first.....")
            self._previousButton:setVisible(false)
            self._nextButton:setVisible(true)
        elseif param.position == "last" then
            -- print("this ball is last.....")
            self._previousButton:setVisible(true)
            self._nextButton:setVisible(false)
        else
            -- print("this ball is center.....")
            self._previousButton:setVisible(true)
            self._nextButton:setVisible(true)
        end
    end
end

function CitySelectionView:cacheNavigation()
    self:_cachePreviousBall(true)
    self:_cacheNextBall(true)
end

-- 创建小球
function CitySelectionView:_createCityBall(ballImage, ballState, cityName, cityID)

    self._delegate:createCityBallFile(cityID)
    self._CityBallClass = self._CityBallClass or require("app/views/CityBall")
    local cityBall = self._CityBallClass.new(ballImage, ballState, cityName)
    -- local cityBall = require("app/views/CityBall").new(ballImage, ballState)
    return cityBall
end

function CitySelectionView:_cacheCityBall(param)

    self._cityBallsCache = self._cityBallsCache or {}

    if not self._cityBallsCache[param.key] then
        local cityBall = self:_createCityBall(param.ballImage, param.ballState, param.cityName, tonumber(param.key))
        self._cityBallsCache[param.key] = cityBall
        cityBall:setDelegate(self._delegate)
    end

    return self._cityBallsCache[param.key]
end

function CitySelectionView:_cachePreviousBall(isInit)

    local param = self._delegate:getParamForPreviousCityBall()

    if param then
        local previousBall = self:_cacheCityBall(param)
        local x, y = self._cityBallsCache[self._currentBallKey]:getPosition()
        previousBall:setPosition(cc.p(x - display.width, y))
        previousBall:addTo(self._cityBallsNode)
        self._previousBallKey = param.key
        self._previousButtonEnabled = true

        if not isInit then
            self._previousButton:setVisible(true)
            self._nextButton:setVisible(true)
        end

    else
        if not isInit then
            self._previousButton:setVisible(false)
        end
        self._previousButton:setButtonEnabled(false)
        self._previousButtonEnabled = false
        self._previousBallKey = nil
    end
end

function CitySelectionView:_cacheNextBall(isInit)

    local param = self._delegate:getParamForNextCityBall()
    if param then
        local nextBall = self:_cacheCityBall(param)
        local x, y = self._cityBallsCache[self._currentBallKey]:getPosition()
        nextBall:setPosition(cc.p(x + display.width, y))
        nextBall:addTo(self._cityBallsNode)
        self._nextBallKey = param.key
        self._nextButtonEnabled = true

        if not isInit then
            self._previousButton:setVisible(true)
            self._nextButton:setVisible(true)
        end

    else
        if not isInit then
            self._nextButton:setVisible(false)
        end
        self._nextButton:setButtonEnabled(false)
        self._nextButtonEnabled = false
        self._nextBallKey = nil
    end
end

-- 滑动到前一个，事件响应
function CitySelectionView:_animateToPreviousDone()
    -- signal delegate
    self._delegate:didMoveToPrevious()

    -- remove next ball
    if self._nextBallKey then
        self._cityBallsCache[self._nextBallKey]:removeFromParent()
        self._cityBallsCache[self._nextBallKey] = nil
    end

    -- update next, current
    self._nextBallKey = self._currentBallKey
    self._currentBallKey = self._previousBallKey

    -- update menu
    self._menuLayer:setLocationLabelString("cityName", self._delegate:getValueForMenuLabelWithName("cityName"))

    -- cache new previous
    self:_cachePreviousBall()

    -- save position
    self._recentSnapPosition = cc.p(self._cityBallsNode:getPosition())

    -- set flags
    self._accumulatedDeltaX = 0
    self._ballsNodeMoveAnimationInProgress = false
    self._nextButton:setButtonEnabled(true)
    self._nextButtonEnabled = true
    self._gestureRecognizer:setEnabled(true)

    
end

-- 滑动到下一个，事件响应
function CitySelectionView:_animateToNextDone()
    -- signal delegate
    self._delegate:didMoveToNext()

    -- remove previous ball
    if self._previousBallKey then
        self._cityBallsCache[self._previousBallKey]:removeFromParent()
        self._cityBallsCache[self._previousBallKey] = nil
    end

    -- update previous, current
    self._previousBallKey = self._currentBallKey
    self._currentBallKey = self._nextBallKey

    -- update menu
    self._menuLayer:setLocationLabelString("cityName", self._delegate:getValueForMenuLabelWithName("cityName"))

    -- cache new next
    self:_cacheNextBall()

    -- save position
    self._recentSnapPosition = cc.p(self._cityBallsNode:getPosition())

    -- set flags
    self._accumulatedDeltaX = 0
    self._ballsNodeMoveAnimationInProgress = false
    self._previousButton:setButtonEnabled(true)
    self._previousButtonEnabled = true
    self._gestureRecognizer:setEnabled(true)
end

function CitySelectionView:_animateNode(node, horizontalMoveDelta, callback)
    if not self._ballsNodeMoveAnimationInProgress then
        self._ballsNodeMoveAnimationInProgress = true
        self._gestureRecognizer:setEnabled(false)
        local move = cc.MoveBy:create(0.4, cc.p(horizontalMoveDelta, 0))
        local easeMove = cc.EaseSineInOut:create(move)
        local done = cc.CallFunc:create(callback)
        node:runAction(cc.Sequence:create(easeMove, done))


    end
end

function CitySelectionView:_animateCityBallsNode(direction)
    if direction == "Previous" then
        self:_animateNode(self._cityBallsNode, display.width, handler(self, self._animateToPreviousDone))
    elseif direction == "Next" then
        self:_animateNode(self._cityBallsNode, -display.width, handler(self, self._animateToNextDone))
    end
end

function CitySelectionView:debug()
    printf("----------------=============----------------")
    printf("previous key: %s", self._previousBallKey or "nil")
    printf("current key: %s", self._currentBallKey or "nil")
    printf("next key: %s", self._nextBallKey or "nil")
    dump(self._cityBallsCache)
    printf("----------------=====end=====----------------\n\n")
end

function CitySelectionView:navigateToPreviousBall()
    -- self:_animateCityBallsNode("Previous")

    -- local move = cc.MoveBy:create(0.4, cc.p(self.widthD, 0))
    -- -- self._background:runAction(move)

    -- local cb = cc.CallFunc:create(function (  )
    --     local x,y = self._background:getPosition()
    --     if x > self.backSize.width/2  then
    --         self._background:setPosition(self.backSize.width/2, display.height/2)
    --     end
    -- end)
    -- self._background:runAction(cc.Sequence:create(move, cb))

    local index = self.pv:getCurPageIndex() 
    if index > 1 then
        self.pv:scrollToPage(index-1)
    end
end

function CitySelectionView:navigateToNextBall()
    -- self:_animateCityBallsNode("Next")

    -- local move = cc.MoveBy:create(0.4, cc.p(-self.widthD, 0))
    -- -- self._background:runAction(move)

    -- local cb = cc.CallFunc:create(function (  )
    --     local x,y = self._background:getPosition()
    --     -- print(x, self.backSize.width/2)
    --     if x < self.backSize.width/2 - self.widthD*self.cityCount then
    --         self._background:setPosition(self.backSize.width/2 - self.widthD*self.cityCount, display.height/2)
    --     end
    -- end)
    -- self._background:runAction(cc.Sequence:create(move, cb))
    local index = self.pv:getCurPageIndex() 
    if index < #self.cityDatas-1 then
        self.pv:scrollToPage(index+1)
    end

end

------ top, bottom menu
function CitySelectionView:menuQuit()
    if self._menuLayer then
        self._menuLayer:menuQuit(animated)
    end
end

function CitySelectionView:menuEnterForController(controllerName, animated)
    if self._menuLayer then
        self._menuLayer:menuEnterForController(controllerName, animated)
    end
end

function CitySelectionView:switchToMenuForController(controllerName, animated)
    self._menuLayer:switchToMenuForController(controllerName, animated)
end

function CitySelectionView:setMenuButtonsEnabled(buttonNames, enabled)
    for k, buttonName in pairs(buttonNames) do
        self._menuLayer:setButtonEnabled(buttonName, enabled)
    end
end

------ middle nav buttons
function CitySelectionView:_createButton(normalImage, pressedImage)

    local buttonStateImages = {}
    buttonStateImages.normal = normalImage
    buttonStateImages.pressed = pressedImage
    -- buttonStateImages.disabled = normalImage
    
    return cc.ui.UIPushButton.new(buttonStateImages, {scale9 = true})
end

function CitySelectionView:_createMiddleNavButtons()
    self._previousButton = self:_createButton("ui/image/city_ball_next.png", "ui/image/city_ball_next.png")
    self._previousButton:setScale(0.7)
    self._previousButton:onButtonClicked(function(event)
        -- if not self._ballsNodeMoveAnimationInProgress and self._previousButtonEnabled then
        print("btn prev........")
            self._delegate:tappedPreviousButton()
        -- end
    end)
    -- self._previousButton:addEventListener("PRESSED_EVENT", function(event)
    --     if not self._ballsNodeMoveAnimationInProgress and self._previousButtonEnabled then
    --         self._delegate:tappedPreviousButton()
    --     end
    -- end)
    -- self._previousButton:addEventListener("RELEASE_EVENT", function(event)
    --     if not self._ballsNodeMoveAnimationInProgress and self._previousButtonEnabled then
    --         self._delegate:tappedPreviousButton()
    --     end
    -- end)

    self._nextButton = self:_createButton("ui/image/city_ball_next.png", "ui/image/city_ball_next.png")
    self._nextButton:setScale(0.7)
    self._nextButton:setRotation(180)
    self._nextButton:onButtonClicked(function(event)
        -- if not self._ballsNodeMoveAnimationInProgress and self._nextButtonEnabled then
        print("btn next........")
            self._delegate:tappedNextButton()
        -- end
    end)

    local horizontalOffset = 50
    self._previousButton:setPosition(cc.p(horizontalOffset, display.height / 2))
    self._nextButton:setPosition(cc.p(display.width - horizontalOffset, display.height / 2))

    -- self._previousButton:setVisible(false)
    -- self._nextButton:setVisible(false)

    self:addChild(self._previousButton, 3)
    self:addChild(self._nextButton, 3)
end

------ touch handler
function CitySelectionView:setGestureRecognitionEnabled(enabled)
    -- self._gestureRecognizer:setEnabled(enabled)
end

function CitySelectionView:_initEvents()
    self._gestureRecognizer = qm.GestureRecognizer:create()
    self._gestureRecognizer:addGestureBeganCallback(handler(self, self._gestureBegan))
    self._gestureRecognizer:addSingleTapCallback(handler(self, self._gestureTap))
    self._gestureRecognizer:addPanCallback(handler(self, self._slideScreen))
    self._gestureRecognizer:addPanEndedCallback(handler(self, self._slideScreenEnded))
    self._gestureRecognizer:applyToNode(self)
    self._gestureRecognizer:addTo(self)
end

function CitySelectionView:_gestureBegan()
    if self._ballsNodeMoveAnimationInProgress then
        self._cityBallsNode:stopActionByTag(600)
        self._ballsNodeMoveAnimationInProgress = false
    end

    local x, y = self._cityBallsNode:getPosition()
    self._accumulatedDeltaX = (x - self._recentSnapPosition.x) / self._elasticFactor
end

function CitySelectionView:_gestureTap()
    self:_slideScreenEnded(0, 0)
end

function CitySelectionView:_slideScreen(deltaX, deltaY)

    self._accumulatedDeltaX = self._accumulatedDeltaX + deltaX
    local factor = display.width * 2

    if self._accumulatedDeltaX >= 0 then -- move right way
        if self._previousBallKey then
            self._elasticFactor = 1.0
        else
            self._elasticFactor = (1.0 - self._accumulatedDeltaX / factor) * 0.4
        end
    else
        if self._nextBallKey then
            self._elasticFactor = 1.0
        else
            self._elasticFactor = (1.0 + self._accumulatedDeltaX / factor) * 0.4
        end
    end

    local realMoveDeltaX = self._elasticFactor * self._accumulatedDeltaX

    local newPosition = cc.p(self._recentSnapPosition.x + realMoveDeltaX, self._recentSnapPosition.y)

    self._cityBallsNode:setPosition(newPosition)
end

function CitySelectionView:_slideScreenEnded(vX, vY)

    local animationMoveToX
    local callback = nil
    local needAnimation = true
    local backMove = false

    -- print(vX, "11111111111111111111")
    if vX < -15 and self._nextBallKey then
        animationMoveToX = self._recentSnapPosition.x - display.width
        callback = handler(self, self._animateToNextDone)
        backMove = true
        -- print(vX, "22222222222222222222", animationMoveToX)
    elseif vX > 15 and self._previousBallKey then
        animationMoveToX = self._recentSnapPosition.x + display.width
        callback = handler(self, self._animateToPreviousDone)
        backMove = true
        -- print(vX, "333333333333333333333333", animationMoveToX)
    else
        local x, y = self._cityBallsNode:getPosition()
        local realMoveDeltaX = x - self._recentSnapPosition.x
        local threhold = display.width / 2
        
        if realMoveDeltaX == 0 then
            needAnimation = false

        elseif realMoveDeltaX >= threhold then
            animationMoveToX = self._recentSnapPosition.x + display.width
            callback = handler(self, self._animateToPreviousDone)
            backMove = true
        elseif realMoveDeltaX > -threhold then
            animationMoveToX = self._recentSnapPosition.x
            callback = handler(self, self._animateToCurrentDone)

            backMove = false

        else
            animationMoveToX = self._recentSnapPosition.x - display.width
            callback = handler(self, self._animateToNextDone)
            backMove = true
        end
    end

    if needAnimation then
        self._ballsNodeMoveAnimationInProgress = true
        local time = 0.3
        local move = cc.MoveTo:create(time, cc.p(animationMoveToX, self._recentSnapPosition.y))
        local easeMove = cc.EaseSineOut:create(move)
        local sequence = cc.Sequence:create(easeMove, cc.CallFunc:create(callback))
        sequence:setTag(600)
        self._cityBallsNode:runAction(sequence)

        if backMove then
            if vX > 0 then
                local move1 = cc.MoveBy:create(0.4, cc.p(self.widthD, 0))
                local cb = cc.CallFunc:create(function (  )
                    local x,y = self._background:getPosition()
                    if x > self.backSize.width/2  then
                        self._background:setPosition(self.backSize.width/2, display.height/2)
                    end
                end)
                self._background:runAction(cc.Sequence:create(move1, cb))
            else
                local move1 = cc.MoveBy:create(0.4, cc.p(-self.widthD, 0))
                local cb = cc.CallFunc:create(function (  )
                    local x,y = self._background:getPosition()
                    -- print(x, self.backSize.width/2)
                    if x < self.backSize.width/2 - self.widthD*self.cityCount then
                        self._background:setPosition(self.backSize.width/2 - self.widthD*self.cityCount, display.height/2)
                    end
                end)
                self._background:runAction(cc.Sequence:create(move1, cb))
            end
        end
        
    end
end

function CitySelectionView:_animateToCurrentDone()
    self._accumulatedDeltaX = 0
    self._ballsNodeMoveAnimationInProgress = false
end

function CitySelectionView:_snapToNearest()
    -- body
end

return CitySelectionView
