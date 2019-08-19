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
 5.使用了block后代理后面用不了
 */

#import "QSHttpManage.h"

@interface QSHttpManage()<NSURLSessionDownloadDelegate>

/**
 目的：把离散的代理事件整合成block方式返回
 这里字典相当一个"队列"，存储正在执行的所有任务返回的block
 以下字典用来存储 block 使用 key:@(self.uploadTask.taskIdentifier)  value:block
 用两个字典，是因为字典的key是唯一，而每一次请求返回两种结果（失败和成功）
 **/
@property (nonatomic, strong) NSMutableDictionary *blockRspDic; // 存放所有success的block
@property (nonatomic, strong) NSMutableDictionary *blockErrDic; // 存放所有error的block
@property (nonatomic, strong) NSMutableDictionary *blockProgressDic; // 存放进度的block
@property (nonatomic, strong) NSMutableDictionary *downloadPathDic;     // 存放下载地址

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
- (void)GET:(NSString *)urlStr param:(NSDictionary *)param success:(BlockRsp)success failure:(BlockErr)failure {
    [self method:@"GET" url:urlStr param:param success:success failure:failure];
}


/**
 POST方法去请求

 @param urlStr 请求Url
 @param param 请求参数
 @param success 请求成功响应
 @param failure 请求失败响应
 */
- (void)POST:(NSString *)urlStr param:(NSDictionary *)param success:(BlockRsp)success failure:(BlockErr)failure {
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
- (void)method:(NSString *)method url:(NSString *)urlStr param:(NSDictionary *)param success:(BlockRsp)success failure:(BlockErr)failure {
    
    // URL编码
    NSString *urlString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString: urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    request.timeoutInterval = 30;
    request.HTTPMethod = method;
    
    // 设备请求参数
    if (param) {
        NSError *paramError = nil;
        NSData *paramData = [NSJSONSerialization dataWithJSONObject:param
                                                            options:NSJSONWritingPrettyPrinted
                                                              error:&paramError];
        if (paramError == nil) {
            request.HTTPBody = paramData;
        }
        else {
            NSDictionary *errorDic = @{NSLocalizedDescriptionKey: @"请求参数格式错误"};
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:100 userInfo:errorDic];
            failure(error);
            return ;
        }
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@", [NSThread currentThread]);
        if (data && (error == nil)) {
            NSError *dataError = nil;
            id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&dataError];
            if (dataError != nil) {
                NSLog(@"响应数据解析失败 %@", dataError);
                success(data);
            }
            if (success) {
                success(result);
            }
        } else if (failure) {
            failure(error);
        }
    }];
    
    [task resume];
}


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
               progress:(BlockProgress)progress success:(BlockRsp)success failure:(BlockErr)failure {
    
    // URL编码
    NSString *urlString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    request.timeoutInterval = 30;
    request.HTTPMethod = @"GET";
    
    // 设备请求参数
    if (param) {
        NSError *paramError = nil;
        NSData *paramData = [NSJSONSerialization dataWithJSONObject:param
                                                            options:NSJSONWritingPrettyPrinted
                                                              error:&paramError];
        if (paramError == nil) {
            request.HTTPBody = paramData;
        }
        else {
            NSDictionary *errorDic = @{NSLocalizedDescriptionKey: @"请求参数格式错误"};
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:100 userInfo:errorDic];
            failure(error);
            return ;
        }
    }
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
    
    // 把block加到字典里，通过 task.taskIdentifier 来查找
    [self.blockProgressDic setObject:progress forKey:@(task.taskIdentifier)];
    [self.blockRspDic setObject:success forKey:@(task.taskIdentifier)];
    [self.blockErrDic setObject:failure forKey:@(task.taskIdentifier)];
    [self.downloadPathDic setObject:(storagePath != nil ? storagePath : @"") forKey:@(task.taskIdentifier)];
    
    [task resume];
}


/**
 上传数据，如：单个图片、语音等数据量比较小的，大文件请通过本类的文件上传方法

 @param urlStr 请求Url
 @param fileData 需要上传的数据
 @param progress 上传进度(0.0 - 1.0)
 @param success 请求成功响应
 @param failure 请求失败响应
 */
- (void)upload:(NSString *)urlStr fileData:(NSData *)fileData progress:(BlockProgress)progress success:(BlockRsp)success failure:(BlockErr)failure {
    
    // URL编码
    NSString *urlString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    request.timeoutInterval = 30;
    request.HTTPMethod = @"POST";
    
    if (fileData) {
        [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)fileData.length] forHTTPHeaderField:@"Content-Length"];
    } else {
        // 请求错误，无数据
        NSDictionary *errorDic = @{NSLocalizedDescriptionKey: @"上传数据为空"};
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:100 userInfo:errorDic];
        failure(error);
        return ;
    }
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                          delegate:self
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionUploadTask *task = [session uploadTaskWithRequest:request fromData:fileData];
    
    // 把block加到字典里，通过 task.taskIdentifier 来查找
    [self.blockProgressDic setObject:progress forKey:@(task.taskIdentifier)];
    [self.blockRspDic setObject:success forKey:@(task.taskIdentifier)];
    [self.blockErrDic setObject:failure forKey:@(task.taskIdentifier)];
    
    [task resume];
}

