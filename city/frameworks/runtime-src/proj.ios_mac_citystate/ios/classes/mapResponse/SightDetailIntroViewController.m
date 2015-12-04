//
//  SightDetailIntroViewController.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/20.
//
//

#import "SightDetailIntroViewController.h"
#import "SightDetailIntroCell.h"

@interface SightDetailIntroViewController ()
@property (nonatomic, strong) NSMutableArray *views;
@property (nonatomic, strong) NSMutableArray *lineviews;
@end

@implementation SightDetailIntroViewController
- (NSMutableArray *)views
{
    if (!_views) {
        _views = [NSMutableArray array];
    }
    return _views;
}

- (NSMutableArray *)lineviews
{
    if (!_lineviews) {
        _lineviews = [NSMutableArray array];
    }
    return _lineviews;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < self.introItems.count; i++) {
        SightDetailIntroCell *sightDetailIntroCell = [SightDetailIntroCell sightDetailIntroCell];
        [self.contentView addSubview:sightDetailIntroCell];
        [self.views addObject:sightDetailIntroCell];
        sightDetailIntroCell.sightDetailIntroItem = self.introItems[i];
        sightDetailIntroCell.frame = CGRectMake(0, CGRectGetMaxY(((UIView *)[self.views lastObject]).frame), self.contentView.width, sightDetailIntroCell.height);
        
        UIView *lineView = [[UIView alloc] init];
        [self.contentView addSubview:lineView];
        [self.lineviews addObject:lineView];
        lineView.backgroundColor = k_defaultLineColor;
    }
    [self showTipView:@{k_ToView:self.contentView,
                        k_ShowMsg:@"该景点暂无介绍",
                        k_ListCount:num([self.introItems count]),
                        }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    for (int i = 0; i < self.introItems.count; i++) {
        SightDetailIntroCell *sightDetailIntroCell = self.views[i];
        sightDetailIntroCell.frame = CGRectMake(0,  i ? CGRectGetMaxY(((UIView *)self.views[i - 1]).frame) : 0, self.contentView.width, sightDetailIntroCell.height);
        
        UIView *lineView = self.lineviews[i];
        lineView.frame = CGRectMake(10, CGRectGetMaxY(sightDetailIntroCell.frame) - 0.6, self.contentView.width - 10 * 2, 0.6);
    }
    
    self.contentView.frame = self.view.bounds;
    self.contentView.contentSize = CGSizeMake(self.contentView.width, CGRectGetMaxY(((UIView *)[self.views lastObject]).frame));
}
@end
