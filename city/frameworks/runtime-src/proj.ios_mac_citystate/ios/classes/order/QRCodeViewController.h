//
//  QRCodeViewController.h
//  citystate
//
//  Created by 石头人工作室 on 15/11/3.
//
//

#import "BaseViewController.h"
#import "OrderIntro.h"

@interface QRCodeViewController : BaseViewController
@property (nonatomic, retain) OrderIntro * orderIntro;

@property (nonatomic, retain) NSString* QRcodeURL;
@property (nonatomic, retain) NSString* passwd;
@property (nonatomic) BOOL used;
@end
