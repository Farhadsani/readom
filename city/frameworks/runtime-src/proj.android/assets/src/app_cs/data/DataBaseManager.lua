
-- 数据库管理，负责封装数据库操作

local DataBaseManager = class("DataBaseManager")

function DataBaseManager:ctor()

end

-- 检查表是否存在，输入表名
function DataBaseManager:isTableExist(tableName)
    local SQL = "SELECT count(*) FROM sqlite_master WHERE type='table' AND name='" .. tableName .. "'"
    local result = lua_sqlite3_get_table(SQL)
    print_r(result)
    -- print("function DataManager:isTableExist(tableName)", tableName)
    -- print(result[1]["count(*)"] ~= "0")
    return result[1]["count(*)"] ~= "0"
end

function DataBaseManager:createTable(tableName, fields)
    
--    local SQL = "CREATE TABLE \"city\" (\"cityid\" INTEGER PRIMARY KEY  NOT NULL  UNIQUE , \"name\" VARCHAR NOT NULL  UNIQUE , \"cname\" TEXT NOT NULL , \"posX\" INTEGER NOT NULL, \"posY\" INTEGER NOT NULL, \"provid\" INTEGER )"
    local SQL = "CREATE TABLE '" .. tableName .. "' ("
    local fieldSql = nil
    for _, field in ipairs(fields) do
    	if fieldSql then
            fieldSql = fieldSql .. ", '" .. field.name .. "' " .. field.attri
    	else
            fieldSql = " '" .. field.name .. "' " .. field.attri
    	end
    end
    SQL = SQL .. fieldSql .. ")"
    
    lua_sqlite3_exec(SQL) 
end

function DataBaseManager:insertValue(tableName, items)
    -- local SQL = "INSERT INTO '" .. tableName .. "' values("
    -- local itemSql = nil
    -- dump(items)
    -- for _, item in ipairs(items) do
    --     if itemSql then
    --         itemSql = itemSql .. ", '" .. item .. "'"
    -- 	else
    --         itemSql = " '" .. item .. "' "
    -- 	end
    -- end
    -- SQL = SQL .. itemSql .. ")"

    local SQL = self:getInsertString( tableName, items )
    if SQL then
        lua_sqlite3_exec(SQL)
    end
end

function DataBaseManager:getInsertString( tableName, items )
    local SQL = "INSERT INTO '" .. tableName .. "' values("
    local itemSql = nil
    for _, item in ipairs(items) do
        if itemSql then
            itemSql = itemSql .. ", '" .. item .. "'"
        else
            itemSql = " '" .. item .. "' "
        end
    end
    if itemSql then
        SQL  = SQL .. itemSql .. ")"
        return SQL
    else
        return nil
    end
end

function DataBaseManager:getDeleteItemString( tableName, conditions )
    local SQL = "DELETE FROM " .. tableName
    if conditions and next(conditions) then
        local conditionSql = nil
        for _, condition in ipairs(conditions) do
            if conditionSql then
                conditionSql = conditionSql .. " AND " .. condition.fieldName .. " = " .. condition.fieldValue
            else
                conditionSql = condition.fieldName .. " = " .. condition.fieldValue
            end
        end
        if conditionSql then
            SQL = SQL .. " WHERE " .. conditionSql 
        end
    end
    return SQL
end

function DataBaseManager:deleteItem( tableName, conditions )
    -- delete from guilinTable where ID = 2
    -- local SQL = "DELETE FROM " .. tableName
    -- if conditions and next(conditions) then
    --     local conditionSql = nil
    --     for _, condition in ipairs(conditions) do
    --         if conditionSql then
    --             conditionSql = conditionSql .. " AND " .. condition.fieldName .. " = " .. condition.fieldValue
    --         else
    --             conditionSql = condition.fieldName .. " = " .. condition.fieldValue
    --         end
    --     end
    --     if conditionSql then
    --         SQL = SQL .. " WHERE " .. conditionSql 
    --     end
    -- end
    local SQL = self:getDeleteItemString( tableName, conditions )
    lua_sqlite3_exec(SQL)
