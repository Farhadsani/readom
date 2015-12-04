//
//  FileManager.m
//  
//
//  Created by hf on 13-1-15.
//  Copyright (c) 2013年 hf. All rights reserved.
//

#import "FileManager.h"

static FileManager *manager = nil;

@implementation FileManager

NSSearchPathDirectory HomeDirectory(){
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    if ([systemVersion isEqualToString:@"5.0"]) {
        return NSCachesDirectory;
    }
    else{
        return NSDocumentDirectory;
    }
}

+ (NSString *)documentsPath{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtExistIndex:0];
}

+ (NSString *)applicationDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSAllDomainsMask, YES) objectAtExistIndex:0];
}

+ (id)shared{
    if (manager == nil) {
        manager = [[FileManager alloc] init];
    }
    return manager;
}

//判断是否需要加载高清图片
+ (BOOL)shouldGetImage2x:(NSString *)path{
    return NO;
}

//从路径取出最后的文件名，如：参数：/logn/login.html  返回：login.html
+ (NSString *)fileNameOfPath:(NSString *)path{
    NSString *name = path;
    NSUInteger start = [name rangeOfString:@"/" options:NSBackwardsSearch].location;
    if (start != NSNotFound) {
        name = [name substringFromIndex:start + 1];
    }
    return name;
}

+ (NSData *)readBundleFile:(NSString *)fileName type:(NSString *)type{
    NSString * path = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    if (path == nil) {
        return nil;
    }
    else{
        return [NSData dataWithContentsOfFile:path];
    }
}

//获取document目录下的全路径
+ (NSString *)getFullDocumentPathWithRelativePath:(NSString *)path{
    if (!path || path.length == 0) {
        return [FileManager documentsPath];
    }
    if ([path rangeOfString:[FileManager documentsPath]].location != NSNotFound) {
        return path;
    }
    NSString *pathUrl = path;
    if (![pathUrl hasPrefix:@"/"]) {
        pathUrl = [NSString stringWithFormat:@"/%@", pathUrl];
    }
    
    if ([FileManager shouldGetImage2x:pathUrl]) {
        NSString * fileName = [FileManager fileNameOfPath:pathUrl];
        NSString * fileType = @"";
        NSArray *array = [fileName componentsSeparatedByString:@"."];
        if (array.count == 2) {
            fileName = [array objectAtExistIndex:0];
            fileType = [array objectAtExistIndex:1];
        }
        NSString * newFileName = [NSString stringWithFormat:@"%@@2x.%@", fileName,fileType];
        newFileName = [pathUrl stringByReplacingOccurrencesOfString:[FileManager fileNameOfPath:pathUrl] withString:newFileName];
        NSString * fullPath = [[FileManager documentsPath] stringByAppendingString:newFileName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
            pathUrl = newFileName;
        }
    }
    return [[FileManager documentsPath] stringByAppendingString:pathUrl];
}

//获取document目录下的子目录path下的所有文件（文件、文件目录）
+ (NSArray *)directoryContentsAtDocument:(NSString *)path{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSError *error = nil;
    NSString * pathToClear = [FileManager getFullDocumentPathWithRelativePath:path];
    if ([[NSFileManager defaultManager] fileExistsAtPath:pathToClear]) {
        NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:pathToClear error:&error];
        if (error == nil) {
            NSMutableArray * maa = [NSMutableArray arrayWithArray:directoryContents];
            [maa removeObject:@".DS_Store"];
            return maa;
        }
    }
//    [fileMgr createDirectoryAtPath:pathToClear withIntermediateDirectories:YES attributes:nil error:nil];
    
    return nil;
}

//获取document目录下，相对路径relativePath的所有资源
//flag:资源所具有的标识(非完全匹配)
+ (NSArray *)getAllResourceAtDocument:(NSString *)relativePath withPartFlag:(NSString *)flag{
    if (!relativePath) {
        return nil;
    }
    
    if (relativePath.length > 0 && [relativePath hasSuffix:@"/"]) {
        relativePath = [relativePath substringToIndex:relativePath.length-1];
    }
    
    NSMutableArray * result = [[[NSMutableArray alloc] init] autorelease];
    NSArray * tmp = [self directoryContentsAtDocument:relativePath];
    for (NSString * str in tmp) {
        if ([str rangeOfString:flag].location != NSNotFound) {
            [result addObject:[NSString stringWithFormat:@"%@/%@",relativePath, str]];
        }
        else if (![str hasPrefix:@"."]) {
            NSArray * tr = [self getAllResourceAtDocument:[NSString stringWithFormat:@"%@/%@",relativePath, str] withPartFlag:flag];
            if (tr && [tr count] > 0) {
                [result addObjectsFromArray:tr];
            }
        }
    }
    if ([result containsObject:@".DS_Store"]) {
        [result removeObject:@".DS_Store"];
    }
    return result;
}

