//
//  ImagePicker_ios.m
//  qmap
//
//  Created by Shenghua Su on 3/31/15.
//
//

#include "ImagePicker.h"

#import "ImagePicker_ios.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "UIImage+Resize.h"

#define IMAGE_PICKER_DEBUG 1
#define IMAGE_PICKER_ERRLOG 1

static int _luaHandler = 0;
static std::function<void(bool)> _pickImageDoneCallback = nullptr;

static void saveLuaHander(int handler)
{
    _luaHandler = handler;
}

static void bindPickImageDoneCallback(const std::function<void(bool)>& callback)
{
    _pickImageDoneCallback = callback;
}

static void executePickImageDoneCallback(bool imageSaved)
{
    if (_pickImageDoneCallback) {
        _pickImageDoneCallback(imageSaved);
        _pickImageDoneCallback = nullptr;
    }
}

int ImagePicker::getLuaHandler()
{
    return _luaHandler;
}

void ImagePicker::pickImage(PickSource source,
                            float jpgImageQuality,
                            bool useCustomizedImageFitSize,
                            cocos2d::Size customizedImageFitSize,
                            const char* imageSavePath,
                            bool createThumbnail,
                            cocos2d::Size thumbnailFillSize,
                            const char* thumbnailSavePath,
                            const std::function<void(bool)>& pickImageDoneCallback,
                            int luaHandler,
                            Error* error)
{
#if IMAGE_PICKER_DEBUG > 0
    printf("\n[ImagePicker]     pickImage: source: %d,\
            \n            jpgImageQuality: %f,\
            \n  useCustomizedImageFitSize: %s,\
            \n     customizedImageFieSize: (%f, %f)\
            \n              imageSavePath: %s,\
            \n            createThumbnail: %s,\
            \n          thumbnailFillSize: (%f, %f)\
            \n              thumbnailPath: %s,\
            \n      pickImageDoneCallback: %s,\
            \n                 luaHandler: %d, \n",
           source,
           jpgImageQuality,
           useCustomizedImageFitSize? "Yes":"No",
           customizedImageFitSize.width, customizedImageFitSize.height,
           imageSavePath,
           createThumbnail? "Yes":"No",
           thumbnailFillSize.width, thumbnailFillSize.height,
           thumbnailSavePath,
           pickImageDoneCallback? "some function" : "nullptr",
           luaHandler);
#endif
    
    ImagePicker_ios* imagePicker = [ImagePicker_ios sharedImagePicker];
    
    *error = NoError;
    
    bool specifiedSourceType = true;
    UIImagePickerControllerSourceType sourceType;
    if (source == ImagePicker::PickFromPhotoLibrary) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if (source == ImagePicker::PickFromCamera) {
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if (source == ImagePicker::UserChoose) {
        specifiedSourceType = false;
    }
    else {
        *error = PickSourceNotDefined;
    }
    
    if (specifiedSourceType && ![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        *error = PickSourceNotAvailable;
    }
    
    if (*error == NoError) {
        
        if (pickImageDoneCallback) {
            bindPickImageDoneCallback(pickImageDoneCallback);
            saveLuaHander(luaHandler);
        }
        
        NSString* imageFilePath = [NSString stringWithCString:imageSavePath encoding:NSASCIIStringEncoding];
        NSString* thumbnailFilePath = createThumbnail? [NSString stringWithCString:thumbnailSavePath encoding:NSASCIIStringEncoding] : nil;
        
        [imagePicker presentImagePickerViewControllerWithSourceTypeSpecified:specifiedSourceType
                                                                  sourceType:sourceType
                                                   useCustomizedImageFitSize:useCustomizedImageFitSize
                                                      customizedImageFitSize:CGSizeMake(customizedImageFitSize.width, customizedImageFitSize.height)
                                                           imageSavePathName:imageFilePath
                                                          compressionQuality:jpgImageQuality
                                                               saveThumbnail:createThumbnail
                                                           thumbnailFillSize:CGSizeMake(thumbnailFillSize.width, thumbnailFillSize.height)
                                                       thumbnailSavePathName:thumbnailFilePath];
    }
}

@interface ImagePicker_ios () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, weak) UIViewController* rootViewController;
@property (nonatomic, strong) UIImagePickerController* imagePickController;

@property (nonatomic, assign) BOOL useCustomizedImageFitSize;
@property (nonatomic, assign) CGSize customizedImageFitSize;
@property (nonatomic, copy) NSString* imageSavePathName;
@property (nonatomic, assign) float compressionQuality;
@property (nonatomic, assign) BOOL saveThumbnail;
@property (nonatomic, assign) CGSize thumbnailFillSize;
@property (nonatomic, copy) NSString* thumbnailSavePathName;
@property (nonatomic, assign) BOOL hasImageSaved;
@end

@implementation ImagePicker_ios

@synthesize imagePickController = _imagePickController;

static ImagePicker_ios *_sharedImagePicker = nil;

+ (ImagePicker_ios *)sharedImagePicker
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedImagePicker = [[ImagePicker_ios alloc] init];
    });
    return _sharedImagePicker;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (UIImagePickerController *)imagePickController
{
    if (!_imagePickController) {
        _imagePickController = [[UIImagePickerController alloc] init];
        _imagePickController.delegate = self;
        _imagePickController.allowsEditing = YES;
    }
    return _imagePickController;
}

