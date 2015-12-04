//
//  SlideNavigationViewController.m
//  SlideNavigationController
//
//  Created by hf on 20/8/15.
//  Copyright (c) 2015 hf. All rights reserved.
//

#import "SlideNavigationViewController.h"

@interface SlideNavigationViewController ()

@end

@implementation SlideNavigationViewController

+ (void)initialize
{
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.titleTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:k_fontName_FZZY size:18],
                                NSForegroundColorAttributeName: UIColorFromRGB(0x666666, 1.0f)};
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadLayerWithImage{
    UIGraphicsBeginImageContext(self.visibleViewController.view.bounds.size);
    [self.visibleViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.animationLayer setContents: (id)viewImage.CGImage];
    [self.animationLayer setHidden:NO];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    [self set_animationLayer];
}

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event{
    id<CAAction> action = (id)[NSNull null];
    return action;
}

- (void)set_animationLayer{
//    if (!_animationLayer) {
        self.animationLayer = [CALayer layer] ;
        CGRect layerFrame = self.view.frame;
        layerFrame.size.height = self.view.frame.size.height-self.navigationBar.frame.size.height;
//        layerFrame.origin.y = self.navigationBar.frame.size.height+20;
    layerFrame.origin.y = self.navigationBar.frame.size.height;
        _animationLayer.frame = layerFrame;
        _animationLayer.masksToBounds = YES;
        [_animationLayer setContentsGravity:kCAGravityBottomLeft];
        [self.view.layer insertSublayer:_animationLayer atIndex:0];
        _animationLayer.delegate = self;
//    }
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGRect layerFrame = self.view.bounds;
    layerFrame.size.height = self.view.bounds.size.height-self.navigationBar.frame.size.height;
//    layerFrame.origin.y = self.navigationBar.frame.size.height+20;
    layerFrame.origin.y = self.navigationBar.frame.size.height+8;
    _animationLayer.frame = layerFrame;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [_animationLayer removeFromSuperlayer];
    [self.view.layer insertSublayer:_animationLayer atIndex:0];
    if(animated){
        [self loadLayerWithImage];
        UIView * toView = [viewController view];
        CABasicAnimation *Animation  = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / -1000;
        rotationAndPerspectiveTransform = CATransform3DMakeTranslation(self.view.frame.size.width, 0, 0);
        [Animation setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(self.view.bounds.size.width, 0, 0)]];
        [Animation setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)]];
        [Animation setDuration:0.3];
        Animation.delegate = self;
        Animation.removedOnCompletion = NO;
        Animation.fillMode = kCAFillModeBoth;
        
        [toView.layer addAnimation:Animation forKey:@"fromRight"];
        
        
        CABasicAnimation *Animation1  = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D rotationAndPerspectiveTransform1 = CATransform3DIdentity;
        rotationAndPerspectiveTransform1.m34 = 1.0 / -1000;
        rotationAndPerspectiveTransform1 = CATransform3DMakeScale(1.0, 1.0, 1.0);
        [Animation1 setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 1.0, 0.9)]];
        [Animation1 setDuration:0.3];
        Animation1.delegate = self;
        Animation1.removedOnCompletion = NO;
        Animation1.fillMode = kCAFillModeBoth;
        [_animationLayer addAnimation:Animation1 forKey:@"scale"];
    }
    [super pushViewController:viewController animated:NO];
}

-(UIViewController*)popViewControllerAnimated:(BOOL)animated{
    [_animationLayer removeFromSuperlayer];
    [self.view.layer insertSublayer:_animationLayer above:self.view.layer];
    if(animated) {
        [self loadLayerWithImage];
        
        UIView * toView = [[self.viewControllers objectAtExistIndex:[self.viewControllers indexOfObject:self.visibleViewController]-1] view];
        CABasicAnimation *Animation  = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / -1000;
        rotationAndPerspectiveTransform = CATransform3DMakeTranslation(self.view.frame.size.width, 0, 0);
        [Animation setFromValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
        [Animation setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(self.view.bounds.size.width, 0, 0)]];
        [Animation setDuration:0.3];
        Animation.delegate = self;
        Animation.removedOnCompletion = NO;
        Animation.fillMode = kCAFillModeBoth;
        [_animationLayer addAnimation:Animation forKey:@"fromRight"];
        
        
        CABasicAnimation *Animation1  = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D rotationAndPerspectiveTransform1 = CATransform3DIdentity;
        rotationAndPerspectiveTransform1.m34 = 1.0 / -1000;
        rotationAndPerspectiveTransform1 = CATransform3DMakeScale(1.0, 1.0, 1.0);
        [Animation1 setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.95, 0.9)]];
//        [Animation1 setToValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
        [Animation1 setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        [Animation1 setDuration:0.3];
        Animation1.delegate = self;
        Animation1.removedOnCompletion = NO;
        Animation1.fillMode = kCAFillModeBoth;
        [toView.layer addAnimation:Animation1 forKey:@"scale"];
        
    }
    return [super popViewControllerAnimated:NO];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [_animationLayer setContents:nil];
    [_animationLayer removeAllAnimations];
    [self.visibleViewController.view.layer removeAllAnimations];
}

@end