//获取document目录下，相对路径relativePath的所有资源
//flag:资源所具有的标识(完全匹配)
+ (NSArray *)getAllResourceAtDocument:(NSString *)relativePath withTotalMatch:(NSString *)flag{
    NSMutableArray * result = [[[NSMutableArray alloc] init] autorelease];
    NSArray * tmp = [self directoryContentsAtDocument:relativePath];
    for (NSString * str in tmp) {
        if ([str isEqualToString:flag]) {
            [result addObject:[NSString stringWithFormat:@"%@/%@",relativePath, str]];
        }
        else if (![str hasPrefix:@"."]) {
            NSArray * tr = [self getAllResourceAtDocument:[NSString stringWithFormat:@"%@/%@",relativePath, str] withTotalMatch:flag];
            if (tr && [tr count] > 0) {
                [result addObjectsFromArray:tr];
            }
        }
    }
    if ([result containsObject:@".DS_Store"]) {
        [result removeObject:@".DS_Store"];
    }
    return result;
}

+ (BOOL)fileExistsAtDocumentAtPath:(NSString *)path{
    if (!path) return NO;
    NSString *localPath = [FileManager getFullDocumentPathWithRelativePath:path];
    if ([localPath hasSuffix:@"/"]) {
        localPath = [localPath substringToIndex:localPath.length - 1];
    }
    return [[NSFileManager defaultManager] fileExistsAtPath:localPath];
}

