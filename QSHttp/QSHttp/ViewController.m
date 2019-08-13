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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
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
    NSData *data = [NSData dataWithContentsOfFile:@"/Users/yyd-wlf/Desktop/javaLearn.zip"];
    [mange uploadWithUrl:@"http://localhost:8080/javaOne_war_exploded/QSUploadServlet" fileData:data success:^(id  _Nonnull rspObject) {
        NSLog(@"响应数据  %@", rspObject);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"失败 %@", error);
    }];
}


@end
