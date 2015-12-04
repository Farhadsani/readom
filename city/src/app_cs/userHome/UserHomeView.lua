
-- UserHomeView.lua 程序启动加载界面
-- add by star 2015.5.6

local UserHomeView = class("UserHomeView", function()
    return display.newLayer()
end)

function UserHomeView:ctor(param)
    -- background
    -- self._background = display.newSprite("ui/LoadLayer.csb")
    -- self._background:setPosition(cc.p(display.width/2, display.height/2))
    -- self._background:setScale(2)

    self._topFillMargin = 0
    self._bottomFillMargin = 0

    -- self:setPosition(cc.p(display.width/2, display.height/2))

    self.rootNode = cc.uiloader:load("ui/UserHome.csb")
    self:addChild(self.rootNode, 1)
    self.mapNode = self.rootNode:getChildByName("mapNode")
    self.mapNode:setPosition(cc.p(display.width/2, display.height/2))

    -- map color background
    self._colorBackgroundTop = cc.LayerColor:create(cc.c4b(255,0,0,0))   --(cc.c3b(52,198,241))
    self:addChild(self._colorBackgroundTop, 10)
    self._colorBackgroundBottom = cc.LayerColor:create(cc.c4b(0,255,0,0))   --(cc.c3b(0,183,238))
    self._colorBackgroundBottom:setContentSize(cc.size(display.width, self._bottomFillMargin))
    self._colorBackgroundBottom:setPosition(cc.p(0, 0))
    self:addChild(self._colorBackgroundBottom, 10)

    
    -- self.rootNode:setVisible(false)
    

    -- self._bgMapMask = cc.LayerColor:create(cc.c4b(0, 0, 0, 0))
    -- -- local mapContentSize = self.rootNode:getContentSize()
    -- -- local maskHeight = mapContentSize.height + (self._topFillMargin + self._bottomFillMargin) * 2
    -- -- self._maskOffsetY = self._bottomFillMargin * 2
    -- self._bgMapMask:setContentSize(cc.size(display.width, display.height))
    -- self._bgMapMask:setAnchorPoint(0, 0)
    -- self._bgMapMask:setPosition(cc.p(0, 0))
    -- -- self.rootNode:addChild(self._bgMapMask, 1)
    -- self._bgMapMask:setVisible(false)
    -- self._bgMapDarkened = false

    self.pnlMove = self.rootNode:getChildByName"pnlMove"
    -- self.pnlMove:setPosition(cc.p(-display.width/2, -display.height/2))

    self.pnlBtn = self.rootNode:getChildByName"pnlBtn"
    -- self.pnlBtn:setPosition(cc.p( 300 , 60))
    self.btnShouye = self.pnlBtn:getChildByName("btnShouye")
    self.btnGuanzhu = self.pnlBtn:getChildByName("btnGuanzhu")

    self.spGuanzhu = self.btnGuanzhu:getChildByName("spGuanzhu")
    self.spShouye = self.btnShouye:getChildByName("spShouye")
    self.txtGuanzhu = self.btnGuanzhu:getChildByName("txtGuanzhu")

    self.pnlMove:setVisible(false)
    self.pnlBtn:setVisible(false)

    self:initUI()

    -- locations mask which is above locations layer
    self._locationsMask = cc.LayerColor:create(cc.c4b(0, 0, 0, 0))
    local mapContentSize = self.spMap:getBoundingBox()             --:getContentSize()
    self._locationsMask:setContentSize(mapContentSize)
    self._locationsMask:setAnchorPoint(cc.p(0, 0))
    self._locationsMask:setPosition(cc.p(0, 0))
    -- self.spMap:addChild(self._locationsMask, 3)
    -- self._locationsMask:setVisible(false)
    self._locationsMask:addTo(self.spMap)
    self._locationsDarkened = false

    local spSize = self.spMap:getContentSize()
    local scaleX = display.width/spSize.width
    local scaleY = display.height/spSize.height

    if scaleX < 1 then scaleX = 1 end
    if scaleY < 1 then scaleY = 1 end
    
    -- self.spMap:setPosition(cc.p(display.width/2, display.height/2))

    local scale =  (scaleX > scaleY ) and scaleX or scaleY
    -- print("scale ", scaleX , scaleY, scale)
    -- print("self.spMap = ", self.spMap:getPosition())
    

    -- self:initTopichot()

    self:initLoginDlg()

    -- self:initEvent()

    self:_calculateZoomLevelScales(3, 2)
    self:_setMapScaleToLevelWithIndex(1, false)
    self:_calculateMapBottomLeftPropertiesAccordingToScale(self.spMap:getScale())
    -- print("self.spMap = ", self.spMap:getPosition())
    -- self.spMap:setPosition(cc.p(display.width/2, display.height/2))
end

function UserHomeView:viewDidLoad( ... )
    -- body
    self:initEvent()
end

function UserHomeView:initLoginDlg( ... )
    self.pnlLoginDlg = self.rootNode:getChildByName"pnlLoginDlg"
    -- self.pnlLoginDlg:setPosition(cc.p(display.width/2, display.height/2))
    local pnlDlgBk = self.pnlLoginDlg:getChildByName"pnlDlgBk"
    local pnlLogin = pnlDlgBk:getChildByName("pnlLogin")
    local pnlCancel = pnlDlgBk:getChildByName("pnlCancel")
    pnlDlgBk:setPosition(cc.p(display.width/2, display.height/2))

    pnlLogin:addTouchEventListener(function ( sender, event )
        if event == 0 then
        elseif event == 1 then
        else   -- if event == 2 then
            print("movw........")
            self._delegate:_login(2)
        end
    end)

    pnlCancel:addTouchEventListener(function ( sender, event )
        if event == 0 then
        elseif event == 1 then
        else   -- if event == 2 then
            self.pnlLoginDlg:setVisible(false)
        end
    end)
end

function UserHomeView:showLoginDlg( isShow )
    if isShow then
        -- self:selectItem(self._portraitstone)
        -- self._selectedScenicSpot = self._stonebase
        -- self:setAllSenicSpotsFlash(false)

        -- self:highLightSelectedScenicSpotSprite(true, true, function (  )
        --     self.pnlLoginDlg:setVisible(isShow)
        -- end)
    else
        -- self._delegate:tappedElseWhere()
        -- self._selectedScenicSpot = nil
        -- self.pnlLoginDlg:setVisible(isShow)
    end
    self.pnlLoginDlg:setVisible(isShow)
end

