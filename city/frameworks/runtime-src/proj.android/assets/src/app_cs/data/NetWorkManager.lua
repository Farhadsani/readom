
-- 网络管理，负责网络数据请求发送

local NetWorkManager = class("NetWorkManager")

function NetWorkManager:ctor(  )
	-- body
end


--参数：协议名
function NetWorkManager:requestData(agreementName, reqParam, callBackSucceed, callBackFail)
    -- 向服务器发送数据
    local onRequestFinished = function ( event )
        -- dump(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            -- 请求失败，显示错误代码和错误消息
            if request:getErrorCode() ~= 0 then
                print("服务器。。。。", request:getErrorCode(), request:getErrorMessage())
                -- device.cancelAlert()
                -- device.showAlert("服务器连接异常!", request:getErrorMessage(), {"关闭"}, function ( event )
                --     if event.buttonIndex == 1 then
                --         device.cancelAlert()
                --     end
                -- end)
                if callBackFail then 
                    callBackFail(request:getErrorMessage())
                end
            end
            return
        end

        print("服务器已经返回。。。", agreementName)
     
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            -- 请求结束，但没有返回 200 响应代码
            print("服务器返回码。。。。", code)
            -- device.cancelAlert()
            -- device.showAlert("服务器连接失败!", request:getErrorMessage(), {"关闭"}, function ( event )
            --     if event.buttonIndex == 1 then
            --         device.cancelAlert()
            --     end
            -- end)
            
            if callBackFail then 
                callBackFail("连接服务器失败")
            end
            return
        end
     
        -- 请求成功，显示服务端返回的内容
        local response = request:getResponseString()
        -- print("请求成功！", response)
        response = json.decode(response)
        -- print_r(response)
        if response.ret ~= 0 then
            print(response.msg)

            -- device.cancelAlert()
            -- device.showAlert("服务器出错!", response.msg, {"关闭"}, function ( event )
            --     if event.buttonIndex == 1 then
            --         device.cancelAlert()
            --     end
            -- end)

            if callBackFail then 
                callBackFail(response.msg)
            end
            return 
        end
        if callBackSucceed then
            callBackSucceed(response.res)
        end
    end
    
    print("联网开始。。。", agreementName)
    -- 创建一个请求，并以 GET 方式发送数据到服务端
    local url = QMapGlobal.serverUrl .. agreementName   
    print("url = ", url)
    -- local url = "http://www.baidu.com"
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    local requestHeaderString = lua_getRequestHeader() or "User-Agent:shitouren_qmap"
                            -- "User-Agent:shitouren_qmap_android"
    -- request:addRequestHeader("User-Agent:shitouren_qmap_ios")
    print("RequestHeader = ", requestHeaderString)
    request:addRequestHeader(requestHeaderString)
    request:setTimeout(5000)

    local cookieString = "shitouren_ssid=" .. lua_getSSID() .. ";shitouren_check=" .. (lua_getSSIDCheck() or "lua_check") .. ";shitouren_verify=" .. (lua_getSSIDVerify() or "lua_verify")
    local ver = getVersion()

    print("当前应用程序的版本是。。", ver)
    cookieString = cookieString .. ";" .. "shitouren_ver=" .. ver
    -- curl_easy_setopt(easy_handle, CURLOPT_COOKIE, "name=JGood; address=HangZhou"); 
    print("cookie......", cookieString)
    request:setCookieString(cookieString) 

    local param = {idx = 0, ver = ver, params = reqParam.data}
    -- dump(param)
    local paramJson = json.encode(param)
	-- param = "{\"idx\":0,\"ver\":210,\"params\":{ "  .. (param or "") .. "}}"
	print("param = ", paramJson)

    -- request:setResponseData(param)
    -- request:addPOSTValue("postData", paramJson)   -- 使用这种方式加入的数据会被addFormContents覆盖
    request:addFormContents("postData", paramJson)   -- 数据

    local files = reqParam.file
    if files and next(files) then
        
        for _,file in pairs(files) do
            local fileFieldName = file.fieldName    -- "imgfile"
            local filePath = file.path    -- device.writablePath.."img/journey/full/1/1_1_1.jpg"
            local contentType = file.contentType      --  "Image/jpeg"
            request:addFormFile(fileFieldName, filePath, contentType)  -- 文件
            print(fileFieldName, filePath, contentType)

            -- request:addFormFile(fileFieldName, device.writablePath.."img/journey/full/1/1_1_2.jpg", contentType)
        end
    end
    
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
    
end


-- agreementName: "http://static.shitouren.com/group1/M00/00/05/0g6asVU98QuAaaMSAADADEWq7bQ509.jpg"
-- filePath: device.writablePath.."1.jpg"
function NetWorkManager:getUrlFile(agreementName, filePath, callBackSucceed, callBackFail, callbackPrecent)
    -- 向服务器发送数据

    local onRequestFinished = function ( event )

        -- "dltotal" = 565547
        -- "name"    = "progress"
        -- "request" = userdata: 0x17485f468
        -- "total"   = 626274
        -- dump(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            -- 请求失败，显示错误代码和错误消息
            -- print("服务器。。。。", request:getErrorCode(), request:getErrorMessage())      
            if request:getErrorCode() ~= 0 then
                -- print("服务器。。。。", request:getErrorCode(), request:getErrorMessage())   
                print("save file failed!, file name is ", filePath)
                if callBackFail then 
                    callBackFail(request:getErrorMessage())
                end
            else
                if callbackPrecent then
                    if event.total ~= 0 then
                        local precent = event.dltotal / event.total 
                        callbackPrecent(precent)
                    end
                end
            end    
            return
        end
     
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            -- 请求结束，但没有返回 200 响应代码
            print("服务器返回码。。。。", code)
            print("save file failed!, file name is ", filePath)
            if callBackFail then 
                callBackFail(request:getErrorMessage())
            end
            return
        end

        -- print("save file succeed!, file name is ", filePath)
        request:saveResponseData(filePath)
        if callBackSucceed then
            callBackSucceed()
        end
    end
    -- print("下载文件开始。。。", agreementName, filePath)
    local request = network.createHTTPRequest(onRequestFinished, agreementName, "GET")
    request:setTimeout(10000)
    request:start()
    -- print("1111111111")
end

return NetWorkManager




-- {ret=0, msg="ok", idx=0, res=
-- {username="Tomcat", utime="2015-04-27 16:19:23", title="桂林之行", cityid=1, userid=111, 
--     journey = 
--         {
--             [1]={markid=1, sightid=1, journeyid=1, mark="今天中午饭堂", userid=111, ctime="2015-04-27 16:19:23", ordernum=1}, 
--             [2]={markid=2, 
--                     image={
--                         [1]={ctime="2015-04-27 16:26:36", imgurl="http://static.shitouren.com/group1/M00/00/05/0g6asVU98QuAaaMSAADADEWq7bQ509.jpg", imgid=100000182, imgname="2_2_1.jpg"}, 
--                         [2]={ctime="2015-04-27 16:26:44", imgurl="http://static.shitouren.com/group1/M00/00/05/0g6asVU98QuAc6a9AAChguoDk3k536.jpg", imgid=100000183, imgname="2_2_2.jpg"}
-- }
-- , sightid=2, journeyid=1, mark="今天下午", userid=111, ctime="2015-04-27 16:19:23", ordernum=2}
-- }
-- , journeyid=1}
-- }




