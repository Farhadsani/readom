//
//  FMLayerWebView.m
//  qmap
//
//  Created by 石头人6号机 on 15/5/20.
//
//

//

//  FMLayerWebView.mm

#include "FMLayerWebView.h"

#include "FMUIWebViewBridge.h"


static FMUIWebViewBridge *g_FMUIWebViewBridge=nil;

FMLayerWebView::FMLayerWebView(){
    
}

FMLayerWebView::~FMLayerWebView(){
    
    [g_FMUIWebViewBridge release];
    
}

void FMLayerWebView::webViewDidFinishLoad(){
    
}

void FMLayerWebView::onBackbuttonClick(){
    
    this->removeFromParentAndCleanup(true);
    
}

bool FMLayerWebView::init(){
    
    if ( !CCLayer::init() ){
        
        return false;
        
    }
    
    g_FMUIWebViewBridge = [[FMUIWebViewBridge alloc] init];
    
//    [g_FMUIWebViewBridge setLayerWebView : this URLString:"http://www.baidu.com"];
    
    return true;
    
}

void FMLayerWebView::setCallBack()
{
    
}

void FMLayerWebView::openURL(std::string strUrl){
    [g_FMUIWebViewBridge setLayerWebView : this URLString:strUrl.c_str()];
}
