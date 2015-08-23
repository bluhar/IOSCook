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

//- (NSString *)imagePathForKey:(NSString *)key;

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
        
        // 将BKImageStore注册了内存过低notification的observer
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(clearCache:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)clearCache:(NSNotification *)note{
    NSLog(@"flushing %d images out of the cache", [self.dictionary count]);
    [self.dictionary removeAllObjects];
}

// 设置指定KEY的对象
- (void)setImage:(UIImage *)image forKey:(NSString *)key{
    //[self.dictionary setObject:image forKey:key];
    self.dictionary[key] = image;

    // 保存图片到文件系统
    NSString *imagePath = [self imagePathForKey:key];
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    [data writeToFile:imagePath atomically:YES];
}

// 获取指定KEY的对象
- (UIImage *)imageForKey:(NSString *)key{
    //return [self.dictionary objectForKey:key];
    //return self.dictionary[key];
    
    UIImage *result = self.dictionary[key];
    if (!result) {
        NSString *imagePath = [self imagePathForKey:key];
        
        // Create UIImage object from file
        result = [UIImage imageWithContentsOfFile:imagePath];
        
        if (result) {
            self.dictionary[key] = result;
        } else {
            NSLog(@"Error: unable to find %@", [self imagePathForKey:key]);
        }
    }
    return result;
}

// 删除指定KEY的对象
- (void)deleteImageForKey:(NSString *)key{
    if (!key) {
        return;
    }
    [self.dictionary removeObjectForKey:key];
    
    // 删除文件系统上的图片
    NSString *imagePath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
}

// 根据指定的key, 返回图片的保存路径
- (NSString *)imagePathForKey:(NSString *)key{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:key];
}

@end
