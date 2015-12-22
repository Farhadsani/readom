-- DataManager.lua 数据管理
-- add by star 2015.3.20

local GameState=require(cc.PACKAGE_NAME .. ".cc.utils.GameState")
-- 请不要直接使用 DataManager 调用这里的方法，请使用 QMapGlobal.DataManager
local DataManager = class("DataManager")

local netWorkManager = require("app_cs/data/NetWorkManager").new()   -- 操作网络
local dataBaseManager = require("app_cs/data/DataBaseManager").new()  -- 操作数据库
local tableFields = require("app_cs/resData/TableFields")   -- 加载字段表


function DataManager:ctor(p)
    -- 初始化用户状态
    self.param = p

    -- 删除临时文件
    self:deleteTempFile()
    ---------------------------

    GameState.init(function(param)
        local returnValue=nil
        if param.errorCode then
            printInfo(param.errorCode)
        else
            -- crypto
            if param.name=="save" then
                local str=json.encode(param.values)
                str=crypto.encryptXXTEA(str, "abcd")
                returnValue={data=str}
            elseif param.name=="load" then
                local str=crypto.decryptXXTEA(param.values.data, "abcd")
                returnValue=json.decode(str)
            end
            -- returnValue=param.values
        end
        return returnValue
    end, "UserFile.txt", "stone")

    
    local gameState = GameState.load()
    print("开始加载数据。。。。。。。。。。。。")
    print_r(gameState)
    if gameState and gameState.ver then
        QMapGlobal.gameState = gameState
        QMapGlobal.gameState.ver = gameState.ver
        -- QMapGlobal.gameState.userid = gameState.userid
        -- QMapGlobal.gameState.pw = gameState.pw
    else
        -- QMapGlobal.gameState = QMapGlobal.gameState or {}
        -- QMapGlobal.gameState.ver = QMapGlobal.ver
        GameState.save(QMapGlobal.gameState)
    end

    self:getNewVer()
    -- 初始化系统数据
    -- self:initSystemData()-- 移动到外部调用
    -- 初始化用户数据
    -- self:initUserClickCityData()
    -- self:initUserData()
    -- self:initUserBaseData()

    -- dataBaseManager:commitTransaction()
end

function DataManager:saveGameState( ... )
    GameState.save(QMapGlobal.gameState)
end

function DataManager:deleteTempFile( ... )
    local fu = cc.FileUtils:getInstance()
    local downloadPath = fu:getDownloadPath()
    -- local path = device.writablePath .. "specialitys/"
    local path = downloadPath .. "specialitys/"
    if fu:isDirectoryExist(path) then
        fu:removeDirectory(path)
    end

    path = downloadPath .. "topicHot/" 
    if fu:isDirectoryExist(path) then
        -- fu:removeDirectory(path)
    end
end

-- 加载数据,第一次启动程序，将内置的数据导入到数据中
-- 以后直接加载数据库数据  
function DataManager:loadData(  )
    print("load data.............")
    -- 1. 检查CityTable是否存在 
    if not dataBaseManager:isTableExist("city") then  -- 不存在，则创建  ，导入内置数据
        --创建city表
        dataBaseManager:createTable("city", tableFields.cityFields)

        local mapData = QMapGlobal.systemData.mapData
        local sqlTable = {}
        for key, data in pairs(mapData) do
            
            -- local sightBase = "sight_base_" .. data.cityid
            -- local sightDesc = "sight_desc_" .. data.cityid
            local tColor = string.format("%X%X%X%X", data.tColor.r, data.tColor.g, data.tColor.b, data.tColor.z)
            local bColor = string.format("%X%X%X%X", data.bColor.r, data.bColor.g, data.bColor.b, data.bColor.z)
            -- dataBaseManager:insertValue("city", {data.cityid, data.name, data.cname, data.pos.x, 
            --     data.pos.y, data.provid , tColor, bColor, data.version, data.versioninfo, 0})
            local sqlString = dataBaseManager:getInsertString("city", {data.cityid, data.name, data.cname, data.pos.x, 
                data.pos.y, data.provid , tColor, bColor, data.version, data.versioninfo, 0})
            table.insert(sqlTable, sqlString)
        end

        if sqlTable and next(sqlTable) then
            dataBaseManager:commitTransaction(sqlTable)
        end

    else  -- 读取数据库中得数据
        --  QMapGlobal.systemData.mapData = {}
        -- 初始化city数据
        local CityTable = dataBaseManager:select("city")      
        local CityTableCopy = {}

        local fu = cc.FileUtils:getInstance()

        local downloadPath = cc.FileUtils:getInstance():getDownloadPath()

        for _, city in pairs(CityTable) do
            city.pos = {x = tonumber(city.posX), y = tonumber(city.posY)}
            city.posX = nil
            city.posY = nil
            city.tColor = analysisColor(city.bgcolortop)
            city.bColor = analysisColor(city.bgcolorend)
            city.version = tonumber(city.version)
            city.versioninfo = tonumber(city.versioninfo)
            city.cityid = tonumber(city.cityid)
            city.provid = tonumber(city.provid)
            -- city.clickcount = tonumber(city.clickcount)

            local sightBase = "sight_base_" .. city.cityid
            local sightDesc = "sight_desc_" .. city.cityid

            local isNative = false
            local sights = {}
            -- local sightPath = device.writablePath .. "map/" .. city.name .. "/" .. city.name .. "sight.json"
            local sightPathN = "res/ui/map/" .. city.name .. "/" .. city.name .. "sight.json"
            local sightPathDL = downloadPath .. "map/" .. city.name .. "/" .. city.name .. "sight.json"
            print("读取json文件。。", sightPathDL, sightPathN)
            if fu:isFileExist(sightPathDL) then
                print("下载存在json文件，需要从json中获取数据！")
                sights = self:getSightFromJsonFile(sightPathDL)
            else  --if fu:isFileExist(sightPathN) then
                print("本地存在json文件，需要从json中获取数据！")
                sights = self:getSightFromJsonFile(sightPathN)
            -- else   -- 没有对应的sight文件
            --     print("没有找到景点文件")
            --     local cityData = QMapGlobal.systemData.mapData[city.cityid]
            --     if cityData and cityData.sight then
            --         sights = clone(cityData.sight)
            --         isNative = true
            --     end
            end
            city.sight = sights
            city.isNative = isNative
            
            dump(city)
            CityTableCopy[city.cityid] = city


            -- local labelName = "card_label_" .. cityID
            local cards = dataBaseManager:select("card_"..city.cityid) 
            -- dump(cards)
            if cards and next(cards) then
                local cardsTemp = {}
                for k, card in pairs(cards) do
                    local labels = dataBaseManager:select("card_label_"..city.cityid, {"label"}, {{fieldName = "cardid", fieldValue = card.cardid}})
                    -- dump(labels)
                    card.label = {}
                    for _,label in pairs(labels) do
                        table.insert(card.label, label.label)
                    end

                    card.cardid = tonumber(card.cardid)
                    card.collectcount = tonumber(card.collectcount)
                    card.imgid = tonumber(card.imgid)
                    card.iscollect = tonumber(card.iscollect)
                    card.source = tonumber(card.source)
                    card.starlevel = tonumber(card.starlevel)
                    card.type = tonumber(card.type)
                    cardsTemp[card.cardid] = card
                    print("从数据库中获得的卡牌的状态，", card.cardname, card.iscollect)
                end

                local cardData = {cards = cardsTemp}
                cardData.ver = tonumber(city.cardver)
                QMapGlobal.cardDatas[city.cityid] = cardData
                -- dump(cardData)
            end

            -- dump(QMapGlobal.cardDatas[2])

        end
        QMapGlobal.systemData.mapData = CityTableCopy
        dump(QMapGlobal.systemData.mapData[1])
    end
end

function DataManager:getSightFromJsonFile( jsonFile )
    local fileUtil = cc.FileUtils:getInstance()
    -- local fullPath = fileUtil:fullPathForFilename(jsonFile)
    -- print(fullPath)
    local jsonStr = fileUtil:getStringFromFile(jsonFile)
    -- print(jsonStr)
    local jsonVal = json.decode(jsonStr)
    -- print("========================")
    -- dump(jsonVal)
    -- print("---------------------")
    local sights = {}
    local sights_file = jsonVal and jsonVal.sights
    if sights_file and next(sights_file) then
        for _, sightSrc in pairs(sights_file) do
            local sight = {}
            sight.sightid = tostring(sightSrc.sightid)
            sight.name = tostring(sight.sightid)
            sight.cname = sightSrc.cname
            local descs = {}
            local descsSrcs = sightSrc.descs
            if descsSrcs and next(descsSrcs) then
                descs = clone(descsSrcs)
            end
            sight.desc = descs
            sight.type = sightSrc.type or SpaceType_sight
            sight.type = tonumber(sight.type)

            sights[sight.sightid] = sight
        end
    end

    return sights
end

