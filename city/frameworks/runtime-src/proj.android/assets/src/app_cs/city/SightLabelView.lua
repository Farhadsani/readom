
-- SightLabelView.lua   景点标签页面
-- add by star 2015.3.16

local SightLabelView = class("SightLabelView", function()
    return display.newLayer()
end)

function SightLabelView:ctor(param)

    -- map layer
    self.rootNode = cc.uiloader:load("ui/ScenicSpotLabelLayer.csb")
    self.rootNode:setPosition(cc.p(0, 0))
    self.rootNode:addTo(self)

    self.pnlBackGround = self.rootNode:getChildByName("pnlBackGround")
    self.txtPackName = self.pnlBackGround:getChildByName("txtPackName")
    self.pnlInput = self.pnlBackGround:getChildByName("pnlInput")
    self.lvContent = self.pnlBackGround:getChildByName("lvContent")
    self.close = self.rootNode:getChildByName("btnClose")
    self.ok = self.pnlBackGround:getChildByName("btnOK")

    self.packData = param.packData
    self.cityData = param.cityData

    self:initUI()
    self:initEvents()
end

function SightLabelView:setDelegate(delegate)
    self.delegate = delegate
end

function SightLabelView:initUI()
    self.txtPackName:setString(self.packData.cname)
    -- dump(self.packData)
    -- dump(self.cityData)
    local labelData = QMapGlobal.DataManager:getLabelData(self.cityData.cityid, self.packData.sightid)
    local labels = labelData and labelData.labels
    self.lvContent:removeAllChildren()
    -- local labelData = QMapGlobal.ortherData.labelData[self.cityData.name][self.packData.sightid]
    if labels and next(labels) then
        for key, label in ipairs(labels) do
            local cell = cc.CSLoader:createNode("ui/labelCell.csb") 
            -- cell:setScale(0.8)
            local bkNode = cell:getChildByName("pnlBack")
            local btn1 = bkNode:getChildByName("btn1")
            local btn2 = bkNode:getChildByName("btn2")

            btn1:setTitleText(label.text .. "  X "..label.like)
            btn2:setTitleText(label.text .. "  X "..label.like)
            --        sp:setTag(tag)
            if label.isowner or label.isliked then
                btn1:setVisible(false)
                btn2:setVisible(true)
            else
                btn1:setVisible(true)
                btn2:setVisible(false)
            end

            btn1:addTouchEventListener(function(sender, event)
                if event == 2 then
                    print("add image。。。。。。。。。")
                    self.delegate:onAgree(label.labelid)
                end
            end)

            local size = bkNode:getContentSize()
            local item = ccui.Layout:create()
            cell:setPosition(cc.p(size.width/2, size.height/2)) 
            item:setContentSize(size)
            cell:addTo(item)
            self.lvContent:insertCustomItem(item, key-1)
        end
    end
    
    local edSize = self.pnlInput:getContentSize()
    local eb = ccui.EditBox:create({width = edSize.width, height = edSize.height}, "Default/Button_Press.png")
    --    eb:setAnchorPoint(0, 1)
    eb:setPosition(cc.p(edSize.width/2,edSize.height/2))
    eb:setPlaceholderFontName("Arial")
    eb:setPlaceholderFontSize(48)
    eb:setPlaceholderFontColor(cc.c3b(0,0,0))
    eb:setFontName("Arial")
    eb:setReturnType(0)
    eb:setFontSize(48)
    eb:setPlaceHolder("你对景点的点评...")
    eb:setFontColor(cc.c3b(0,0,0))
    eb:setInputMode(0)
    eb:addTo(self.pnlInput)
    self.eb = eb
end

function SightLabelView:initEvents()
    --    self:setTouchEnabled(true)
    --    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.mapHandler))
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
end

function SightLabelView:mapHandler(event)
    print("CitySelectionView...... click...")

    if event.name == "began" then
        return true

    elseif event.name == "moved" then

    elseif event.name == "ended" then

    end
end

function SightLabelView:getLabel()
    return self.eb:getText()
end

function SightLabelView:addToNode(scene)
    self:addTo(scene)
end

function SightLabelView:onEnter()
    print("CitySelectionView onenter()")
end

function SightLabelView:onExit()
    print("CitySelectionView onExit()")
end

return SightLabelView