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

#include "GestureRecognizer.h"

#define GESTURE_TYPE_NON_RECOGNIZED             0
#define GESTURE_TYPE_SINGLE_TAP                 1
#define GESTURE_TYPE_SINGLE_TAP_POSSIBLE        2
#define GESTURE_TYPE_DOUBE_TAP                  3
#define GESTURE_TYPE_DOUBE_TAP_POSSIBLE         4
#define GESTURE_TYPE_PAN                        5
#define GESTURE_TYPE_PINCH                      6
#define GESTURE_TYPE_DOUBLE_FINGER_TAP          7
#define GESTURE_TYPE_DOUBLE_FINGER_TAP_POSSIBLE 8
#define GESTURE_TYPE_START_RECOGNITION          9

#define MAX_DURATION_BETWEEN_TAPS       0.2
#define MAX_DISTANCE_BETWEEN_TAPS       80.
#define MAX_DURATION_OF_SINCE_BEGAN     0.2
#define MAX_DISTANCE_OF_SINCE_BEGAN     30.

#define MAX_DURATION_BETWEEN_DOUBLE_FINGER_TOUCHES 0.1

#define MAX_TOUCHES_ALLOWED 2

GestureRecognizer* GestureRecognizer::create()
{
    GestureRecognizer *ret = new (std::nothrow) GestureRecognizer();
    if (ret && ret->init()) {
        ret->autorelease();
        return ret;
    }
    
    CC_SAFE_DELETE(ret);
    return nullptr;
}

GestureRecognizer::GestureRecognizer()
: _node(nullptr)
, _eventListener(nullptr)
, _gestureBeganCallback(nullptr)
, _singleTapCallback(nullptr)
, _doubleTapCallback(nullptr)
, _panCallback(nullptr)
, _doubleFingersTapCallback(nullptr)
, _pinchCallback(nullptr)
, _panEndedCallback(nullptr)
, _pinchEndedCallback(nullptr)
, _recognizedType(GESTURE_TYPE_NON_RECOGNIZED)
, _continueTapsPointsCount(0)
, _pinchRecentDistance(1.)
, _numberOfTouchesInCycle(0)
{}

GestureRecognizer::~GestureRecognizer()
{}

bool GestureRecognizer::init()
{
    if (Node::init()) {
        for (auto i = 0; i < MAX_NUMBER_OF_CONTINUE_TAPS_ALLOWED; ++i) {
            _continueTapsPoints[i] = Vec2::ZERO;
        }
        for (auto i = 0; i < MAX_NUMBER_OF_TOUCHES_ALLOWED; ++i) {
            _touchesData[i] = { false, { Vec2::ZERO, 0 } };
        }
        return true;
    }
    return false;
}

void GestureRecognizer::applyToNode(Node* node)
{
    _node = node;
    
    auto listener = EventListenerTouchAllAtOnce::create();
    
    listener->onTouchesBegan = std::bind(&GestureRecognizer::_onTouchesBegan, this, std::placeholders::_1, std::placeholders::_2);
    listener->onTouchesMoved = std::bind(&GestureRecognizer::_onTouchesMoved, this, std::placeholders::_1, std::placeholders::_2);
    listener->onTouchesEnded = std::bind(&GestureRecognizer::_onTouchesEnded, this, std::placeholders::_1, std::placeholders::_2);
    
    _node->getEventDispatcher()->addEventListenerWithFixedPriority(listener, 10);
    
    _eventListener = listener;
}

void GestureRecognizer::removeFromNode()
{
    if (_node) {
        _node->getEventDispatcher()->removeEventListener(_eventListener);
        _node = nullptr;
    }
}

void GestureRecognizer::setEnabled(bool enabled)
{
//    this->removeFromNode();
    if (_eventListener) {
        _eventListener->setEnabled(enabled);
    }
}

void GestureRecognizer::addGestureBeganCallback(const GestureCallbackNoArgs& gestureBeganCallback, int ref)
{
    _gestureBeganCallback = gestureBeganCallback;
    _luaHanderRef[0] = ref;
}

