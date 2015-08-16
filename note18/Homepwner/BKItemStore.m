//
//  BKItemStore.m
//  Homepwner
//
//  Created by vivi 卫 on 15-7-26.
//  Copyright (c) 2015年 Colin. All rights reserved.
//

#import "BKItemStore.h"
#import "BKItem.h"
#import "BKImageStore.h"

@interface BKItemStore ()

@property (nonatomic) NSMutableArray *privateItems;

@end

@implementation BKItemStore

// 类方法，获得单例类的实例
+ (instancetype)sharedStore{
    // 静态变量：当方法执行完后，不会被销毁
    static BKItemStore *sharedStore = nil;
    
    if(!sharedStore){
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
}

- (instancetype)init{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[BKItemStore sharedStore]" userInfo:nil];
    return nil;
}

// 指定初始化方法
- (instancetype)initPrivate{
    self = [super init];
    if(self){
        
        // Unarchive data
        NSString *path = [self itemArchivePath];
        _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (!_privateItems) {
            _privateItems = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (BKItem *)createItem{
    BKItem *item = [BKItem randomItem];
    //BKItem *item = [[BKItem alloc] init];
    
    [self.privateItems addObject:item];
    
    return item;
}

- (void)removeItem:(BKItem *)item{
    // 删除对应的图片
    NSString *key = item.itemKey;
    [[BKImageStore sharedStore] deleteImageForKey:key];
    
    //[self.privateItems removeObject:item];
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex{
    if (fromIndex == toIndex) {
        return;
    }
    BKItem *item = self.privateItems[fromIndex];
    
    [self.privateItems removeObjectAtIndex:fromIndex];
    
    [self.privateItems insertObject:item atIndex:toIndex];
}

// The compiler only auto-synthesizes an instance variable if you let it synthesize at least one accessor.
// 由于allItems是readonly，而此处我们又重写了其get方法，所以编译器不会帮我们创建实例变量
- (NSArray *)allItems{
    return self.privateItems;
}

// 返回application sandbox的Document目录
- (NSString *)itemArchivePath{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

- (BOOL)saveChanges{
    NSString *path = [self itemArchivePath];
    
    // 1. 创建NSKeyedArchiver实例对象；
    // 2. 调用privateItems对象(NSMutableArray)的encodeWithCoder:方法，形参是NSKeyedArchiver实例；
    // 3. 数组向其内部的每个BKItem对象，发送encodeWithCoder:消息，形参是同样的NSKeyedArchiver实例；
    // 4. NSKeyedArchiver写数据到指定路径上
    return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:path];
}

@end