end

function DataBaseManager:getSetValueString( tableName, fields, conditions)
    -- UPDATE 表 SET 列 = '新值', 列2 = ‘新值2’ 【WHERE 条件语句】
    local SQL = "UPDATE " .. tableName .. " SET "
    local fieldSql = nil
    -- print_r(fields)
    for key,value in pairs(fields) do
        -- print(key, value)
        if fieldSql then
            fieldSql = fieldSql .. ", '" .. key .."' = '" .. value .. "'"
        else
            fieldSql = "'" .. key .."' = '" .. value .. "'"
        end
    end
    if not fieldSql then return end

    SQL = SQL ..fieldSql 
    if conditions and next(conditions) then
        local conditionSql = nil
        for _, condition in ipairs(conditions) do
            -- print_r(condition)
            if conditionSql then
                conditionSql = conditionSql .. " AND " .. condition.fieldName .. " == " .. condition.fieldValue
            else
                conditionSql = condition.fieldName .. " == " .. condition.fieldValue
            end
        end
        SQL = SQL .. " WHERE " .. conditionSql 
    end

    return SQL
end

function DataBaseManager:setValue( tableName, fields, conditions)
    -- -- UPDATE 表 SET 列 = '新值', 列2 = ‘新值2’ 【WHERE 条件语句】
    -- local SQL = "UPDATE " .. tableName .. " SET "
    -- local fieldSql = nil
    -- -- print_r(fields)
    -- for key,value in pairs(fields) do
    --     -- print(key, value)
    --     if fieldSql then
    --         fieldSql = fieldSql .. ", '" .. key .."' = '" .. value .. "'"
    --     else
    --         fieldSql = "'" .. key .."' = '" .. value .. "'"
    --     end
    -- end
    
    -- SQL = SQL ..fieldSql 
    -- if conditions and next(conditions) then
    --     local conditionSql = nil
    --     for _, condition in ipairs(conditions) do
    --         print_r(condition)
    --         if conditionSql then
    --             conditionSql = conditionSql .. " AND " .. condition.fieldName .. " == " .. condition.fieldValue
    --         else
    --             conditionSql = condition.fieldName .. " == " .. condition.fieldValue
    --         end
    --     end
    --     SQL = SQL .. " WHERE " .. conditionSql 
    -- end
    local SQL = self:getSetValueString( tableName, fields, conditions)
    if SQL then
        lua_sqlite3_exec(SQL)
    end
end

function DataBaseManager:select(tableName, fields, conditions)
    local fieldSql = nil
    -- print("111111111111111111111111111")
    -- print_r(fields)
    if fields and next(fields) then
        for _, field in ipairs(fields) do
            print_r(field)
        	if fieldSql then 
                fieldSql = fieldSql .. "," .. field
        	else
                fieldSql = field
        	end
        end
    else
        fieldSql = " * "
    end
    
    local SQL = "SELECT " .. fieldSql .. " FROM " .. tableName  -- .. " WHERE sightid == " .. sight.sightid
    if conditions and next(conditions) then
        local conditionSql = nil
        for _, condition in ipairs(conditions) do
        print_r(condition)
            if conditionSql then
                conditionSql = conditionSql .. " AND " .. condition.fieldName .. " == " .. condition.fieldValue
            else
                conditionSql = condition.fieldName .. " == " .. condition.fieldValue
            end
        end
        SQL = SQL .. " WHERE " .. conditionSql 
    end
    return lua_sqlite3_get_table(SQL)
end

-- 批量操作数据库
function DataBaseManager:commitTransaction( sqlTable )
    print("lua 中已经开始操作数据库事务了。。。。。。。")
    lua_sqlite3_commit(sqlTable)
end

return DataBaseManager