function UserHomeView:initUI( ... )
    self.spMap = self.rootNode:getChildByName("mapNode"):getChildByName("spMap") 
    print("spMap赋值。。。。。。。。。。。。。。。。。。。", self.spMap)

    self._chest = self.spMap:getChildByName("chest")              -- 宝箱
    self._desirepond = self.spMap:getChildByName("desirepond")    -- 许愿池
    self._bigmouthbird = self.spMap:getChildByName("bigmouthbird") -- 大嘴鸟
    self._dock = self.spMap:getChildByName("dock")   --  码头
    self._hotball = self.spMap:getChildByName("hotball")   -- 热气球
    self._lighthouse = self.spMap:getChildByName("lighthouse")   -- 灯塔
    self._postbox = self.spMap:getChildByName("postbox")     --信箱
    self._stonebase = self.spMap:getChildByName("stonebase")    -- 石头人底座
    self._portraitstone = self.spMap:getChildByName("portraitstone")   -- 石像
    self._aboutstone = self.spMap:getChildByName("aboutstone")

    self.pnlCallout = self.spMap:getChildByName("pnlCallout")
    self.txtCallout = self.pnlCallout:getChildByName("txtCallout")
    self.spCallout = self.pnlCallout:getChildByName("spCallout")
    self.pnlCallout:setVisible(false)

    self.pnlBigMouthBird = self.spMap:getChildByName("pnlBigMouthBird")
    -- self.pnlBigMouthBird:setVisible(true)

    local txtCallout1 = cc.ui.UILabel.new({
            UILabelType = 2,
            text = "",
            font = QMapGlobal.resFile.font.content,
            size = 36, 
            color = cc.c3b(255, 255, 255), -- 使用纯红色
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_BOTTOM,
            dimensions = cc.size(400, 0)
        })
    -- print("--------------------------------")
    -- print_r(txtCallout1)
    txtCallout1:setAnchorPoint(cc.p(0.5,0))
    -- txtCallout1:setPosition(cc.p(self.txtCallout:getPosition()))
    txtCallout1:setPosition(cc.p(140,28 ))
    txtCallout1:addTo(self.pnlCallout)
    self.txtCallout1 = txtCallout1

    self.txtCallout:setVisible(false)
    self.txtCallout1:setVisible(true)
    self.spCallout:setTexture("ui/image/calloutBK2.png")

    self.pnlLoginTip = self.spMap:getChildByName("pnlLoginTip")
    self.spLoginTip = self.pnlLoginTip:getChildByName("spLoginTip")
    self.txtLoginTip = self.pnlLoginTip:getChildByName("txtLoginTip")
    self.pnlLoginTip:setVisible(false)

    self.txtCallout:setFontName(QMapGlobal.resFile.font.content)
    self.txtCallout:setFontSize(36)

    self.txtLoginTip:setFontName(QMapGlobal.resFile.font.content)
    self.txtLoginTip:setFontSize(36)

    self:reSetNodesTable(false, false)

    self._hotball:setVisible(false)
end


function UserHomeView:reSetNodesTable( isLogin, isSelfHome )
    self.nodesTables = {}

    table.insert(self.nodesTables, self._chest)
    table.insert(self.nodesTables, self._desirepond)
    
    table.insert(self.nodesTables, self._dock)
    -- if not isNotAll then
        table.insert(self.nodesTables, self._hotball)
    -- end
    table.insert(self.nodesTables, self._lighthouse)
    if isSelfHome or isLogin then
        -- print("1221212121212121212121")
        table.insert(self.nodesTables, self._postbox)
        table.insert(self.nodesTables, self._bigmouthbird)
    end
    table.insert(self.nodesTables, self._stonebase)
    table.insert(self.nodesTables, self._portraitstone)
    table.insert(self.nodesTables, self._aboutstone)
end

 -- 0，没有关系，1，已经关注，2，只是粉丝，3互相关注
function UserHomeView:refreshGuangzhu( type )
    -- body
    -- self.btnGuanzhu:
end

-- 闪烁的节点
function UserHomeView:initFlickerNode( style )
    -- body
end
-- 可点击的节点
function UserHomeView:initCanClickNode( style )
    -- body
end

-- 刷新界面 -1 访客，0 未登录， 1 登陆
function UserHomeView:refreshUI( isLogin, isSelfHome, userInfo )
    print("刷新界面。。。。。。。", isLogin, isSelfHome)
    dump(userInfo)
    if self.t1 then
        self.scheduler.unscheduleGlobal(self.t1)
        self.t1 = nil
    end
    self.pnlCallout:setVisible(false)
    self.pnlMove:setVisible(false)
    self.pnlBtn:setVisible(false)
    self.pnlBigMouthBird:setVisible(false)
    self._hotball:setVisible(false)

    if isLogin then  -- 登录
        if isSelfHome then   -- 自己家
            self:setUserInfo(userInfo)
            -- self.pnlMove:setVisible(true)
            self._portraitstone:setVisible(true)
            if self._delegate:getRole() == 1 then
                print("商家。。。。。。。。。。。。。。。。")
                self._hotball:setVisible(true)
            end
        else   -- 在别人家
            self:refresh(userInfo)
            -- print("设置了btn可见。。。。。。。。。。。。。。", isLogin, isSelfHome)
            self.pnlBtn:setVisible(true)
            -- self:reSetNodesTable( true )
            self._portraitstone:setVisible(true)
            self.pnlBigMouthBird:setVisible(true)
            self._hotball:setVisible(true)
        end
    else
        if isSelfHome then
            if self.frendCaption then self.frendCaption:setVisible(false) end
            if self.userCaption then self.userCaption:setVisible(false) end
            -- self.pnlMove:setVisible(true)
            -- self:reSetNodesTable( false,  )
            self._portraitstone:setVisible(false)
        else
            self:refresh(userInfo)
            -- print("设置了btn可见。。。。。。。。。。。。。。", isLogin, isSelfHome)
            self.pnlBtn:setVisible(true)
            -- self:reSetNodesTable( true )
            self._portraitstone:setVisible(true)
            -- self._hotball:setVisible(true)
        end
    end

    self:reSetNodesTable( isLogin, isSelfHome )

    if isLogin and not isSelfHome then
        if self._delegate then
            self._delegate:getFollowState()
        end
    else
        self:changeGZSprite("uh_add2")
    end
    
    if isLogin or not isSelfHome then
        if self._delegate then
            -- print("22222222222222222222222222222")
            self._delegate:getCallout()
        end
    end



end