void GestureRecognizer::addSingleTapCallback(const GestureCallback& singleTapCallback, int ref)
{
    _singleTapCallback = singleTapCallback;
    _luaHanderRef[1] = ref;
}

void GestureRecognizer::addDoubleTapCallback(const GestureCallback& doubleTapCallback, int ref)
{
    _doubleTapCallback = doubleTapCallback;
    _luaHanderRef[2] = ref;
}

void GestureRecognizer::addPanCallback(const GestureCallback& panCallback, int ref)
{
    _panCallback = panCallback;
    _luaHanderRef[3] = ref;
}

void GestureRecognizer::addDoubleFingersTapCallback(const GestureCallback& doubleFingersTapCallback, int ref)
{
    _doubleFingersTapCallback = doubleFingersTapCallback;
    _luaHanderRef[4] = ref;
}

void GestureRecognizer::addPinchCallback(const GesturePinchCallback& pinchCallback, int ref)
{
    _pinchCallback = pinchCallback;
    _luaHanderRef[5] = ref;
}

void GestureRecognizer::addPanEndedCallback(const GestureCallback& panEndedCallback, int ref)
{
    _panEndedCallback = panEndedCallback;
    _luaHanderRef[6] = ref;
}

void GestureRecognizer::addPinchEndedCallback(const GestureCallbackNoArgs& pinchEndedCallback, int ref)
{
    _pinchEndedCallback = pinchEndedCallback;
    _luaHanderRef[7] = ref;
}

int GestureRecognizer::getRefAtIndex(int index)
{
    return _luaHanderRef[index];
}

void GestureRecognizer::_stopGestureRecognition()
{
    _continueTapsPointsCount = 0;
    _recognizedType = GESTURE_TYPE_NON_RECOGNIZED;
    _numberOfTouchesInCycle = 0;
}

inline double GestureRecognizer::_deltaTimeOfTouchFromPieceToPiece(const TouchData& touchData, TouchPieceId fromPieceId, TouchPieceId toPieceId)
{
    return touchData.touchPieces[toPieceId].time - touchData.touchPieces[fromPieceId].time;
}

inline float GestureRecognizer::_distanceOfTouchFromPieceToPiece(const TouchData& touchData, TouchPieceId fromPieceId, TouchPieceId toPieceId)
{
    return touchData.touchPieces[fromPieceId].point.distance(touchData.touchPieces[toPieceId].point);
}

inline float GestureRecognizer::_distanceOfDoubleTouchesPiece(TouchPieceId pieceId)
{
    return _touchesData[0].touchPieces[pieceId].point.distance(_touchesData[1].touchPieces[pieceId].point);
}

inline double GestureRecognizer::_deltaTimeOfDoubleTouchesPiece(TouchPieceId pieceId)
{
    return std::abs(_touchesData[0].touchPieces[pieceId].time - _touchesData[1].touchPieces[pieceId].time);
}

inline Vec2 GestureRecognizer::_averagePointOfDoubleTouchesPiece(TouchPieceId pieceId)
{
    return (_touchesData[0].touchPieces[pieceId].point + _touchesData[1].touchPieces[pieceId].point) * 0.5;
}

