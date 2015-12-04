
QMapGlobal.menuDescription = {
 
    itemImageBasePath = "ui/menu/image/",
    
    configForViewControllers = {
    
        -- 城市景点
        ScenicSpotsController = {
            topBar = {
                position1 = {type = "Button",  btnScale = 1,  fontScale = 2.3,    name = "back102", dW = -40, dH = 10,caption = "",captionPos = "R", initEnabled = true},
                -- position2 = {type = "LocationLabel2", name = "cityName", csbFile = "ui/menu/locationLabel2.csb", } --btn = {pnlback = "swicthCity"}}
                position2 = {type = "LocationLabel4", name = "cityName", csbFile = "ui/menu/locationLabel4.csb", }
                -- position3 = {type = "LocationLabel1", name = "cityName", csbFile = "ui/menu/locationLabel1.csb"}
            },
            bottomBar = {
                -- position1 = {type = "Button", name = "start", caption = "开始",captionPos = "D", initEnabled = true},
                position2 = {type = "Button", name = "strategy1", caption = nil,captionPos = "D", initEnabled = true, btnScale = 2, },
                -- position3 = {type = "Button", name = "record", caption = "说说",captionPos = "D", initEnabled = true}
                -- position2 = {type = "LocationLabel2", scale = 1.5, dH = -50, csbFile = "ui/menu/locationLabel3.csb", btn = {task = "strategy", shop = "shop"}}
            },
            -- suspendBar = {
            --     position1 = {type = "Button", name = "shop", btnScale = 1.8, caption = "",captionPos = "D", initEnabled = true, disVisible = true, varHeight = false, fontY = -50},
            --     position2 = {type = "Button", name = "strategy", btnScale = 1.8, caption = "",captionPos = "D", initEnabled = true, disVisible = true},
            -- }
        },
        
        -- 点评
        TravelCommentController = {
            topBar = {
                position1 = {type = "Button",        name = "back", caption = "返回",captionPos = "R", initEnabled = true},
                position2 = {type = "LocationLabel", name = "cityName", csbFile = "ui/menu/locationLabel.csb"}
            },
            bottomBar = {
                position1 = {type = "Button", name = "edit", caption = "编辑",captionPos = "D", initEnabled = true},
                position3 = {type = "Button", name = "publish", caption = "发布",captionPos = "D", initEnabled = true}
            }
        },
        
        -- 查看游记
        BrowseTravelNoteController = { 
            topBar = {
                -- position1 = {type = "Button", name = "back", caption = "返回",captionPos = "R", initEnabled = true},
                position2 = {type = "CustomizedWidget", name = "jouneyWidget", csbFile = "ui/menu/CollectCaptionNode.csb"}

            },
            bottomBar = {
                position1 = {type = "Button", name = "roundBack",   caption = "返回",  captionPos = "D", initEnabled = true},
                -- position2 = {type = "Button", name = "addFavorite", caption = "收藏",  captionPos = "D", initEnabled = true},
                position3 = {type = "Button", name = "next",        caption = "下一篇", captionPos = "D", initEnabled = true}
            }
        },
        
        -- 行程
        PlanTravelRouteController = {
            topBar = {
                position1 = {type = "Button",        name = "back", caption = "返回",captionPos = "R", initEnabled = true},
                position2 = {type = "LocationLabel", name = "cityName", csbFile = "ui/menu/locationLabel.csb"}
            },
            bottomBar = {
                position1 = {type = "Button", name = "sort",   caption = "排序",    captionPos = "D", initEnabled = true},
                position3 = {type = "Button", name = "delete", caption = "清除全部", captionPos = "D", initEnabled = true}
            }
        },

        -- city selection logged in
        CitySelectionViewControllerLoggedIn = {
            topBar = {
                position2 = {type = "CustomizedWidget", name = "jouneyWidget", csbFile = "ui/menu/CollectCaptionNode.csb"}
            },  
            bottomBar = {
                -- position1 = {type = "Button", name = "sort",   caption = "排序",    captionPos = "D", initEnabled = true},
                -- position3 = {type = "Button", name = "delete", caption = "清除全部", captionPos = "D", initEnabled = true}
            }
        },

        -- city selection un-logged in
        CitySelectionViewControllerUnloggedIn = {
            topBar = {
                position2 = {type = "LocationLabel", name = "cityName", csbFile = "ui/menu/locationLabel.csb"},
                -- position3 = {type = "Button",        name = "back", initEnabled = true}
            },
            bottomBar = {
                -- position1 = {type = "Button", name = "sort",   caption = "排序",    captionPos = "D", initEnabled = true},
                -- position3 = {type = "Button", name = "delete", caption = "清除全部", captionPos = "D", initEnabled = true}
            }
        },

        StrategyController = {
            topBar = {
                position1 = {type = "Button",        name = "back", caption = "返回",captionPos = "R", initEnabled = true},
                position2 = {type = "LocationLabel", name = "cityName", csbFile = "ui/menu/locationLabel.csb"}
            },
            bottomBar = {
                position1 = {type = "Button", name = "food", caption = "美食",captionPos = "D", initEnabled = true},
                position2 = {type = "Button", name = "task", caption = "任务",captionPos = "D", initEnabled = true},
                position3 = {type = "Button", name = "cardCollect", caption = "我的收藏",captionPos = "D", initEnabled = true}
            }
        },
    }
} 