function DataManager:initSystemData(LoadDataOverCallBack)
    LoadDataOverCallBack()
    do return end
    -- 加载数据
    self:loadData()
    -- 联网获取网络数据
    self:getCityList(function ( cityData )
        local mapData = {}
        dump(cityData)

        for i, item  in pairs(cityData) do
            local cityid = tonumber(item.cityid)
            if cityid and cityid ~= 0 then
  
                mapData[cityid] = {
                    cityid = cityid,
                    name = item.name,
                    cname = item.cname,
                    provid = item.provid or 0,
                    pos = {x = item.pos_x, y = item.pos_y},
                    tColor = analysisColor(item.bgcolortop),
                    bColor = analysisColor(item.bgcolorend),
                    version = item.version,
                    -- newVersion = item.version,
                    -- versioninfo = item.versioninfo
                }

                -- item.iconfile
                -- local fu = cc.FileUtils:getInstance()
                -- local downloadPath = fu:getDownloadPath()
                -- local ballPath = downloadPath .. "map/" .. item.name .. "/image/"
                -- cc.FileUtils:getInstance():createDirectory(ballPath)
                -- print("开始下载ball", ballPath , item.cname)
                -- ballPath = ballPath .. item.name .. "ball.png"
                -- if not fu:isFileExist(ballPath) then
                --     netWorkManager:getUrlFile(item.iconfile, ballPath, function (  )
                --     end, function (  )
                --         -- body
                --     end)
                -- end
  
                QMapGlobal.tempCityBall[cityid] = {name = item.name, ballUrl = item.iconfile}
                
            end
        end
        -- QMapGlobal.systemData.mapData = mapData

        local nativeCityDatas = {}
        for k, cityData in pairs(mapData) do
            local cityID = cityData.cityid
            local nativeCityData = QMapGlobal.systemData.mapData[cityID]
            if not nativeCityData then  -- 本地不存在，需要添加
                -- dump(cityData)
                print("->>>>>, 新增的数据", cityData.name)
                nativeCityData = cityData
                nativeCityData.state = "newData"
                nativeCityData.newVersion = nativeCityData.version
                nativeCityData.version = 0

                -- 添加到数据库中
                local tColor = string.format("%X%X%X%X", cityData.tColor.r, cityData.tColor.g, 
                            cityData.tColor.b, cityData.tColor.z or 255)
                local bColor = string.format("%X%X%X%X", cityData.bColor.r, cityData.bColor.g, 
                            cityData.bColor.b, cityData.bColor.z or 255)
                -- print("向数据库中添加的数据。。。。。。。。")
                -- print(cityID, cityData.name, cityData.cname, cityData.pos.x, 
                --     cityData.pos.y, cityData.provid , tColor, bColor, 0, 0)
                dataBaseManager:insertValue("city", {cityID, cityData.name, cityData.cname, cityData.pos.x, 
                    cityData.pos.y, cityData.provid , tColor, bColor, 0, 0, 0})           
            else

                -- print("->>>>>>", nativeCityData.isNative)
                local alterParam = {}
                if nativeCityData.name ~= cityData.name then
                    nativeCityData.name = cityData.name
                    alterParam.name = cityData.name
                end
                if nativeCityData.cname ~= cityData.cname then
                    nativeCityData.cname = cityData.cname
                    alterParam.cname = cityData.cname
                end
                if nativeCityData.pos.x ~= cityData.pos.x or nativeCityData.pos.y ~= cityData.pos.y then
                    nativeCityData.pos = {x = cityData.pos.x, y = cityData.pos.y}
                    alterParam.posX = cityData.pos.x
                    alterParam.posY = cityData.pos.y
                end
                if nativeCityData.tColor.r ~= cityData.tColor.r or nativeCityData.tColor.g ~= cityData.tColor.g
                    or nativeCityData.tColor.b ~= cityData.tColor.b or nativeCityData.tColor.z ~= cityData.tColor.z then
                        nativeCityData.tColor = {r = cityData.tColor.r, g = cityData.tColor.g, 
                                b = cityData.tColor.b, z = cityData.tColor.z or 255 }
                        alterParam.bgcolortop = string.format("%X%X%X%X", cityData.tColor.r, cityData.tColor.g, 
                            cityData.tColor.b, cityData.tColor.z)
                end

                if nativeCityData.bColor.r ~= cityData.bColor.r or nativeCityData.bColor.g ~= cityData.bColor.g
                    or nativeCityData.bColor.b ~= cityData.bColor.b or nativeCityData.bColor.z ~= cityData.bColor.z then
                        nativeCityData.bColor = {r = cityData.bColor.r, g = cityData.bColor.g, 
                                b = cityData.bColor.b, z = cityData.bColor.z or 255 }
                        alterParam.bgcolortop = string.format("%X%X%X%X", cityData.bColor.r, cityData.bColor.g, 
                            cityData.bColor.b, cityData.bColor.z)
                end

                -- nativeCityData.bottomColor = cityData.bottomColor
                nativeCityData.newVersioninfo = cityData.versioninfo
                if nativeCityData.version < cityData.version then
                    nativeCityData.state = "oldData"
                    nativeCityData.newVersion = cityData.version
                else
                    nativeCityData.state = "unAlter"
                end 
                -- 修改数据库
                if alterParam and next(alterParam) then
                    dataBaseManager:setValue("city", alterParam, {{fieldName = "cityid", fieldValue = cityID}})
                end

                -- cityData

            end
            nativeCityDatas[cityID] = nativeCityData
        end

        -- 更新数据库
        for k, cityData in pairs(nativeCityDatas) do
            if not cityData.state then  -- 删除数据
                dataBaseManager:deleteItem("city", {cityid = cityData.cityid})
            end
        end

        QMapGlobal.systemData.mapData = nativeCityDatas
-- print("initSystemData     00000000000000000000000")
        -- if self.param and self.param.callBack then
        --     -- print("initSystemData     11111111111111111111")
        --     self.param.callBack()
        -- end
        if LoadDataOverCallBack then LoadDataOverCallBack() end
    end, function (  )
        -- 连接网络失败
        -- print("initSystemData     222222222222222222222222")
        -- if self.param and self.param.callBack then
        --     -- print("initSystemData     3333333333333333333333333333")
        --     self.param.callBack()
        -- end
        if LoadDataOverCallBack then LoadDataOverCallBack() end
    end)
    
    
end

-- 初始化用户点击城市的数据
function DataManager:initUserClickCityData( ... )
    local userid = 0
    if dataBaseManager:isTableExist("cityClick") then
        local cityClickTable = dataBaseManager:select("cityClick", {}, {{fieldName = "userid", fieldValue = userid} })
        dump(cityClickTable)
        for _, item in pairs(cityClickTable) do
            QMapGlobal.userClickCityData[tonumber(item.cityid)] = tonumber(item.clickcount)
        end
    end
    -- print("11111111111111111111111111111111111")
    dump(QMapGlobal.userClickCityData)
end

-- 初始化用户基本信息
function DataManager:initUserBaseData( ... )
    -- 加载用户数据
    -- QMapGlobal.userData.userBaseInfo = GameState.load()
    -- if not QMapGlobal.userData.userBaseInfo then
    --     -- QMapGlobal.userData.userInfo = {userid = 0}   -- 未登录用户
    --     -- QMapGlobal.userData.userBaseInfo = {userid = 111, name="star", image = "star.png", email = "star@shitouren.com", phone = "12345678901", pic = "headImage.jpg",
    --     --     addr = "北京市", sex = "boy", desc = "上天入地唯我独尊",
    --     --     itinerarys = {}  -- 行程数据表
    --     --     }   -- 测试用户
    --     GameState.save(QMapGlobal.userData.userBaseInfo)
    -- end
end

-- 初始化用户行程，行程数据在UserFile.txt中   --被弃用
function DataManager:initItineraryData( ... )
     -- 1 .判断是否有行程表
    local userid = QMapGlobal.userData.userBaseInfo.userid
    if not userid then 
        printInfo("no user info.....")
        return
    end
    local itineraryTable = "itinerary"
    if dataBaseManager:isTableExist(itineraryTable) then
        local userItinerarys = QMapGlobal.userData.userInfo.itinerary or {}
        local userItineraryTable = dataBaseManager:select(itineraryTable, nil, {{fieldName = "userid", fieldValue = userid}})
        for _, userItinerary in pairs(userItineraryTable) do
            local cityid = tonumber(userItinerary.cityid)
            userItinerarys[cityid] = userItinerarys[cityid] or {}
            table.insert(userItinerarys[cityid], {sightid = tonumber(userItinerary.sightid) ,order = tonumber(userItinerary.order)})
        end
        -- print("用户行程数据。。。。")
        -- print_r(userItinerarys)
    end
end