//将某一个文件夹下的文件拷贝到另一个文件夹下
//fromPath和toPath都是相对于document目录
+ (BOOL)copyItemsAtPath:(NSString *)fromPath toPath:(NSString *)toPath{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if (![self fileExistsAtDocumentAtPath:toPath]) {
        [fileMgr createDirectoryAtPath:toPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    BOOL copyFlag = YES;
    if ([self fileExistsAtDocumentAtPath:fromPath]) {
        NSString * tP = [FileManager getFullDocumentPathWithRelativePath:toPath];
        if (![tP hasSuffix:@"/"]) {
            tP = [NSString stringWithFormat:@"%@/", tP];
        }
        NSArray * content = [self directoryContentsAtDocument:fromPath];
        for (NSString * path in content) {
            NSString * tm = fromPath;
            if (![fromPath hasSuffix:@"/"]) {
                tm = [NSString stringWithFormat:@"%@/", fromPath];
            }
            NSString * fp = [FileManager getFullDocumentPathWithRelativePath:[NSString stringWithFormat:@"%@%@", tm, path]];
            NSString * a2 = [NSString stringWithFormat:@"%@%@", tP, path];
            if (![fileMgr fileExistsAtPath:[a2 stringByReplacingOccurrencesOfString:[FileManager fileNameOfPath:a2] withString:@""]]) {
                [fileMgr createDirectoryAtPath:[a2 stringByReplacingOccurrencesOfString:[FileManager fileNameOfPath:a2] withString:@""] withIntermediateDirectories:YES attributes:nil error:nil];
            }
            if ([fileMgr fileExistsAtPath:a2]) {
                [fileMgr removeItemAtPath:a2 error:nil];
            }
            if (![fileMgr copyItemAtPath:fp toPath:a2 error:nil]) {
                copyFlag = NO;
            }
        }
    }
    return copyFlag;
}

//读document目录下url目录下的数据
- (NSData *)readDataAtDocumentAtPath:(NSString *)url error:(NSError *)error{
    if (url == nil) return nil;
    
    NSString *pathUrl = [FileManager getFullDocumentPathWithRelativePath:url];
    //image自动判断是否读取高清图片
//    if ([FileManager shouldGetImage2x:pathUrl]) {
//        NSString * fileName = [FileManager fileNameOfPath:pathUrl];
//        NSString * fileType = @"";
//        NSArray *array = [fileName componentsSeparatedByString:@"."];
//        if (array.count == 2) {
//            fileName = [array objectAtExistIndex:0];
//            fileType = [array objectAtExistIndex:1];
//        }
//        NSString * newFileName = [NSString stringWithFormat:@"%@@2x.%@", fileName,fileType];
//        newFileName = [url stringByReplacingOccurrencesOfString:[FileManager fileNameOfPath:url] withString:newFileName];
//        NSString * fullPath = [[FileManager documentsPath] stringByAppendingString:newFileName];
//        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
//            pathUrl = fullPath;
//        }
//    }
    NSString *srcPath = nil;
    InfoLog(@"localPath【At Documents】:%@", pathUrl);
    NSString * fileName = [FileManager fileNameOfPath:url];
    NSString * fileType = @"";
    
    if ([fileName rangeOfString:@"."].location != NSNotFound) {
        NSArray *array = [fileName componentsSeparatedByString:@"."];
        if (array.count == 2) {
            fileName = [array objectAtExistIndex:0];
            fileType = [array objectAtExistIndex:1];
        }
    }
    else{
        return nil;
    }
    
    srcPath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
#ifdef __READFROMBUNDLE__
    if (!srcPath) {
        Error(@"NOT FOUDN FILE【At Bundle】:%@.%@",fileName,fileType);
    }
    return srcPath ? [NSData dataWithContentsOfFile:srcPath options:0 error:&error] : nil;
#endif
    
#ifdef __READFROMBUNDLEATFIRST__
    if (!srcPath) {
        Error(@"NOT FOUDN FILE【At Bundle】:%@.%@",fileName,fileType);
    }
    else{
        return [NSData dataWithContentsOfFile:srcPath options:0 error:&error];
    }
#endif
    
    
//    InfoLog(@"pathUrl:%@", pathUrl);
    if (![[NSFileManager defaultManager] fileExistsAtPath:pathUrl]) {
#ifdef __GET_RESOURCE_FROM_BUNDLE_WHEN_DOCUMENT_NOT_EXITS__
        if (srcPath.length && [[NSFileManager defaultManager] fileExistsAtPath:srcPath]) {
            BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:[pathUrl stringByReplacingOccurrencesOfString:[FileManager fileNameOfPath:url] withString:@""]
                                 withIntermediateDirectories:YES
                                                  attributes:nil
                                                       error:nil];
            if (result) {
#ifdef __ENCODE_TO_LOCAL_RESOURCE__
                
                if (![SecurityManager judgeFileTypeShouldBeEncodeOrNot:pathUrl]) {
                    if ([[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:pathUrl error:nil]) {
                        return [NSData dataWithContentsOfFile:pathUrl options:0 error:&error];
                    }
                }
                if ([[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:pathUrl error:nil]) {
                    NSString * ss = [NSString stringWithContentsOfFile:pathUrl encoding:NSUTF8StringEncoding error:nil];
                    NSData * data = [ss dataUsingEncoding:NSUTF8StringEncoding];
                    data = [data AES128EncryptWithKey:[[ResourcePoolService sharedPoolResourceController] keyToEncodeLocalFile]];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:pathUrl]) {
                        [[NSFileManager defaultManager] removeItemAtPath:pathUrl error:nil];
                    }
                    if ([self writeToDocumentWithData:data toPath:pathUrl]) {
                        return [NSData dataWithContentsOfFile:pathUrl options:0 error:&error];
                    }
                }
                
#else
                
                if ([[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:pathUrl error:nil]) {
                    return [NSData dataWithContentsOfFile:pathUrl options:0 error:&error];
                }
                
#endif
                
            }
        }
#endif
    }
    else{
        return [NSData dataWithContentsOfFile:pathUrl options:0 error:&error];
    }
    return nil;
}

//读document目录下url目录下的数据
- (NSString *)readStringAtDocumentAtPath:(NSString *)url error:(NSError *)error{
    NSData * data = [self readDataAtDocumentAtPath:url error:error];
    NSString * tmp = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    if (!tmp) {
        NSStringEncoding gbk = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        tmp = [[NSString alloc] initWithData:data encoding:gbk];
    }
    
    return tmp;
}

//+ (BOOL)unzipFileAtFullPath:(NSString *)path toDestination:(NSString *)destination {
//    if ([[NSFileManager defaultManager] fileExistsAtPath:path] && destination != nil) {
//        return [ZipArchive unzipFileAtPath:path toDestination:destination overwrite:YES password:nil error:nil];
//    }
//    else{
//        return NO;
//    }
//}
//
//+ (BOOL)unzipFileAtPath:(NSString *)path toDestination:(NSString *)destination {
//    if (path == nil || destination == nil) return NO;
//    
//    NSString *pathUrl = [FileManager getFullDocumentPathWithRelativePath:path];
//    NSString *destinationpathUrl = [FileManager getFullDocumentPathWithRelativePath:destination];
//    if ([destinationpathUrl hasSuffix:@".zip"]) {
//        destinationpathUrl = [destinationpathUrl stringByReplacingOccurrencesOfString:@".zip" withString:@""];
//        return [ZipArchive unzipFileAtPath:pathUrl toDestination:destinationpathUrl];
//    }
//    else if ([destinationpathUrl hasSuffix:@".rar"]) {
//        destinationpathUrl = [destinationpathUrl stringByReplacingOccurrencesOfString:@".rar" withString:@""];
//        return [ZipArchive unzipFileAtPath:pathUrl toDestination:destinationpathUrl];
//    }
//    else{
//        return NO;
//    }
//}

//写数据
- (BOOL)writeToDocumentWithData:(NSData *)data toPath:(NSString *)path{
    if (data == nil || path == nil) return NO;
    
    NSString *pathUrl = [FileManager getFullDocumentPathWithRelativePath:path];
    pathUrl = [pathUrl stringByReplacingOccurrencesOfString:[FileManager fileNameOfPath:path] withString:@""];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager createDirectoryAtPath:pathUrl
                         withIntermediateDirectories:YES
                                          attributes:nil
                                               error:nil];
    if (result) {
        NSString * tmpName = [FileManager fileNameOfPath:path];
        if (![tmpName hasPrefix:@"/"]) {
            tmpName = [NSString stringWithFormat:@"/%@", tmpName];
        }
        BOOL result;
        pathUrl = [pathUrl stringByAppendingFormat:@"%@",tmpName];
        pathUrl = [pathUrl stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
        
        if ([FileManager shouldGetImage2x:pathUrl]) {
            NSString * fileName = [FileManager fileNameOfPath:pathUrl];
            NSString * fileType = @"";
            NSArray *array = [fileName componentsSeparatedByString:@"."];
            if (array.count == 2) {
                fileName = [array objectAtExistIndex:0];
                fileType = [array objectAtExistIndex:1];
            }
            NSString * newFileName = [NSString stringWithFormat:@"%@@2x.%@", fileName,fileType];
            pathUrl = [pathUrl stringByReplacingOccurrencesOfString:[FileManager fileNameOfPath:pathUrl] withString:newFileName];
        }
        
        InfoLog(@"write to file at path:%@", pathUrl);
        result = [data writeToFile:pathUrl atomically:YES];
        return result;
    }
    return NO;
}

//写数据
- (BOOL)writeToDocumentWithString:(NSString *)string toPath:(NSString *)path{
    if (string == nil || path == nil) return NO;
    NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self writeToDocumentWithData:data toPath:path];
}

//删除document目录下具体的文件，url路径必须为文件路径如 logn/login.html
//还可以删除整个文件目录
- (BOOL)deleteFileAtDocumentAtPath:(NSString *)path{
    if (path == nil) {
        return NO;
    }
    if (![FileManager fileExistsAtDocumentAtPath:path] || path.length == 0) return YES;
    
    NSString *localPath = [FileManager getFullDocumentPathWithRelativePath:path];
    InfoLog(@"%@", localPath);
    return [[NSFileManager defaultManager] removeItemAtPath:localPath error:nil];
}

- (BOOL)moveFileAtDocumentAtPath:(NSString *)fromPath toDocumentAtPath:(NSString *)toPath{
    if (fromPath == nil || toPath == nil) {
        return NO;
    }
    if (![FileManager fileExistsAtDocumentAtPath:fromPath] || fromPath.length == 0) return YES;
    
    NSString *localFromPath = [FileManager getFullDocumentPathWithRelativePath:fromPath];
    NSString *localToPath = [FileManager getFullDocumentPathWithRelativePath:toPath];
    if (![localFromPath hasSuffix:@"/"]) {
        localFromPath = [NSString stringWithFormat:@"%@/", localFromPath];
    }
    if (![localToPath hasSuffix:@"/"]) {
        localToPath = [NSString stringWithFormat:@"%@/", localToPath];
    }
    
    NSArray * contents = [FileManager directoryContentsAtDocument:fromPath];
    for (NSString * path in contents) {
        [[NSFileManager defaultManager] moveItemAtPath:[NSString stringWithFormat:@"%@%@", localFromPath, path] toPath:[NSString stringWithFormat:@"%@%@", localToPath, path] error:nil];
    }
    
    return YES;
}

//删除路径下的所有文件，path为全路径
+ (BOOL)deleteDirectoryAtPath:(NSString *)path error:(NSError **)error{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:path error:error];
    for (NSString *subPath in directoryContents){
        NSString *filePath = [path stringByAppendingPathComponent:subPath];
        BOOL result = [fileManager removeItemAtPath:filePath error:error];
        if (!result) {
            return NO;
        }
    }
    return YES;
}

