//
//  RatingViewController.m
//  RatingController
//
//  Created by Ajay on 2/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RatingView.h"

@implementation RatingView

@synthesize s1, s2, s3, s4, s5;
@synthesize unselectedImageName = _unselectedImageName;
@synthesize partlySelectedImageName = _partlySelectedImageName;
@synthesize fullySelectedImageName = _fullySelectedImage;
@synthesize viewDelegate;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _space_width = 0;
    }
    return self;
}

- (void)dealloc {
	[s1 release];
	[s2 release];
	[s3 release];
	[s4 release];
	[s5 release];
    [super dealloc];
}

-(void)setImagesDeselected:(NSString *)deselectedImage
			partlySelected:(NSString *)halfSelectedImage
			  fullSelected:(NSString *)fullSelectedImage
			   andDelegate:(id<RatingViewDelegate>)d {
    self.unselectedImageName = deselectedImage;
    self.partlySelectedImageName = halfSelectedImage;
    self.fullySelectedImageName = fullSelectedImage;
	unselectedImage = [UIImage imageNamed:deselectedImage];
    if (halfSelectedImage == nil) {
        partlySelectedImage = [[unselectedImage retain] autorelease];
    }
    else{
        partlySelectedImage = [UIImage imageNamed:halfSelectedImage];
    }
//	partlySelectedImage = (halfSelectedImage == nil) ? unselectedImage : [UIImage imageNamed:halfSelectedImage];
	fullySelectedImage = [UIImage imageNamed:fullSelectedImage];
	viewDelegate = d;
	
	height=0.0; width=0.0;
	if (height < [fullySelectedImage size].height) {
		height = [fullySelectedImage size].height;
	}
	if (height < [partlySelectedImage size].height) {
		height = [partlySelectedImage size].height;
	}
	if (height < [unselectedImage size].height) {
		height = [unselectedImage size].height;
	}
	if (width < [fullySelectedImage size].width) {
		width = [fullySelectedImage size].width;
	}
	if (width < [partlySelectedImage size].width) {
		width = [partlySelectedImage size].width;
	}
	if (width < [unselectedImage size].width) {
		width = [unselectedImage size].width;
	}
    
    if (self.star_height) {
        height = self.star_height;
    }
    if (self.star_width) {
        width = self.star_width;
    }
    
    width += _space_width;
	
	starRating = 0;
	lastRating = 0;
	s1 = [[UIImageView alloc] initWithImage:unselectedImage];
	s2 = [[UIImageView alloc] initWithImage:unselectedImage];
	s3 = [[UIImageView alloc] initWithImage:unselectedImage];
	s4 = [[UIImageView alloc] initWithImage:unselectedImage];
	s5 = [[UIImageView alloc] initWithImage:unselectedImage];
    
    s1.contentMode = UIViewContentModeCenter;
    s2.contentMode = UIViewContentModeCenter;
    s3.contentMode = UIViewContentModeCenter;
    s4.contentMode = UIViewContentModeCenter;
    s5.contentMode = UIViewContentModeCenter;
    if (self.starMode) {
        s1.contentMode = self.starMode;
        s2.contentMode = self.starMode;
        s3.contentMode = self.starMode;
        s4.contentMode = self.starMode;
        s5.contentMode = self.starMode;
    }
    
    CGFloat y = (self.height - height ) /2.0;
    y = (y<0)?0:y;
	[s1 setFrame:CGRectMake(0,         y, width, height)];
	[s2 setFrame:CGRectMake(width,     y, width, height)];
	[s3 setFrame:CGRectMake(2 * width, y, width, height)];
	[s4 setFrame:CGRectMake(3 * width, y, width, height)];
	[s5 setFrame:CGRectMake(4 * width, y, width, height)];
	
	[s1 setUserInteractionEnabled:NO];
	[s2 setUserInteractionEnabled:NO];
	[s3 setUserInteractionEnabled:NO];
	[s4 setUserInteractionEnabled:NO];
	[s5 setUserInteractionEnabled:NO];
	
	[self addSubview:s1];
	[self addSubview:s2];
	[self addSubview:s3];
	[self addSubview:s4];
	[self addSubview:s5];
	
	CGRect frame = [self frame];
	frame.size.width = width * 5;
//	frame.size.height = height;
	[self setFrame:frame];
}

-(void)displayRating:(float)rating {
//    if ((!unselectedImage || ![unselectedImage isKindOfClass:[UIImage class]]) && self.unselectedImageName) {
//        unselectedImage = [UIImage imageNamed:self.unselectedImageName];
//    }
//    if ((!partlySelectedImage || ![partlySelectedImage isKindOfClass:[UIImage class]]) && self.partlySelectedImageName) {
//        partlySelectedImage = [UIImage imageNamed:self.partlySelectedImageName];
//    }
//    if ((!fullySelectedImage || ![fullySelectedImage isKindOfClass:[UIImage class]]) && self.fullySelectedImageName) {
//        fullySelectedImage = [UIImage imageNamed:self.fullySelectedImageName];
//    }
    unselectedImage = [UIImage imageNamed:self.unselectedImageName];
    partlySelectedImage = [UIImage imageNamed:self.partlySelectedImageName];
    fullySelectedImage = [UIImage imageNamed:self.fullySelectedImageName];
	[s1 setImage:unselectedImage];
	[s2 setImage:unselectedImage];
	[s3 setImage:unselectedImage];
	[s4 setImage:unselectedImage];
	[s5 setImage:unselectedImage];
	
	if (rating >= 0.5) {
		[s1 setImage:partlySelectedImage];
	}
	if (rating >= 1) {
		[s1 setImage:fullySelectedImage];
	}
	if (rating >= 1.5) {
		[s2 setImage:partlySelectedImage];
	}
	if (rating >= 2) {
		[s2 setImage:fullySelectedImage];
	}
	if (rating >= 2.5) {
		[s3 setImage:partlySelectedImage];
	}
	if (rating >= 3) {
		[s3 setImage:fullySelectedImage];
	}
	if (rating >= 3.5) {
		[s4 setImage:partlySelectedImage];
	}
	if (rating >= 4) {
		[s4 setImage:fullySelectedImage];
	}
	if (rating >= 4.5) {
		[s5 setImage:partlySelectedImage];
	}
	if (rating >= 5) {
		[s5 setImage:fullySelectedImage];
	}
	
	starRating = rating;
	lastRating = rating;
    if (viewDelegate) {
        [viewDelegate RatingView:self ratingChanged:rating];
    }
}

-(void) touchesBegan: (NSSet *)touches withEvent: (UIEvent *)event
{
	[self touchesMoved:touches withEvent:event];
}

-(void) touchesMoved: (NSSet *)touches withEvent: (UIEvent *)event
{
	CGPoint pt = [[touches anyObject] locationInView:self];
	int newRating = (int) (pt.x / width) + 1;
	if (newRating < 1 || newRating > 5)
		return;
	
	if (newRating != lastRating)
		[self displayRating:newRating];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[self touchesMoved:touches withEvent:event];
}

-(float)rating {
	return starRating;
}

@end
