//
//  ImagePicker_ios.h
//  qmap
//
//  Created by Shenghua Su on 3/31/15.
//
//

#import <UIKit/UIKit.h>

@interface ImagePicker_ios : NSObject

+ (ImagePicker_ios*)sharedImagePicker;

- (void)presentImagePickerViewControllerWithSourceTypeSpecified:(BOOL)sourceTypeSpecified
                                                     sourceType:(UIImagePickerControllerSourceType)sourceType
                                      useCustomizedImageFitSize:(BOOL)useCustomizedImageFitSize
                                         customizedImageFitSize:(CGSize)customizedImageFitSize
                                              imageSavePathName:(NSString *)imageSavePathName
                                             compressionQuality:(float)compressionQuality
                                                  saveThumbnail:(BOOL)saveThumbnail
                                              thumbnailFillSize:(CGSize)thumbnailFillSize
                                          thumbnailSavePathName:(NSString *)thumbnailSavePathName;

@end
