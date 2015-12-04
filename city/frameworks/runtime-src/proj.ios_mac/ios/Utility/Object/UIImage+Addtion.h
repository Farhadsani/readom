//
//  UIImage+Addtion.h
//  TapRepublic
//
//  Created by hf on 13-5-13.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Addtion)

+ (UIImage *)imageWithView:(UIView *)view;

+ (UIImage *)imageWithColor:(id)color;

//用于动画开门效果
+ (NSArray*)splitImageIntoTwoParts:(UIImage*)image;

+ (UIImage *)imageWithColor:(id)color baseView:(UIView *)baseView;

//缩小图片
+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage;
//缩小图片
+ (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize;

//改变Image图片的大小
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;

+ (NSString *)imageStringToBase64Char:(UIImage *)image;

+ (UIImage *)base64CharToImage:(NSString *)base64String;
@end

@interface UIDevice (Addtion)

#pragma mark camera utility
+ (BOOL) isCameraAvailable;

+ (BOOL) isRearCameraAvailable;

+ (BOOL) isFrontCameraAvailable;

+ (BOOL) doesCameraSupportTakingPhotos;

+ (BOOL) isPhotoLibraryAvailable;
+ (BOOL) canUserPickVideosFromPhotoLibrary;
+ (BOOL) canUserPickPhotosFromPhotoLibrary;

+ (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType;


@end