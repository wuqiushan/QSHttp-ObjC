
![image](https://github.com/SimonGitHub123/QSHttp-OC/blob/master/QSHttp-OC.png)

[![Build Status](https://travis-ci.org/shuzheng/zheng.svg?branch=master)](https://github.com/SimonGitHub123/QSHttp-OC)  [![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE) [![language](https://img.shields.io/badge/language-objective--c-green.svg)](1) [![language](https://img.shields.io/badge/support-cocoapods-269539.svg)](1)

### 概述
为简化后期的手机客户端与服务器调试，特此对各个环境进行了封装，本仓库为Objective-C版本，安卓仓库传送门、服务器仓库传送门。


### 特点
* 采用多线程异步请求机制
* 支持请求的URL带有中文


### 进度
* [x] 完成基本的GET、POST、上传、下载、等操作
* [x] 完成delegate向block的转换
* [x] 完成上传、下载的实时进度
* [ ] 支持无网通知


### 安装方法
使用cocopods:
```ruby
pod 'QSHttp-OC', '~> 1.0.1'
```

### 使用方法

GET方法示例：
```Objective-C
- (void)get_http {
    QSHttpManage *mange = [[QSHttpManage alloc] init];
    [mange GET:@"http://localhost:8080/javaOne_war_exploded/天气jahttp" param:nil success:^(id  _Nonnull rspObject) {
        NSLog(@"响应数据  %@", rspObject);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"失败 %@", error);
    }];
}
```

POST方法示例：
```Objective-C
- (void)get_http {
    QSHttpManage *mange = [[QSHttpManage alloc] init];
    [mange POST:@"http://localhost:8080/javaOne_war_exploded/天气jahttp" param:nil success:^(id  _Nonnull rspObject) {
        NSLog(@"响应数据  %@", rspObject);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"失败 %@", error);
    }];
}
```

download下载文件示例：
```Objective-C
- (void)get_http {
    QSHttpManage *mange = [[QSHttpManage alloc] init];
    [mange download:@"http://localhost:8080/javaOne_war_exploded/QSDownloadServlet" param:nil storagePath:@"/Users/yyd-wlf/Desktop" progress:^(float progress) {
        
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
- (void)get_http {
    QSHttpManage *mange = [[QSHttpManage alloc] init];
    NSData *data = [NSData dataWithContentsOfFile:@"/Users/yyd-wlf/Desktop/javaLearn.zip"];
    [mange upload:@"http://localhost:8080/javaOne_war_exploded/QSUploadServlet" fileData:data progress:^(float progress) {
        
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
- (void)get_http {
    QSHttpManage *mange = [[QSHttpManage alloc] init];
    [self upload:@"http://localhost:8080/javaOne_war_exploded/QSUploadServlet" filePath:@"/Users/yyd-wlf/Desktop/123.zip" progress:^(float progress) {
        
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
