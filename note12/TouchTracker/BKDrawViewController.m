//
//  BKDrawViewController.m
//  TouchTracker
//
//  Created by vivi 卫 on 15-8-3.
//  Copyright (c) 2015年 bk. All rights reserved.
//

#import "BKDrawViewController.h"
#import "BKDrawView.h"

@implementation BKDrawViewController

- (void)loadView{
    self.view = [[BKDrawView alloc] initWithFrame:CGRectZero];
}

@end
