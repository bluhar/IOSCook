//
//  BKHypnosisViewController.m
//  HypoNerd
//
//  Created by vivi 卫 on 15-7-9.
//  Copyright (c) 2015年 Colin. All rights reserved.
//

#import "BKHypnosisViewController.h"
#import "BKHypnosisView.h"

@implementation BKHypnosisViewController

// loadView方法为ViewController创建视图
- (void)loadView{
    // 创建自定义的视图
    BKHypnosisView *backgroundView = [[BKHypnosisView alloc] init];
    // 设置ViewController's view property
    self.view = backgroundView;
}

@end
