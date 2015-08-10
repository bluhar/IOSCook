//
//  BKImageStore.h
//  Homepwner
//
//  Created by vivi 卫 on 15-8-2.
//  Copyright (c) 2015年 Colin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BKImageStore : NSObject

// 静态方法，获得单例
+ (instancetype)sharedStore;

// 实例方法
- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;

@end