-- 初始化用户数据
function DataManager:initUserData( )
    -- 初始化用户游记
    do return end
    local mapData = QMapGlobal.systemData.mapData
    local userJourneys = {}
    local userid = QMapGlobal.userData.userInfo.userid or 0
    if not userid then
        return
    end
    for _, cityData in pairs(mapData) do
        local cityid = tonumber(cityData.cityid)
        local journey_base = "journey_base_" .. cityid
        local journey_info = "journey_info_" .. cityid
        local journey_image = "journey_image_" .. cityid
        local journey_mark = "journey_mark_" .. cityid

        local journeyBaseTable = dataBaseManager:select(journey_base, nil, { {fieldName = "userid", fieldValue = userid} })
        local userJourney = {}
        -- print("初始化时。。。。。。")
        -- print_r(journeyBaseTable)
        -- 此处返回应该只有一条记录，为以后扩展，多条记录时journeyid不一样
        for _, journeyBase in pairs(journeyBaseTable) do
            userJourney.journeyid = tonumber(journeyBase.journeyid)   
            userJourney.title = journeyBase.title
            userJourney.upload = journeyBase.upload
            userJourney.utime = journeyBase.utime
            userJourney.cityid = cityid
            local orderString = journeyBase.order  -- "markid1,markid2,markid3"
            -- print("order string...", orderString)
            local orderTable = Split1(orderString, ",")
            -- print_r(orderTable)
            local journeys = {}
            local journeyInfoTable = dataBaseManager:select(journey_info, nil, { {fieldName = "userid", fieldValue = userid}, {fieldName = "journeyid", fieldValue = userJourney.journeyid}})
            for _, journeyInfo in pairs(journeyInfoTable) do
                local journey = {}
                journey.sightid = tonumber(journeyInfo.sightid)
                journey.order = orderTable[journeyInfo.markid]     --journeyInfo.order       ??????
                journey.markid = tonumber(journeyInfo.markid)

                local journeyMarkTable = dataBaseManager:select(journey_mark, nil, {{fieldName = "userid", fieldValue = userid}, {fieldName = "markid", fieldValue = journey.markid}})
                for _, mark in pairs(journeyMarkTable) do   
                    journey.mark = mark.mark
                    journey.ctime = mark.ctime
                end

                local journeyImageTable = dataBaseManager:select(journey_image, nil, {{fieldName = "userid", fieldValue = userid}, {fieldName = "markid", fieldValue = journey.markid}})
                -- print("这是第一次从数据库中获得的数据。。。。。。")
                -- print_r(journeyImageTable)
                local images = {}
                for _, image in pairs(journeyImageTable) do
                    -- print("获取的数据。。。。", image.imageid, image.ctime)
                    table.insert(images, {id = image.imageid, ctime = image.ctime})
                end
                -- dump(journeyImageTable)
                journey.image = images
                table.insert(journeys, journey)
            end
            userJourney.journey = journeys
        end

        userJourneys[cityid] = userJourney

    end
    QMapGlobal.userData.userInfo.journeys = userJourneys
    -- dump(QMapGlobal.userData.userInfo.journeys)
    -- print_r(QMapGlobal.userData.userInfo.journeys)
end

-- 收藏数据，保存到数据库
function DataManager:collectData(param)
    -- journey_base_1， journey_info_1， journey_image_1， journey_mark_1， collect
    local journey_base = "journey_base_"..param.cityid
    if dataBaseManager:isTableExist(journey_base) then -- 存在
        -- 1.保存数据
        
    else
    
    end
end

--提取景点的数据
function DataManager:getSightData( cityID )
    local cityData = QMapGlobal.systemData.mapData[cityID]
    local sightData = cityData.sight or {}
    -- dump(cityData)
    -- print("提取景点数据。。。。。。。。。。。", sightData.isNative, cityData.name)
    if not (next(sightData) and (not cityData.isNative) ) then
    -- if (not (next(sightData))) or sightData.isNative then

        local fu = cc.FileUtils:getInstance()
        local downloadPath = fu:getDownloadPath()
        -- local sightPath = device.writablePath .. "map/" .. cityData.name .. "/" .. cityData.name .. "sight.json"
        local sightPath = downloadPath .. "map/" .. cityData.name .. "/" .. cityData.name .. "sight.json"
        print("读取json文件。。", sightPath)
        if fu:isFileExist(sightPath) then
            print("存在json文件，需要从json中获取数据！")
            local sights = self:getSightFromJsonFile(sightPath)
            if sights then
                sightData = sights
                sightData.isNative = nil
            end
        end

    end
    QMapGlobal.systemData.mapData[cityID].sight = sightData
    return sightData
end

function DataManager:getCityData( cityID )
    -- body
    local fu = cc.FileUtils:getInstance()
    local downloadPath = fu:getDownloadPath()
    local cityData = { cityid = QMapGlobal.cityID, name = QMapGlobal.cityName, cname = QMapGlobal.cityShowName, provid = 0, version = 0, 
        tColor = analysisColor(QMapGlobal.cityTColor), bColor =  analysisColor(QMapGlobal.cityBColor), versioninfo = 0,
        isNative = true}

    local sights = {}
    -- local sightPath = device.writablePath .. "map/" .. city.name .. "/" .. city.name .. "sight.json"
    local sightPathN = "res/ui/map/" .. QMapGlobal.cityName .. "/" .. QMapGlobal.cityName .. "sight.json"
    local sightPathDL = downloadPath .. "map/" .. QMapGlobal.cityName .. "/" .. QMapGlobal.cityName .. "sight.json"
    print("读取json文件。。", sightPathDL, sightPathN)
    if fu:isFileExist(sightPathDL) then
        print("下载存在json文件，需要从json中获取数据！")
        sights = self:getSightFromJsonFile(sightPathDL)
    else  --if fu:isFileExist(sightPathN) then
        print("本地存在json文件，需要从json中获取数据！")
        sights = self:getSightFromJsonFile(sightPathN)
    end
    cityData.sight = sights
    QMapGlobal.systemData.mapData[cityID] = cityData
    return cityData
    -- return QMapGlobal.systemData.mapData[cityID] or {}

end

-- 该函数测试使用，实际使用时，请调用相应的函数
function DataManager:requestData(agreementName, reqParam, callBackSucceed, callBackFail)
    -- 向服务器发送数据
    -- self:getCityList()
    self:getSightList(callBackSucceed)
end

-- -获取城市列表
function DataManager:getCityIDList(  )
    local cityTable = {}
    for _, city in pairs(QMapGlobal.systemData.mapData) do
        table.insert(cityTable, city.cityid)
    end
    return cityTable
end

function DataManager:isDown( cityID )

    local fu = cc.FileUtils:getInstance()
    local cityData = QMapGlobal.systemData.mapData[cityID]
    local cityName = cityData and cityData.name
    if not cityName then 
        printError("no this city ,cityID is ", cityID)
        return false
    end

    local downloadPath = fu:getDownloadPath()
    -- local path = device.writablePath .. "map/" .. cityName .."/"
    local path = downloadPath .. "map/" .. cityName .."/"
    local csbPath = path .. cityName .. ".csb"
    if not fu:isFileExist(csbPath) then
        return false
    end
    -- if not fu:isFileExist(path .. cityName .. "sight.json") then
    --     return "Undownloaded"
    -- end
    path = path .. "image/"
    -- if not fu:isFileExist(path .. cityName .. "ball.png") then  -- 球
    --     return false
    -- end
    if not fu:isFileExist(path .. cityName .. "map.jpg") then  -- 地图
        return false
    end
    if not fu:isFileExist(path .. cityName .. ".plist") then   -- 景点plist
        return false
    end
    if not fu:isFileExist(path .. cityName .. ".png") then  -- 景点合图
        return false
    end

    return true
    
end

function DataManager:getClickCount( cityID )
    local clickcount = QMapGlobal.userClickCityData[cityID]
    return clickcount or 0
end

function DataManager:setClickCount( cityID )
    print("当前进入的城市ID是", cityID)
    local clickcount = (QMapGlobal.userClickCityData[cityID] or 0) + 1
    local userid = 0
 
    if dataBaseManager:isTableExist("cityClick") then
        local cityClickTable = dataBaseManager:select("cityClick", {}, {{fieldName = "userid", fieldValue = userid}, {fieldName = "cityid", fieldValue = cityID} })
        dump(cityClickTable)
        if cityClickTable and next(cityClickTable) then
            dataBaseManager:setValue("cityClick", {clickcount = clickcount}, {{fieldName = "userid", fieldValue = userid}, {fieldName = "cityid", fieldValue = cityID} })
        else
            dataBaseManager:insertValue("cityClick", {cityID, userid, clickcount})
        end
    else
        dataBaseManager:createTable("cityClick", tableFields.city_click_fields)
        dataBaseManager:insertValue("cityClick", {cityID, userid, clickcount})
    end
    QMapGlobal.userClickCityData[cityID] = clickcount
    dump(QMapGlobal.userClickCityData)
end

-- 创建游记系列表
function DataManager:createJourneyTable( cityid )
    local journey_base = "journey_base_" .. cityid
    local journey_info = "journey_info_" .. cityid
    local journey_image = "journey_image_" .. cityid
    local journey_mark = "journey_mark_" .. cityid
    if not dataBaseManager:isTableExist(journey_base) then    
        dataBaseManager:createTable(journey_base, tableFields.journey_base_Fields)
        dataBaseManager:createTable(journey_info, tableFields.journey_info_Fields)
        dataBaseManager:createTable(journey_image, tableFields.journey_image_Fields)
        dataBaseManager:createTable(journey_mark, tableFields.journey_mark_Fields)
    end
end

-- 创建评论ID（MarkID）。
-- 创建规则：同一个城市，同一个用户是
function DataManager:getMarkID( cityid )
    local userid = QMapGlobal.userData.userInfo.userid
    local journey_info = "journey_info_" .. cityid
    local journeyInfoTable = dataBaseManager:select(journey_info, {markid}, {{fieldName = "userid", fieldValue = userid}})
    local newMarkid = 1
    for _, journeyMark in pairs(journeyInfoTable) do
        local markid = tonumber(journeyMark.markid)
        if newMarkid <= markid then   --查找最大的ID
            newMarkid = markid+1
        end
    end
    return newMarkid
end

-- 创建游记ID（JourneyID）， 当前每个城市只能创建一篇游记，取默认值为1.
function DataManager:getJourneyID( param )
    return 1