- (void)presentImagePickerViewControllerWithSourceTypeSpecified:(BOOL)sourceTypeSpecified
                                                     sourceType:(UIImagePickerControllerSourceType)sourceType
                                      useCustomizedImageFitSize:(BOOL)useCustomizedImageFitSize
                                         customizedImageFitSize:(CGSize)customizedImageFitSize
                                              imageSavePathName:(NSString *)imageSavePathName
                                             compressionQuality:(float)compressionQuality
                                                  saveThumbnail:(BOOL)saveThumbnail
                                              thumbnailFillSize:(CGSize)thumbnailFillSize
                                          thumbnailSavePathName:(NSString *)thumbnailSavePathName
{
    self.useCustomizedImageFitSize = useCustomizedImageFitSize;
    self.customizedImageFitSize = customizedImageFitSize;
    self.imageSavePathName = imageSavePathName;
    self.compressionQuality = compressionQuality;
    self.saveThumbnail = saveThumbnail;
    self.thumbnailFillSize = thumbnailFillSize;
    self.thumbnailSavePathName = thumbnailSavePathName;
    
    self.hasImageSaved = false;
    if (sourceTypeSpecified) {
        self.imagePickController.sourceType = sourceType;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self.imagePickController
                                                                                     animated:YES completion:nil];
    }
    else {
        UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍照", @"从相册中选取", nil];
        
        self.rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [choiceSheet showInView:self.rootViewController.view];
    }
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    BOOL canPick = YES;
    if (buttonIndex == 0) { // pick from camera
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickController.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else {
            canPick = NO;
#if IMAGE_PICKER_ERRLOG > 0
            InfoLog(@"[ImagePicker Error]: camera source not available");
#endif
        }
    }
    else if (buttonIndex == 1) { // pick from photo library
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            self.imagePickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        else {
            canPick = NO;
#if IMAGE_PICKER_ERRLOG > 0
            InfoLog(@"[ImagePicker Error]: photo library source not available");
#endif
        }
    }
    else {
        canPick = NO;
        executePickImageDoneCallback(false);
    }
    
    if (canPick) {
        [self.rootViewController presentViewController:self.imagePickController animated:YES completion:nil];
    }
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    UIImage *originalImage, *editedImage;
    
    if ([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
        
        editedImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // Save the new image (original or edited) to the Camera Roll if the image have metadata, which means it comes from the library
        if([info objectForKey:UIImagePickerControllerMediaMetadata] != nil) {
            UIImageWriteToSavedPhotosAlbum(editedImage, nil, nil , nil);
        }
        
        // target image
        UIImage* targetImage = originalImage;
        if (self.useCustomizedImageFitSize) {
            targetImage = [UIImage imageWithImage:targetImage scaledToFitToSize:self.customizedImageFitSize];
        }
        else {
            targetImage = [UIImage imageWithImage:targetImage
                                     scaledToSize:targetImage.size
                                           inRect:CGRectMake(0.0, 0.0, targetImage.size.width, targetImage.size.height)
                                retinaScaleFactor:1.0];
        }
        
#if IMAGE_PICKER_DEBUG > 0
        InfoLog(@"original Image size: (%f, %f)", originalImage.size.width, originalImage.size.height);
        InfoLog(@"edited Image size: (%f, %f)", editedImage.size.width, editedImage.size.height);
        InfoLog(@"target Image size: (%f, %f)", targetImage.size.width, targetImage.size.height);
        if (self.useCustomizedImageFitSize) {
            InfoLog(@"calling scaleToFitToSize: (customized size)(%f, %F)", self.customizedImageFitSize.width, self.customizedImageFitSize.height);
            InfoLog(@"--------> new image size: (%f, %f)", targetImage.size.width, targetImage.size.height);
        }
#endif
        // save target image
        BOOL saveImageSucceeded = [self saveImage:targetImage to:self.imageSavePathName jpgQuality:self.compressionQuality];
        self.hasImageSaved = saveImageSucceeded;
        
        if (saveImageSucceeded) {
            
            if (self.saveThumbnail) {
                // thumbnail image
                UIImage *thumbnailImage = [UIImage imageWithImage:originalImage scaledToFillToSize:self.thumbnailFillSize];
                
                // save thumbnail
                [self saveImage:thumbnailImage to:self.thumbnailSavePathName jpgQuality:self.compressionQuality];
            }
        }
    }
    else
    {
#if IMAGE_PICKER_ERRLOG
        InfoLog(@"[ImagePicker Error]: media picked not image type");
#endif
    }
    
    [self imagePickerControllerDidCancel:picker];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        executePickImageDoneCallback(self.hasImageSaved == YES);
    }];
}

