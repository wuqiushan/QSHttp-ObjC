//
//  QSHttpManage.h
//  QSHttp
//
//  Created by wuqiushan on 2019/8/12.
//  Copyright © 2019 wuqiushan3@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

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
- (void)GET:(NSString *)urlStr param:(NSDictionary *)param success:(void(^)(id rspObject))success failure:(void(^)(NSError *error))failure;


/**
 POST方法去请求
 
 @param urlStr 请求Url
 @param param 请求参数
 @param success 请求成功响应
 @param failure 请求失败响应
 */
- (void)POST:(NSString *)urlStr param:(NSDictionary *)param success:(void(^)(id rspObject))success failure:(void(^)(NSError *error))failure;

/**
 下载文件
 
 @param urlStr 请求Url
 @param param 请求参数
 @param success 请求成功响应
 @param failure 请求失败响应
 */
- (void)downloadWithUrl:(NSString *)urlStr param:(NSDictionary *)param success:(void(^)(id rspObject))success failure:(void(^)(NSError *error))failure;

/**
 上传数据，如：单个图片、语音等数据量比较小的，大文件请通过本类的文件上传方法
 
 @param urlStr 请求Url
 @param fileData 需要上传的数据
 @param success 请求成功响应
 @param failure 请求失败响应
 */
- (void)uploadWithUrl:(NSString *)urlStr fileData:(NSData *)fileData success:(void(^)(id rspObject))success failure:(void(^)(NSError *error))failure;

/**
 上传文件，流方式
 
 @param urlStr 请求Url
 @param filePath 文件路径
 @param success 请求成功响应
 @param failure 请求失败响应
 */
- (void)uploadWithUrl:(NSString *)urlStr filePath:(NSString *)filePath success:(void(^)(id rspObject))success failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
