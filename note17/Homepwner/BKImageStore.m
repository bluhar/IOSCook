//
//  BKImageStore.m
//  Homepwner
//
//  Created by vivi 卫 on 15-8-2.
//  Copyright (c) 2015年 Colin. All rights reserved.
//

#import "BKImageStore.h"

@interface BKImageStore()

@property (nonatomic, strong) NSMutableDictionary *dictionary;

@end

@implementation BKImageStore

// 静态方法，调用此该来获取单例实例
+ (instancetype)sharedStore{
    static BKImageStore *sharedStore = nil;
//    if(!sharedStore){
//        sharedStore = [[self alloc] initPrivate];
//    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

// 如果调用此方法直接抛出错误
- (instancetype)init{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[BKImageStore sharedStore]" userInfo:nil];
    return nil;
}

// 私有的初始化方法
- (instancetype)initPrivate{
    self = [super init];
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

// 设置指定KEY的对象
- (void)setImage:(UIImage *)image forKey:(NSString *)key{
    //[self.dictionary setObject:image forKey:key];
    self.dictionary[key] = image;
}

// 获取指定KEY的对象
- (UIImage *)imageForKey:(NSString *)key{
    //return [self.dictionary objectForKey:key];
    return self.dictionary[key];
}

// 删除指定KEY的对象
- (void)deleteImageForKey:(NSString *)key{
    if (!key) {
        return;
    }
    [self.dictionary removeObjectForKey:key];
}

@end