function UserHomeView:refresh( userInfo)
    -- self:setUserInfo(userID, userName, intro, zonename, smallImage, bigImage)
    do return end
    dump(userInfo)
    local userCaption 
    if self.frendCaption then
        userCaption = self.frendCaption 
    else
        userCaption = cc.uiloader:load("ui/UserHomeCaption2.csb")
        userCaption:addTo(self.rootNode)
    end

    userCaption:setVisible(false)
    if self.userCaption then
        self.userCaption:setVisible(false)
    end
    self:setUserData(userCaption, userInfo)

    self.frendCaption = userCaption
end

function UserHomeView:setUserInfo(userInfo)
    do return end
    print("function UserHomeView:setUserInfo(userid, username, intro, zonename)")
    local userCaption
    if not self.userCaption then
        userCaption = cc.uiloader:load("ui/UserHomeCaption1.csb")
        userCaption:addTo(self.rootNode)
    else
        userCaption = self.userCaption
    end
    userCaption:setVisible(false)
    if self.frendCaption then
        self.frendCaption:setVisible(false)
    end
    
    self:setUserData(userCaption, userInfo)
    self.userCaption = userCaption
end


-- userInfo = {userid = 0, name = "", intro = "", zone = "", imglink = "", thumblink = ""}
function UserHomeView:setUserData( node, userInfo )
    local pnlBack = node:getChildByName("pnlBack")
    local spBack = pnlBack:getChildByName("spBack")
    local spUserImage = spBack:getChildByName("spUserImage")
    local txtUserName = pnlBack:getChildByName("txtUserName")
    local txtZoneName = pnlBack:getChildByName("txtZoneName")
    local goBack = pnlBack:getChildByName("goBack")

    txtUserName:setFontName(QMapGlobal.resFile.font.caption)
    txtZoneName:setFontName(QMapGlobal.resFile.font.content)
    txtUserName:setFontSize(40)
    txtZoneName:setFontSize(36)
    
    local fu = cc.FileUtils:getInstance()
    local downLoadPath = fu:getDownloadPath()
    downLoadPath = downLoadPath .. "userImage/"
    local imagePath = downLoadPath .. userInfo.userid .. "_s.png"
    local isExistImage = fu:isFileExist(imagePath)

    ---------------------------------------------------------------------------
    local spBackSize = spBack:getContentSize()
    spBack:removeAllChildren()
    local stencilNode = cc.Sprite:create("ui/image/wBGCircle.png")    --模板 
    local stencilNodeSize = stencilNode:getContentSize()
    stencilNode:setScale(spBackSize.width/stencilNodeSize.width)
    local clipNode = cc.ClippingNode:create()
    clipNode:setStencil(stencilNode)
    clipNode:setAnchorPoint(0.5, 0.5)
    clipNode:setPosition(cc.p(spBackSize.width/2 ,spBackSize.height/2 ))
    clipNode:setAlphaThreshold(0)
    local sp1 
    print("存在图片。。", imagePath, isExistImage)
    if isExistImage then
        sp1 = cc.Sprite:create(imagePath)
    else
        sp1 = cc.Sprite:create( "res/user/0.png")
    end
    local spSize = sp1:getContentSize()

    local spScaleX = spBackSize.width/spSize.width
    local spScaleY = spBackSize.height/spSize.height
    local spScale = (spScaleX > spScaleY) and spScaleX or spScaleY
    sp1:setScale(spScale)
    sp1:addTo(clipNode)
    clipNode:addTo(spBack)
    -- spUserImage:setVisible(false)
    -- clipNode:setBackGroundColorType(1)
    -- clipNode:setBackGroundColor(cc.c3b(0,255,255))
    ---------------------------------------------------------------------------

    local userCaptionSize = pnlBack:getContentSize()

    -- node:setPosition(cc.p(-display.width/2, display.height/2 - userCaptionSize.height - 50))
    node:setPosition(cc.p(0, display.height - userCaptionSize.height - 50))

    local userNameString = userInfo.name
    if userInfo.intro then
        userInfo.intro = string.trim(userInfo.intro)
        if string.len(userInfo.intro) > 0 then
            userNameString = userNameString .. ", " .. userInfo.intro
        end
    end
    txtUserName:setString(userNameString)
    txtZoneName:setString(userInfo.zone)

    if goBack then
        goBack:addTouchEventListener(function(sender, event)
            if event == 2 then
                print("当前点击了返回........")
                self._delegate:goBack()
            end
        end)
    end

    -- local downLoadPath = cc.FileUtils:getInstance():getDownloadPath()
    -- downLoadPath = downLoadPath .. "userImage/"
    if isExistImage then
        print(userInfo.imglink)
        if userInfo.imglink then
            QMapGlobal.DataManager:downLoadSpecialityFile(userInfo.imglink,  userInfo.userid .. "_b.png", downLoadPath, function (  )
                    end)
        end
    else
        print("开始下载图片。。。", userInfo.userid, userInfo.thumblink)
        QMapGlobal.DataManager:downLoadSpecialityFile(userInfo.thumblink,  userInfo.userid .. "_s.png", downLoadPath, function (  )
            print("完成下载图片。。。", userInfo.userid)
            local path = downLoadPath .. userInfo.userid .. "_s.png"
            local spBackSize = spBack:getContentSize()
            spBack:removeAllChildren()
            local stencilNode = cc.Sprite:create("ui/image/wBGCircle.png")    --模板 
            local stencilNodeSize = stencilNode:getContentSize()
            stencilNode:setScale(spBackSize.width/stencilNodeSize.width)
            local clipNode = cc.ClippingNode:create()
            clipNode:setStencil(stencilNode)
            clipNode:setAnchorPoint(0.5,0.5)
            clipNode:setPosition(cc.p(spBackSize.width/2 ,spBackSize.height/2 ))
            clipNode:setAlphaThreshold(0)
            local sp1 = cc.Sprite:create( path)
            local spSize = sp1:getContentSize()
            local spScaleX = spBackSize.width/spSize.width
            local spScaleY = spBackSize.height/spSize.height
            local spScale = (spScaleX > spScaleY) and spScaleX or spScaleY
            sp1:setScale(spScale)
            sp1:addTo(clipNode)
            clipNode:addTo(spBack)

            QMapGlobal.DataManager:downLoadSpecialityFile(userInfo.imglink,  userInfo.userid .. "_b.png", downLoadPath, function (  )
                end)
        end)
    end
end

