//
//  ImageManager.cpp
//  qmap
//
//  Created by 石头人6号机 on 15/4/3.
//
//

#include "ImageManager.h"
//#import "SDWebImageManager.h"

//int lua_register_qmap_GestureRecognizer(lua_State* tolua_S)
//{
//    tolua_usertype(tolua_S,"qm.GestureRecognizer");
//    tolua_cclass(tolua_S,"GestureRecognizer","qm.GestureRecognizer","cc.Node",nullptr);
//    
//    tolua_beginmodule(tolua_S,"GestureRecognizer");
//    tolua_function(tolua_S,"create", lua_qmap_GestureRecognizer_create);
//    tolua_function(tolua_S,"applyToNode", lua_qmap_GestureRecognizer_applyToNode);
//    tolua_function(tolua_S,"removeFromNode", lua_qmap_GestureRecognizer_removeFromNode);
//    tolua_function(tolua_S,"setEnabled", lua_qmap_GestureRecognizer_setEnabled);
//    tolua_function(tolua_S,"addSingleTapCallback", lua_qmap_GestureRecognizer_addSingleTapCallback);
//    tolua_function(tolua_S,"addDoubleTapCallback", lua_qmap_GestureRecognizer_addDoubleTapCallback);
//    tolua_function(tolua_S,"addPanCallback", lua_qmap_GestureRecognizer_addPanCallback);
//    tolua_function(tolua_S,"addDoubleFingersTapCallback", lua_qmap_GestureRecognizer_addDoubleFingersTapCallback);
//    tolua_function(tolua_S,"addPinchCallback", lua_qmap_GestureRecognizer_addPinchCallback);
//    tolua_endmodule(tolua_S);
//    std::string typeName = typeid(GestureRecognizer).name();
//    g_luaType[typeName] = "qm.GestureRecognizer";
//    g_typeCast["GestureRecognizer"] = "qm.GestureRecognizer";
//    return 1;
//}


//TOLUA_API int register_ImageManager_manual(lua_State* tolua_S)
//{
//    if (NULL == tolua_S)
//        return 0;
//    
//    tolua_open(tolua_S);
//    
//    tolua_module(tolua_S,"ImageManager",0);
//    tolua_beginmodule(tolua_S,"ImageManager");
//    
//    lua_register_qmap_QMapActionInterval(tolua_S);
//    lua_register_qmap_GestureRecognizer(tolua_S);
//    
//    tolua_endmodule(tolua_S);
//    
//    return 1;
//}


//void ImageManager::getImage()
//{
//    SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
//    //    [imageManager diskImageExistsForURL:[NSURL URLWithString:@"http://image.baidu.com/detail/newindex?col=%E8%B5%84%E8%AE%AF&tag=%E5%A8%B1%E4%B9%90&pn=0&pid=5692241461084217137&aid=&user_id=10086&setid=-1&sort=0&newsPn=0&star=angelababy&fr=&from=1"]];
//    ////    [imageManager ]
//    //    [imageManager downloadImageWithURL:[NSURL URLWithString:@"http://static.shitouren.com/img/sight/full/[cityid]/[sightid]/[imageid].jpg"] options:SDWebImageRetryFailed progress:NULL  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) { }];
//    //    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    
//    NSURL* imagePath = [NSURL URLWithString:@"http://s14.sinaimg.cn/middle/9914f9fdhbc611c219f3d&690"];
//    [imageManager downloadImageWithURL:imagePath options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//     
//        NSLog(@"显示当前进度,%ld,%ld", receivedSize, expectedSize);
//     
//     } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//     //        [self.image1 sd_setImageWithURL:imageURL];
//        NSLog(@"下载完成");
//     }];
//
//}
