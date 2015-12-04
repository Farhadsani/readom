//
//  CursorTextField.h
//  CursorInputDemo
//
//  Created by Tom on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef CursorInputDemo_CursorTextField_h
#define CursorInputDemo_CursorTextField_h

#include "cocos2d.h"
#include "UIWidget.h"

USING_NS_CC;

class CursorTextField: public cocos2d::ui::Widget, public TextFieldDelegate  //, public Layer   //, public TouchDelegate
{
private:
    // 点击开始位置
    Point m_beginPos;
    
    // 光标精灵
    Sprite *m_pCursorSprite;
    
    // 光标动画
    Action *m_pCursorAction;
                 
    // 光标坐标
    Point m_cursorPos;
    
    // 输入框内容
    std::string *m_pInputText;
public:
    CursorTextField();
    ~CursorTextField();
    
    // static
    static CursorTextField* textFieldWithPlaceHolder(const char *placeholder, const char *fontName, float fontSize);
    
    // CCLayer
    void onEnter();
    void onExit();
    
    // 初始化光标精灵
    void initCursorSprite(int nHeight);
    
    // CCTextFieldDelegate
    virtual bool onTextFieldAttachWithIME(TextFieldTTF *pSender);
    virtual bool onTextFieldDetachWithIME(TextFieldTTF * pSender);
    virtual bool onTextFieldInsertText(TextFieldTTF * pSender, const char * text, int nLen);
    virtual bool onTextFieldDeleteBackward(TextFieldTTF * pSender, const char * delText, int nLen);
    
    // CCLayer Touch
    bool onTouchBegan(Touch *pTouch, Event *pEvent);
    void onTouchEnded(Touch *pTouch, Event *pEvent);
    
    // 判断是否点击在TextField处
    bool isInTextField(Touch *pTouch);
    // 得到TextField矩形
    Rect getRect();
    
    // 打开输入法
    void openIME();
    // 关闭输入法
    void closeIME();
};

#endif