function UserHomeView:switchCallout( callouts )
    -- body
    -- self.pnlCallout:setVisible(true)
    if not callouts or not next(callouts) then return end
    self.callouts = callouts
    self.calloutIndex = 1
    -- dump(self.callouts)

    self.scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
    if self.t1 then
        self.scheduler.unscheduleGlobal(self.t1)
        self.t1 = nil
    end
    self.t1 = self.scheduler.scheduleGlobal(function()

        if not self.callouts or not next(self.callouts) then 
            if self.t1 then
                self.scheduler.unscheduleGlobal(self.t1)
                self.t1 = nil
            end
            return 
        end

        if self.calloutIndex > #self.callouts then
            self.calloutIndex = 1
        end
        self.pnlCallout:setVisible(true)
-- print("1111111111111111")
        self.txtCallout:setString(self.callouts[self.calloutIndex])
        self.txtCallout1:setString(self.callouts[self.calloutIndex])

        self.calloutIndex = self.calloutIndex + 1
        -- self.txtCallout:setVisible(false)
        -- self.txtCallout1:setVisible(true)
        -- self.spCallout:setTexture("ui/image/calloutBK1.png")

        local callSize = self.txtCallout:getContentSize()   
        local callSize1 = self.txtCallout1:getContentSize()
        local spSize = self.spCallout:getContentSize()
        -- print("size...", callSize.width, callSize.height, (callSize.width + 20)/140)
        if callSize.width < callSize1.width then
            self.spCallout:setScaleX((callSize.width+40)/spSize.width)
            self.spCallout:setScaleY((callSize.height+40)/spSize.height)
        else
            self.spCallout:setScaleX((callSize1.width+40)/spSize.width)
            self.spCallout:setScaleY((callSize1.height+40)/spSize.height)
        --     self.txtCallout:setVisible(true)
        --     self.txtCallout1:setVisible(false)
        --     self.spCallout:setTexture("ui/image/calloutBK.png")
        --     self.spCallout:setScaleX((callSize.width + 20)/279)
        end
        -- self.pnlCallout:setContentSize(cc.size(callSize.width + 20, 66))
        -- self.pnlCallout:setBackGroundImage("ui/image/calloutBK.png")
         
        -- self.spCallout:setScaleX((callSize.width + 20)/279)

    end, 2)
    
end

function UserHomeView:initTopichot( ... )
    local topHotNode = cc.uiloader:load("ui/TopicHot.csb")
    topHotNode:setPosition(cc.p(-display.width/2 + 40, -display.height/2 + 10))

    local backGround = topHotNode:getChildByName("backGround")
    local pvContent = backGround:getChildByName("pvContent")

    topHotNode:addTo(self.rootNode)
    self.topHotNode = topHotNode
    self.pvContent = pvContent
end

function UserHomeView:setTopichot( topicData ) 
    dump(topicData)
    if topicData and next(topicData) then
        local fu = cc.FileUtils:getInstance()
        self.pvContent:removeAllPages()
        for _, item in pairs(topicData) do

            -- url = item.imglink, topicid = item.topicid, fileName = fileName
            
            if not fu:isFileExist(item.fileName) then
                -- item.fileName
            end

            local sp1 = display.newSprite(item.fileName)
            local size = sp1:getContentSize()
            local photoSize = self.pvContent:getContentSize()
            local dW = photoSize.width/size.width
            local dH = photoSize.height/size.height
            local dS = dW < dH and dW or dH
            local l = ccui.Layout:create()
            l:setContentSize(photoSize)
            sp1:setScale(dS)
            sp1:setPosition(cc.p(photoSize.width/2,photoSize.height/2))
            sp1:addTo(l)
            self.pvContent:addPage(l)
            
            
            -- local spPoint = cc.uiloader:load("ui/MarkPointNode.csb")
            -- spPoint:setPosition(cc.p(500 + (key - (imageCount+1)/2) * 50, 650))
            -- local spPic = spPoint:getChildByName("pnlBack"):getChildByName("spPic")
            -- if key ~= 1 then
            --     spPic:setTexture("ui/image/graySmall.png")
            -- end
            -- table.insert(self.spPointList,spPic)
            -- spPoint:addTo(self.pnlBackGround)
        end
        self.pvContent:setCustomScrollThreshold(15)
    end
end


function UserHomeView:_calculateZoomLevelScales(fixedLevelCount, maxScale)

    if fixedLevelCount < 1 then
        printError("zoom level count must not be less than 1")
        return
    end

    self._fixedZoomLevelScales = {}
    self._fixedZoomLevelScalesIndex = 0

    if fixedLevelCount == 1 then
        self._fixedZoomLevelScales[1] = maxScale
        return
    end

    local mapSize = self.spMap:getContentSize()
    if mapSize.width <= display.width or mapSize.height <= display.height then
        self._fixedZoomLevelScales[1] = maxScale
    else
        local hRatio = display.width / mapSize.width
        local vRatio = display.height / mapSize.height

        -- first level
        local index = 1
        local firstLevelScale = hRatio < vRatio and vRatio or hRatio
        self._fixedZoomLevelScales[index] = firstLevelScale

        -- second level to second-last level if any
        if fixedLevelCount > 2 then
            local scaleRatio = math.pow(maxScale/firstLevelScale, 1.0/(fixedLevelCount-1))
            local zoomLevel = 2
            while zoomLevel < fixedLevelCount do
                self._fixedZoomLevelScales[index+1] = scaleRatio * self._fixedZoomLevelScales[index]
                index = index + 1
                zoomLevel = zoomLevel + 1
            end
        end

        -- last level
        self._fixedZoomLevelScales[index+1] = maxScale
    end
end