/**
 上传文件，流方式
 
 @param urlStr 请求Url
 @param filePath 文件路径
 @param progress 上传进度(0.0 - 1.0)
 @param success 请求成功响应
 @param failure 请求失败响应
 */
- (void)upload:(NSString *)urlStr filePath:(NSString *)filePath progress:(BlockProgress)progress success:(BlockRsp)success failure:(BlockErr)failure {
    
    // URL编码
    NSString *urlString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    request.timeoutInterval = 30;
    request.HTTPMethod = @"POST";
    
    if (filePath) {
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
            // 请求错误，路径不存在
            NSDictionary *errorDic = @{NSLocalizedDescriptionKey: @"路径不存在"};
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:100 userInfo:errorDic];
            failure(error);
            return ;
        }
        
    } else {
        // 请求错误，路径为空
        NSDictionary *errorDic = @{NSLocalizedDescriptionKey: @"路径不能为空"};
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:100 userInfo:errorDic];
        failure(error);
        return ;
    }
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                          delegate:self
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionUploadTask *task = [session uploadTaskWithStreamedRequest:request];
    // 把block加到字典里，通过 task.taskIdentifier 来查找
    [self.blockProgressDic setObject:progress forKey:@(task.taskIdentifier)];
    [self.blockRspDic setObject:success forKey:@(task.taskIdentifier)];
    [self.blockErrDic setObject:failure forKey:@(task.taskIdentifier)];
    [task resume];
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

/*
 2.下载完成
 downloadTask:里面包含请求信息，以及响应信息
 location：下载后自动帮我保存的地址
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    
    NSFileManager *manage = [NSFileManager defaultManager];
    
    // 获取目的路径, 如果为空或者路径不存在时使用默认路径
    NSString *storagePath = [self.downloadPathDic objectForKey:@(downloadTask.taskIdentifier)];
    if (storagePath == nil) {
        storagePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    } else {
        if (![manage fileExistsAtPath:storagePath]) {
            storagePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        }
    }
    NSString *allPath = [storagePath stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    
    // 把临时路径里的文件 移动到 目标路径
    NSError *error = nil;
    [manage moveItemAtURL:location toURL:[NSURL fileURLWithPath:allPath] error:&error];
    if (error) {
        NSLog(@"文件下载失败 %@", error);
    } else {
        NSLog(@"文件下载完成路径 %@", allPath);
    }
    
    // 完成后把目的路径从字典中移除
    [self.downloadPathDic removeObjectForKey:@(downloadTask.taskIdentifier)];
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
    // 获取进度的 block 同时传值
    BlockProgress progressBlock = (BlockProgress)[self.blockProgressDic objectForKey:@(downloadTask.taskIdentifier)];
    if (progressBlock) {
        progressBlock(progress);
    }
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
    
    // 获取成功的 block 同时传值
    BlockRsp success = (BlockRsp)[self.blockRspDic objectForKey:@(task.taskIdentifier)];
    BlockErr failure = (BlockErr)[self.blockErrDic objectForKey:@(task.taskIdentifier)];
    BlockProgress progress = (BlockProgress)[self.blockProgressDic objectForKey:@(task.taskIdentifier)];
    
    if ((error == nil) && (success)) {
        success(@"请求成功");
    }
    else if (failure) {
        failure(error);
    }
    
    // 请求完后任务结束，要把所有有关的block释放掉
    if (success) {
        [self.blockRspDic removeObjectForKey:@(task.taskIdentifier)];
        success = nil;
    }
    if (failure) {
        [self.blockErrDic removeObjectForKey:@(task.taskIdentifier)];
        failure = nil;
    }
    if (progress) {
        [self.blockProgressDic removeObjectForKey:@(task.taskIdentifier)];
        progress = nil;
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
    // 获取进度的 block 同时传值
    BlockProgress progressBlock = (BlockProgress)[self.blockProgressDic objectForKey:@(task.taskIdentifier)];
    if (progressBlock) {
        progressBlock(progress);
    }
}


#pragma mark 数组懒加载
- (NSMutableDictionary *)blockProgressDic {
    if (!_blockProgressDic) {
        _blockProgressDic = [[NSMutableDictionary alloc] init];
    }
    return _blockProgressDic;
}

- (NSMutableDictionary *)blockRspDic {
    if (!_blockRspDic) {
        _blockRspDic = [[NSMutableDictionary alloc] init];
    }
    return _blockRspDic;
}

- (NSMutableDictionary *)blockErrDic {
    if (!_blockErrDic) {
        _blockErrDic = [[NSMutableDictionary alloc] init];
    }
    return _blockErrDic;
}

- (NSMutableDictionary *)downloadPathDic {
    if (!_downloadPathDic) {
        _downloadPathDic = [[NSMutableDictionary alloc] init];
    }
    return _downloadPathDic;
}

@end