//清除document目录下子目录path下的所有文件资源，如果参数为空清除document目录下所有文件资源
- (BOOL)clearAllFilesAtDocumentAtPath:(NSString *)path{
    InfoLog(@"%s, path:%@", __FUNCTION__, path);
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSError *error = nil;
    
    NSString * pathToClear = [FileManager getFullDocumentPathWithRelativePath:path];
    [fileMgr createDirectoryAtPath:pathToClear withIntermediateDirectories:YES attributes:nil error:nil];
    NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:pathToClear error:&error];
    if (error == nil) {
        for (NSString *path1 in directoryContents) {
            NSString * tmp = path1;
            if (![path1 hasPrefix:@"/"]) {
                tmp = [NSString stringWithFormat:@"/%@", path1];
            }
            NSString *fullPath = [pathToClear stringByAppendingPathComponent:tmp];
            if ([fileMgr fileExistsAtPath:fullPath]) {
                return [fileMgr removeItemAtPath:fullPath error:&error];
            }
        }
    }
    return YES;
}

+ (NSString *)handelPlistFilePath:(NSString *)plistFilePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * name = plistFilePath;
    if (![name hasSuffix:@".plist"]) {
        name = [NSString stringWithFormat:@"%@.plist",name];
    }
	NSString *realPath = [FileManager getFullDocumentPathWithRelativePath:name];
    NSString * fileName = [FileManager fileNameOfPath:name];
    if ([fileName rangeOfString:@"."].location != NSNotFound) {
        fileName = [fileName substringToIndex:[fileName rangeOfString:@"."].location];
    }
	NSString *srcPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
	if (![fileManager fileExistsAtPath:realPath] && srcPath != nil) {
        [fileManager copyItemAtPath:srcPath toPath:realPath error:nil];
	}
    return realPath;
}

