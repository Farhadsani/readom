
-- BrowseCityView.lua 城市场景，游记页面

--[[    主页面参数：
cityName : 城市名称
]]--

local BrowseCityView = class("BrowseCityView", function()
    return display.newLayer()
end)

function BrowseCityView:ctor(param)

    self.cityData = param.cityData
    self:initUI()
    self:initEvents()
    local paramTest = {cityname = "桂林", username = "star", desc = "上天入地唯我独尊"}
    self:onRefresh(paramTest)
end

function BrowseCityView:setDelegate(delegate)
    self.delegate = delegate
    self.mapLayer.delegate = delegate
    self.menuLayer.delegate = delegate
end

function BrowseCityView:initUI()
    -- map layer
    self.mapLayer = require("app/views/MapLayer").new({mapName = self.cityData.name})
    self.mapLayer:addTo(self)

    -- menu layer
    self.menuLayer = require("app/views/MenuLayer").new()
    self.menuLayer:addTo(self)
end

-- 刷新界面数据
function BrowseCityView:onRefresh(param)
    -- 刷新菜单数据
    local pnlCaption = self.menuLayer.rootMenuNode:getChildByName("pnlCaption")
    local txtCityName = pnlCaption:getChildByName("txtCityName")
    local pnlImage = pnlCaption:getChildByName("pnlImage")
    local txtuserName = pnlCaption:getChildByName("txtuserName")
    local txtDesc = pnlCaption:getChildByName("txtDesc")
    
--    local param = {cityname = "桂林", username = "star", desc = "上天入地唯我独尊"}
    txtCityName:setString(param.cityname)
    txtuserName:setString(param.username)
    txtDesc:setString(param.desc)
    
    local stencilNode = cc.Sprite:create("ui/image/wBGCircle.png")    --模板 
    stencilNode:setScale(2)
    local clipNode = cc.ClippingNode:create()
    clipNode:setStencil(stencilNode)
    clipNode:setAnchorPoint(0.5,0.5)
    clipNode:setPosition(cc.p(90 ,90 ))
    clipNode:setAlphaThreshold(0)
    local sp1 = cc.Sprite:create( "13.jpg")
    sp1:addTo(clipNode)
    clipNode:addTo(pnlImage)
    
    -- 刷新地图数据
    
end

function BrowseCityView:initEvents()
    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.mapHandler))
end

function BrowseCityView:mapHandler(event)
    print("CitySelectionView...... click...")

    if event.name == "began" then
        return true

    elseif event.name == "moved" then

    elseif event.name == "ended" then
        self.delegate:cityTapped("CitySelectionView", {cityName = "qingdao"})
    end
end

function BrowseCityView:addToNode(scene)
    self:addTo(scene)
end

function BrowseCityView:onEnter()
    print("BrowseCityView onenter()")
end

function BrowseCityView:onExit()
    print("BrowseCityView onExit()")
end

function BrowseCityView:showMsg(strMsg)
    local msg = cc.uiloader:load("ui/messageBox.csb")
    local txtMsg = msg:getChildByName("pnlBG"):getChildByName("txtMsg")
    txtMsg:setString(strMsg)
    msg:setPosition(cc.p(display.width/2,display.height/2))
    msg:addTo(self)
    return msg
end

function BrowseCityView:closeMsg(node)
    node:removeFromParent()
end

return BrowseCityView
