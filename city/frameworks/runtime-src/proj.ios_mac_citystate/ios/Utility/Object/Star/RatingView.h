//
//  RatingViewController.h
//  RatingController
//
//  Created by Ajay on 2/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RatingView;
@protocol RatingViewDelegate
-(void)RatingView:(RatingView *)view ratingChanged:(float)newRating;
@end


@interface RatingView : UIView {
	UIImageView *s1, *s2, *s3, *s4, *s5;
	UIImage *unselectedImage, *partlySelectedImage, *fullySelectedImage;
	id<RatingViewDelegate> viewDelegate;

	float starRating, lastRating;
	float height, width; // of each image of the star!
    
//    NSString *unselectedImageName;
//    NSString *partlySelectedImageName;
//    NSString *fullySelectedImageName;
}

@property (nonatomic, assign) id<RatingViewDelegate> viewDelegate;
@property (nonatomic, retain) UIImageView *s1;
@property (nonatomic, retain) UIImageView *s2;
@property (nonatomic, retain) UIImageView *s3;
@property (nonatomic, retain) UIImageView *s4;
@property (nonatomic, retain) UIImageView *s5;
@property (nonatomic, retain) NSString *unselectedImageName;
@property (nonatomic, retain) NSString *partlySelectedImageName;
@property (nonatomic, retain) NSString *fullySelectedImageName;

@property (nonatomic) CGFloat star_width;//星星width
@property (nonatomic) CGFloat star_height;//星星height
@property (nonatomic) CGFloat space_width;//两个星星之间的间距

@property (nonatomic)                 UIViewContentMode starMode;


- (id)initWithFrame:(CGRect)frame;

-(void)setImagesDeselected:(NSString *)unselectedImage partlySelected:(NSString *)partlySelectedImage 
			  fullSelected:(NSString *)fullSelectedImage andDelegate:(id<RatingViewDelegate>)d;
-(void)displayRating:(float)rating;

-(float)rating;

@end
