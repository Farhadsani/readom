
-- SightBrowseRemarkView.lua   景点评论页面
-- add by star 2015.3.16

local SightBrowseRemarkView = class("SightBrowseRemarkView", function()
    return display.newLayer()
end)

function SightBrowseRemarkView:ctor(param)
    -- print("当前进入SightBrowseRemarkView。。。。。。。。。。。。。。。。")
    -- map layer
    self.rootNode = cc.uiloader:load("ui/ScenicSpotCommentLayer.csb")
    self.rootNode:setPosition(cc.p(0, 0))
    self.rootNode:addTo(self)

    self.pnlBackGround = self.rootNode:getChildByName("pnlBackGround")
    self.txtPackName = self.pnlBackGround:getChildByName("txtPackName")
    self.lvContent = self.pnlBackGround:getChildByName("lvContent")
    self.close = self.rootNode:getChildByName("btnClose")

    self.packData = param.packData
    self.cityData = param.cityData

    -- self:initUI()
    self:initEvents()
end

function SightBrowseRemarkView:setDelegate(delegate)
    self.delegate = delegate
end

function SightBrowseRemarkView:initCell( node, comment )
    local txtUserName = node:getChildByName("txtUserName")
    local txtTime = node:getChildByName("txtTime")
    local txtSightName = node:getChildByName("txtSightName")
    local txtComment = node:getChildByName("txtComment")
    local txtCaption = node:getChildByName"txtCaption"
    local txtOrder = node:getChildByName"pnlOrder" -- :getChildByName"txtOrder"
    local spUserPic = node:getChildByName"pnlUserPic":getChildByName"spUserPic"
    local pnlMainPic = node:getChildByName"pnlMainPic"
    -- local userName = comment.userName or QMapGlobal.ortherData.userIDName[comment.userid]
    txtUserName:setString(comment.username)
    txtTime:setString(comment.journey.ctime)
    -- local cityData = QMapGlobal.systemData.mapData[self.packData.sightid]
    -- local sightData = cityData.sight[comment.sightid]
    txtSightName:setVisible(false)
    txtComment:setString(comment.journey.mark)
    txtOrder:setVisible(false)
    txtCaption:setString("【"..comment.title.."】")
    -- self.journey:getAuthorid()
    local authorImagePath = "user/" .. comment.userid .. ".jpg"
    spUserPic:setTexture(authorImagePath)

    -- local fu = cc.FileUtils:getInstance()
    -- local writePath = fu:getWritablePath()

    local downloadPath = cc.FileUtils:getInstance():getDownloadPath()

    local images = comment.journey and comment.journey.image
    local i = 1
    if images and next(images) then
        for k,image in pairs(images) do
            if i > 6 then break end
            -- local imagePath = self.journey:getThumbnailPathForImage( mark.sightid, image.id)
            -- local imagePath = "img/journey/thumb/" .. tostring(self.cityData.cityid) .. "/"
            --          .. tostring(comment.userid) .. "/"
            --          .. tostring(comment.journeyid) .. "/"
            --          -- .. tostring(sightid) .. "/"
            --          .. tostring(comment.markid) .. "/"
            --          .. tostring(image.id) .. ".jpg"
            -- local imagePath = device.writablePath.. "temp/" 
            local imagePath = downloadPath .. "temp/"
                .. comment.cityid .. "/" 
                .. comment.userid .."/" 
                .. image.imgname
            -- if io.exists(writePath .. imagePath) then
                local sp = display.newSprite(imagePath)
                local spSize = sp:getContentSize()
                local pnlPic = pnlMainPic:getChildByName("pnlPic"..i)
                if pnlPic then
                    local pnlSize = pnlPic:getContentSize()
                    local sW = pnlSize.width/spSize.width
                    local sH = pnlSize.height/spSize.height
                    local scale =  sW > sH and sW or sH 
                    sp:setScale(scale)
                    pnlPic:setVisible(true)
                    pnlPic:setSwallowTouches(false)
                    sp:setPosition(cc.p(pnlSize.width/2, pnlSize.height/2))
                    sp:addTo(pnlPic)

                    local beginPointX, beginPointY = 0,0
                    pnlPic:addTouchEventListener(function ( sender, event )
                        if event == 0 then
                            local pTemp = sender:getTouchBeganPosition()
                            beginPointX, beginPointY = pTemp.x, pTemp.y
                        elseif event == 2 then
                            local pTemp = sender:getTouchEndPosition()
                            if math.abs(pTemp.x - beginPointX) < QMapGlobal.TouchAffectRange and  
                                math.abs(pTemp.y - beginPointY) < QMapGlobal.TouchAffectRange then
                                self.delegate:onShowImages(comment, self.cityData.cityid, k)
                            end
                        end
                    end)
                end
            -- end
            i = i+1
        end
    end
end

function SightBrowseRemarkView:initUI(commentData)
    local pnlUserPiclist = {}
    self.txtPackName:setString(self.packData.cname)
    -- print(self.cityData.name)
    -- local commentDatas = QMapGlobal.ortherData.commentData[self.cityData.name]
    -- local commentData = commentDatas and commentDatas[self.packData.sightid]
    -- print_r(self.packData)
    if commentData and next(commentData) then
        for key, comment in ipairs(commentData) do
            local cell = cc.CSLoader:createNode("ui/scenicSpotNoteCell.csb") 
            local bkNode = cell:getChildByName("pnlBack")
            self:initCell(bkNode, comment)

            local size = bkNode:getContentSize()
            local item = ccui.Layout:create()
            cell:setPosition(cc.p(size.width/2, size.height/2)) 
            item:setContentSize(size)
            cell:addTo(item)
            
            self.lvContent:insertCustomItem(item, key-1)
        end
    end
    -- print("测试滚动条。。。。。。。。。。。。。。")
--    for key, var in ipairs(pnlUserPiclist) do
--        
--        local stencilNode = cc.Sprite:create("ui/image/wBGCircle.png")    --模板 
--        local clipNode = cc.ClippingNode:create()
--        clipNode:setStencil(stencilNode)
----        clipNode:setAnchorPoint(0.5,0.5)
--        clipNode:setPosition(cc.p(40 ,40 ))
--        clipNode:setAlphaThreshold(0)
--        clipNode:setInverted(true)
----        clipNode:setContentSize(80,80)
--
--        local layerTest = display.newColorLayer(cc.c4b(0,255,0,0))
--        clipNode:addChild(layerTest)
--
--        local sp1 = cc.Sprite:create("ui/image/wBGCircle.png") -- "wFrameBG.png")
--        sp1:setScale(1.2)
--        sp1:addTo(clipNode)
--        clipNode:addTo(var)
--    end

end

function SightBrowseRemarkView:initEvents()
    --    self:setTouchEnabled(true)
    --    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.mapHandler))
    self.close:addTouchEventListener(function(sender, event)
        if event == 2 then
            print("关闭。。。。。。。。。")
            self.delegate:onClose()
        end
    end)
end

function SightBrowseRemarkView:mapHandler(event)
    print("CitySelectionView...... click...")

    if event.name == "began" then
        return true

    elseif event.name == "moved" then

    elseif event.name == "ended" then

    end
end


function SightBrowseRemarkView:addToNode(scene)
    self:addTo(scene)
end

function SightBrowseRemarkView:onEnter()
    print("CitySelectionView onenter()")
end

function SightBrowseRemarkView:onExit()
    print("CitySelectionView onExit()")
end

return SightBrowseRemarkView
