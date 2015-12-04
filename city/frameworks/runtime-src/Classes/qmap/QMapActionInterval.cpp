//
//  QMapActionInterval.cpp
//  qmap
//
//  Created by Shenghua Su on 3/11/15.
//
//

#include "QMapActionInterval.h"

//QMapActionInterval* QMapActionInterval::create(float duration, const std::function<void(float)>& func)
//{
//    QMapActionInterval *ret = new (std::nothrow) QMapActionInterval();
//    if (ret && ret->initWithDuration(duration, func)) {
//        ret->autorelease();
//        return ret;
//    }
//    
//    CC_SAFE_DELETE(ret);
//    return nullptr;
//}

bool QMapActionInterval::initWithDuration(float duration, const std::function<void(float)>& func)
{
    if (ActionInterval::initWithDuration(duration)) {
        _function = func;
        return true;
    }
    
    return false;
}

QMapActionInterval* QMapActionInterval::clone() const
{
    // no copy constructor
    auto a = new (std::nothrow) QMapActionInterval();
    a->initWithDuration(_duration, _function);
    a->autorelease();
    return a;
}

void QMapActionInterval::startWithTarget(Node *target)
{
    ActionInterval::startWithTarget(target);
}

QMapActionInterval* QMapActionInterval::reverse() const
{
    // no reverse version, just returen a clone
    return this->clone();
}


void QMapActionInterval::update(float t)
{
    if (_target) {
//<<<<<<< HEAD
//=======
//        printf("call QMapActionInterval::update");
//>>>>>>> fangdong
        if (_function) {
            _function(t);
        }
    }
}
