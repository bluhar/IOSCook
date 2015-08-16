//
//  BKDetailViewController.h
//  Homepwner
//
//  Created by vivi 卫 on 15-7-31.
//  Copyright (c) 2015年 Colin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BKItem;

@interface BKDetailViewController : UIViewController

// 声明指定初始化文法
- (instancetype)initForNewItem:(BOOL)isNew;

@property (nonatomic,strong) BKItem *item;

@property (nonatomic, copy) void (^dismissBlock)(void);

@end
