//
//  QSHttpManage.m
//  QSHttp
//
//  Created by wuqiushan on 2019/8/12.
//  Copyright © 2019 wuqiushan3@163.com. All rights reserved.
//
/**
 此类为一个单例，方便用户调用书写
 1.采用多线程异步请求机制
 2.支持中英文URL请求
 3.有上传、下载、GET、POST等多种请求方式
 4.支持无网提示
 */

#import "QSHttpManage.h"

@interface QSHttpManage()<NSURLSessionDownloadDelegate>

@property (atomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (atomic, strong) NSURLSessionUploadTask *uploadTask;

@property (nonatomic, strong) NSMutableArray *blockRspArray;  // 存放所有Rsp的block
@property (nonatomic, strong) NSMutableArray *blockErrArray;  // 存放所有Rsp的block

@end

@implementation QSHttpManage

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

///**
// 为了给用户调用方便，这里使用单例，然后用单例方法
//
// @return 返回一个单例
// */
//+ (instancetype)sharedInstance {
//    static QSHttpManage *shared = nil;
//    static dispatch_once_t onceToken;
//    _dispatch_once(&onceToken, ^{
//        shared = [[QSHttpManage alloc] init];
//    });
//
//    return shared;
//}

/**
 GET方法去请求
 
 @param urlStr 请求Url
 @param param 请求参数
 @param success 请求成功响应
 @param failure 请求失败响应
 */
- (void)GET:(NSString *)urlStr param:(NSDictionary *)param success:(void(^)(id rspObject))success failure:(void(^)(NSError *error))failure {
    [self method:@"GET" url:urlStr param:param success:success failure:failure];
}


/**
 POST方法去请求

 @param urlStr 请求Url
 @param param 请求参数
 @param success 请求成功响应
 @param failure 请求失败响应
 */
- (void)POST:(NSString *)urlStr param:(NSDictionary *)param success:(void(^)(id rspObject))success failure:(void(^)(NSError *error))failure {
    [self method:@"POST" url:urlStr param:param success:success failure:failure];
}

/**
 通用方法去请求

 @param method 请求方式
 @param urlStr 请求Url
 @param param 请求参数
 @param success 请求成功响应
 @param failure 请求失败响应
 */
- (void)method:(NSString *)method url:(NSString *)urlStr param:(NSDictionary *)param success:(void(^)(id rspObject))success failure:(void(^)(NSError *error))failure {
    
    // URL编码
    NSString *urlString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString: urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    request.timeoutInterval = 30;
    request.HTTPMethod = method;
    
    // 设备请求参数
    if (param != nil) {
        NSError *paramError = nil;
        NSData *paramData = [NSJSONSerialization dataWithJSONObject:param
                                                            options:NSJSONWritingPrettyPrinted
                                                              error:&paramError];
        if (paramError == nil) {
            request.HTTPBody = paramData;
        }
        else {
            NSLog(@"请求参数错误 = %@", paramError);
        }
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@", [NSThread currentThread]);
        if (data && (error == nil)) {
            NSError *dataError = nil;
            id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&dataError];
            if (dataError != nil) {
                NSLog(@"响应数据解析失败 %@", dataError);
            }
            if (success) {
                success(result);
            }
        } else {
            if (failure) {
                failure(error);
            }
        }
    }];
    
    [dataTask resume];
}


/**
 下载文件

 @param urlStr 请求Url
 @param param 请求参数
 @param success 请求成功响应
 @param failure 请求失败响应
 */
- (void)downloadWithUrl:(NSString *)urlStr param:(NSDictionary *)param success:(void(^)(id rspObject))success failure:(void(^)(NSError *error))failure {
    
    // URL编码
    NSString *urlString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    request.timeoutInterval = 30;
    request.HTTPMethod = @"GET";
    
    // 设备请求参数
    if (param != nil) {
        NSError *paramError = nil;
        NSData *paramData = [NSJSONSerialization dataWithJSONObject:param
                                                            options:NSJSONWritingPrettyPrinted
                                                              error:&paramError];
        if (paramError == nil) {
            request.HTTPBody = paramData;
        }
        else {
            NSLog(@"请求参数错误 = %@", paramError);
        }
    }
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    self.downloadTask = [session downloadTaskWithRequest:request];
    [self.downloadTask resume];
    
    /*
     // 使用了block后代理后面用不了
    self.downloadTask = [session downloadTaskWithRequest:urlRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    }];
    [self.downloadTask resume];
     */
}


/**
 上传数据，如：单个图片、语音等数据量比较小的，大文件请通过本类的文件上传方法

 @param urlStr 请求Url
 @param fileData 需要上传的数据
 @param success 请求成功响应
 @param failure 请求失败响应
 */
- (void)uploadWithUrl:(NSString *)urlStr fileData:(NSData *)fileData success:(void(^)(id rspObject))success failure:(void(^)(NSError *error))failure {
    
    // URL编码
    NSString *urlString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    request.timeoutInterval = 30;
    request.HTTPMethod = @"POST";
    
    if (fileData != nil) {
        
        [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)fileData.length] forHTTPHeaderField:@"Content-Length"];
        
    } else {
        // 请求错误，无参数
        return;
    }
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                          delegate:self
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    
    self.uploadTask = [session uploadTaskWithRequest:request fromData:fileData];
    [self.uploadTask resume];
}


/**
 上传文件，流方式

 @param urlStr 请求Url
 @param filePath 文件路径
 @param success 请求成功响应
 @param failure 请求失败响应
 */
