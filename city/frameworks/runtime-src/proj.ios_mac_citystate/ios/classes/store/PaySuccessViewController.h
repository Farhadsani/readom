//
//  PaySuccessViewController.h
//  citystate
//
//  Created by hf on 15/11/16.
//
//

typedef enum PayType{
    AliPay = 0, //支付宝
    WeichatPay, //微信支付
}PayType;

#import "BaseViewController.h"
#import "OrderDetailViewController.h"

@interface PaySuccessViewController : BaseViewController

@property(nonatomic, retain) NSMutableDictionary * infoFromPayCalllback;
@property(nonatomic, retain) NSMutableDictionary * orderInfo;
@property(nonatomic) BOOL navbarHidden;

@property(nonatomic) PayType payType; //支付方式(0：支付宝；1：微信支付)

@property (nonatomic, retain) OrderIntro * orderIntro;

@end
