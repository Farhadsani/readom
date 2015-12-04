//
//  QMapActionInterval.h
//  qmap
//
//  Created by Shenghua Su on 3/11/15.
//
//

#ifndef __qmap__QMapActionInterval__
#define __qmap__QMapActionInterval__

#include "2d/CCActionInterval.h"

USING_NS_CC;

/**  callback on every action tick
 */
class CC_DLL QMapActionInterval : public ActionInterval
{
public:
    QMapActionInterval():_function(nullptr) {}
    virtual ~QMapActionInterval() {}
    
    /** initializes the action */
    bool initWithDuration(float duration, const std::function<void(float)>& func);
    
    //
    // Overrides
    //
    virtual QMapActionInterval* clone() const override;
    virtual QMapActionInterval* reverse(void) const  override;
    virtual void startWithTarget(Node *target) override;
    virtual void update(float time) override;
    
protected:
    /** function that will be called */
    std::function<void(float)> _function;
    
private:
    CC_DISALLOW_COPY_AND_ASSIGN(QMapActionInterval);
};

#endif /* defined(__qmap__QMapActionInterval__) */