end

-- 返回当前的city的order字符串  ，
-- journeyID取默认值0，当前每个city只能有一条journey
function DataManager:getMarkOrder( cityID, journeyID )
    local order = nil    
    local userID = QMapGlobal.userData.userInfo.userid
    local journey_base = "journey_base_" .. cityID
    if dataBaseManager:isTableExist(journey_base) then
        local markIDs = dataBaseManager:select(journey_base, {order}, { {fieldName = "userid", fieldValue = userID}, {fieldName = "journeyid", fieldValue = journeyID}})
        if markIDs and next(markIDs) then
            order = markIDs[1].order  -- 原则上如果有则只能有一条记录，返回的应该是字符串MarkID列表
        end
    end
    return order
end

function DataManager:getJourney( cityID )
    return QMapGlobal.userData.userInfo.journeys[cityID]
end

---获取地图下载状态-------------------------
function DataManager:getDownloadState( cityID )
    -- 未下载  Undownloaded
    -- 下载中  Downloading
    -- 已下载  Downloaded
    -- 更新    Update

    if self.downLoading and self.downLoading[cityID] then
        return self.downLoading[cityID]
    end

    local fu = cc.FileUtils:getInstance()
    local cityData = QMapGlobal.systemData.mapData[cityID]
    local cityName = cityData and cityData.name
    if not cityName then 
        printError("no this city ,cityID is ", cityID)
        return "Undownloaded"
    end

    local downloadPath = fu:getDownloadPath()
    -- local path = device.writablePath .. "map/" .. cityName .."/"
    local path = downloadPath .. "map/" .. cityName .."/"
    local csbPath = path .. cityName .. ".csb"
    if not fu:isFileExist(csbPath) then
        return "Undownloaded"
    end
    if not fu:isFileExist(path .. cityName .. "sight.json") then
        return "Undownloaded"
    end
    path = path .. "image/"
    if not fu:isFileExist(path .. cityName .. "ball.png") then  -- 球
        return "Undownloaded"
    end
    if not fu:isFileExist(path .. cityName .. "map.jpg") then  -- 地图
        return "Undownloaded"
    end
    if not fu:isFileExist(path .. cityName .. ".plist") then   -- 景点plist
        return "Undownloaded"
    end
    if not fu:isFileExist(path .. cityName .. ".png") then  -- 景点合图
        return "Undownloaded"
    end



    -- if self.downLoading and self.downLoading[cityID] then
    --     return self.downLoading[cityID]
    -- end

    -- 
    -- if cityData.newVersioninfo and cityData.newVersioninfo > cityData.versioninfo then 
    --     print("主版本。。", cityData.newVersioninfo , cityData.versioninfo)
    --     return "Update"
    -- end

    if cityData.newVersion and cityData.newVersion > cityData.version then 
        print("此版本。。", cityData.newVersion , cityData.version)
        return "Update"
    end

    return "Downloaded"  -- "Update"       --
end

function DataManager:mapHasNewVer( cityID )

    do return false end
    local cityData = QMapGlobal.systemData.mapData[cityID]
    local cityName = cityData and cityData.name
    if not cityName then 
        printError("no this city ,cityID is ", cityID)
        return false
    end
    dump(cityData)
    if cityData.newVersion and cityData.newVersion > cityData.version then 
        print("此版本。。", cityData.newVersion , cityData.version)
        return true
    end
    print("没有新版本。。。。。")
    return false
end

-- 是否已经发布评论
function DataManager:getJourneyState( cityID )
    local journeyData = QMapGlobal.userData.userInfo.journeys[cityID]
    if not journeyData or not next(journeyData) then return "NoRemark" end -- 没有发布评论
    print_r(journeyData)
    local journeys = journeyData.journey
    if not journeys or not next(journeys) then return "NoRemark" end
    
    if journeyData.upload == "true" then
        return "Published"
    end
    return "Remarked"
end

-- 添加一条Journey
function DataManager:addJourney( param )
    local userid = QMapGlobal.userData.userInfo.userid
    local cityid = param.cityid
    local sightid = param.sightid
    local journeyid = self:getJourneyID({})  
    if not cityid or not sightid then 
        printInfo("cannot to add item todatabase, the cityid is %s and the sightid is %s", cityid or "nil", sightid or "nil")
        return 
    end
    local title = param.title or ""
    local upload = (param.upload or false) and "true" or "false"
    local utime = param.utime or ""
    local order = self:getMarkOrder(cityid, journeyid)
    local mark = param.mark or ""
    local markid = param.markid or self:getMarkID(cityid)
    local image = param.image or {}
    local orderStr = order and (order.. ","..markid) or tostring(markid)

    self:createJourneyTable(cityid)

    local journey_base = "journey_base_" .. cityid
    local journey_info = "journey_info_" .. cityid
    local journey_image = "journey_image_" .. cityid
    local journey_mark = "journey_mark_" .. cityid
    local js = dataBaseManager:select(journey_base, {}, {{fieldName = "userid", fieldValue = userid}})
    if not js or not next(js) then
        -- print("1 这是orderString....", orderStr)
        dataBaseManager:insertValue(journey_base, {userid, journeyid, title, upload, utime, orderStr })
    else
        -- print("2 这是orderString....", orderStr)
        dataBaseManager:setValue(journey_base, {title = title, order = orderStr}, {{fieldName = "userid", fieldValue = userid}})
    end
    js = dataBaseManager:select(journey_info, nil, {{fieldName = "sightid", fieldValue = sightid}, {fieldName = "userid", fieldValue = userid}})
    if not js or not next(js) then
        dataBaseManager:insertValue(journey_info, {userid, journeyid, sightid, markid})
        dataBaseManager:insertValue(journey_mark, {userid, markid, mark, ""})
    else
        dataBaseManager:setValue(journey_mark, {mark = mark}, {{fieldName = "userid", fieldValue = userid},{fieldName = "markid", fieldValue = markid}})
    end

    -- 由于该表不好操作，所以先将数据全部删掉，再添加
    dataBaseManager:deleteItem(journey_image, {{fieldName = "userid", fieldValue = userid},{fieldName = "markid", fieldValue = markid}} )
    if image and next(image) then
        for k,v in pairs(image) do
            -- print("这里是向数据库中添加图片的地方。。。。", v.id, v.ctime )
            dataBaseManager:insertValue(journey_image, {userid, markid, v.id, v.ctime or ""})
        end
    end


    local userJourneys = QMapGlobal.userData.userInfo.journeys
    -- print("DataManager............................star, 这尼玛是1")
    -- print_r(QMapGlobal.userData.userInfo.journeys)
    -- print("DataManager............................star")

    local userJourney = userJourneys[cityid]
    if not (userJourney and next(userJourney) ) then 
        userJourneys[cityid] = {
            journeyid = journeyid,  cityid = cityid,  title = title,  upload = upload,   utime = utime,
            journey = {   --新添加的数据
                {sightid = sightid, order = 1, markid = markid, mark = mark, ctime = "", 
                    image = image },
            }
        }
    else
        -- print("11111111111111111111111111111")
        local journey = userJourney.journey
        local isFind = false
        for _,v in pairs(journey) do
            if v.markid == markid then   -- 存在时，更改
                v.mark = mark
                v.image = image
                isFind = true
            end
        end
        if not isFind then
            local v = {sightid = sightid, order = #journey+1, markid = markid, mark = mark, ctime = "", 
                    image = image }
            dump(v)
            table.insert(journey, v)
        end
        userJourney.title = title
        userJourney.upload = upload
        userJourney.utime = utime
    end

    -- print("DataManager............................star")
    -- print_r(QMapGlobal.userData.userInfo.journeys)
    -- print("DataManager............................star")
end

-- 删除一条Mark
function DataManager:removeMark( cityID, markID )
    if not cityID or not markID then return end
    local userid = QMapGlobal.userData.userInfo.userid     --QMapGlobal.userData.userBaseInfo.userid or 0   -- 为0时，用户未注册
    -- 1.删除内存数据中得记录
    local journeyData = QMapGlobal.userData.userInfo.journeys[cityID]
    local markDatas = journeyData.journey
    local delOrder = nil
    for k, markData in pairs(markDatas) do
        if markData.markid == markID then
            table.remove(markDatas, k)
            delOrder = markData.order
            break
        end
    end

    if delOrder then
        for _,item in pairs(markDatas) do
            if delOrder < item.order then
                item.order = item.order -1
            end
        end
    end

    journeyData.journey = markDatas
    QMapGlobal.userData.userInfo.journeys[cityID] = journeyData
    local markDatas1 = sequenceSort(markDatas, {{"order", 1}} )
    local orderString = nil
    for _,v in ipairs(markDatas1) do
        if orderString then
            orderString = orderString .. "," .. tostring(v.markid)
        else
            orderString = tostring(v.markid)
        end
    end

    -- 2.删除数据库中的数据记录
    local journey_base = "journey_base_" .. cityID
    local journey_info = "journey_info_" .. cityID
    local journey_image = "journey_image_" .. cityID
    local journey_mark = "journey_mark_" .. cityID
    dataBaseManager:deleteItem(journey_image, {{fieldName = "userid", fieldValue = userid},{fieldName = "markid", fieldValue = markID}} )
    dataBaseManager:deleteItem(journey_mark, {{fieldName = "userid", fieldValue = userid},{fieldName = "markid", fieldValue = markID}} )
    dataBaseManager:deleteItem(journey_info, {{fieldName = "userid", fieldValue = userid},{fieldName = "markid", fieldValue = markID}} )

    -- 一个用户一个城市只有一篇游记
    dataBaseManager:setValue(journey_base, {order = orderString or ""}, {{fieldName = "userid", fieldValue = userid}})
