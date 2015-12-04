
-- AddSightRemarkView.lua   添加评论页面
-- add by star 2015.3.11

local AddSightRemarkView = class("AddSightRemarkView", function()
    return display.newLayer()
end)

function AddSightRemarkView:ctor(param)

    -- map layer
    self.rootNode = cc.uiloader:load("ui/AddCommentLayer.csb")
    self.rootNode:setPosition(cc.p(0, 0))
    self.rootNode:addTo(self)

    self.pnlBackGround = self.rootNode:getChildByName("pnlBackGround")
    self.txtPackName = self.pnlBackGround:getChildByName("txtPackName")
--    self.tfInfo = self.pnlBackGround:getChildByName("tfInfo")
    self.ok = self.pnlBackGround:getChildByName("btnOK")
    self.close = self.rootNode:getChildByName("btnClose")
    self.txtComment = self.pnlBackGround:getChildByName("txtComment")
    self.lvImage = self.pnlBackGround:getChildByName("lvImage")
    -- print_r(self.txtComment)

    self.spImageList = {}   
    self.imageList = {}
    -- self.txtComment:setVisible(false)
    -- self.addImageNode = self.pnlBackGround:getChildByName("addImageNode")
    -- self.pnlAddImage = self.addImageNode:getChildByName("pnlAddImage")
    -- self.btnAddImage = self.pnlAddImage:getChildByName("btnAddImage")
    -- self.spImage = self.pnlAddImage:getChildByName("spImage")
    -- table.insert( self.spImageList, self.spImage )
    -- print_r(self.tfInfo)
--    self:initUI()
    
    -- self.cityid = param.cityid
    -- self.packid = param.packid

    self.txtPackName:setString("")
    -- print("这是测试输入框的。。。。。。")
    -- print_r(self.txtPackName)
    
--    self.tfInfo:setPlaceHolder(0)
--    self.tfInfo:setTouchAreaEnabled(true)

--     local eb = ccui.EditBox:create({width = 850, height = 300}, "Default/Button_Press.png")
-- --    eb:setAnchorPoint(0, 1)
--     eb:setPosition(cc.p(500,1300))
--     eb:setPlaceholderFontName("Arial")
--     eb:setPlaceholderFontSize(48)
--     eb:setPlaceholderFontColor(cc.c3b(0,0,0))
--     eb:setFontName("Arial")
--     eb:setReturnType(0)
--     eb:setFontSize(48)
--     eb:setPlaceHolder("你对景点的点评...")
--     eb:setFontColor(cc.c3b(0,0,0))
--     eb:setInputMode(0)
--    -- eb:setInputFlag(inputFlag)
    
--     eb:addTo(self.pnlBackGround)
--     self.eb = eb
    -- eb:setContentSize(cc.size(800,300))


    self:createButton(1)

    self:initEvents()
end

function AddSightRemarkView:createButton( index )
    print("创建一个按钮。。。。。。")

    local addImageNode = cc.uiloader:load("ui/AddImageNode.csb")
    -- addImageNode:setPosition(cc.p(530, 982))
    -- addImageNode:addTo(self.pnlBackGround)

    local pnlAddImage = addImageNode:getChildByName("pnlAddImage")
    -- local btnAddImage = pnlAddImage:getChildByName("btnAddImage")
    local spImage = pnlAddImage:getChildByName("spImage")
    table.insert( self.spImageList, spImage )
    
    -- btnAddImage:addTouchEventListener(function(sender, event)
    --     if event == 2 then
    --         print("add image。。。。。。。。。")
    --         self.delegate:onAddImage()
    --     end

    -- end)

    pnlAddImage:setVisible(true)
    pnlAddImage:setSwallowTouches(false)
    local beginPointX, beginPointY = 0,0
    pnlAddImage:addTouchEventListener(function ( sender, event )
        if event == 0 then
            local pTemp = sender:getTouchBeganPosition()
            beginPointX, beginPointY = pTemp.x, pTemp.y
        elseif event == 2 then
            local pTemp = sender:getTouchEndPosition()
            if math.abs(pTemp.x - beginPointX) < QMapGlobal.TouchAffectRange and  
                math.abs(pTemp.y - beginPointY) < QMapGlobal.TouchAffectRange then
                self.delegate:onAddImage()
            end
        end
    end)

    local size = pnlAddImage:getContentSize()
    local lvSize = self.lvImage:getContentSize()

    local nC = (index-1) % 3 
    local nR = math.floor((index-1) / 3) 
    addImageNode:setPosition(cc.p(size.width/2 + nC * (size.width+ 10), size.height/2)) 
    if nC == 0 then
        local item = ccui.Layout:create()
        item:setContentSize(cc.size(lvSize.width, size.height))
        addImageNode:addTo(item)
        self.lvImage:insertCustomItem(item, nR)
    else
        local item = self.lvImage:getItem(nR)
        addImageNode:addTo(item)
    end
    
end

function AddSightRemarkView:addImage( ... )
    print("0 add image......")
end

function AddSightRemarkView:_menuButtonPressed()
    print("1 add image......")
end

function AddSightRemarkView:_menuButtonReleased()
    print("2 add image......")
end

function AddSightRemarkView:setDelegate(delegate)
    self.delegate = delegate
end

function AddSightRemarkView:initUI( param )
    -- body
    self.txtPackName:setString(param.packName)
    self.journeyData = param.journeyData

    -- dump(self.journeyData)
end


-- 返回本页面的点评信息
function AddSightRemarkView:getMarkInfo()
    local markInfo = {}
    markInfo.mark = self.txtComment:getString() 
    markInfo.image = self.imageList
    -- dump(markInfo)
    return markInfo
end

function AddSightRemarkView:showAddImage( path , index)
    local sp = self.spImageList[index]
    if sp then
        sp:setTexture(path)
        sp:setVisible(true)

        local spSize = sp:getContentSize()
        local pnlSize = sp:getParent():getContentSize()
        local sW = pnlSize.width/spSize.width
        local sH = pnlSize.height/spSize.height
        local scale =  sW > sH and sW or sH 
        sp:setScale(scale)

        self:createButton(index + 1)

        table.insert(self.imageList, {id = index, ctime = ""})
    end
end

function AddSightRemarkView:initEvents()
    --    self:setTouchEnabled(true)
    --    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.mapHandler))
    self.close:setSwallowTouches(false)
    self.ok:setSwallowTouches(false)
    self.close:addTouchEventListener(function(sender, event)
        if event == 2 then
            print("关闭。。。。。。。。。")
            self.delegate:onClose()
        end
    end)

    self.ok:addTouchEventListener(function(sender, event)
        if event == 2 then
            print("确定。。。。。。。。。")
            self.delegate:onOK()
        end

    end)

    -- self.btnAddImage:addTouchEventListener(function(sender, event)
    --     if event == 2 then
    --         print("add image。。。。。。。。。")
    --         self.delegate:onAddImage()
    --     end

    -- end)
end

function AddSightRemarkView:mapHandler(event)
    print("CitySelectionView...... click...")

    if event.name == "began" then
        return true

    elseif event.name == "moved" then

    elseif event.name == "ended" then

    end
end

function AddSightRemarkView:addToNode(scene)
    self:addTo(scene)
end

function AddSightRemarkView:onEnter()
    print("CitySelectionView onenter()")
end

function AddSightRemarkView:onExit()
    print("CitySelectionView onExit()")
end

return AddSightRemarkView
