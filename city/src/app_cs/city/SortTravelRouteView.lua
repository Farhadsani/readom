
-- SortTravelRouteView.lua 城市场景 行程排序页面
-- add by star 2015.3.19

local SortTravelRouteView = class("SortTravelRouteView", function()
    return display.newLayer()
end)

function SortTravelRouteView:setDelegate(delegate)
    self.delegate = delegate
end

function SortTravelRouteView:ctor(param)

    self.rootLayer = cc.uiloader:load("ui/EdittingLayer.csb")
    self.rootLayer:addTo(self)

    self.pnlBackGround = self.rootLayer:getChildByName("pnlBackground")
    self.pnlContent = self.pnlBackGround:getChildByName("lvContent")
    self.txtPageTitle = self.pnlBackGround:getChildByName("txtPageTitle")

    local btnBack = self.rootLayer:getChildByName("pnlBackground"):getChildByName("btnBack")
    btnBack:addTouchEventListener(function ( sender, event )
        if event == 2 then
            print("关闭。。。。。。。。。")
            self.delegate:onBack()
        end
    end)

    self.txtPageTitle:setString("排序")
    self.cityID = param.cityid

    self:onInit()
end

function SortTravelRouteView:onInit(  )
    local cityData = QMapGlobal.systemData.mapData[self.cityID]
    
    local itinerarysData = QMapGlobal.userData.userBaseInfo.itinerarys
    local cityItinerarys = itinerarysData[self.cityID]
    if not cityItinerarys then return end

    self.pnlContent:removeAllChildren()
    
    self.cellList = {}   -- 记录所有item项
    self.cellListIndex = {}  -- 按照索引记录，方便查找
    local cellCount = table.nums(cityItinerarys)
    -- local i = 0
    local pnlContentHeight = 0
    local moveOff = 0   --移动距离偏移量，取cell高度的一半
    local cellOff = 0  --当滚动视图内部大小比外部小时，该值大于0
    for i, cityItinerary in pairs(cityItinerarys) do
        -- i = i + 1
        local cell = cc.CSLoader:createNode("ui/TravelNoteCell.csb")   
        local item = ccui.Layout:create()  

        local pnlCell = cell:getChildByName("pnlCell")
        local pnlCellBackground = pnlCell:getChildByName("pnlCellBackground")
        local btnMove = pnlCellBackground:getChildByName("btnMove")
        local btnEdit = pnlCellBackground:getChildByName("btnDel")
        local txtPackName = pnlCellBackground:getChildByName("txtPackName")
        local pnlSerial = pnlCell:getChildByName("pnlSerial")
        local txtSerial = pnlSerial:getChildByName("txtSerial")
        local pnlPackImage = pnlCellBackground:getChildByName("pnlPackImage")
        local spPackImage = pnlPackImage:getChildByName("spPackImage")

        txtPackName:setString("")
        local sightID = cityItinerary
        local sightData = cityData.sight
        for _,sight in pairs(sightData) do
            if sight.sightid == tonumber(sightID) then
                txtPackName:setString(sight.cname)
                local imagePath = "map/" .. cityData.name .. "/sightImage/"..sightID.."/1.jpg"
                -- print("这是城市景点的路径。。", imagePath)
                spPackImage:setTexture(imagePath)

                local spSize = spPackImage:getContentSize()
                local pnlSize = pnlPackImage:getContentSize()
                local sW = pnlSize.width/spSize.width
                local sH = pnlSize.height/spSize.height
                local scale =  sW > sH and sW or sH 
                spPackImage:setScale(scale)
                break
            end
        end

        local moveX = 0
        local moveY = 0
        btnMove:addTouchEventListener(function(sender, event)
            -- print("move......", event)
            if event == 0 then
                print("moveCell begin.......")
                cell:setOpacity(100)
                local p = sender:getTouchBeganPosition()
                moveX = p.x
                moveY = p.y
                print_r(p)
            elseif event == 1 then
                print("moveCell move.......")
                local p = sender:getTouchMovePosition()
                --                local dx = p.x - moveX
                local dy = p.y - moveY
                local posX, posY = item:getPosition()
                item:setPosition(cc.p(posX , posY + dy))

                if dy > 0 then  -- 向上滑动
                    local selfCell = self.cellList[sender]
                    local nextCellNode = self.cellListIndex[selfCell.index-1]
                    local nextCell = self.cellList[nextCellNode]

                    if nextCell then
                        if posY > nextCell.pos.y - moveOff  + cellOff then

                            nextCell.node:setPosition(cc.p(selfCell.pos.x, selfCell.pos.y + cellOff))
                            self.cellListIndex[nextCell.index], self.cellListIndex[selfCell.index] = sender, nextCellNode
                            nextCell.index, selfCell.index = selfCell.index, selfCell.index-1

                            nextCell.pos, selfCell.pos = {x = selfCell.pos.x, y = selfCell.pos.y}, {x = nextCell.pos.x, y = nextCell.pos.y}
                        end
                        nextCell.txtSerial:setString(nextCell.index)
                    end
                    selfCell.txtSerial:setString(selfCell.index)
                elseif dy < 0 then  -- 向下滑动
                    local selfCell = self.cellList[sender]
                    local nextCellNode = self.cellListIndex[selfCell.index+1]
                    local nextCell = self.cellList[nextCellNode]

                    if nextCell then
                        if posY < nextCell.pos.y + moveOff   + cellOff then

                            nextCell.node:setPosition(cc.p(selfCell.pos.x, selfCell.pos.y + cellOff))
                            self.cellListIndex[nextCell.index], self.cellListIndex[selfCell.index] = sender, nextCellNode
                            nextCell.index, selfCell.index = selfCell.index, selfCell.index+1

                            nextCell.pos, selfCell.pos = {x = selfCell.pos.x, y = selfCell.pos.y}, {x = nextCell.pos.x, y = nextCell.pos.y}
                        end
                        nextCell.txtSerial:setString(nextCell.index)
                    end 
                    selfCell.txtSerial:setString(selfCell.index)
                end

                --                print("移动的幅度。。。。。", dy)
                --                print_r(p)
                local glPos = self.rootLayer:convertToNodeSpace(p)
                -- print("..................")
                -- print_r(glPos)
                if glPos.y < 100 then
                    --                    pnlContent:scrollToPercentVertical(10, 0.01, false)
                    --                    pnlContent:jumpToPercentVertical(10)
                end

                --                print("世界坐标系")
                --                print_r(glPos)
                --                local layer = display.newLayer()
                --                layer.

                --                sender:(p)
                moveX = p.x
                moveY = p.y
                -- print_r(p)
            else   -- event is 2 or 3
                print("moveCell end.......")
                local p1 = sender:getTouchEndPosition()
                -- print_r(p1)
                cell:setOpacity(255)
                local tableCell = self.cellList[sender]
                -- print(i, tableCell.pos.x, tableCell.pos.y)
                tableCell.node:setPosition(cc.p(tableCell.pos.x, tableCell.pos.y + cellOff))

                --修改顺序
                self.delegate:onAlterOrder(self.cellList)
            end
        end)
        
        btnEdit:addTouchEventListener(function(sender, event)
            -- print_r(event)
            if event == 0 then 

                return true
            elseif event == 1 then
                -- print(param)
                -- print_r(event)
                --                item:setPosition(cc.P())
            elseif event == 2 then
                print("move。。。。。。。。。")
                self.delegate:onDel(sightID)
            end
        end)
        --        local t = p:getChildByName("txtCaption")
        --        t:setString("这是第"..i.."个")
        
        txtSerial:setString(i)
        local cellSize = pnlCell:getContentSize()
        pnlContentHeight = pnlContentHeight + cellSize.height + 10
        moveOff = cellSize.height/2
        item:setContentSize(cc.size(cellSize.width, cellSize.height + 10))
        local itemY = (cellSize.height+10)*(cellCount-i)    --340*10 - 340*(i-1) - 170
        local itemX = (1080 - cellSize.width)/2
        item:setPosition(cc.p(itemX, itemY))
        print(i, itemX, itemY, cellSize.width, cellSize.height)
        cell:setPosition(cc.p(cellSize.width/2, (cellSize.height+10)/2))
        cell:addTo(item)
        item:addTo(self.pnlContent)
        --        table.insert(self.cellList, )

        self.cellList[btnMove] = {node = item, pos = {x = itemX, y = itemY}, index = i, sightid = cityItinerary, txtSerial = txtSerial}
        self.cellListIndex[i] = btnMove

        --        pnlContent:insertCustomItem(item, i-1)   -- 此处不能直接添加cell节点
    end
    local pnlSVSize = self.pnlContent:getContentSize()
    if pnlSVSize.height > pnlContentHeight then
--        pnlSVSize.height = pnlContentHeight
--        pnlContent:setContentSize(pnlSVSize)
        cellOff = pnlSVSize.height - pnlContentHeight
    end
    
    self.pnlContent:setInnerContainerSize(cc.size(1080, pnlContentHeight))
    -- print("pnlContent height ", pnlContentHeight)
end

function SortTravelRouteView:setDelegate(delegate)
    self.delegate = delegate
end

function SortTravelRouteView:initUI()

end

function SortTravelRouteView:initEvents()

end

function SortTravelRouteView:lvHandler(event)
    print_r(event)
end

function SortTravelRouteView:addToNode(scene)
    self:addTo(scene)
end

function SortTravelRouteView:onEnter()
    print("StartCommentCityView onenter()")
end

function SortTravelRouteView:onExit()
    print("StartCommentCityView onExit()")
end

return SortTravelRouteView