/**
 * function: 读取document目录下的plist文件，该plist文件为字典类型
 * @params plistFilePath:文件的路径（应该包含文件名及格式）如：/src/paramInfo.plist、或者：paramInfo.plist
 * @return dictionary 
 */
+ (NSDictionary *)readPlistFileOfDictionaryTypeAtDocument:(NSString *)plistFilePath{
    return [NSDictionary dictionaryWithContentsOfFile:[self handelPlistFilePath:plistFilePath]];
}

/**
 * function: 读取document目录下的plist文件，该plist文件为数组类型
 * @params plistFilePath:文件的路径（应该包含文件名及格式）如：/src/paramInfo.plist、或者：paramInfo.plist
 * @return array
 */
+ (NSArray *)readPlistFileOfArrayTypeAtDocument:(NSString *)plistFilePath{
    return [NSArray arrayWithContentsOfFile:[self handelPlistFilePath:plistFilePath]];
}

+ (NSString *)handelPlistFilePaths:(NSString *)plistFilePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * name = plistFilePath;
	NSString *realPath = [FileManager getFullDocumentPathWithRelativePath:name];
    NSString * fileName = [FileManager fileNameOfPath:name];
    if ([fileName rangeOfString:@"."].location != NSNotFound) {
        fileName = [fileName substringToIndex:[fileName rangeOfString:@"."].location];
    }
	NSString *srcPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    
    if (![fileManager fileExistsAtPath:realPath] && srcPath != nil) {
        [fileManager copyItemAtPath:srcPath toPath:realPath error:nil];
	}
    return realPath;
}

/*
 *function: 保存plist文件到document目录下
 * @params:
 * plistFilePath:将要保存的文件路径（应该包含文件名及格式），如：/src/paramInfo.plist、或者：paramInfo.plist
 * dict:保存的具体数据(字典)
 * @return BOOL
 */
+ (BOOL)savePlistFileAtDocument:(NSString *)plistFilePath withDictionary:(NSDictionary *)dict{
    return [dict writeToFile:[self handelPlistFilePaths:plistFilePath] atomically:YES];
}

/*
 *function: 保存plist文件到document目录下
 * @params:
 * plistFilePath:将要保存的文件路径（应该包含文件名及格式），如：/src/paramInfo.plist、或者：paramInfo.plist
 * array:保存的具体数据(数组)
 * @return BOOL
 */
+ (BOOL)savePlistFileAtDocument:(NSString *)plistFilePath withArray:(NSArray *)array{
    return [array writeToFile:[self handelPlistFilePaths:plistFilePath] atomically:YES];
}

@end