end

-- 修改排列顺序
function DataManager:alterMarkOrder( journeys, cityID)
    journeys = sequenceSort(journeys, {{"index", 1}})
    local orderStr = nil
    local orderList = {}
    for i, journey in ipairs(journeys) do
        if orderStr then
            orderStr = orderStr .. "," .. journey.markid
        else
            orderStr = tostring(journey.markid)
        end
        orderList[journey.markid] = journey.index
    end

    local userid = QMapGlobal.userData.userInfo.userid or 0   -- 为0时，用户未注册
    -- 更新数据库数据
    local journey_base = "journey_base_" .. cityID
    dataBaseManager:setValue(journey_base, { order = orderStr }, {{fieldName = "userid", fieldValue = userid}})

    -- 更新内存数据
    local userJourneys = QMapGlobal.userData.userInfo.journeys
    local userJourney = userJourneys[cityID]
    -- print("qqqqqqqqqqqqqqqqqqqqq")
    -- print_r(userJourney)
    for _, journeyItem in pairs(userJourney.journey) do
        journeyItem.order = orderList[tonumber(journeyItem.markid)]
    end
end

-- 是否已经收藏游记
function DataManager:isJourneyCollect( authorID, cityID, journeyID )
    -- {userid = 111, authorid = 113, cityid = 1, journeyid = 1 }
    local collects = QMapGlobal.userData.userInfo.collect
    for _, collect in pairs(collects) do
        if collect.authorid == authorID and collect.cityid == cityID and collect.journeyid == journeyID then
            return true
        end
    end
    return false
end

-- 添加行程记录，行程记录纸保存在本地，不会被上传到服务器
function DataManager:addItinerary( itineraryData )
    -- print("添加行程数据。。。。。。。。。")
    -- print_r(itineraryData)
    -- 1 .判断是否有行程表
    local userid = QMapGlobal.userData.userBaseInfo.userid or 0   -- 为0时，用户未注册
    local itinerarys = QMapGlobal.userData.userBaseInfo.itinerarys

    local itineraryTable = itinerarys[itineraryData.cityid] or {}
    table.insert(itineraryTable, itineraryData.sightid )
    itinerarys[itineraryData.cityid] = itineraryTable
    QMapGlobal.userData.userBaseInfo.itinerarys = itinerarys

    GameState.save(QMapGlobal.userData.userBaseInfo)
end

-- 修改行程的顺序
function DataManager:alterItineraryOrder(itineraryList, cityID)
    -- local itinerarys = QMapGlobal.userData.userBaseInfo.itinerarys 
    itineraryList = sequenceSort(itineraryList, {{"order", 1}})
    local itinerarys = {}
    for _,v in pairs(itineraryList) do
        table.insert(itinerarys, v.sightid)
    end
    QMapGlobal.userData.userBaseInfo.itinerarys[cityID] = itinerarys
    GameState.save(QMapGlobal.userData.userBaseInfo)
    -- print_r(QMapGlobal.userData.userBaseInfo.itinerarys)
    -- print_r()
    -- local itineraryTable = itinerarys[cityID] or {}
    -- table.insert(itineraryTable, itineraryData.sightid )
    -- itinerarys[itineraryData.cityid] = itineraryTable
    -- QMapGlobal.userData.userBaseInfo.itinerarys = itinerarys

    -- GameState.save(QMapGlobal.userData.userBaseInfo)
end

-- 获取行程新的记录的排列顺序
function DataManager:getItineraryOrder( cityID )
    local order = 1
    local itinerarys = QMapGlobal.userData.userInfo.itinerary
    if itinerarys then
        local cityitinerarys = itinerarys[cityID]
        if cityitinerarys then
            for _,v in pairs(cityitinerarys) do
                if order <= v.order then
                    order = v.order + 1
                end
            end
        end
    end
    return order 
end

-- 删除行程记录
function DataManager:delAllItinerary(cityID)
    local itineraryTable = "itinerary"
    -- local userid = QMapGlobal.userData.userInfo.userid or 0 -- -- 为0时，用户未注册
    -- self:deleteItem(itineraryTable, {{fieldName = "userid", fieldValue = userid},{fieldName = "cityid", fieldValue = cityID}})
    -- QMapGlobal.userData.userInfo.itinerary[cityID] = nil

    QMapGlobal.userData.userBaseInfo.itinerarys[cityID] = nil
    GameState.save(QMapGlobal.userData.userBaseInfo)
end

function DataManager:delItinerary( cityID, sightID )
    local itineraryTable = "itinerary"
    local userid = QMapGlobal.userData.userInfo.userid or 0 -- -- 为0时，用户未注册

    local cityItinerary = QMapGlobal.userData.userBaseInfo.itinerarys[cityID]
    for k,item in pairs(cityItinerary) do
        if tonumber(item) == tonumber(sightID) then
            table.remove(cityItinerary, k)
            break
        end
    end
    QMapGlobal.userData.userBaseInfo.itinerarys[cityID] = cityItinerary
    GameState.save(QMapGlobal.userData.userBaseInfo)
end

-- 获取用户行程表中的数据，传入cityID时，返回该城市的行程数据
function DataManager:getUserItinerary( cityID )
    local itinerary = QMapGlobal.userData.userBaseInfo.itinerarys
    if not cityID then return itinerary end
    return itinerary[cityID]
end

-- 判断用户是否已经对该景点有行程
function DataManager:sightIsInItinerary( cityID, sightID )
    local itinerarys = QMapGlobal.userData.userBaseInfo.itinerarys and QMapGlobal.userData.userBaseInfo.itinerarys[cityID]
    if not itinerarys then return false end
    for _,sightid in pairs(itinerarys) do
        -- print(sightid , type(sightid), sightID, type(sightID))
        if tonumber(sightid) == tonumber(sightID) then
            return true
        end
    end
    return false
end

function DataManager:getSpecialityData( cityID )
    local cityData = QMapGlobal.systemData.mapData[cityID]
    local cityCName = cityData and cityData.cname
    local cityName = cityData and cityData.name
    local specialityData = QMapGlobal.specialityDatas[cityID] or {}
    return cityCName, cityName, specialityData
end

-- --  获取应用程序的版本
-- function DataManager:getVersion( ... )
--     return "2.1.0"
-- end

-- 以下是网络操作

-- 更新版本
function DataManager:getNewVer(  )
    do return end
    netWorkManager:requestData("api/app/getnewver", {data = {} }, function ( fileInfo )
        -- dump(fileInfo)
        local downloadPath = cc.FileUtils:getInstance():getDownloadPath()

        local newVer = fileInfo.appver   -- 新版本号
        local files = fileInfo.detail
        -- print_r(files)
        if files and next(files) then
            local count = #files
            for _, item in pairs(files) do
                if item.optype == 1 or item.optype == 2 then  -- add or 更新
                    -- item.url      -- 下载地址
                    -- item.path     -- 本地存储路径
                    -- item.filename -- 文件名
                    -- local path = device.writablePath .. item.path
                    local path = downloadPath .. item.path
                    cc.FileUtils:getInstance():createDirectory(path)
                    path = path .. item.filename
                    netWorkManager:getUrlFile(item.url, path, function ( ... )
                            print("download file succeed! ", path)
                            count = count - 1
                            if count == 0 then
                                -- 更新应用程序当前版本
                                -- QMapGlobal.ver = newVer
                                QMapGlobal.gameState.ver = newVer
                                GameState.save(QMapGlobal.gameState)
                            end
                        end, function (  )
                            print("download file fail! ", path)
                        end)
                -- elseif item.optype == 2 then -- 更新
                elseif item.optype == 3 then -- 删除
                    -- local path = device.writablePath .. item.path
                    local path = downloadPath .. item.path
                    path = path .. item.filename
                    cc.FileUtils:getInstance():removeFile(path)
                    count = count - 1
                end
            end
        end

        print("api/app/getnewver", "已经完成。。。。。。")
    end, function (  )
        -- body
        print("api/app/getnewver", "已经失败。。。。。。")
    end)
end


-- 登录系统
function DataManager:signin( ... )
    netWorkManager:requestData("api/user/signin", { ssid = "abc" , userid = 111, email = "yexiang@shitouren.com" , passwd = "hahahaha" , rememberme = "on" })
end

-- 获得城市列表
function DataManager:getCityList( callBackSucceed, callBackFail )
    print("获取城市列表。。。。。。。")
    netWorkManager:requestData("api/city/list", {data = {}}, callBackSucceed, callBackFail)
end

