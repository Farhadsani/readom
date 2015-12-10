

-- EditMarkView.lua 城市场景 编辑mark界面
-- add by star 2015.3.9

local EditMarkView = class("EditMarkView", function()
    return display.newLayer()
end)

function EditMarkView:ctor(param)

    self.cityid = param.cityid
    self.sightid = param.sightid

    self.rootLayer = cc.uiloader:load("ui/EditMarkLayer.csb")
    self.rootLayer:addTo(self)
    
    self.pnlBackGround = self.rootLayer:getChildByName("pnlBackGround")
    self.lvImage = self.pnlBackGround:getChildByName("lvImage")
    self.btnOK = self.pnlBackGround:getChildByName("btnOK")
    self.txtPackName = self.pnlBackGround:getChildByName("txtPackName")
    self.txtMark = self.pnlBackGround:getChildByName("txtMark")
    self.btnDel = self.pnlBackGround:getChildByName("btnDel")
    
    self.btnBack = self.rootLayer:getChildByName("btnClose")
    self.spImageList = {}
    self:initEvents()
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

function EditMarkView:setDelegate(delegate)
    self.delegate = delegate
end

function EditMarkView:initUI(param)
    
    self.txtPackName:setString(param.sightName)
    self.txtMark:setString(param.mark)

    self:initImages(param.images)   
end

function EditMarkView:initImages( images )
    self.lvImage:removeAllChildren()
    self.index = 1
    self.btnAddImage = self:createButton(1 , 1)
    self.index = 2
    self.btnDelImage = self:createButton(2 , -1)
    self.index = 1
    if images and next(images) then
        for i,image in ipairs(images) do
            -- index = index + 1
            self.index = i
            self:createButton(i, 0, image.path, image.id)
            -- index = i
        end
    end
end

function EditMarkView:showAddImage( path , index, imageID)
    self.index = self.index + 1
    self:createButton(index, 0, path, imageID)
end

