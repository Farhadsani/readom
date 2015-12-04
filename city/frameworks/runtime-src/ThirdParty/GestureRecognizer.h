/****************************************************************************
 Copyright (c) 2014 StarHeart Technologies Ltd.
 
 http://www.starheart-tech.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

#ifndef __starheart__GestureRecognizer__
#define __starheart__GestureRecognizer__

#include "cocos2d.h"

USING_NS_CC;

#define MAX_NUMBER_OF_TOUCHES_ALLOWED 2
#define MAX_NUMBER_OF_CONTINUE_TAPS_ALLOWED 2

class CC_DLL GestureRecognizer : public Node
{
public:
    
    static GestureRecognizer* create();
    
    void applyToNode(Node* node);
    void removeFromNode();
    
    void setEnabled(bool enabled);
    
    // callback types
    typedef std::function<void()> GestureCallbackNoArgs;
    typedef std::function<void(const Vec2& point)> GestureCallback;
    typedef std::function<void(const Vec2& point, float distanceRatio)> GesturePinchCallback;
    
    // callbacks
    void addGestureBeganCallback(const GestureCallbackNoArgs& gestureBeganCallback, int ref);
    void addSingleTapCallback(const GestureCallback& singleTapCallback, int ref);
    void addDoubleTapCallback(const GestureCallback& doubleTapCallback, int ref);
    void addPanCallback(const GestureCallback& panCallback, int ref);
    void addDoubleFingersTapCallback(const GestureCallback& doubleFingersTapCallback, int ref);
    void addPinchCallback(const GesturePinchCallback& pinchCallback, int ref);
    void addPanEndedCallback(const GestureCallback& panEndedCallback, int ref);
    void addPinchEndedCallback(const GestureCallbackNoArgs& pinchEndedCallback, int ref);

    // ref
    int getRefAtIndex(int index);
    
CC_CONSTRUCTOR_ACCESS:
    
    GestureRecognizer();
    virtual ~GestureRecognizer();
    
    virtual bool init();
                        
private:
    
    // touch handlers
    void _onTouchesBegan(const std::vector<Touch*>& touches, Event* event);
    void _onTouchesMoved(const std::vector<Touch*>& touches, Event* event);
    void _onTouchesEnded(const std::vector<Touch*>& touches, Event* event);
    
    void _stopGestureRecognition();
    
    // callback structures
    Node*                   _node;
    EventListener*          _eventListener;
    
    GestureCallbackNoArgs   _gestureBeganCallback;
    GestureCallback         _singleTapCallback;
    GestureCallback         _doubleTapCallback;
    GestureCallback         _panCallback;
    GestureCallback         _doubleFingersTapCallback;
    GesturePinchCallback    _pinchCallback;
    GestureCallback         _panEndedCallback;
    GestureCallbackNoArgs   _pinchEndedCallback;
    
    int                     _luaHanderRef[8];
    
    // private type
    typedef struct {
        Vec2    point;
        double  time;
    } TouchPiece;
    
    typedef enum {
        TouchPieceIdS               = 0,
        TouchPieceIdB               = 1,
        TouchPieceIdP               = 2,
        TouchPieceIdR               = 3,
        TouchPieceIdCount           = 4
    } TouchPieceId;
    
    typedef struct {
        bool        tapTimeRestrictionSatisfied;
        TouchPiece  touchPieces[TouchPieceIdCount];
    } TouchData;
    
    // recognition structures
    int             _recognizedType;
    Vec2            _continueTapsPoints[MAX_NUMBER_OF_CONTINUE_TAPS_ALLOWED];
    unsigned int    _continueTapsPointsCount;
    float           _pinchRecentDistance;
    unsigned int    _numberOfTouchesInCycle;
    TouchData       _touchesData[MAX_NUMBER_OF_TOUCHES_ALLOWED];
    
    // helper methods
    void    _saveTouchData(const std::vector<Touch*>& touches, TouchPieceId touchPieceId, bool checkTapTimeRestriction = false);
    bool    _anyTouchHasThreholdMove(const std::vector<Touch*>& touches);
    void    _onEndedWithSingleTouch();
    void    _onEndedWithSingleTouchInCycle(const std::vector<Touch*>& touches);
    void    _onEndedWithDoubleTouchesInCycle(const std::vector<Touch*>& touches);
    
    double  _deltaTimeOfTouchFromPieceToPiece(const TouchData& touchData, TouchPieceId fromPieceId, TouchPieceId toPieceId);
    float   _distanceOfTouchFromPieceToPiece(const TouchData& touchData, TouchPieceId fromPieceId, TouchPieceId toPieceId);
    
    float   _distanceOfDoubleTouchesPiece(TouchPieceId pieceId);
    double  _deltaTimeOfDoubleTouchesPiece(TouchPieceId pieceId);
    Vec2    _averagePointOfDoubleTouchesPiece(TouchPieceId pieceId);

private:
    CC_DISALLOW_COPY_AND_ASSIGN(GestureRecognizer);
};

#endif /* defined(__starheart__GestureRecognizer__) */