-- 更新下载地图相关文件  ,该函数用以取代 getMapFile 
function DataManager:downloadMapFiles( cityID, callBackSucceed, callBackFail )
    local ver = QMapGlobal.systemData.mapData[cityID].version 
    local cityName = QMapGlobal.systemData.mapData[cityID].name

    local fu = cc.FileUtils:getInstance()
    local downloadPath = fu:getDownloadPath()
    local csbPath = downloadPath .. "map/" .. cityName .."/" .. cityName .. ".csb"
    if not fu:isFileExist(csbPath) then
        ver = 0
    end

    local data = {cityid = cityID, version = ver}
    self.downLoading = self.downLoading or {}

    -- local downloadPath = cc.FileUtils:getInstance():getDownloadPath()

    netWorkManager:requestData("api/city/getmapver", {data = data}, function ( mapData )
        -- dump(mapData)
        local version = mapData.version
        local versioninfo = mapData.versioninfo

        -- local rootPath = device.writablePath.. "map/" .. cityName .. "/"
        local rootPath = downloadPath .. "map/" .. cityName .. "/"
        -- cc.FileUtils:getInstance():createDirectory(rootPath)
        local imagePath = rootPath .. "image/"
        cc.FileUtils:getInstance():createDirectory(imagePath)

        local downloadList = {}
        if mapData.iconfile then
            table.insert(downloadList, {agreement = mapData.iconfile,  path = imagePath .. cityName .. "ball.png"})
        end
        if mapData.csbfile then
            table.insert(downloadList, {agreement = mapData.csbfile,  path = rootPath .. cityName .. ".csb"})
        end
        -- if mapData.iconfile then
        --     table.insert(downloadList, {agreement = mapData.iconfile,  path = imagePath .. cityName .. "ball.png"})
        -- end
        if mapData.plistfile then
            table.insert(downloadList, {agreement = mapData.plistfile, path = imagePath .. cityName .. ".plist"})
        end
        if mapData.pngfile then
            table.insert(downloadList, {agreement = mapData.pngfile,  path = imagePath .. cityName .. ".png"})
        end
        if mapData.jpgfile then
            table.insert(downloadList, {agreement = mapData.jpgfile,  path = imagePath .. cityName .. "map.jpg"})
        end
        if mapData.jsonfile then
            table.insert(downloadList, {agreement = mapData.jsonfile,  path = rootPath  .. cityName ..  "sight.json"})
        end

        local count = #downloadList

        local index = 0
        local downLoadFile
        downLoadFile = function ( )
            if #downloadList > 0 then -- 还有未下载
                local item = downloadList[1]
                netWorkManager:getUrlFile(item.agreement, item.path, function (  )
                    table.remove(downloadList, 1)
                    index = index + 1
                    local progress = math.floor(index*100/count)
                    self.downLoading[cityID] = progress
                    callBackSucceed(cityID, progress )
                    
                    downLoadFile()
                end, function (  )
                    self.downLoading[cityID] = nil
                    if callBackFail then
                        callBackFail()
                    end
                end, function ( precent )
                    local maxV = math.floor((index + 1)*100/count)
                    local minV = math.floor((index) * 100 /count)
                    local v = minV + (maxV-minV)*precent
                    -- print(maxV, minV, precent, v)
                    local progress = math.floor(minV + (maxV-minV)*precent)
                    self.downLoading[cityID] = progress
                    callBackSucceed(cityID, progress )
                end)
            else   -- 下载完成
                callBackSucceed(cityID, "completed")
                dataBaseManager:setValue("city", {version = version}, {{fieldName = "cityid", fieldValue = cityID}})
                QMapGlobal.systemData.mapData[cityID].version = version
                -- QMapGlobal.systemData.mapData[cityID].versioninfo = versioninfo
                self.downLoading[cityID] = nil

                QMapGlobal.systemData.mapData[cityID].isNative = true
                self:getSightData( cityID )
            end
        end

        if count > 0 then
            downLoadFile()
        end

    end,callBackFail)
end

-- 下载地图文件 ，该函数不推荐使用，已被重写，替代函数是 downloadMapFiles
function DataManager:getMapFile( cityID, callBackSucceed, callBackFail )
    local data = {cityid = cityID}
    local cityName = QMapGlobal.systemData.mapData[cityID].name
    self.downLoading = self.downLoading or {}

    local downloadPath = cc.FileUtils:getInstance():getDownloadPath()

    netWorkManager:requestData("api/city/getmapver", {data = data}, function ( mapData )

        local version = mapData.version
        local versioninfo = mapData.versioninfo

        -- local csbPath = device.writablePath.. "map/" .. cityName .. "/"
        local csbPath = downloadPath .. "map/"..cityName .. "/"
        cc.FileUtils:getInstance():createDirectory(csbPath)
        csbPath =  csbPath .. cityName .. ".csb"
        netWorkManager:getUrlFile(mapData.csbfile, csbPath, function (  )

            -- local rootPath = device.writablePath.. "map/" .. cityName .. "/"
            local rootPath = downloadPath .. "map/"..cityName .. "/"
            local path = rootPath .. "image/"
            local downloadList = {
                {agreement = mapData.iconfile,  path = path .. cityName .. "ball.png"},
                {agreement = mapData.plistfile, path = path .. cityName .. ".plist"},
                {agreement = mapData.pngfile,   path = path .. cityName .. ".png"},
                {agreement = mapData.jpgfile,   path = path .. cityName .. "map.jpg"},

                {agreement = mapData.jsonfile, path = rootPath .. "sight.json"}
            }
            local count = #downloadList + 1
            local index = 1

            if callBackSucceed then
                local progress = math.floor(index*100/count)
                self.downLoading[cityID] = progress
                callBackSucceed(cityID, progress)
            end

            cc.FileUtils:getInstance():createDirectory(path)
            
            for i, item in pairs(downloadList) do
                -- if item.agreement then
                    netWorkManager:getUrlFile(item.agreement, item.path, function ( ... )
                        index = index + 1
                        if count == index then
                            if callBackSucceed then
                                -- print("完成   这里的时cityID是。。。", cityID)
                                callBackSucceed(cityID, "completed")
                                dataBaseManager:setValue("city", {version = version, versioninfo = versioninfo}, {{fieldName = "cityid", fieldValue = cityID}})
                                QMapGlobal.systemData.mapData[cityID].version = version
                                QMapGlobal.systemData.mapData[cityID].versioninfo = versioninfo
                                self.downLoading[cityID] = nil
                            end
                        else
                            if callBackSucceed then
                                -- print("未完成   这里的时cityID是。。。", cityID)
                                local progress = math.floor(index*100/count)
                                self.downLoading[cityID] = progress
                                callBackSucceed(cityID, progress )
                            end
                        end
                    end,function (  )
                        index = index + 1
                        if callBackFail then
                            callBackFail()
                        end
                    end)
                -- end
            end
        end)
        
    end, callBackFail)
end

-- 获取景点列表
function DataManager:getSightList(cityID, callBackSucceed , callBackFail)
    local cityData = {cityid = cityID}
    netWorkManager:requestData("api/sight/dict", {data = cityData}, callBackSucceed, callBackFail)
end

-- 获取景点的简介信息
function DataManager:getSightDescription( cityID, sightID, callBackSucceed, callBackFail )
    local sightDesc = {cityid = cityID, sightid = sightID}
    local downloadPath = cc.FileUtils:getInstance():getDownloadPath()
    netWorkManager:requestData("api/sight/detail", {data = sightDesc}, function ( descData )
        local cityName = QMapGlobal.systemData.mapData[cityID].name
        local imgs = descData.imgs
        if imgs and next(imgs) then
            local imgCount = #imgs
            -- local sightImgPath = device.writablePath.. "map/" .. cityName .. "/sightImage/" .. descData.sightid .. "/"
            local sightImgPath = downloadPath .. "map/" .. cityName .. "/sightImage/" .. descData.sightid .. "/"
            cc.FileUtils:getInstance():createDirectory(sightImgPath)
            for _, imgItem in pairs(imgs) do
                netWorkManager:getUrlFile(imgItem.url, sightImgPath .. imgItem.index .. ".jpg", function ( )
                    imgCount = imgCount - 1
                    if imgCount == 0 then
                        if callBackSucceed then
                            callBackSucceed(descData)
                        end
                    end
                end)
            end
        end
        
    end, callBackFail)
end

-- 发布一篇游记
function DataManager:publishJourney(cityID, callBackSucceed, callBackFail)
    local journey = QMapGlobal.userData.userInfo.journeys[cityID]
    journeyData = clone(journey)
    journeyData.userid = 111
    local files = {}
    local downloadPath = cc.FileUtils:getInstance():getDownloadPath()
    if journeyData.journey and next(journeyData.journey) then
        for _, item in pairs(journeyData.journey) do
            if item and next(item) then
                for _,img in pairs(item.image) do
                    img.imgname = item.sightid .. "_" .. item.markid .. "_" .. img.id
                    -- local path = device.writablePath.."img/journey/full/".. cityID .. "/" .. img.imgname .. ".jpg"    --  1_1_1.jpg"
                    local path = downloadPath .."img/journey/full/".. cityID .. "/" .. img.imgname .. ".jpg"    --  1_1_1.jpg"
                    table.insert(files, {fieldName = "imgfile", path = path, contentType = "Image/jpeg"})
                end
            end
        end
    end

    netWorkManager:requestData("api/journey/publish", {data = journeyData, file = files}, function (  )
        journeyData.upload = true
        
        callBackSucceed()
    end, callBackFail)
end

