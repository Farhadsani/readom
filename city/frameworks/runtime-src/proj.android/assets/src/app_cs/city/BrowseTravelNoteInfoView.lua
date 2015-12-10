

local BrowseTravelNoteInfoView = class("BrowseTravelNoteInfoView", function()
    return display.newLayer()
end)

function BrowseTravelNoteInfoView:ctor(param)

    self.cityid = param.cityid

    self.rootLayer = cc.uiloader:load("ui/BrowseLayer.csb")
    self.rootLayer:addTo(self)
    
    -- self.pnlBackGround = self.rootLayer:getChildByName("pnlBackground")
    self.pnlContent = self.rootLayer:getChildByName("lvContent")

    self.journey = param.journey
    -- print("aaaaaaaaaaaaaaaaaaaa")
    -- dump(self.journey)

    self.CurOrder = param.order or 1
    
    local btnBack = self.rootLayer:getChildByName("btnClose")
    btnBack:addTouchEventListener(function(sender, event)
        if event == 2 then
            print("关闭。。。。。。。。。")
            self.delegate:onClose()
        end
    end)

    -- self:initUI()
--    pnlContent:setTouchEnabled(true)
--    pnlContent:addNodeEventListener(cc., handler(self, self.lvHandler))
--    pnlContent:scrollListener(function(event)
--        print_r(event)
--    end)
--    pnlContent:setTouchEnabled(true)
--    pnlContent:addEventListener(handler(self, self.lvHandler) )
--    function (event)
--        print_r(event)
--    end)
    
--    pnlContent:addEventListenerListView(function (event)
--        print_r(event)
--    end)
end

function BrowseTravelNoteInfoView:setDelegate(delegate)
    self.delegate = delegate
end

function BrowseTravelNoteInfoView:initCell( node, mark )
    local txtUserName = node:getChildByName("txtUserName")
    local txtTime = node:getChildByName("txtTime")
    local txtSightName = node:getChildByName("txtSightName")
    local txtComment = node:getChildByName("txtComment")
    local txtCaption = node:getChildByName"txtCaption"
    local txtOrder = node:getChildByName"pnlOrder":getChildByName"txtOrder"
    local spUserPic = node:getChildByName"pnlUserPic":getChildByName"spUserPic"
    local pnlMainPic = node:getChildByName"pnlMainPic"
    txtUserName:setString(self.journey:getUserName())
    txtTime:setString(mark.ctime)
    local cityData = QMapGlobal.systemData.mapData[self.journey:getCityID()]
    local sightData = cityData.sight[mark.sightid]
    txtSightName:setString(sightData.cname)
    txtComment:setString(mark.mark)
    txtOrder:setString(mark.order)
    txtCaption:setString("【"..self.journey:getTitle().."】")
    -- self.journey:getAuthorid()
    spUserPic:setTexture(self.journey:getAuthorImagePath())

    -- local fu = cc.FileUtils:getInstance()
    -- local writePath = fu:getWritablePath()
-- do return end
    local images = mark.image
    local i = 1
    if images and next(images) then
        for k,image in pairs(images) do
            if i > 6 then break end
            local imagePath = self.journey:getThumbnailPathForImage( mark.sightid, image.imgname)
            
            -- if io.exists( writePath .. imagePath) then
                local sp = display.newSprite(imagePath)
                local spSize = sp:getContentSize()
                local pnlPic = pnlMainPic:getChildByName("pnlPic"..i)
                if pnlPic then
                    local pnlSize = pnlPic:getContentSize()
                    local sW = pnlSize.width/spSize.width
                    local sH = pnlSize.height/spSize.height
                    local scale =  sW > sH and sW or sH 
                    sp:setScale(scale)
                    sp:setPosition(cc.p(pnlSize.width/2, pnlSize.height/2))
                    sp:addTo(pnlPic)
                    pnlPic:setVisible(true)
                    pnlPic:setSwallowTouches(false)
                    local beginPointX, beginPointY = 0,0
                    pnlPic:addTouchEventListener(function ( sender, event )
                        if event == 0 then
                            local pTemp = sender:getTouchBeganPosition()
                            beginPointX, beginPointY = pTemp.x, pTemp.y
                        elseif event == 2 then
                            local pTemp = sender:getTouchEndPosition()
                            if math.abs(pTemp.x - beginPointX) < QMapGlobal.TouchAffectRange and  
                                math.abs(pTemp.y - beginPointY) < QMapGlobal.TouchAffectRange then
                                self.delegate:onShowImages(mark.markid, k)   --由于闭包，此处不能用i代替k。
                            end
                        end
                    end)
                    -- print("function BrowseTravelNoteInfoView:initCell( node, mark ).................")
                    -- print_r(pnlPic)
                end
            -- end
            i = i+1
        end
    end
end

function BrowseTravelNoteInfoView:initUI()

    local marks = self.journey:getMarks()
    local h1 = 0
    local h2 = 0

--    cc.CSLoader:
    if marks and next(marks) then
        for i,mark in pairs(marks) do
            local cell = cc.CSLoader:createNode("ui/scenicSpotNoteCell.csb")
            local item = ccui.Layout:create()  
            local pnlBack = cell:getChildByName("pnlBack")

            self:initCell(pnlBack, mark)

            local size = pnlBack:getContentSize()
            cell:setPosition(cc.p(size.width/2, size.height/2)) 
            item:setContentSize(size)
            cell:addTo(item)
            self.pnlContent:insertCustomItem(item, i-1)
            if i < self.CurOrder then
                h1 = h1 + size.height
            end
            h2 = h2 + size.height
        end
    end

    if h2 ~= 0 then
        local a1 = cc.DelayTime:create(0)
        local a2 = cc.CallFunc:create(function()
                -- local contentSIze = self.pnlContent:getInnerContainerSize()
                -- self.pnlContent:jumpToPercentVertical(h1*100/h2)
                local lvSize = self.pnlContent:getContentSize()

                if h2 - h1 < lvSize.height then
                    h1 = h2 - lvSize.height
                end
                local offset = h1*100/(h2-lvSize.height)
                if offset < 0 then offset = 0 end
                self.pnlContent:jumpToPercentVertical(offset)
                -- print("高度比：", h1,h2, h1*100/(h2-lvSize.height))
            end)
        local a3 = cc.Sequence:create({a1,a2})
        self.pnlContent:runAction(a3)
    end
end

function BrowseTravelNoteInfoView:setListViewPos( order )
    -- self.pnlContent:jumpToPercentVertical(50)
    print("function BrowseTravelNoteInfoView:setListViewPos( order )", order)
    -- local a1 = cc.DelayTime:create(0.1)
    -- local a2 = cc.CallFunc:create(function()
    --         -- self.pnlContent:jumpToTop()
    --         -- self.pnlContent:jumpToBottom()

    -- self.pnlContent:jumpToPercentVertical((order -1)* 300)
    --     end)
    -- local a3 = cc.Sequence:create({a1,a2})
    -- self.pnlContent:runAction(a3)
    
    -- self.pnlContent:jumpToPercentHorizontal(500)
end

function BrowseTravelNoteInfoView:initEvents()

end

function BrowseTravelNoteInfoView:lvHandler(event)
    print_r(event)
end

function BrowseTravelNoteInfoView:addToNode(scene)
    self:addTo(scene)
end

function BrowseTravelNoteInfoView:onEnter()
    print("StartCommentCityView onenter()")
end

function BrowseTravelNoteInfoView:onExit()
    print("StartCommentCityView onExit()")
end

return BrowseTravelNoteInfoView