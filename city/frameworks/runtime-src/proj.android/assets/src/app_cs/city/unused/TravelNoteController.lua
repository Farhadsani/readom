-- TravelNoteController.lua add star 2015.3.5
-- 行程页面控制器，有主界面的行程按钮进入


local TravelNoteController = class("TravelNoteController", require("app/controllers/ViewController"))

function TravelNoteController:ctor(param)
    TravelNoteController.super.ctor(self, param)
    self.name = "TravelNoteController"
    self.viewClassPath = "app/city/TravelNoteView.lua"
    self.superior = param.superior
    self.cityData = param.cityData
end

-- handle events from self.view
function TravelNoteController:tapMapLocationItemWithName(itemName)
    print("TravelNoteController:tapMapLocationItemWithName", itemName)
    local packDatas = self.cityData.sight
    for key, pack in pairs(packDatas) do
        if pack.name == itemName then
            self.curPackData = pack
            break  
        end
    end
    
    self.itineraryData = QMapGlobal.userData.userInfo.itinerary.qingdao
    if self.curPackData then
        local btnCaption = "采集"
        local func = self.onCollect
        for key, itinerary in pairs(self.itineraryData) do
        	if itinerary.id == self.curPackData.id then
        	   btnCaption = "取消"
        	   func = self.onDelCollect
        	   break
        	end
        end
        self.view:showPackMenu({packName = self.curPackData.cName, caption = btnCaption, node = self, func = func})
    end     
end

-- 排序
function TravelNoteController:onSort()
    self.superior:switchView("TravelNoteSortViewController")
end

-- 删除
function TravelNoteController:onDelete()

end


-- 返回 返回到城市地图主页面
function TravelNoteController:onBack()
    self.superior:switchView("MainCityViewController")
end

-- 采集
function TravelNoteController:onCollect()
    print("采集。。。。。。")
    table.insert(self.itineraryData, {id = self.curPackData.id})
    self.view:refresh(self.itineraryData)
end

-- 取消采集
function TravelNoteController:onDelCollect()
    print("取消采集。。。。。。")
    for key, itinerary in pairs(self.itineraryData) do
    	if itinerary.id == self.curPackData.id then
            table.remove(self.itineraryData,key)
            self.view:refresh(self.itineraryData)
            break
    	end
    end
end

function TravelNoteController:tapMenuButtonWithName(buttonName)
    print("TravelNoteController:tapMenuButtonWithName:", buttonName)
    if buttonName == "sort" then
        self:onSort()
    elseif buttonName == "delete" then
        self:onDelete()
    elseif buttonName == "back" then
        self:onBack()
    end
end

return TravelNoteController