-- 
function EditMarkView:createButton( index, isAdd,  path, imageID )
    local addImageNode = cc.uiloader:load("ui/AddImageNode.csb")

    local pnlAddImage = addImageNode:getChildByName("pnlAddImage")
    local spImage = pnlAddImage:getChildByName("spImage")
    local pnlDelImage = addImageNode:getChildByName("pnlDelImage")
    local spSelect = addImageNode:getChildByName("spSelect")

    local size = pnlAddImage:getContentSize()
    local lvSize = self.lvImage:getContentSize()

    local nC = (self.index-1) % 3 
    local nR = math.floor((self.index-1) / 3) 
    addImageNode:setPosition(cc.p(size.width/2 + nC * (size.width+ 10), size.height/2)) 
    -- if nC == 0 then
    local item = self.lvImage:getItem(nR)
    if not item then
        item = ccui.Layout:create()
        self.lvImage:insertCustomItem(item, nR)
        item:setContentSize(cc.size(lvSize.width, size.height + 10))
    end
    
    addImageNode:addTo(item)
 
    pnlAddImage:setSwallowTouches(false)
    pnlDelImage:setSwallowTouches(false)
    if isAdd == 0 then   -- 显示一张图片
        table.insert( self.spImageList, spImage )
        pnlAddImage:setVisible(true)
        local beginPointX, beginPointY = 0,0
        pnlAddImage:addTouchEventListener(function ( sender, event )
            if event == 0 then
                local pTemp = sender:getTouchBeganPosition()
                beginPointX, beginPointY = pTemp.x, pTemp.y
            elseif event == 2 then
                local pTemp = sender:getTouchEndPosition()
                if math.abs(pTemp.x - beginPointX) < QMapGlobal.TouchAffectRange and  
                    math.abs(pTemp.y - beginPointY) < QMapGlobal.TouchAffectRange then
                        self.delegate:selectImage(imageID, function ( isSel )
                            spSelect:setVisible(isSel)
                        end)
                end
            end
        end)

        if path then
            print("图片的路径。。。。", path)
            spImage:setTexture(path)
            spImage:setVisible(true)

            local spSize = spImage:getContentSize()
            local pnlSize = spImage:getParent():getContentSize()
            local sW = pnlSize.width/spSize.width
            local sH = pnlSize.height/spSize.height
            local scale =  sW > sH and sW or sH 
            spImage:setScale(scale)
        end
    elseif isAdd == 1 then   --显示添加图片
        pnlDelImage:setVisible(false)
        pnlAddImage:setVisible(true)
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
    elseif isAdd == -1 then  -- 显示删除图片   
        pnlDelImage:setVisible(true)
        pnlAddImage:setVisible(false)

        pnlDelImage:addTouchEventListener(function ( sender, event )
            if event == 0 then
                local pTemp = sender:getTouchBeganPosition()
                beginPointX, beginPointY = pTemp.x, pTemp.y
            elseif event == 2 then
                local pTemp = sender:getTouchEndPosition()
                if math.abs(pTemp.x - beginPointX) < QMapGlobal.TouchAffectRange and  
                    math.abs(pTemp.y - beginPointY) < QMapGlobal.TouchAffectRange then
                    self.delegate:onDelImage()
                end
            end
        end)
    end

    if isAdd == 0 then
        local newIndex = self.index + 1
        if self.btnAddImage then 
            local nC = (newIndex-1) % 3 
            local nR = math.floor((newIndex-1) / 3) 
            self.btnAddImage:setPosition(cc.p(size.width/2 + nC * (size.width+ 10), size.height/2)) 
            local item = self.lvImage:getItem(nR)
            print(item)
            if not item then
                item = ccui.Layout:create()
                item:setContentSize(cc.size(lvSize.width, size.height + 10))
                self.lvImage:insertCustomItem(item, nR)
            end
            if nC == 0 then
                self.btnAddImage:retain()
                self.btnAddImage:removeFromParent()
                self.btnAddImage:addTo(item)
                self.btnAddImage:release()
            end
            newIndex = newIndex + 1
        end
        if self.btnDelImage then  -- 向后移动一个位置
            -- self.btnDelImage:setPosition()
            local nC = (newIndex-1) % 3 
            local nR = math.floor((newIndex-1) / 3) 
            self.btnDelImage:setPosition(cc.p(size.width/2 + nC * (size.width+ 10), size.height/2)) 
            local item = self.lvImage:getItem(nR)
            if not item then
                item = ccui.Layout:create()
                item:setContentSize(cc.size(lvSize.width, size.height + 10))
                self.lvImage:insertCustomItem(item, nR)
            end
            if nC == 0 then
                self.btnDelImage:retain()
                self.btnDelImage:removeFromParent(false)
                -- print(self.btnDelImage)
                -- self.btnDelImage:reta
                self.btnDelImage:addTo(item)
                self.btnDelImage:release()
            end
        end
    end
    
    
    return addImageNode
end

function EditMarkView:initEvents()
    self.btnBack:setSwallowTouches(false)
    self.btnOK:setSwallowTouches(false)
    self.btnDel:setSwallowTouches(false)
    self.btnBack:addTouchEventListener(function(sender, event)
        if event == 2 then
            print("关闭。。。。。。。。。")
            self.delegate:onBack()
        end
    end)

    self.btnOK:addTouchEventListener(function(sender, event)
        if event == 2 then
            print("确定。。。。。。。。。")
            self.delegate:onOK()
        end
    end)

    self.btnDel:addTouchEventListener(function(sender, event)
        if event == 2 then
            print("删除。。。。。。。。。")
            self.delegate:onDelMark()
        end
    end)
end

-- 返回本页面的点评信息
function EditMarkView:getMarkInfo()
    local markInfo = {}
    markInfo.mark = self.txtMark:getString() 
    markInfo.image = self.imageList
    -- dump(markInfo)
    return markInfo
end

function EditMarkView:lvHandler(event)
    print_r(event)
end

function EditMarkView:addToNode(scene)
    self:addTo(scene)
end

function EditMarkView:onEnter()
    print("StartCommentCityView onenter()")
end

function EditMarkView:onExit()
    print("StartCommentCityView onExit()")
end

return EditMarkView