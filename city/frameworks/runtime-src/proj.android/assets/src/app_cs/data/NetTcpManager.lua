

-- 网络长连接管理

local  NetTcpManager = class("NetTcpManager")

function NetTcpManager:ctor(  )
	-- body
end

-- 初始化
function NetManager:init(  )
 	self._listenerList = {}
 	scnet.init()
 	scnet.connect(host,port)
end
 
 
 
 
 
-- 注册消息
-- 注册之后 接受到服务器消息之后进行广播，谁注册，谁相应
function NetManager:registerMsg( msgid,callBack )
 	self._listenerList[msgid] = self._listenerList[msgid] or {}
 	local isExist = self:findCallBack(msgid,callBack)
 	if not isExist then
 		table.insert(self._listenerList[msgid],callBack)
 	end
end
 
 
 
-- 移除注册消息
function NetManager:removeRegister( msgid,callBack )
 	if self._listenerList[msgid] then
 		for k,v in pairs(self._listenerList) do
 			if v == callBack then
 				self._listenerList[msgid][k] = nil
 			end
 		end
 	end
end
 
 
 
-- 发送消息
-- 整理数据发送给服务器
function NetManager:sendMsg( msgid,data )
 	scnet.send(msgid,data)
end
 
 
 
-- 接受消息
-- 派发事件（数据）
function NetManager:receiveMsg( msgid,data )
 	if self._listenerList[msgid] then
 		for k,v in pairs(self._listenerList[msgid]) do
 			v(data)
 		end
 	end
end
 
 
function NetManager:findCallBack( msgid,callBack )
 	for k,v in pairs(self._listenerList[msgid]) do
 		if v == callBack then
 			return true
 		end
 	end
 	return false
end
 
return NetTcpManager