function UserHomeView:_setMapScaleToLevelWithIndex(levelIndex, animated)
    -- print("1111111111111")
    if levelIndex < 1 or levelIndex > #self._fixedZoomLevelScales then
        printError("invalid level index: %d, index must be in [%d, %d]", levelIndex, 1, #self._fixedZoomLevelScales)
        return
    end

    if self._fixedZoomLevelScalesIndex ~= levelIndex then
        dump(self._fixedZoomLevelScales)
        if animated then
            self:_startMapScaleToAnimation(0.2, self._fixedZoomLevelScales[levelIndex])
        else
            self:_setMapScale(self._fixedZoomLevelScales[levelIndex])
        end

--         starIndex = (starIndex or 0) + 1
--         print("11111111111111111111111", starIndex)
-- print( self._fixedZoomLevelScales[levelIndex])
        self._fixedZoomLevelScalesIndex = levelIndex
        self._mapInFixedZoomLevel = true
    end
end

function UserHomeView:_mapScaleAnimationTick(tickTime)
    self:_setMapScale(self.mapScaleParams.startScale + self.mapScaleParams.scaleDelta * tickTime)
end

function UserHomeView:_startMapScaleToAnimation(duration, scaleTo)
    self:stopActionByTag(500)
    self.mapScaleParams = self.mapScaleParams or {}
    self.mapScaleParams.startScale = self.spMap:getScale()
    self.mapScaleParams.scaleDelta = scaleTo - self.mapScaleParams.startScale
    local scaleMapAction = qm.QMapActionInterval:create(duration, handler(self, self._mapScaleAnimationTick))
    scaleMapAction:setTag(500)
    self:runAction(scaleMapAction)
end

function UserHomeView:_setMapScale(newScale)
    local currentScale = self.spMap:getScale()
    if newScale ~= currentScale then
        -- print("设置scale", newScale)
        self.spMap:setScale(newScale)
        self:_calculateMapBottomLeftPropertiesAccordingToScale(newScale)
        self._mapInFixedZoomLevel = false


        -- local minScale = self._fixedZoomLevelScales[1]
        -- local maxScale = self._fixedZoomLevelScales[#self._fixedZoomLevelScales]
        -- -- local s = (maxScale - minScale)/2 + minScale
        -- local s = (maxScale + minScale)/2 

        -- print(newScale , s, maxScale, minScale, (maxScale + minScale)/4)
        -- if self.prohibitNameLayerShow then
        --     self._markNameLayer:setNameVisible(false)
        -- else
        --     self._markNameLayer:setNameVisible(newScale > s)
        -- end

        -- self.nameLayerIsShow = (newScale > s)

    end
end

function UserHomeView:setAniate(  )
	-- body
end

function UserHomeView:setDelegate(delegate)
    self._delegate = delegate
    -- self._menuLayer:setDelegate(delegate)

    if not self._delegate:isLogin() then
        self._portraitstone:setVisible(false)
    end
end

------ scenic spots breathing flash
function UserHomeView:setAllSenicSpotsFlash(flashed)

    if self._allSenicSpotsFlash ~= flashed then
        
        -- local children = self.spMap:getChildren()
        if flashed then
            for k, node in pairs(self.nodesTables) do
                -- print("设置闪烁。。",node:getName())
                QMapGlobal.Action:startTintColorFlashAnimation(node, cc.c3b(160, 160, 160), 1.5)
            end
        else
            for k, node in pairs(self.nodesTables) do
                QMapGlobal.Action:stopTintColorFlashAnimation(node)
            end
        end

        self._allSenicSpotsFlash = flashed
    end
end

function UserHomeView:initEvent( ... )
	-- 允许 node 接受触摸事件
	-- self:setTouchEnabled(true)

	-- -- 设置触摸模式
	-- self:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE) -- 多点
	-- -- node:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE) -- 单点（默认模式）

	-- self.touchInfo = {state = 0, pOld1 = nil, pOld2 = nil, pNew1 = {x = 0, y = 0}, pNew2 = {x = 0, y = 0}}   -- 当前没有触摸事件
	-- -- 注册触摸事件
	-- self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	--     -- event.name 是触摸事件的状态：began, moved, ended, cancelled
	--     -- 多点触摸增加了 added 和 removed 状态
	--     -- event.points 包含所有触摸点
	--     -- 按照 events.point[id] = {x = ?, y = ?} 的结构组织
	--     -- for id, point in pairs(event.points) do
	--     --     printf("event [%s] %s = %0.2f, %0.2f",
	--     --            event.name, id, point.x, point.y)
	--     -- end
	--     dump(event)

	--     local points = event.points

	--     if event.name == "began" then
	--     	if #points == 1 then
	--     		points[1]
	--     		self.touchInfo.state = 1
	--     		self.touchInfo.pNew1 = {}

	--     	elseif #points == 2 then
	--     		self.touchInfo.state = 2

	--     	end

	--         return true
	--     elseif event.name == "added" then
	--     elseif event.name == "removed" then
	--     elseif event.name == "moved" then

	-- 	elseif event.name == "ended" then
	-- 	elseif event.name == "cancelled" then
	--     end
	-- end)
    print("注册触摸事件。。。。。。。。。。。。。。")
    
	self._gestureRecognizer = qm.GestureRecognizer:create()
    self._gestureRecognizer:addGestureBeganCallback(handler(self, self._gestureBegan))
    self._gestureRecognizer:addSingleTapCallback(handler(self, self._singleTap))
    self._gestureRecognizer:addDoubleTapCallback(handler(self, self._doubleTap))
    self._gestureRecognizer:addPanCallback(handler(self, self._mapMoved))
    self._gestureRecognizer:addDoubleFingersTapCallback(handler(self, self._doubleFingersTap))
    self._gestureRecognizer:addPinchCallback(handler(self, self._pinch))
    self._gestureRecognizer:addPanEndedCallback(handler(self, self._mapMoveEnded))
    self._gestureRecognizer:applyToNode(self)
    self._gestureRecognizer:addTo(self)

    -- self.pvContent:addEventListener(function(sender, event)
    --     local index = sender:getCurPageIndex()  
    --     if self.curIndex == index then
    --         self._delegate:onSelTopichot(index + 1)
    --     end   
    --     self.curIndex = index
    --     -- if self.spPointList and next(self.spPointList) then
    --     --     for key, var in ipairs(self.spPointList) do
    --     --         if index + 1 == key then
    --     --            var:setTexture("ui/image/greenSmall.png")
    --     --         else
    --     --            var:setTexture("ui/image/graySmall.png")
    --     --         end
    --     --     end
    --     -- end
    -- end)

    self.pnlMove:addTouchEventListener(function ( sender, event )
        -- print("1111111111111111", event)
        if event == 0 then
            -- self:endScheduler()
            -- for _, cell in pairs(self.existCells) do
            --     cell:pause()
            -- end
        elseif event == 1 then
        else   -- if event == 2 then
            print("movw........")
            self._delegate:onMove()
        end
    end)
    self.btnGuanzhu:addTouchEventListener(function ( sender, event )
        -- print("1111111111111111", event)
        if event == 0 then
            self._delegate:clickBtnGuanzhu(true)
            -- self:endScheduler()
            -- for _, cell in pairs(self.existCells) do
            --     cell:pause()
            -- end
        elseif event == 1 then
        else   -- if event == 2 then
            self._delegate:clickBtnGuanzhu(false)
            print("关注........")
            self._delegate:onGuanzhu()
        end
    end)
    self.btnShouye:addTouchEventListener(function ( sender, event )
        -- print("1111111111111111", event)
        if event == 0 then
            self.spShouye:setTexture("ui/image/uh_image/uh_shouye1.png")
            -- self:endScheduler()
            -- for _, cell in pairs(self.existCells) do
            --     cell:pause()
            -- end
        elseif event == 1 then
        else   -- if event == 2 then
            print("首页........")
            self.spShouye:setTexture("ui/image/uh_image/uh_shouye2.png")
            self._delegate:onMainPage()
        end
    end)

    self.pnlBigMouthBird:addTouchEventListener(function ( sender, event )
        -- print("1111111111111111", event)
        if event == 0 then
            self:hitBird(true)
            self._delegate:SendPetMsg()
        elseif event == 1 then
        else   -- if event == 2 then
             self:hitBird(false)
        end
    end)