#pragma mark helper methods

- (BOOL)saveImage:(UIImage *)image to:(NSString *)imageSaveFileName jpgQuality:(float)jpgQuality
{
    BOOL succeeded = NO;
    
    // path
    NSString* saveFileName = [NSString stringWithFormat:@"Documents/%@.jpg", imageSaveFileName];
    NSString* fullSavePathName = [NSHomeDirectory() stringByAppendingPathComponent:saveFileName];
    
    // check directory existence
    NSError* error = NULL;
    BOOL dirCreated = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* dirPath = [fullSavePathName stringByDeletingLastPathComponent];
    BOOL isDir;
    BOOL fileExist = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    if (!fileExist || !isDir) {
        dirCreated = [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    // save file
    if (dirCreated) {
        BOOL result = [UIImageJPEGRepresentation(image, jpgQuality) writeToFile:fullSavePathName
                                                                        options:NSDataWritingAtomic
                                                                          error:&error];
        succeeded = result;
        
        if (!result) {
#if IMAGE_PICKER_ERRLOG > 0
            InfoLog(@"[ImagePicker Error]: file save error: %@, reason: %@, for file: %@",
                  [error localizedDescription],
                  [error localizedFailureReason],
                  fullSavePathName);
#endif
        }
    }
    else {
#if IMAGE_PICKER_ERRLOG > 0
        InfoLog(@"[ImagePicker Error]: create directory error: %@, reason: %@, for file: %@",
              [error localizedDescription],
              [error localizedFailureReason],
              fullSavePathName);
#endif
    }
    
    return succeeded;
}
    
@end
