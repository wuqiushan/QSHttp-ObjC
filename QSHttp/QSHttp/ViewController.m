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

//@property (nonatomic, strong) QSHttpManage *mange;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    QSHttpManage *mange = [[QSHttpManage alloc] init];
    [mange GET:@"http://www.eechot.ga/server/QSHttp/GET/天气" param:nil success:^(id  _Nonnull rspObject) {
        NSLog(@"响应数据  %@", rspObject);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"失败 %@", error);
    }];
}

- (void)post_http {
    
    QSHttpManage *mange = [[QSHttpManage alloc] init];
    [mange POST:@"http://www.eechot.ga/server/QSHttp/POST" param:nil success:^(id  _Nonnull rspObject) {
        NSLog(@"响应数据  %@", rspObject);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"失败 %@", error);
    }];
}

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