end

function UserHomeView:_addMapPositionDelta(delta)
    -- SBL: screen bottom left
    local newSBLPosition = cc.pAdd(self._mapCurrentSBLPosition, delta)
    self:_guardSBLPositionAssign(newSBLPosition)
end

function UserHomeView:_whichItemContainPoint(point)
    local pointInMapSpace = self.spMap:convertToNodeSpace(point)

    local nodeRect
    for i=#self.nodesTables,1,-1 do
        local node = self.nodesTables[i]

        nodeRect = node:getBoundingBox()
        if node:isVisible() and cc.rectContainsPoint(nodeRect, pointInMapSpace) then
            return node
        end
    end
    return nil
end

function UserHomeView:_addSelectedScenicSpotSpriteAboveLocationMask(tip)
    if not self._locationsMaskHasScenicSpotSpriteAdded then
        -- self:_addSenicSpotCloneAboveLocationsMask(self._selectedScenicSpot)

        if self._selectedScenicSpot == self._stonebase then
            self:_addSenicSpotCloneAboveLocationsMask(self._selectedScenicSpot, tip)
            if self._delegate:isLogin() then
                self:_addSenicSpotCloneAboveLocationsMask(self._portraitstone, tip)
            end
        elseif self._selectedScenicSpot == self._portraitstone then
            self:_addSenicSpotCloneAboveLocationsMask(self._stonebase, tip)
            self:_addSenicSpotCloneAboveLocationsMask(self._selectedScenicSpot, tip)
        else
            self:_addSenicSpotCloneAboveLocationsMask(self._selectedScenicSpot, tip)
        end
        self._locationsMaskHasScenicSpotSpriteAdded = true
    end
end

------ locations mask and view spot sprite show above locations mask
function UserHomeView:_locationsMaskChangeDarknessDoneCallback()
    if self._locationsMaskAnimationCallback then
        self._locationsMaskAnimationCallback()
    end
end

function UserHomeView:highLightSelectedScenicSpotSprite(highLighted, animated, callback, tip)
    if self._selectedScenicSpot then
        self._locationsMaskAnimationCallback = callback
        if highLighted then
            self:_setLocationsMaskToDark(true, animated)
            self:_addSelectedScenicSpotSpriteAboveLocationMask(tip)
        else
            self:_setLocationsMaskToDark(false, animated)
        end
    end
end

function UserHomeView:_locationsMaskToTransparentDone()
    self._locationsMask:setVisible(false)
    self._locationsMask:removeAllChildren()
    self._locationsMaskHasScenicSpotSpriteAdded = false
    self._locationsDarkened = false
    self:_locationsMaskChangeDarknessDoneCallback()
end

function UserHomeView:_locationsMaskToDarkDone()
    self._locationsDarkened = true
    self:_locationsMaskChangeDarknessDoneCallback()
end

function UserHomeView:_setLocationsMaskToDark(dark, animated)
    if self._locationsDarkened ~= dark then
        self:_setNodeToDark(self._locationsMask, dark, animated,
                            handler(self, self._locationsMaskToDarkDone),
                            handler(self, self._locationsMaskToTransparentDone))
    else
        if dark then
            self:_locationsMaskToDarkDone()
        else
            self:_locationsMaskToTransparentDone()
        end
    end
end

function UserHomeView:_setNodeToDark(node, dark, animated, toDarkCallback, toTransparentCallback)
    if animated then
        if dark then
            node:setVisible(true)
            -- print("2222222@@@@@@@@@@@@@@@@@@@")
            QMapGlobal.Action:startFadeToAnimation(node, 150/255, 0.4, 0.2, toDarkCallback)
        else
            QMapGlobal.Action:startFadeToAnimation(node, 0, 0.4, 0.2, toTransparentCallback)
        end
    else
        if dark then
            node:setVisible(true)
            node:setOpacity(150)
            toDarkCallback()
        else
            node:setOpacity(0)
            toTransparentCallback()
        end
    end
end

function UserHomeView:_addSenicSpotCloneAboveLocationsMask(sprite, tip)
    local duplicatedSprite = display.newSprite(sprite:getSpriteFrame())
    local posX, posY = sprite:getPosition()
    duplicatedSprite:setPosition(cc.p(posX, posY ))
    duplicatedSprite:setName(sprite:getName())
    self._locationsMask:addChild(duplicatedSprite)

    if tip then
        local loginTip = cc.uiloader:load("ui/HPLoginTip.csb")
        loginTip:setPosition(cc.p(posX-80, posY+55))
        -- local label = cc.ui.UILabel.new({
        --     UILabelType = 2,
        --     text = "您还未登录，点击此处登陆..",
        --     font =  QMapGlobal.resFile.font.caption,   --"Zapfino",  --"Arial",
        --     size = 48, 
        --     color = cc.c3b(125, 111, 103), -- 使用纯红色
        --     align = cc.ui.TEXT_ALIGN_LEFT, 
        --     valign = cc.ui.TEXT_VALIGN_TOP,
        --     dimensions = cc.size(320, 0)
        -- })
        -- local Panel_1 = loginTip:getChildByName("Panel_1")
        -- Panel_1:addChild(label)
        -- label:setPosition(cc.p(40, 140))
        self._locationsMask:addChild(loginTip)
    end
end

function UserHomeView:_clearScenicSpotAboveLocationMask(sprite, animated)
    if animated then
        local fadeOut = cc.FadeOut:create(0.2)
        local fadeOutDone = cc.CallFunc:create(function()
            sprite:removeFromParent()
        end)
        sprite:runAction(cc.Sequence:create(fadeOut, fadeOutDone))
    else 
        sprite:removeFromParent()
    end
    self._locationsMaskHasScenicSpotSpriteAdded = false
end


function UserHomeView:zoomIn()
    if self._fixedZoomLevelScalesIndex < #self._fixedZoomLevelScales then
        self:_setMapScaleToLevelWithIndex(self._fixedZoomLevelScalesIndex + 1, true)
    end
end

function UserHomeView:zoomOut()
    if self._fixedZoomLevelScalesIndex > 1 then
        self:_setMapScaleToLevelWithIndex(self._fixedZoomLevelScalesIndex - 1, true)
    end