-- 获取一篇游记,查看其他作者的游记
function DataManager:getOrtherJourney( cityID , callBackSucceed, callBackFail)

    self.journeyList = self.journeyList or {}
    self.journeyList[cityID] = self.journeyList[cityID] or {}
    local userid = QMapGlobal.userData.userInfo.userid or 0 

    local downloadPath = cc.FileUtils:getInstance():getDownloadPath()

    local data = {userid = userid, cityid = cityID, browsed_uids = self.journeyList[cityID]}
    netWorkManager:requestData("api/journey/browse", {data = data}, function ( journeyData )
        table.insert(self.journeyList[cityID], {userid = journeyData.userid, journeyid = journeyData.journeyid})

        local imgCount = 0
        if journeyData and next(journeyData) then
            if journeyData.journey and next(journeyData.journey) then
                for _, item in pairs(journeyData.journey) do
                    if item and next(item) then
                        item.order = item.ordernum
                        if item.image and next(item.image) then
                            imgCount = imgCount + #item.image
                        end
                    end
                end
            end
        end

        -- 下载图片
        if imgCount > 0 and journeyData and next(journeyData) then
            if journeyData.journey and next(journeyData.journey) then
                for _, item in pairs(journeyData.journey) do
                    if item and next(item) then
                        item.order = item.ordernum
                        if item.image and next(item.image) then
                            -- local path = device.writablePath.. "temp/" .. journeyData.cityid .. "/" .. journeyData.userid .."/"
                            local path = downloadPath .. "temp/" .. journeyData.cityid .. "/" .. journeyData.userid .."/"
                            cc.FileUtils:getInstance():createDirectory(path)
                            for _, img in pairs(item.image) do                              
                                local imageName = path .. img.imgname
                                netWorkManager:getUrlFile(img.imgurl, imageName, function (  )
                                    imgCount = imgCount - 1
                                    print("还有".. imgCount .. "张图片在下载")
                                    if imgCount == 0 and callBackSucceed then
                                        callBackSucceed(journeyData)
                                    end
                                end)
                            end
                        end
                    end
                end
            end
        end 
        
    end, callBackFail)
end

-- 获取一个城市某个景点的所有游记
function DataManager:getSightJourney( cityID, sightID, callBackSucceed, callBackFail )
    local userID = QMapGlobal.userData.userInfo.userid or 0
    self.journeyStart = self.journeyStart or 0
    local param = {userid = userID, cityid = cityID, sightid = sightID, start = self.journeyStart}
    local downloadPath = cc.FileUtils:getInstance():getDownloadPath()
    netWorkManager:requestData("api/journey/browsesight", {data = param}, function ( journeyData )
        -- print_r(journeyData)
        local imgCount = 0
        local imgList = {}
        if journeyData and next(journeyData) then
            self.journeyStart = self.journeyStart + #journeyData
            for _, markItem in pairs(journeyData) do
                local oneMark = markItem.journey
                -- local path = device.writablePath.. "temp/" .. markItem.cityid .. "/" .. markItem.userid .."/"
                local path = downloadPath .. "temp/" .. markItem.cityid .. "/" .. markItem.userid .."/"
                if oneMark and next(oneMark) then
                    local images = oneMark.image
                    if images and next(images) then
                        imgCount = imgCount + #images
                        for _, image in pairs(images) do
                            table.insert(imgList, {path = path, imgName = image.imgname, url = image.imgurl})                            
                        end
                    end
                end
            end
        end

        for _, imageItem in pairs(imgList) do
            cc.FileUtils:getInstance():createDirectory(imageItem.path)
            local imageName = imageItem.path .. imageItem.imgName
            netWorkManager:getUrlFile(imageItem.url, imageName, function (  )
                imgCount = imgCount - 1
                print("file download succeed, name is ", imageName)
                if imgCount == 0 and callBackSucceed then
                    callBackSucceed(journeyData)
                end
            end,function (  )
                imgCount = imgCount - 1
                -- print("还有".. imgCount .. "张图片在下载")
                print("file download fail, name is ", imageName)
                if imgCount == 0 and callBackSucceed then
                    callBackSucceed(journeyData)
                end
            end)
        end

    end, callBackFail)
end

-- 收藏游记。。
function DataManager:collectJourney( authorID, cityID, journeyID , callBackSucceed, callBackFail)
    -- {userid = 111, authorid = 113, cityid = 1, journeyid = 1 }
    local userid = QMapGlobal.userData.userInfo.userid or 0 -- -- 为0时，用户未注册

    local param = {userid = userid, authorid = authorID, cityid = cityID, journeyid = journeyID}
    netWorkManager:requestData("api/journey/collect", {data = param}, function(  )
        local item = {userid = userid, authorid = authorID, cityid = cityID, journeyid = journeyID}
        table.insert(QMapGlobal.userData.userInfo.collect , item)
        if callBackSucceed then
            callBackSucceed()
        end
    end, callBackFail)

    -- local item = {userid = userid, authorid = authorID, cityid = cityID, journeyid = journeyID}
    -- table.insert(QMapGlobal.userData.userInfo.collect , item)
end

-- 获取弹幕信息
function DataManager:getLabelData(cityID, sightID, callBackSucceed, callBackFail)
    local userid = QMapGlobal.userData.userInfo.userid or 0 -- -- 为0时，用户未注册
    local data = {userid = userid, cityid = cityID, sightid = sightID}
    netWorkManager:requestData("api/sight/getcomment", {data = data}, function ( labelData )
        if callBackSucceed then
            local contents = labelData.content
            for _, content in pairs(contents) do
                content.content = content.username .. "：" .. content.content
            end
            callBackSucceed(labelData.content)
        end
    end, callBackFail)
end

-- 新添加的
function DataManager:addLabelData( cityID, sightID, text , callBackSucceed, callBackFail)
    local userid = QMapGlobal.userData.userInfo.userid or 0 -- -- 为0时，用户未注册
    local data = {userid = userid, cityid = cityID, sightid = sightID, content = text}
    netWorkManager:requestData("api/sight/addcomment", {data = data}, callBackSucceed, callBackFail)
end

function DataManager:agreeLabel( cityID, sightID, labelID, agree )
    -- body
    local labelCityData = QMapGlobal.ortherData.labelData[cityID]
    local labelSightData = labelCityData and labelCityData[sightID]
    local labels = labelSightData and labelSightData.labels
    if labels and next(labels) then
        for _,label in pairs(labels) do
            if label.labelid == labelID then
                label.isliked = true
                break
            end
        end
    end
end

function DataManager:getSpecialityDatas( cityID , callBackSucceed, callBackFail)
    local data = {cityid = cityID}
    netWorkManager:requestData("api/city/product", {data = data}, function ( specialityData )
        -- dump(specialityData)
        if specialityData and next(specialityData) then
            QMapGlobal.specialityDatas = QMapGlobal.specialityDatas  or {}
            local products = specialityData.products 
            if products and next(products) then
                QMapGlobal.specialityDatas[cityID] = products
                if callBackSucceed then
                    callBackSucceed()
                end
                return
            end
        end
        
    end, callBackFail )
end


function DataManager:downLoadSpecialityFile( url, fileName, filePath , callBack)
    cc.FileUtils:getInstance():createDirectory(filePath)
    netWorkManager:getUrlFile(url, filePath .. fileName, function ( )
        if callBack then
            callBack()
        end
    end)        
end

-- 获取城市卡牌数据
function DataManager:getCardDatas( cityID, callBackSucceed, callBackFail )
    local ver = 0  -- 获取cityID的卡牌版本
    local data = {cityid = cityID, ver = 0}

    local downloadPath = cc.FileUtils:getInstance():getDownloadPath()
    netWorkManager:requestData("api/city/getcards", {data = data}, function ( cardDatas )
        -- dump(cardDatas)
        if cardDatas and next(cardDatas) and cardDatas.ver ~= ver then

            -- local path = device.writablePath.. "cardImage/" 
            local path = downloadPath .. "cardImage/" 
            cc.FileUtils:getInstance():createDirectory(path)
            path = path .. cityID .. "_"
            -- 保存数据到数据库
            local tableName = "card_" .. cityID 
            local labelName = "card_label_" .. cityID
            if not dataBaseManager:isTableExist(tableName) then
                -- 新建表
                dataBaseManager:createTable(tableName, tableFields.card_fields)
                dataBaseManager:createTable(labelName, tableFields.card_label_fields)
            end

            local tempCards = {}
            local cards = cardDatas.cards 
            dataBaseManager:deleteItem(tableName)
            dataBaseManager:deleteItem(labelName)
            if cards then
                local sqlTable = {}
                for k, card in pairs(cards) do
                    card.cardid = tonumber(card.cardid)
                    netWorkManager:getUrlFile(card.imgurl, path..card.cardid..".png", function (  )
                        
                    end)

                    local isCollect = 0
                    if QMapGlobal.cardDatas[cityID] then
                        local cards1 = QMapGlobal.cardDatas[cityID].cards
                        if cards1 and cards1[card.cardid] then
                            isCollect = cards1[card.cardid].iscollect or 0
                            -- print("获取的isCollect is ", isCollect)
                        end
                    end
                    card.iscollect = isCollect
                    -- dataBaseManager:insertValue(tableName, {card.cardid, card.cardname, card.imgid, card.desc, card.source, card.starlevel, card.type, isCollect, card.collectcount})
                    local sqlString = dataBaseManager:getInsertString(tableName, {card.cardid, card.cardname, card.imgid, card.desc, card.source, card.starlevel, card.type, isCollect, card.collectcount})
                    table.insert(sqlTable, sqlString)
                    local labels = card.label
                    for _, label in pairs(labels) do
                        -- dataBaseManager:insertValue(labelName, {card.cardid, label})
                        local sqlString1 = dataBaseManager:getInsertString(labelName, {card.cardid, label})
                        table.insert(sqlTable, sqlString1)
                    end
                    tempCards[card.cardid] = card
                end
                if next(sqlTable) then
                    dataBaseManager:commitTransaction(sqlTable)
                end
            end
            cardDatas.cards = tempCards
            QMapGlobal.cardDatas[cityID] = cardDatas
            dataBaseManager:setValue("city", {cardver = cardDatas.ver}, {{fieldName = "cityid", fieldValue = cityID}})

            if callBackSucceed then
                callBackSucceed()
            end
        end
    end, callBackFail)
