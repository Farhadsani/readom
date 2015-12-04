//
//  FileManager.h
//  
//
//  Created by hf on 13-1-15.
//  Copyright (c) 2013年 hf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

+ (id)shared;

/**
 * document root path
 */
+ (NSString *)documentsPath;

+ (NSString *)applicationDirectory;

/**
 * get the name from file path
 * @param path: the file path. eg: /logn/login.html
 * @return file name,eg:login.html
 */
+ (NSString *)fileNameOfPath:(NSString *)path;

/**
 * 获取path相对于document目录下的全路径
 * get the full path with the reletave path,under document path
 * @param path: the relative path
 * @return the full path
 */
+ (NSString *)getFullDocumentPathWithRelativePath:(NSString *)path;

/**
 * 获取document目录下的子目录path下的所有文件（文件、文件目录）,最后返回的数组中内容为string类型（目录名和文件名）
 * get all file and path under document path
 * @param path: the relative path under document path
 * @return array(数组中内容为string类型（目录名和文件名）)
 */
+ (NSArray *)directoryContentsAtDocument:(NSString *)path;

//将某一个文件夹下的文件拷贝到另一个文件夹下
//fromPath和toPath都是相对于document目录
+ (BOOL)copyItemsAtPath:(NSString *)fromPath toPath:(NSString *)toPath;

//获取document目录下，相对路径relativePath的所有资源(只具有flag特征)
//flag:资源所具有的标识
+ (NSArray *)getAllResourceAtDocument:(NSString *)relativePath withPartFlag:(NSString *)flag;

//获取document目录下，相对路径relativePath的所有资源(完全匹配)
//flag:资源所具有的标识
+ (NSArray *)getAllResourceAtDocument:(NSString *)relativePath withTotalMatch:(NSString *)flag;

/**
 * 读Bundle下的文件
 * read any file under the Bundle
 * @param fileName: the file name
 * @param type: the file type
 * @return data
 */
+ (NSData *)readBundleFile:(NSString *)fileName type:(NSString *)type;

/**
 * 解压的路径是任意的
 * unzip the zip package
 * @param path: the zip package full path
 * @param destination: the destination path of the unziped package
 * @return BOOL
 */
//+ (BOOL)unzipFileAtFullPath:(NSString *)path toDestination:(NSString *)destination;

/**
 * 解压的路径都是document目录下
 * unzip the zip package under document path
 * @param path: the zip package relative path under document path
 * @param destination: the destination path of the unziped package
 * @return BOOL
 */
//+ (BOOL)unzipFileAtPath:(NSString *)path toDestination:(NSString *)destination;

#pragma mark - read & write & delete

//判断document目录下的相对路径path文件是否存在
+ (BOOL)fileExistsAtDocumentAtPath:(NSString *)path;

/**
 * 读document目录下url目录下的数据
 * read file data with file path under document path
 * @param url: the relative path
 * @return data
 */
- (NSData *)readDataAtDocumentAtPath:(NSString *)url error:(NSError *)error;

/**
 * 读document目录下url目录下的数据
 * read file data with file path under document path
 * @param url: the relative path
 * @return string
 */
- (NSString *)readStringAtDocumentAtPath:(NSString *)url error:(NSError *)error;

/**
 * 写数据到document目录下
 * write data to file under document path
 * @param path: the relative path
 * @param data:the data waiting to write
 * @return BOOL
 */
- (BOOL)writeToDocumentWithData:(NSData *)data toPath:(NSString *)path;

/**
 * 写数据到document目录下
 * write string to file under document path
 * @param path: the relative path
 * @param data:the string waiting to write
 * @return BOOL
 */
- (BOOL)writeToDocumentWithString:(NSString *)string toPath:(NSString *)path;

/**
 * 删除document目录下具体的文件，url路径必须为相对文件路径如 logn/login.html，还可以删除整个文件目录
 * delete file with reletave path under document path
 * @param path: the relative path
 * @return BOOL
 */
- (BOOL)deleteFileAtDocumentAtPath:(NSString *)path;

- (BOOL)moveFileAtDocumentAtPath:(NSString *)fromPath toDocumentAtPath:(NSString *)toPath;

/**
 * 删除路径下的所有文件，path为全路径
 * delete file with full path
 * @param path: the full path
 * @return BOOL
 */
+ (BOOL)deleteDirectoryAtPath:(NSString *)path error:(NSError **)error;

/**
 * 清除document目录下子目录path下的所有文件资源，如果参数为空清除document目录下所有文件资源
 * delete all files and path of relative path under document path
 * @param path: the reletave path
 * @return BOOL
 */
- (BOOL)clearAllFilesAtDocumentAtPath:(NSString *)path;

#pragma mark - plist file

/**
 * function: 读取document目录下的plist文件，该plist文件为字典类型
 * @params plistFilePath:文件的路径（应该包含文件名及格式）如：/src/paramInfo.plist、或者：paramInfo.plist
 * @return dictionary
 */
+ (NSDictionary *)readPlistFileOfDictionaryTypeAtDocument:(NSString *)plistFilePath;

/**
 * function: 读取document目录下的plist文件，该plist文件为数组类型
 * @params plistFilePath:文件的路径（应该包含文件名及格式）如：/src/paramInfo.plist、或者：paramInfo.plist
 * @return array
 */
+ (NSArray *)readPlistFileOfArrayTypeAtDocument:(NSString *)plistFilePath;

/*
 *function: 保存plist文件到document目录下
 * @params:
 * plistFilePath:将要保存的文件路径（应该包含文件名及格式），如：/src/paramInfo.plist、或者：paramInfo.plist
 * dict:保存的具体数据(字典)
 * @return BOOL
 */
+ (BOOL)savePlistFileAtDocument:(NSString *)plistFilePath withDictionary:(NSDictionary *)dict;

/*
 *function: 保存plist文件到document目录下
 * @params:
 * plistFilePath:将要保存的文件路径（应该包含文件名及格式），如：/src/paramInfo.plist、或者：paramInfo.plist
 * array:保存的具体数据(数组)
 * @return BOOL
 */
+ (BOOL)savePlistFileAtDocument:(NSString *)plistFilePath withArray:(NSArray *)array;


@end
