//
//  ViewController.m
//  QSHttp
//
//  Created by wuqiushan on 2019/8/12.
//  Copyright © 2019 wuqiushan3@163.com. All rights reserved.
//

#import "ViewController.h"
#import "QSHttp/QSHttpManage.h"

@interface ViewController ()

@property (nonatomic, strong) QSHttpManage *mange;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mange = [[QSHttpManage alloc] init];
    [self setupView];
}


- (void)setupView {
    
    UIButton *getButton = [self createButtonWithName:@"GET" x:10 y:100];
    [getButton addTarget:self action:@selector(get_http) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getButton];
    
    UIButton *postButton = [self createButtonWithName:@"POST" x:10 y:150];
    [postButton addTarget:self action:@selector(post_http) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:postButton];
    
    UIButton *downloadButton = [self createButtonWithName:@"download" x:10 y:200];
    [downloadButton addTarget:self action:@selector(download_http) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downloadButton];
    
    UIButton *uploadDataButton = [self createButtonWithName:@"uploadData" x:10 y:250];
    [uploadDataButton addTarget:self action:@selector(uploadData_http) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:uploadDataButton];
    
    UIButton *uploadFileButton = [self createButtonWithName:@"uploadFile" x:10 y:300];
    [uploadFileButton addTarget:self action:@selector(uploadFile_http) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:uploadFileButton];
}


#pragma mark - 按键事件

- (void)get_http {
    
    [self.mange GET:@"http://localhost:8080/javaOne_war_exploded/天气jahttp" param:nil success:^(id  _Nonnull rspObject) {
        NSLog(@"响应数据  %@", rspObject);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"失败 %@", error);
    }];
}

- (void)post_http {
    [self.mange POST:@"http://localhost:8080/javaOne_war_exploded/天气jahttp" param:nil success:^(id  _Nonnull rspObject) {
        NSLog(@"响应数据  %@", rspObject);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"失败 %@", error);
    }];
}

- (void)download_http {
    
    [self.mange downloadWithUrl:@"http://localhost:8080/javaOne_war_exploded/QSDownloadServlet" param:nil storagePath:@"/Users/yyd-wlf/Desktop" progress:^(float progress) {
        
        int progressInt = progress * 100;
        NSLog(@"下载进度 %d%%", progressInt);
        
    } success:^(id  _Nonnull rspObject) {
        NSLog(@"响应数据  %@", rspObject);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"失败 %@", error);
    }];
}

- (void)uploadData_http {
    
    NSData *data = [NSData dataWithContentsOfFile:@"/Users/yyd-wlf/Desktop/javaLearn.zip"];
    [self.mange uploadWithUrl:@"http://localhost:8080/javaOne_war_exploded/QSUploadServlet" fileData:data progress:^(float progress) {
        
        int progressInt = progress * 100;
        NSLog(@"上传进度 %d%%", progressInt);
        
    } success:^(id  _Nonnull rspObject) {
        NSLog(@"响应数据  %@", rspObject);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"失败 %@", error);
    }];
}

- (void)uploadFile_http {
    
    [self.mange uploadWithUrl:@"http://localhost:8080/javaOne_war_exploded/QSUploadServlet" filePath:@"/Users/yyd-wlf/Desktop/123.zip" progress:^(float progress) {
        
        int progressInt = progress * 100;
        NSLog(@"上传进度 %d%%", progressInt);
        
    } success:^(id  _Nonnull rspObject) {
        NSLog(@"响应数据  %@", rspObject);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"失败 %@", error);
    }];
}


- (void)initData {
    
    NSLog(@"ViewController 1 %@", [NSThread currentThread]);
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    dic[@"name"] = @"张三";
    QSHttpManage *mange = [[QSHttpManage alloc] init];
//    [mange GET:@"http://localhost:8080/javaOne_war_exploded/天气jahttp" param:dic success:^(id  _Nonnull rspObject) {
//        NSLog(@"响应数据  %@", rspObject);
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"失败 %@", error);
//    }];
    NSLog(@"ViewController 2 %@", [NSThread currentThread]);
    
//    [mange GET:@"http://localhost:8080/javaOne_war_exploded/QSDownloadServlet" param:dic success:^(id  _Nonnull rspObject) {
//        NSLog(@"响应数据  %@", rspObject);
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"失败 %@", error);
//    }];
    
//    [mange downloadWithUrl:@"http://localhost:8080/javaOne_war_exploded/QSDownloadServlet" param:nil success:^(id  _Nonnull rspObject) {
//        NSLog(@"响应数据  %@", rspObject);
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"失败 %@", error);
//    }];
    
    // 测试文件上传
//    [mange uploadWithUrl:@"http://localhost:8080/javaOne_war_exploded/QSUploadServlet" filePath:@"/Users/yyd-wlf/Desktop/123.zip" success:^(id  _Nonnull rspObject) {
//        NSLog(@"响应数据  %@", rspObject);
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"失败 %@", error);
//    }];
    
    // 测试数据上传
//    NSData *data = [NSData dataWithContentsOfFile:@"/Users/yyd-wlf/Desktop/javaLearn.zip"];
//    [mange uploadWithUrl:@"http://localhost:8080/javaOne_war_exploded/QSUploadServlet" fileData:data success:^(id  _Nonnull rspObject) {
//        NSLog(@"响应数据  %@", rspObject);
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"失败 %@", error);
//    }];
    
//    [mange uploadWithUrl1:@"http://localhost:8080/javaOne_war_exploded/QSUploadServlet" filePath:@"/Users/yyd-wlf/Desktop/123.zip" success:^(id  _Nonnull rspObject) {
//        NSLog(@"响应数据  %@", rspObject);
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"失败 %@", error);
//    }];
    
//    [mange uploadWithUrl:@"http://localhost:8080/javaOne_war_exploded/QSUploadServlet" filePath:nil progress:^(float progress) {
//
//        int progressInt = progress * 100;
//        NSLog(@"上传进度 %d%%", progressInt);
//
//    } success:^(id  _Nonnull rspObject) {
//        NSLog(@"响应数据  %@", rspObject);
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"失败 %@", error);
//    }];
}


// 创建一个Button按钮
- (UIButton *)createButtonWithName:(NSString *)name x:(CGFloat)x y:(CGFloat)y {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(x, y, 100, 40);
    button.contentMode = UIViewContentModeCenter;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button setTitle:name forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 3.0f;
    button.backgroundColor = [UIColor blackColor];
    return button;
}

@end