void GestureRecognizer::_saveTouchData(const std::vector<Touch *> &touches, TouchPieceId touchPieceId, bool checkTapTimeRestriction)
{
    for (int i = 0; i < touches.size(); ++i) {
        
        int touchId = touches[i]->getID();
        
        if (touchId < MAX_TOUCHES_ALLOWED) {
            
            auto point = touches[i]->getLocation();
            
            switch (touchPieceId) {
                    
                case TouchPieceIdB:
                    _touchesData[touchId].touchPieces[TouchPieceIdB].point = point;
                    _touchesData[touchId].touchPieces[TouchPieceIdB].time = utils::gettime();
                    _touchesData[touchId].touchPieces[TouchPieceIdR].point = point;
                    _touchesData[touchId].touchPieces[TouchPieceIdR].time = _touchesData[touchId].touchPieces[TouchPieceIdB].time;
                    if (_numberOfTouchesInCycle == 0 || touchId > 0) {
                        ++_numberOfTouchesInCycle;
                    }
                    break;
                    
                case TouchPieceIdR:
                    _touchesData[touchId].touchPieces[TouchPieceIdS].point = _touchesData[touchId].touchPieces[TouchPieceIdP].point;
                    _touchesData[touchId].touchPieces[TouchPieceIdS].time = _touchesData[touchId].touchPieces[TouchPieceIdP].time;
                    _touchesData[touchId].touchPieces[TouchPieceIdP].point = _touchesData[touchId].touchPieces[TouchPieceIdR].point;
                    _touchesData[touchId].touchPieces[TouchPieceIdP].time = _touchesData[touchId].touchPieces[TouchPieceIdR].time;
                    _touchesData[touchId].touchPieces[TouchPieceIdR].point = point;
                    _touchesData[touchId].touchPieces[TouchPieceIdR].time = utils::gettime();
                    break;
                    
                default:
                    break;
            }
            Vec2 delta = _touchesData[touchId].touchPieces[TouchPieceIdR].point - _touchesData[touchId].touchPieces[TouchPieceIdP].point;
            
            if (checkTapTimeRestriction) {
                
                auto duration = _deltaTimeOfTouchFromPieceToPiece(_touchesData[touchId], TouchPieceIdB, TouchPieceIdR);
                auto distance = _touchesData[touchId].touchPieces[TouchPieceIdB].point.distance(point);
                
                _touchesData[touchId].tapTimeRestrictionSatisfied = duration <= MAX_DURATION_OF_SINCE_BEGAN
                                                                  && distance <= MAX_DISTANCE_OF_SINCE_BEGAN;
            }
            
        }
    }
}

void GestureRecognizer::_onTouchesBegan(const std::vector<Touch*>& touches, Event* event)
{
    _saveTouchData(touches, TouchPieceIdB);
    
    if (_numberOfTouchesInCycle == 1 && _continueTapsPointsCount > 0 && _continueTapsPointsCount <= MAX_NUMBER_OF_CONTINUE_TAPS_ALLOWED) {

        auto distance = _touchesData[0].touchPieces[TouchPieceIdB].point.distance(_continueTapsPoints[_continueTapsPointsCount-1]);
        auto duration = _deltaTimeOfTouchFromPieceToPiece(_touchesData[0], TouchPieceIdR, TouchPieceIdB);
        
        if (duration < MAX_DURATION_BETWEEN_TAPS && distance < MAX_DISTANCE_BETWEEN_TAPS) {
            _recognizedType = GESTURE_TYPE_DOUBE_TAP_POSSIBLE;
        }
    }
    
    if (_recognizedType == GESTURE_TYPE_NON_RECOGNIZED) {
        _recognizedType = GESTURE_TYPE_START_RECOGNITION;
        if (_gestureBeganCallback) {
            _gestureBeganCallback();
        }
    }
}

bool GestureRecognizer::_anyTouchHasThreholdMove(const std::vector<Touch*>& touches)
{
    for (auto i = 0; i < touches.size(); ++i) {
        
        auto distanceSinceBegan = touches[i]->getStartLocation().distance(touches[i]->getLocation());
        
        if (distanceSinceBegan > MAX_DISTANCE_OF_SINCE_BEGAN) {
            return true;
        }
    }
    
    return false;
}