end

function UserHomeView:_mapMoved(deltaX, deltaY)
	-- print("function UserHomeView:_mapMoved(deltaX, deltaY)", deltaX, deltaY)
    self:_addMapPositionDelta(cc.p(deltaX, deltaY))

    -- local mapPosX, mapPosY = self.spMap:getPosition()
    -- self.spMap:setPosition(cc.p(mapPosX + deltaX, mapPosY + deltaY))
end

function UserHomeView:_mapMoveEnded(vX, vY)
    print("function UserHomeView:_mapMoveEnded(vX, vY)", vX, vY)
    -- self:stopActionByTag(502)

    -- if vX~= 0 or vY~= 0 then
    --     local deceleration = 90
    --     self._mapInertialMoveParams = self._mapInertialMoveParams or { deceleration = {} }
    --     self._mapInertialMoveParams.velocity = cc.p(vX, vY)
    --     local vLen = cc.pGetLength(self._mapInertialMoveParams.velocity)
    --     self._mapInertialMoveParams.deceleration.x = -vX / vLen * deceleration;
    --     self._mapInertialMoveParams.deceleration.y = -vY / vLen * deceleration;
    --     self._mapInertialMoveParams.lastTick = 0
    --     self._mapInertialMoveParams.duration = 2.0
    --     local inertialMoveAction = qm.QMapActionInterval:create(self._mapInertialMoveParams.duration, handler(self, self._mapInertialAnimationTick))
    --     inertialMoveAction:setTag(502)
    --     self:runAction(inertialMoveAction)
    -- end
end

function UserHomeView:_gestureBegan()
	-- print("function UserHomeView:_gestureBegan()")
    -- self:stopActionByTag(502)
end

function UserHomeView:_singleTap(x, y)
	-- print("function UserHomeView:_singleTap(x, y)", x, y)
    self._itemTapped = self:_whichItemContainPoint(cc.p(x, y))
    if (self._itemTapped) then
        self:selectItem(self._itemTapped)
    else
        self._delegate:tappedElseWhere()
        self._selectedScenicSpot = nil
    end
end

function UserHomeView:selectItem( itemTapped )
    self._selectedScenicSpot = itemTapped
    self._delegate:tappedScenicSpotWithName(itemTapped:getName())
end

function UserHomeView:_doubleTap(x, y)
	local pointInMapSpace = self.spMap:convertToNodeSpace(cc.p(x, y))
    self:_setMapAnchorToPoint(pointInMapSpace)
    self:zoomIn()
end

function UserHomeView:_doubleFingersTap(x, y)
    -- print("UserHomeView:_doubleFingersTap(x, y)", x, y)
    print("spMap取值。。。。。。。。。。。。。。。。。。。", self.spMap)
    if not self.spMap then return end
    local pointInMapSpace = self.spMap:convertToNodeSpace(cc.p(x, y))
    self:_setMapAnchorToPoint(pointInMapSpace)
    self:zoomOut()
end

function UserHomeView:_pinch(x, y, distanceRatio)
    -- print("UserHomeView:_pinch(x, y, distanceRatio)", x, y, distanceRatio)
    if not self.spMap then return end
    local pointInMapSpace = self.spMap:convertToNodeSpace(cc.p(x, y))
    self:_setMapAnchorToPoint(pointInMapSpace)
    self:_guardMapScaleAssign(self.spMap:getScale() * distanceRatio)

    -- self.spMap:setScale(self.spMap:getScale() * distanceRatio)

end

