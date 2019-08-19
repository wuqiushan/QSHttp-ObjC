//
//  QSHttpManage.h
//  QSHttp
//
//  Created by wuqiushan on 2019/8/12.
//  Copyright © 2019 wuqiushan3@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BlockProgress)(float progress);
typedef void(^BlockRsp)(id rspObject);
typedef void(^BlockErr)(NSError *error);


@interface QSHttpManage : NSObject

//+ (instancetype)sharedInstance;

/**
 GET方法去请求
 
 @param urlStr 请求Url
 @param param 请求参数
 @param success 请求成功响应
 @param failure 请求失败响应
 */
- (void)GET:(NSString *)urlStr param:(NSDictionary *)param success:(BlockRsp)success failure:(BlockErr)failure;


/**
 POST方法去请求
 
 @param urlStr 请求Url
 @param param 请求参数
 @param success 请求成功响应
 @param failure 请求失败响应
 */
- (void)POST:(NSString *)urlStr param:(NSDictionary *)param success:(BlockRsp)success failure:(BlockErr)failure;

/**
 下载文件, 如果不设置存储路径的话，存储到默认位置 /Library/Caches 下
 
 @param urlStr 请求Url
 @param param 请求参数
 @param storagePath 下载后存储的位置 例：如果完整路径是 download/test/b.zip 则只传user/test/
 @param progress 下载进度(0.0 - 1.0)
 @param success 请求成功响应
 @param failure 请求失败响应
 */
- (void)download:(NSString *)urlStr param:(NSDictionary *)param storagePath:(NSString *)storagePath
               progress:(BlockProgress)progress success:(BlockRsp)success failure:(BlockErr)failure;

/**
 上传数据，如：单个图片、语音等数据量比较小的，大文件请通过本类的文件上传方法
 
 @param urlStr 请求Url
 @param fileData 需要上传的数据
 @param progress 上传进度(0.0 - 1.0)
 @param success 请求成功响应
 @param failure 请求失败响应
 */
- (void)upload:(NSString *)urlStr fileData:(NSData *)fileData progress:(BlockProgress)progress success:(BlockRsp)success failure:(BlockErr)failure;

/**
 上传文件，流方式
 
 @param urlStr 请求Url
 @param filePath 文件路径
 @param progress 上传进度(0.0 - 1.0)
 @param success 请求成功响应
 @param failure 请求失败响应
 */
- (void)upload:(NSString *)urlStr filePath:(NSString *)filePath progress:(BlockProgress)progress success:(BlockRsp)success failure:(BlockErr)failure;


@end

NS_ASSUME_NONNULL_END
