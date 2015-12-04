//
//  ImagePicker.h
//  qmap
//
//  Created by Shenghua Su on 3/31/15.
//
//

#ifndef __qmap__ImagePicker__
#define __qmap__ImagePicker__

#include <stdio.h>

#include "math/CCGeometry.h"

class ImagePicker
{
public:
    
    typedef enum {
        PickFromPhotoLibrary    = 1,
        PickFromCamera          = 2,
        UserChoose              = 3
    } PickSource;
    
    typedef enum {
        NoError,
        PickSourceNotDefined,
        PickSourceNotAvailable
    } Error;
    
    static void pickImage(PickSource source,
                          float jpgImageQuality,
                          bool useCustomizedImageFitSize,
                          cocos2d::Size customizedImageFitSize,
                          const char* imageSavePath,
                          bool createThumbnail,
                          cocos2d::Size thumbnailFillSize,
                          const char* thumbnailSavePath,
                          const std::function<void(bool)>& pickImageDoneCallback,
                          int luaHandler,
                          Error* error);
    
    static int getLuaHandler();
    
};

#endif /* defined(__qmap__ImagePicker__) */