void GestureRecognizer::_onTouchesMoved(const std::vector<Touch*>& touches, Event* event)
{
     _saveTouchData(touches, TouchPieceIdR);
    
    if (_numberOfTouchesInCycle == 1) {
        
        switch (_recognizedType) {
                
            case GESTURE_TYPE_PINCH:
                _recognizedType = GESTURE_TYPE_PAN;
                break;
                
            case GESTURE_TYPE_PAN:
                if(_panCallback) {
                    _panCallback(touches[0]->getDelta());
                }
                break;
                
            default:
            {
                auto distance = touches[0]->getStartLocation().distance(touches[0]->getLocation());
                if (distance > MAX_DISTANCE_OF_SINCE_BEGAN) {
                    _recognizedType = GESTURE_TYPE_PAN;
                }
                break;
            }
        }
    }
    else if (_numberOfTouchesInCycle == 2) {
        
        Vec2 center = _averagePointOfDoubleTouchesPiece(TouchPieceIdR);
        float distance = _distanceOfDoubleTouchesPiece(TouchPieceIdR);
        
        switch(_recognizedType) {
                
            case GESTURE_TYPE_PINCH:
                if (_pinchCallback) {
                    _pinchCallback(center, distance / _pinchRecentDistance);
                }
                _pinchRecentDistance = distance;
                break;
                
            case GESTURE_TYPE_PAN:
                _recognizedType = GESTURE_TYPE_PINCH;
                _pinchRecentDistance = distance;
                break;
                
            default:
                if (_anyTouchHasThreholdMove(touches)) {
                    _recognizedType = GESTURE_TYPE_PINCH;
                    _pinchRecentDistance = distance;
                }
                break;
        }
    }
}

void GestureRecognizer::_onEndedWithSingleTouch()
{
    auto duration = _deltaTimeOfTouchFromPieceToPiece(_touchesData[0], TouchPieceIdB, TouchPieceIdR);
    auto distance = _distanceOfTouchFromPieceToPiece(_touchesData[0], TouchPieceIdB, TouchPieceIdR);

    if (duration <= MAX_DURATION_OF_SINCE_BEGAN && distance <= MAX_DISTANCE_OF_SINCE_BEGAN) {
        
        _continueTapsPointsCount = (_continueTapsPointsCount > MAX_NUMBER_OF_CONTINUE_TAPS_ALLOWED) ?
                                    MAX_NUMBER_OF_CONTINUE_TAPS_ALLOWED : _continueTapsPointsCount;

        _continueTapsPoints[_continueTapsPointsCount] = _touchesData[0].touchPieces[TouchPieceIdB].point;
        ++_continueTapsPointsCount;
        
        if (_continueTapsPointsCount == 1) {
            
            _recognizedType = GESTURE_TYPE_SINGLE_TAP_POSSIBLE;
            
            this->scheduleOnce([&](float) {
                
                _recognizedType = GESTURE_TYPE_SINGLE_TAP;

                if (_singleTapCallback) {
                    _singleTapCallback(_continueTapsPoints[0]);
                }
                _stopGestureRecognition();
            }, MAX_DURATION_BETWEEN_TAPS, "singleTapCall");
        }
        else if (_continueTapsPointsCount == 2 && _recognizedType == GESTURE_TYPE_DOUBE_TAP_POSSIBLE) {
            
            _recognizedType = GESTURE_TYPE_DOUBE_TAP;
            
            this->unschedule("singleTapCall");
            if (_doubleTapCallback) {
                _doubleTapCallback(Vec2(_continueTapsPoints[0].x, _continueTapsPoints[0].y));
            }
            _stopGestureRecognition();
        }
    }
    else {
        _recognizedType = GESTURE_TYPE_SINGLE_TAP;
        
        if (_singleTapCallback) {
            _singleTapCallback(_touchesData[0].touchPieces[TouchPieceIdB].point);
        }
        _stopGestureRecognition();
    }
}

