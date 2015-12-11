-- EditSightRemarkView.lua 城市场景 开始点评页面
-- add by star 2015.3.9

local EditSightRemarkView = class("EditSightRemarkView", function()
    return display.newLayer()
end)

function EditSightRemarkView:ctor(param)

    self.cityid = param.cityid

    self.rootLayer = cc.uiloader:load("ui/EdittingLayer.csb")
    self.rootLayer:addTo(self)
    
    self.pnlBackGround = self.rootLayer:getChildByName("pnlBackground")
    self.pnlContent = self.pnlBackGround:getChildByName("lvContent")
    
    
    local btnBack = self.pnlBackGround:getChildByName("btnBack")
    btnBack:addTouchEventListener(function ( sender, event )
        if event == 2 then
            print("关闭。。。。。。。。。")
            self.delegate:onBack()
        end
    end)

    self:initUI()
end

function EditSightRemarkView:setDelegate(delegate)
    self.delegate = delegate
end

function EditSightRemarkView:initUI()
    local userJourneys = QMapGlobal.userData.userInfo.journeys
    print("current cityid is ".. self.cityid )
    local cityid = tonumber(self.cityid)
    local userJourney = userJourneys[cityid]
    if not userJourney or not userJourney.journey then
        printInfo("the is no journeyData")
        return
    end

    self.cellList = {}   -- 记录所有item项
    self.cellListIndex = {}  -- 按照索引记录，方便查找
    -- print("尼玛这个列表是。。。。。。。。")
    -- print_r(userJourney.journey)
    local journeys = userJourney.journey
    local cellCount = table.nums(journeys)

    self.pnlContent:removeAllChildren()
 
    journeys = sequenceSort(journeys, {{"order", 1}})   -- 按照order字段，升序排列
    -- print("尼玛这个值要是2，", cellCount)
    local pnlContentHeight = 0
    local moveOff = 0
    local cellOff = 0  --当滚动视图内部大小比外部小时，该值大于0
    for i, journey in ipairs(journeys) do

        local cell = cc.CSLoader:createNode("ui/EdittingCell.csb")   
        local item = ccui.Layout:create()  
        local pnlCell = cell:getChildByName("pnlCell")
        local pnlCellBackground = pnlCell:getChildByName("pnlCellBackground")
        local btnMove = pnlCellBackground:getChildByName("btnMove")
        local txtComment = pnlCellBackground:getChildByName("txtComment")
        local txtPackName = pnlCellBackground:getChildByName("txtPackName")
        local pnlSerial = pnlCell:getChildByName("pnlSerial")
        local txtSerial = pnlSerial:getChildByName("txtSerial")
        local pnlPic = pnlCellBackground:getChildByName("pnlPic")

        -- print("qwwwwewqwfadsfjabsdjhfgasjdh")
        print_r(journey)
        txtComment:setString(journey.mark)
        local sightName = ""
        local sightid = tonumber(journey.sightid)
        local cityData = QMapGlobal.systemData.mapData[cityid]
        local sights = cityData.sight
        for _, sight in pairs(sights) do
            if sight.sightid == sightid then
                sightName = sight.cname
                break
            end
        end
        txtPackName:setString(sightName)

        local fu = cc.FileUtils:getInstance()

        local images = journey.image
        if images and next(images) then
            local i = 1
            for k,image in pairs(images) do
                local pnlImage = pnlPic:getChildByName("pnlImage".. i)
                if pnlImage then
                    -- local imagePath = fu:getWritablePath() .. "img/journey/full/".. cityid .. "/" .. sightid .. "_" .. journey.markid .. "_" .. image.id ..".jpg"
                    local imagePath = fu:getDownloadPath() .. "img/journey/full/".. cityid .. "/" .. sightid .. "_" .. journey.markid .. "_" .. image.id ..".jpg"
                    print("设置图片的路径。。", imagePath)
                    local spImage = pnlImage:getChildByName("spImage")
                    spImage:setTexture(imagePath)
                    spImage:setVisible(true)

                    local spSize = spImage:getContentSize()
                    local pnlSize = spImage:getParent():getContentSize()
                    local sW = pnlSize.width/spSize.width
                    local sH = pnlSize.height/spSize.height
                    local scale =  sW > sH and sW or sH 
                    spImage:setScale(scale)
                end
                i = i +1
            end
        end
        
        local moveX = 0
        local moveY = 0
        btnMove:addTouchEventListener(function(sender, event)
            -- print("move......", event)
            if event == 0 then
                print("move begin.......")
                cell:setOpacity(100)
                local p = sender:getTouchBeganPosition()
                moveX = p.x
                moveY = p.y
                print_r(p)
            elseif event == 1 then
                print("move move.......")
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

--                            self.cellList[i], self.cellList[i-1] = self.cellList[i-1], self.cellList[i]
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
                        if posY < nextCell.pos.y + moveOff  + cellOff then

                            nextCell.node:setPosition(cc.p(selfCell.pos.x, selfCell.pos.y + cellOff))
--                            local actMove = cc.MoveTo:create(0.05, cc.p(selfCell.pos.x, selfCell.pos.y))
--                            local act2 = cc.EaseSineIn:create(actMove)
--                            nextCell.node:runAction(act2)

                            --                            self.cellList[i], self.cellList[i-1] = self.cellList[i-1], self.cellList[i]
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
                print("..................")
                print_r(glPos)
                if glPos.y < 100 then
--                    pnlContent:scrollToPercentVertical(10, 0.01, false)
                    -- pnlContent:jumpToPercentVertical(10)
                end
               
                moveX = p.x
                moveY = p.y
                print_r(p)
            else   -- event is 2 or 3
                print("move end.......")
                cell:setOpacity(255)
                local p1 = sender:getTouchEndPosition()
--                local p2 = sender:getTouchMovePosition()
                print_r(p1)
                
                local tableCell = self.cellList[sender]
                print(i, tableCell.pos.x, tableCell.pos.y)
                tableCell.node:setPosition(cc.p(tableCell.pos.x, tableCell.pos.y + cellOff))
                
                --修改顺序
                self.delegate:onAlterOrder(self.cellList)
            end
        end)
        local btnEdit = pnlCellBackground:getChildByName("btnEdit")

        btnEdit:addTouchEventListener(function(sender, event)
            print_r(event)
            if event == 0 then 
                

                return true
            elseif event == 1 then
                -- print(param)
                -- print_r(event)
--                item:setPosition(cc.P())
            elseif event == 2 then
                print("edit。。。。。。。。。")
               self.delegate:onEdit(journey.markid, sightid)
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
        
        self.cellList[btnMove] = {node = item, pos = {x = itemX, y = itemY}, index = i, journey = journey, txtSerial = txtSerial}
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
    print("pnlContent height ", pnlContentHeight)
    
--    pnlContent:setContentSize(cc.size(1080,340*10))
    print_r(self.pnlContent)
    print("pnlContent:isInertiaScrollEnabled:", self.pnlContent:isInertiaScrollEnabled())
--    pnlContent:addEventListener(function(paam, p2, p3)
--        print("...............")
--        print(p2)
--        print_r(p2)
--        print_r(p3)
--    end)

--    local size1 = pnlContent:getInnerContainerSize()
--    print("11111111111111111111")
--    print_r(size1)
end

function EditSightRemarkView:initEvents()

end

function EditSightRemarkView:lvHandler(event)
    print_r(event)
end

function EditSightRemarkView:addToNode(scene)
    self:addTo(scene)
end

function EditSightRemarkView:onEnter()
    print("StartCommentCityView onenter()")
end

function EditSightRemarkView:onExit()
    print("StartCommentCityView onExit()")
end

return EditSightRemarkView