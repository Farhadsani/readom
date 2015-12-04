//
//  StoreCommentFrame.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/14.
//
//

#import <Foundation/Foundation.h>
#import "StoreComment.h"

#define StoreCommentCellUserNameFont [UIFont fontWithName:k_fontName_FZZY size:15]
#define StoreCommentCellStartReateLabelFont [UIFont fontWithName:k_fontName_FZZY size:15]
#define StoreCommentCellTimeLabelFont [UIFont fontWithName:k_defaultFontName size:11]
#define StoreCommentCellContentFont [UIFont fontWithName:k_fontName_FZZY size:13]

#define StoreCommentCellStartReateH (45.0/2)

@interface StoreCommentFrame : NSObject
@property (nonatomic, strong) StoreComment *storeComment;
@property (nonatomic, assign) CGRect userIconFrame;
@property (nonatomic, assign) CGRect userNameFrame;
@property (nonatomic, assign) CGRect startReateFrame;
@property (nonatomic, assign) CGRect startReateLabelFrame;
@property (nonatomic, assign) CGRect timeLabelFrame;
@property (nonatomic, assign) CGRect contentLabelFrame;
@property (nonatomic, assign) CGRect commentImgsViewFrame;
@property (nonatomic, assign) CGFloat cellHight;
@end