- (void)uploadWithUrl:(NSString *)urlStr filePath:(NSString *)filePath success:(void(^)(id rspObject))success failure:(void(^)(NSError *error))failure {
    
    // URL编码
    NSString *urlString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    request.timeoutInterval = 30;
    request.HTTPMethod = @"POST";
    
    if (filePath != nil) {
        NSFileManager *manage = [NSFileManager defaultManager];
        if ([manage fileExistsAtPath:filePath]) {
            // 流方式 >>> 上传文件, 节省内存, 请求头设置大小和类型
            NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
            //    NSLog(@"%@", fileUrl.pathExtension); // .zip
            request.HTTPBodyStream = [NSInputStream inputStreamWithFileAtPath:fileUrl.path];
            [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
            NSString *contentSizeStr = [NSString stringWithFormat:@"%lld", [self fileSizeAtPath:fileUrl.path]];
            [request setValue:contentSizeStr forHTTPHeaderField:@"Content-Length"];
        } else {
            // 请求错误，无参数
        }
        
    } else {
        // 请求错误，无参数
        return ;
    }
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                          delegate:self
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    
    self.uploadTask = [session uploadTaskWithStreamedRequest:request];
    [self.uploadTask resume];
}

- (void)uploadWithUrl1:(NSString *)urlStr filePath:(NSString *)filePath success:(BlockRsp)success failure:(BlockErr)failure {
    
    // URL编码
    NSString *urlString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    request.timeoutInterval = 30;
    request.HTTPMethod = @"POST";
    
    if (filePath != nil) {
        NSFileManager *manage = [NSFileManager defaultManager];
        if ([manage fileExistsAtPath:filePath]) {
            // 流方式 >>> 上传文件, 节省内存, 请求头设置大小和类型
            NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
            //    NSLog(@"%@", fileUrl.pathExtension); // .zip
            request.HTTPBodyStream = [NSInputStream inputStreamWithFileAtPath:fileUrl.path];
            [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
            NSString *contentSizeStr = [NSString stringWithFormat:@"%lld", [self fileSizeAtPath:fileUrl.path]];
            [request setValue:contentSizeStr forHTTPHeaderField:@"Content-Length"];
        } else {
            // 请求错误，无参数
        }
        
    } else {
        // 请求错误，无参数
        return ;
    }
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                          delegate:self
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    
    // 把block加到数组里, 应该加载到字典里，更好查找
    [self.blockRspArray addObject:success];
    [self.blockErrArray addObject:failure];
    
    self.uploadTask = [session uploadTaskWithStreamedRequest:request];
    [self.uploadTask resume];
}

// 获取单个文件大小
- (long long)fileSizeAtPath:(NSString *)filePath {
    
    NSFileManager *manage = [NSFileManager defaultManager];
    if ([manage fileExistsAtPath:filePath]) {
        return [[manage attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}


#pragma mark - session delegate
#define IOSCachesDir [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

/*
 2.下载完成
 downloadTask:里面包含请求信息，以及响应信息
 location：下载后自动帮我保存的地址
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    
    NSLog(@"临时存储的路径 %@", location.absoluteString);
    
    NSString *documentsPath = IOSCachesDir;
    NSString *audioPath = [documentsPath stringByAppendingPathComponent:@"MoonLogs.zip"];
    NSURL *audiUrl = [NSURL fileURLWithPath:audioPath];
    
    // 移动图片的存储地址
    NSFileManager *manage = [NSFileManager defaultManager];
    NSError *error = nil;
    [manage moveItemAtURL:location toURL:audiUrl error:&error];
    if (error == nil) {
        NSLog(@"文件下载完成路径 %@", audiUrl.absoluteString);
    } else {
        NSLog(@"文件下载失败 %@", error);
    }
}

// 下载进度
/*
 1.接收到服务器返回的数据
 bytesWritten: 当前这一次写入的数据大小
 totalBytesWritten: 已经写入到本地文件的总大小
 totalBytesExpectedToWrite : 被下载文件的总大小
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    float progress = 1.0 * totalBytesWritten / totalBytesExpectedToWrite;
    int progressInt = progress * 100;
    NSLog(@"下载进度 %d%%", progressInt);
}

// 断点续传
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes {
    
}

/*
 3.请求完毕
 如果有错误, 那么error有值
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    if (error != nil) {
        NSLog(@"请求错误 %@", error);
    } else {
        NSLog(@"请求成功 %@", error);
    }
    
}


#pragma mark - NSURLSessionTaskDelegate
/**
 * 获取上传的进度信息，可以帮组我们合理的实现进度条
 * @param bytesSent 每秒上传多少数据
 * @param totalBytesSent 已经上传了多少数据
 * @param totalBytesExpectedToSend 需要上传数据的总共的大小
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    
    float progress = 1.0 * totalBytesSent / totalBytesExpectedToSend;
    int progressInt = progress * 100;
    NSLog(@"上传进度 %d%%", progressInt);
}


#pragma mark 数组懒加载
- (NSMutableArray *)blockRspArray {
    if (!_blockRspArray) {
        _blockRspArray = [[NSMutableArray alloc] init];
    }
    return _blockRspArray;
}

- (NSMutableArray *)blockErrArray {
    if (!_blockErrArray) {
        _blockErrArray = [[NSMutableArray alloc] init];
    }
    return _blockErrArray;
}

@end
