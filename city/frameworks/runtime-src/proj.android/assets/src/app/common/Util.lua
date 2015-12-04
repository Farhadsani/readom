


-- function print a table 
-- paramTable :table
function print_r(paramTable, ret, indent)
    --    if GM.debugPrintToFile or Util.isPlatform(CC_PLATFORM_WIN32) then   
    local r = ""
    local t = type(paramTable)
    if t == "table" then
        if not indent then indent = 0 end
        r = "{"
        local first = true
        for k,v in pairs(paramTable) do
            local key = print_r(k, true, indent + 1)
            local value = print_r(v, true, indent + 1)

            key = (type(k) == "number") and "[" .. key .. "]" or key

            value = (type(v) == "string")  and '"' .. value .. '"' or value

            r = r .. (first and "" or ", ") .. key .. "=" .. value
            if first then first = false end
        end
        r = r .. "}\n"
    elseif t == "function" then r = "funciton"
    elseif t == "string" then   r = paramTable
    elseif t == "boolean" then  r = paramTable and "true" or "false"
    elseif t == "nil" then      r = t
    elseif t == "userdata" then
        t = tolua.type(paramTable)
        if t == "CCPoint" then r = "{x="..paramTable.x..",y="..paramTable.y.."}"
        elseif t == "CCSize" then r = "{width="..paramTable.width..",height="..paramTable.height.."}"
        elseif t == "CCRect" then r = "{origin="..print_r(paramTable.origin, true)..",size="..print_r(paramTable.size, true).."}"
        else r = t
        end
    else r = r .. paramTable
    end
    if ret then return r else print(r) end
    --    end
end

-- 拆分字符串成一个数组
function Split(szFullString, szSeparator)  
    if not szFullString then return nil end
--    print("in Split", szFullString)
    local nFindStartIndex = 1  
    local nSplitIndex = 1  
    local nSplitArray = {}  
    while true do  
--        print("11111", nFindLastIndex)
        local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)  
--        print(nFindLastIndex)
        if not nFindLastIndex then  
            nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))  
            break  
        end  
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)  
        nFindStartIndex = nFindLastIndex + string.len(szSeparator)  
        nSplitIndex = nSplitIndex + 1  
    end  
    return nSplitArray  
end  

-- 拆分字符串成一个表，并将值作为key
function  Split1( szFullString, szSeparator )
    if not szFullString then return nil end

    local nFindStartIndex = 1  
    local nSplitIndex = 1  
    local nSplitArray = {}  
    while true do  

        local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)  
--        print(nFindLastIndex)
        if not nFindLastIndex then  
            local value = string.sub(szFullString, nFindStartIndex, string.len(szFullString)) 
            nSplitArray[value] =  nSplitIndex
            break  
        end  
        local value = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
        nSplitArray[value] = nSplitIndex
        nFindStartIndex = nFindLastIndex + string.len(szSeparator)  
        nSplitIndex = nSplitIndex + 1  
    end  
    return nSplitArray  
end

function AnalysisNode (this, nodeName)
--	this:getchild
end


-- 排序,
-- array:需要排序的数组，必须是连续的数字下标。
-- sortKeys :排序字段表  
sequenceSort = function ( array, sortKeys )
    -- sortKeys = sortKeys
    if not sortKeys or not next(sortKeys) then
        print("no sortKey!")
        return array
    end
    local sortTime = #sortKeys
    local sortTypes = {[1]="ascending", [2]="descending"}   -- 1 升序， 2 降序

    local sortFunc = function(table1, table2)
        if not table1 or not table2 then 
            print("!!! can not sort array because have not element")
            return false
        end
        local sortContinue
        sortContinue = function ( index )
            if index > sortTime then return false end
            -- ¹Ø¼ü×ÖÒ»¸öÒ»¸öµÄ¶Ô±È
            -- print("sortKeys........", sortKeys[index])
            local sortKey, sortType = sortKeys[index][1], sortKeys[index][2]
            sortType = sortType or 1
            sortType = sortTypes[sortType]

            local var1, var2 = table1[sortKey], table2[sortKey]
            if type(var1) ~= "boolean" and type(var2) ~= "boolean" then
                if sortType == "ascending" then
                    var1 = var1 or 9999999
                    var2 = var2 or 9999999
                else
                    var1 = var1 or -9999999
                    var2 = var2 or -9999999
                end
                if not var1 or not var2 then 
                    print("!!! can not sort array by key is", sortKey)
                    return false 
                end
            end
            local i = 1
            if type(var1) == "boolean" then var1 = var1 and i or -i end
            if type(var2) == "boolean" then var2 = var2 and i or -i end
            if var1 == var2 then
                index = index + 1
                return sortContinue(index)
            else
                if sortType == "ascending" then
                    -- ÉýÐò
                    return var1 < var2
                else
                    -- ½µÐò
                    return var1 > var2
                end
            end
        end
        return sortContinue(1)
    end
    table.sort(array, sortFunc)
    return array
end

analysisColor = function ( colorString )
    local r = string.sub(colorString, 1, 2) 
    local g = string.sub(colorString, 3, 4)
    local b = string.sub(colorString, 5, 6)
    local z = string.sub(colorString, 7, 8)
    r = tonumber(r, 16)
    g = tonumber(g, 16)
    b = tonumber(b, 16)
    z = tonumber(z, 16)
    -- print(r,g,b,z)
    -- return cc.c4b(r,g,b,z)
    return {r = r, g = g, b = b, z = z}
end

-- 获取应用程序的版本
getVersion = function (  )
    print("获取当前的版本。。。", QMapGlobal.gameState.ver )
    -- return 
    return QMapGlobal.gameState.ver 
end