void GestureRecognizer::_onEndedWithSingleTouchInCycle(const std::vector<Touch*>& touches)
{
    switch (_recognizedType) {
            
        case GESTURE_TYPE_PAN:
            if (_panEndedCallback) {
                if ((_touchesData[0].touchPieces[TouchPieceIdP].point - _touchesData[0].touchPieces[TouchPieceIdS].point).length() > 10) {
                    Vec2 velocity = (_touchesData[0].touchPieces[TouchPieceIdR].point - _touchesData[0].touchPieces[TouchPieceIdS].point)
                                    / (_touchesData[0].touchPieces[TouchPieceIdR].time - _touchesData[0].touchPieces[TouchPieceIdS].time);
                    _panEndedCallback(velocity);
                }
                else {
                    _panEndedCallback(Vec2::ZERO);
                }
            }
            _stopGestureRecognition();
            break;
            
            
        case GESTURE_TYPE_DOUBLE_FINGER_TAP_POSSIBLE:
        {
            auto doubleTouchesEndedTimeOk = _deltaTimeOfDoubleTouchesPiece(TouchPieceIdR) <= MAX_DURATION_BETWEEN_DOUBLE_FINGER_TOUCHES;
            auto touchId = touches[0]->getID();
            if (touchId < MAX_NUMBER_OF_TOUCHES_ALLOWED && doubleTouchesEndedTimeOk && _touchesData[touchId].tapTimeRestrictionSatisfied) {
                
                _recognizedType = GESTURE_TYPE_DOUBLE_FINGER_TAP;
                
                if (_doubleFingersTapCallback) {
                    _doubleFingersTapCallback(_averagePointOfDoubleTouchesPiece(TouchPieceIdB));
                }
                _stopGestureRecognition();
            }
            break;
        }
            
        case GESTURE_TYPE_PINCH:
            _stopGestureRecognition();
            break;
            
        default:
            _onEndedWithSingleTouch();
            break;
    }
}

void GestureRecognizer::_onEndedWithDoubleTouchesInCycle(const std::vector<Touch *>& touches)
{
    auto numberOfTouchesInThisCall = touches.size();
    
    if (_recognizedType == GESTURE_TYPE_PINCH) {
        
        Vec2 center = _averagePointOfDoubleTouchesPiece(TouchPieceIdR);
        float distance = _distanceOfDoubleTouchesPiece(TouchPieceIdR);

        if (_pinchCallback) {
            _pinchCallback(center, distance / _pinchRecentDistance);
        }
        _pinchRecentDistance = distance;
        
        if (_pinchEndedCallback) {
            _pinchEndedCallback();
        }
        
        if (numberOfTouchesInThisCall == 2) {
            _stopGestureRecognition();
        }
    }
    else {
        if (numberOfTouchesInThisCall == 2) {
            
            auto doubleTouchesBeganTimeOk = _deltaTimeOfDoubleTouchesPiece(TouchPieceIdB) < MAX_DURATION_BETWEEN_DOUBLE_FINGER_TOUCHES;
            auto doubleTouchesEndedTimeOk = _deltaTimeOfDoubleTouchesPiece(TouchPieceIdR) < MAX_DURATION_BETWEEN_DOUBLE_FINGER_TOUCHES;
            
            if (doubleTouchesBeganTimeOk && doubleTouchesEndedTimeOk && _touchesData[0].tapTimeRestrictionSatisfied && _touchesData[1].tapTimeRestrictionSatisfied) {

                _recognizedType = GESTURE_TYPE_DOUBLE_FINGER_TAP;
                
                if (_doubleFingersTapCallback) {
                    _doubleFingersTapCallback(_averagePointOfDoubleTouchesPiece(TouchPieceIdB));
                }
                _stopGestureRecognition();
            }
        }
        else { // numberOfTouchesInThisCall ==  1
            
            auto doubleTouchesBeganTimeOk = _deltaTimeOfDoubleTouchesPiece(TouchPieceIdB) < MAX_DURATION_BETWEEN_DOUBLE_FINGER_TOUCHES;
            
            auto touchId = touches[0]->getID();
            if (touchId < MAX_NUMBER_OF_TOUCHES_ALLOWED && doubleTouchesBeganTimeOk && _touchesData[touchId].tapTimeRestrictionSatisfied) {

                _recognizedType = GESTURE_TYPE_DOUBLE_FINGER_TAP_POSSIBLE;
            }
        }
    }
}

void GestureRecognizer::_onTouchesEnded(const std::vector<Touch*>& touches, Event* event)
{
    _saveTouchData(touches, TouchPieceIdR, true);
    
    if (_numberOfTouchesInCycle == 1) {
        _onEndedWithSingleTouchInCycle(touches);
    }
    else if (_numberOfTouchesInCycle == 2) {
        
        _onEndedWithDoubleTouchesInCycle(touches);
    }

    if (_numberOfTouchesInCycle > 0)
        --_numberOfTouchesInCycle;
}
