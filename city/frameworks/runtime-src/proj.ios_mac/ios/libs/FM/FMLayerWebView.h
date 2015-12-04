//
//  FMLayerWebView.h
//  qmap
//
//  Created by 石头人6号机 on 15/5/20.
//
//

#ifndef qmap_FMLayerWebView_h
#define qmap_FMLayerWebView_h

//

//  FMLayerWebView.h

#include "platform/CCCommon.h"

#include "cocos2d.h"

USING_NS_CC;

class FMLayerWebView : public Layer{
    
public:
    
    FMLayerWebView();
    
    ~FMLayerWebView();
    
    virtual bool init();
    
//    LAYER_NODE_FUNC(FMLayerWebView);
    CREATE_FUNC(FMLayerWebView);
    
    void webViewDidFinishLoad();
    
    void onBackbuttonClick();
    void openURL(std::string strUrl);
    void setCallBack();
    
private:
    
    int mWebViewLoadCounter;
    
};

#endif
