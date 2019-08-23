![image](https://github.com/SimonGitHub123/QSHttp-OC/blob/master/QSHttp-OC.png)

[![Build Status](https://travis-ci.org/shuzheng/zheng.svg?branch=master)](https://github.com/SimonGitHub123/QSHttp-OC)  [![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE) [![language](https://img.shields.io/badge/language-objective--c-green.svg)](1) [![language](https://img.shields.io/badge/support-cocoapods-269539.svg)](1)

### 概述
为简化后期的手机客户端与服务器调试，特此对各个环境进行了封装，本仓库为iOS版本，其它有Java(安卓通用)版本、服务器版本。
* [x] 支持iOS，[传送门](https://github.com/wuqiushan/QSHttp-OC)
* [x] 支持android(java)，[传送门](https://github.com/wuqiushan/QSHttp-Java)
* [x] 支持服务器端，[传送门](https://github.com/wuqiushan/QSHttp-Server)


### 特点
* 采用多线程异步请求机制
* 支持请求的URL带有中文


### 进度
* [x] 完成基本的GET、POST、上传、下载、等操作
* [x] 完成delegate向block的转换
* [x] 完成上传、下载的实时进度
* [ ] 支持无网通知


### 安装方法
使用cocoapods:
```ruby
pod 'QSHttp-OC', '~> 1.1.1'
```

### 使用方法

GET方法示例：
```Objective-C
- (void)get_http {
    
    QSHttpManage *mange = [[QSHttpManage alloc] init];
    [mange GET:@"http://www.eechot.ga/server/QSHttp/GET/天气" param:nil success:^(id  _Nonnull rspObject) {
        NSLog(@"响应数据  %@", rspObject);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"失败 %@", error);
    }];
}
```

POST方法示例：
```Objective-C
- (void)post_http {
    
    QSHttpManage *mange = [[QSHttpManage alloc] init];
    [mange POST:@"http://www.eechot.ga/server/QSHttp/POST" param:nil success:^(id  _Nonnull rspObject) {
        NSLog(@"响应数据  %@", rspObject);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"失败 %@", error);
    }];
}
```

download下载文件示例：
```Objective-C
- (void)download_http {
    
    QSHttpManage *mange = [[QSHttpManage alloc] init];
    [mange download:@"http://www.eechot.ga/server/QSHttp/Download" param:nil storagePath:@"/Users/yyd-wlf/Desktop/QSHttpFile" progress:^(float progress) {
        
        int progressInt = progress * 100;
        NSLog(@"下载进度 %d%%", progressInt);
        
    } success:^(id  _Nonnull rspObject) {
        NSLog(@"响应数据  %@", rspObject);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"失败 %@", error);
    }];
}
```

upload上传数据(NSData)示例：
```Objective-C
- (void)uploadData_http {
    
    QSHttpManage *mange = [[QSHttpManage alloc] init];
    NSData *data = [NSData dataWithContentsOfFile:@"/Users/yyd-wlf/Desktop/QSHttpFile/nginx-1.16.0.tar.gz"];
    [mange upload:@"http://www.eechot.ga/server/QSHttp/Upload" fileData:data progress:^(float progress) {
        
        int progressInt = progress * 100;
        NSLog(@"上传进度 %d%%", progressInt);
        
    } success:^(id  _Nonnull rspObject) {
        NSLog(@"响应数据  %@", rspObject);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"失败 %@", error);
    }];
}
```

upload上传文件示例：
```Objective-C
- (void)uploadFile_http {
    
    QSHttpManage *mange = [[QSHttpManage alloc] init];
    [mange upload:@"http://www.eechot.ga/server/QSHttp/Upload" filePath:@"/Users/yyd-wlf/Desktop/QSHttpFile/nginx-1.16.0.tar.gz" progress:^(float progress) {
        
        int progressInt = progress * 100;
        NSLog(@"上传进度 %d%%", progressInt);
        
    } success:^(id  _Nonnull rspObject) {
        NSLog(@"响应数据  %@", rspObject);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"失败 %@", error);
    }];
}
```

### 许可证
所有源代码均根据MIT许可证进行许可。