------ map set scale, position
function UserHomeView:_guardMapScaleAssign(newScale)
    -- guard scale
    local minScale = self._fixedZoomLevelScales[1]
    local maxScale = self._fixedZoomLevelScales[#self._fixedZoomLevelScales]
    if newScale > maxScale then
        newScale = maxScale
    elseif newScale < minScale then
        newScale = minScale
    end

    -- update zoom index
    if #self._fixedZoomLevelScales > 1 then
        for index = 2, #self._fixedZoomLevelScales do
            floorScale = self._fixedZoomLevelScales[index-1]
            ceilingScale = self._fixedZoomLevelScales[index]
            midScale = floorScale + (ceilingScale - floorScale) * 0.5
            if newScale >= midScale then
                self._fixedZoomLevelScalesIndex = index
            else
                self._fixedZoomLevelScalesIndex = index - 1
                break
            end
        end
    end

    self:_setMapScale(newScale)
end

function UserHomeView:_setMapAnchorToPoint(pointInMap)
    local size = self.spMap:getContentSize()
    local newAnchorPoint = cc.p(pointInMap.x / size.width, pointInMap.y / size.height)

    local currentAnchor = self.spMap:getAnchorPoint()
    local x, y = self.spMap:getPosition()

    local newAnchorBasedPosition = cc.p(self._mapCurrentSBLPosition.x + newAnchorPoint.x * self._mapScreenSize.width,
                                        self._mapCurrentSBLPosition.y + newAnchorPoint.y * self._mapScreenSize.height)

-- print("设置锚点")
-- dump(newAnchorPoint)
-- print("设置位置 _setMapAnchorToPoint")
-- dump(newAnchorBasedPosition)
    self.spMap:setAnchorPoint(newAnchorPoint)
    self.spMap:setPosition(newAnchorBasedPosition)
end

function UserHomeView:_guardSBLPositionAssign(newSBLPosition)
    -- SBL: screen bottom left
    -- print(self._mapSBLMinX, self._mapSBLMaxX , self._mapSBLMinY ,self._mapSBLMaxY, newSBLPosition.x, newSBLPosition.y)
    if newSBLPosition.x < self._mapSBLMinX then
        newSBLPosition.x = self._mapSBLMinX
    elseif newSBLPosition.x > self._mapSBLMaxX then
        newSBLPosition.x = self._mapSBLMaxX
    end

    if newSBLPosition.y < self._mapSBLMinY then
        newSBLPosition.y = self._mapSBLMinY
    elseif newSBLPosition.y > self._mapSBLMaxY then
        newSBLPosition.y = self._mapSBLMaxY
    end

    local currentAnchor = self.spMap:getAnchorPoint()
    -- SBA: screen-based anchor
    
    -- print(currentAnchor.x , self._mapScreenSize.width , newSBLPosition.x, currentAnchor.y , self._mapScreenSize.height , newSBLPosition.y)
    -- print("xxx", currentAnchor.x * self._mapScreenSize.width + newSBLPosition.x)
    -- print("yyy", currentAnchor.y * self._mapScreenSize.height + newSBLPosition.y)
    local newSBAPosition = cc.p(currentAnchor.x * self._mapScreenSize.width + newSBLPosition.x,
                                currentAnchor.y * self._mapScreenSize.height + newSBLPosition.y)
    -- print("1111111111111111111111111")
    -- dump(newSBAPosition)
    self.spMap:setPosition(newSBAPosition)

    if self._mapScaleUpdated then
        -- self._markLayer:refresh()
        -- self._markNameLayer:refresh()
        -- self:_updatePopupMenu()
        self._mapScaleUpdated = false
    else
        local delta = cc.pSub(newSBLPosition, self._mapCurrentSBLPosition)
        -- self._markLayer:deltaMove(delta)
        -- self._popupMenuLayer:deltaMove(delta)
        -- self._markNameLayer:deltaMove(delta)
    end

    self._mapCurrentSBLPosition = newSBLPosition
end

function UserHomeView:_calculateMapBottomLeftPropertiesAccordingToScale(scale)
-- print("UserHomeView:_calculateMapBottomLeftPropertiesAccordingToScale", scale)
    -- calculate map screen size
    local mapScreenSize = self.spMap:getContentSize()
    mapScreenSize.width = mapScreenSize.width * scale
    mapScreenSize.height = mapScreenSize.height * scale
    self._mapScreenSize = mapScreenSize
    -- calculate SBL(screen bottom left) bound
    if mapScreenSize.width <= display.width then -- cannot move horizontally
        self._mapSBLMinX = -mapScreenSize.width / 2
        self._mapSBLMaxX = self._mapSBLMinX
    else
        self._mapSBLMinX = display.width / 2 - mapScreenSize.width
        self._mapSBLMaxX = -display.width / 2
    end

    if mapScreenSize.height <= display.height then -- cannot move vertically
        self._mapSBLMinY = -mapScreenSize.height / 2
        self._mapSBLMaxY = self._mapSBLMinY
    else
        self._mapSBLMinY = display.height / 2 - mapScreenSize.height
        self._mapSBLMaxY = -display.height / 2
    end

    -- apply margin
    self._mapSBLMinY = self._mapSBLMinY - self._topFillMargin
    self._mapSBLMaxY = self._mapSBLMaxY + self._bottomFillMargin

    -- calculate SBL(screen bottom left) position
    local currentX, currentY = self.spMap:getPosition()
    -- print("function UserHomeView:_calculateMapBottomLeftPropertiesAccordingToScale(scale)", currentX, currentY)
    local currentAnchor = self.spMap:getAnchorPoint()
    -- print(currentX , self._mapScreenSize.width , currentAnchor.x, currentY , self._mapScreenSize.height , currentAnchor.y)


    local newSBLPosition = cc.p(currentX - self._mapScreenSize.width * currentAnchor.x,
                                currentY - self._mapScreenSize.height * currentAnchor.y)

    -- print("function UserHomeView:_calculateMapBottomLeftPropertiesAccordingToScale(scale) 111")
    -- dump(newSBLPosition)
    self._mapScaleUpdated = true
    self:_guardSBLPositionAssign(newSBLPosition)
end

function UserHomeView:clearScenicSpotWithNameAboveLocationMask(spriteName, animated)
    local children = self._locationsMask:getChildren()
    for k, node in pairs(children) do
        if spriteName == node:getName() then
            self:_clearScenicSpotAboveLocationMask(node, animated)
            return
        end
    end
end

function UserHomeView:setBackgroundMapToDark(dark, animated)

    self:_setNodeToDark(self._bgMapMask, dark, animated,
                        handler(self, self._bgMapMaskToDarkDone),
                        handler(self, self._bgMapMaskToTransparentDone))
end

function UserHomeView:hitBird( isHit )
    if isHit then
        self._bigmouthbird:setTexture("ui/image/userHome/bigmouthbird_1.png")
    else
        self._bigmouthbird:setTexture("ui/image/userHome/bigmouthbird.png")
    end
    -- self._bigmouthbird:setTexture("ui/image/userHome/bigmouthbird_1.png")

    -- local a1 = cc.DelayTime:create(0.8)
    -- local a2 = cc.CallFunc:create(function()
    -- --     print("111111111111111111")
    --         self._bigmouthbird:setTexture("ui/image/userHome/bigmouthbird.png")
    --     end)
    -- local a3 = cc.Sequence:create(a1, a2)
    -- self._bigmouthbird:runAction(a3)
end

function UserHomeView:viewWillUnload( ... )

    print("userHome场景退出")
    if self.t1 then
        self.scheduler.unscheduleGlobal(self.t1)
        self.t1 = nil
    end

    if self._gestureRecognizer then
        print("关闭手势！")
        self._gestureRecognizer:setEnabled(false)
    end
    
end

function UserHomeView:showLoginTip( strMsg )
    self.txtLoginTip:setString(strMsg)
    
    local tipSize = self.txtLoginTip:getContentSize()
    self.pnlLoginTip:setContentSize(cc.size(tipSize.width + 20, 66))
    self.spLoginTip:setScaleX((tipSize.width + 20)/279)

    -- self.pnlLoginTip:stopAllActions()
    -- self.pnlLoginTip:stopActionByTag(818)
    -- local a1 = cc.DelayTime:create(3)
    -- local a2 = cc.CallFunc:create(function()
    --         self.pnlLoginTip:setVisible(false)
    --     end)
    -- local a3 = cc.Sequence:create(a1, a2)
    -- a3:setTag(818)
    -- self.pnlLoginTip:runAction(a3)

    -- self.pnlLoginTip:setVisible(true)

    self._selectedScenicSpot = self._stonebase
    self._delegate:tappedScenicSpotWithNameNoEvent(self._stonebase:getName(), {})

end

function UserHomeView:changeGZSprite( picName )
    self.spGuanzhu:setTexture("ui/image/uh_image/"..picName..".png")
    if picName == "uh_add1" or picName == "uh_add2" then
        self.txtGuanzhu:setString("关注")
    elseif picName == "uh_hf1" or picName == "uh_hf2" then
        self.txtGuanzhu:setString("相互关注")
    elseif picName == "uh_gz1" or picName == "uh_gz2" then
        self.txtGuanzhu:setString("已关注")
    end
    local txtSize = self.txtGuanzhu:getContentSize()
    local txtPtx, txtPty = self.txtGuanzhu:getPosition()
    local spSize = self.spGuanzhu:getContentSize()
    local spPtx, spPty = self.spGuanzhu:getPosition()
    local x = txtPtx - txtSize.width/2 - 14.5 - spSize.width/2
    local y = spPty
    self.spGuanzhu:setPosition(cc.p(x,y))
end

return UserHomeView










