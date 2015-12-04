//
//  UserBaseInfoController.h
//  qmap
//
//  Created by 石头人6号机 on 15/7/30.
//
/*
 *[基本资料]页面
 *功能：显示用户的名称、个人简介
 * 登出帐号 功能
 */

#import "BaseUIViewController.h"
#import "UserBriefItem.h"
#import "UserBaseInfoView.h"

#import "PostThumbCell.h"
#import "ZYQAssetPickerController.h"

#import "StreetListInAreaViewController.h"
#import "EditStoreCategoryViewController.h"

typedef enum ImagePickTag{
    UserLogo_picker = 32,    //用户头像
    StorePictures_picker    //商家相册
}ImagePickTag;

@interface UserBaseInfoController : BaseViewController <ZYQAssetPickerControllerDelegate, UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,PostThumbCellDelegate, StreetListInAreaVCDelegate, EditStoreCategoryVCDelegate>

@end