end

-- 收藏卡牌
function DataManager:collectCard( cityID, cardID, isCollect, callBackSucceed, callBackFail )
    local data = {userid = 0, cityid = cityID, cardid = cardID, iscollect = isCollect}
    netWorkManager:requestData("api/card/collect", {data = data}, function ( returnData )
        -- dump(returnData)
        dataBaseManager:setValue("card_"..cityID, {iscollect = isCollect}, {{fieldName = "cardid", fieldValue = cardID}})
        -- print("33333333333333333333")
        if QMapGlobal.cardDatas[cityID] then
            -- print("22222222222222222222222")
            -- dump(QMapGlobal.cardDatas[cityID])
            if QMapGlobal.cardDatas[cityID].cards and QMapGlobal.cardDatas[cityID].cards[cardID] then
                QMapGlobal.cardDatas[cityID].cards[cardID].iscollect = isCollect
                local count = QMapGlobal.cardDatas[cityID].cards[cardID].collectcount
                -- print("111111111111111111111111")
                if isCollect == 1 then
                    count = count + 1
                else
                    count = count - 1
                end
                QMapGlobal.cardDatas[cityID].cards[cardID].collectcount = count
                if callBackSucceed then
                    callBackSucceed(count)
                end
            end
        end
        
    end, callBackFail)
end

-- 获取卡牌的收藏次数
function DataManager:getCollectCountForCard( cityID, cardID, callBackSucceed, callBackFail )
    local data = {cityid = cityID, cardid = cardID}
    netWorkManager:requestData("api/card/getcollcount", {data = data}, function ( returnData )
        dump(returnData)
    end, callBackFail)
end

-- 获取卡牌的弹幕
function DataManager:getBarrageForCard( cityID, cardID, callBackSucceed, callBackFail )
    local data = {cityid = cityID, cardid = cardID}
    netWorkManager:requestData("api/card/getcomment", {data = data}, function ( returnData )
        -- dump(returnData)
        if callBackSucceed then
            callBackSucceed(returnData)
        end
    end, callBackFail)
end


-- 写卡牌的弹幕
function DataManager:addBarrageForCard( cityID, cardID, content, callBackSucceed, callBackFail )
    local data = {cityid = cityID, cardid = cardID, content = content, userid = 0}
    netWorkManager:requestData("api/card/addcomment", {data = data}, function ( returnData )
        dump(returnData)
        if callBackSucceed then
            callBackSucceed(returnData)
        end
    end, callBackFail)
end

-- 下载小球
function DataManager:downloadBallFile( url, fileName, callBackSucceed, callBackFail )
    netWorkManager:getUrlFile(url, fileName, function ( )
        if callBackSucceed then
            callBackSucceed()
        end
    end)        
end

function DataManager:getTopichot( callBackSucceed, callBackFail )
-- dump(QMapGlobal.systemData.mapData)
    local cityID = QMapGlobal.gameState.curCityID or 0
    local cityData = QMapGlobal.systemData.mapData[cityID]
    local provid = 0
    if cityData then
        provid = cityData.provid or 0
    end
    -- dump(cityData)
    local data = {provid = tonumber(provid)}
    netWorkManager:requestData("api/topic/hot", {data = data}, function ( returnData )
        -- dump(returnData)
        if returnData and next(returnData) then
            -- QMapGlobal.topicHotData = QMapGlobal.topicHotData or {}
            QMapGlobal.topicHotData = {}

            local downloadPath = cc.FileUtils:getInstance():getDownloadPath()
            local filePath = downloadPath .. "topicHot/" 
            cc.FileUtils:getInstance():createDirectory(filePath) 

            for _, item in pairs(returnData) do
                
                local fileName = filePath .. item.topicid .. ".png"
                table.insert(QMapGlobal.topicHotData, {url = item.imglink, topicid = item.topicid, fileName = fileName})
                netWorkManager:getUrlFile(item.imglink, fileName, function ( )
                    if callBack then
                        callBack()
                    end
                end)       

            end
        end
        if callBackSucceed then
            callBackSucceed()
        end
    end, callBackFail)

end

function DataManager:SendPetMsg( userID, msgContent, callBackSucceed, callBackFail )
    print("send msg ", userID, msgContent)
    netWorkManager:requestData("api/message/pet/add", {data = {peerid = userID, content = msgContent}}, function ( returnData )
        print("pet msg 成功。。。。")
    end)
end

function DataManager:getShoutList( userID, callBackSucceed, callBackFail )
    netWorkManager:requestData("api/shout/list", {data = {userid = userID}}, function ( returnData )
        print("获取三句话 成功。。。。")
        print_r(returnData)
        if callBackSucceed then
            callBackSucceed(returnData)
        end
    end)
end

-- 关注好友，返回关注后的状态 0，没有关系，1，已经关注，2，只是粉丝，3互相关注
function DataManager:follow(isFollow, userID, callBackSucceed, callBackFail)
    netWorkManager:requestData("api/user/"..isFollow, {data = {userid = userID}}, function ( returnData )
        -- print("关注 成功。。。。")
        -- print_r(returnData)
        if callBackSucceed then
            callBackSucceed(returnData)
        end
    end, callBackFail)
end

-- 是否已经关注 ， 0，没有关系，1，已经关注，2，只是粉丝，3互相关注
function DataManager:isFollow( userID, callBackSucceed, callBackFail )
    netWorkManager:requestData("api/user/buddy/type", {data = {userid = userID}}, function ( returnData )
        if callBackSucceed then
            callBackSucceed(returnData)
        end
    end, callBackFail)
end

function DataManager:getCategoryInfo( categoryType, categoryID, callBackSucceed, callBackFail )
    local url = "api/category/"
    -- if categoryType == CategoryType_sight then
    local param = nil
    if categoryType == CategoryType_social then   
        url = url .. "social"
        param = {categoryid = categoryID}
    elseif categoryType == CategoryType_hotTag then
        url = url .. "tag"
        param = {tagid = categoryID}
    elseif categoryType == CategoryType_consume then
        url = url .. "cost"
        param = {categoryid = categoryID}
    else -- CategoryType_sight
        local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
        scheduler.performWithDelayGlobal(function (  )
            callBackSucceed()
        end, 0)
        return 
    end
    local _categoryType = categoryType
    netWorkManager:requestData(url, {data = param}, function ( returnData )
        -- local imglinks = returnData.imglink
        -- dump(returnData)
        local datas = {}
        for _, data in pairs(returnData) do
            local areaid = data.areaid
            if areaid then
                local dataTemp = {}
                dataTemp.count = data.count
                dataTemp.sightID = data.areaid
                if _categoryType == CategoryType_hotTag then
                    dataTemp.categoryID = data.tagid
                else
                    dataTemp.categoryID = data.categoryid
                end
                local imglinks = data.imglink
                if imglinks and next(imglinks) then
                    local fu = cc.FileUtils:getInstance()
                    local downloadPath = fu:getDownloadPath()
                    local categoryPicPath = downloadPath .. "temp/categoryPic/"
                    fu:createDirectory(categoryPicPath)
                    local images = {}
                    for i, imglink in pairs(imglinks) do
                        local fileName = dataTemp.categoryID .. "_" .. areaid .. "_" .. i .. ".png"
                        table.insert(images, fileName)
                        netWorkManager:getUrlFile(imglink, categoryPicPath .. fileName)
                    end
                    dataTemp.imgFiles = images
                else
                    dataTemp.count = 0
                end
                datas[areaid] = dataTemp
                -- dump(dataTemp)
            end
        end
        
        if callBackSucceed then
            callBackSucceed(datas)
        end
    end, callBackFail)
end

-- 网络操作结束

-- 以下是数据处理
function DataManager:getShowNameForSight( cityID, sightID)

    local cityData = QMapGlobal.systemData.mapData[cityID]
    if cityData then
        if cityData.sight and cityData.sight[sightID] then
            return cityData.sight[sightID].cname
        end
    end
    return nil
end

-- 判断景点true还是片区false
function DataManager:isSight( cityID, sightID)
    -- print("isSight..", cityID, sightID)
    local cityData = QMapGlobal.systemData.mapData[cityID]

    if cityData then
        if cityData.sight and cityData.sight[sightID] then
            -- print("景点的类型。。", sightID, cityData.sight[sightID].type)
            if cityData.sight[sightID].type or cityData.sight[sightID].type == SpaceType_sight then 
                -- print("false")
                return true
            else
                -- print("true")
                return false
            end
        end
    end
    return false
end
-- 数据处理结束

return DataManager


















