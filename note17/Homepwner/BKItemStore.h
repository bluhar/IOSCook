//
//  BKItemStore.h
//  Homepwner
//
//  Created by vivi 卫 on 15-7-26.
//  Copyright (c) 2015年 Colin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BKItem;

@interface BKItemStore : NSObject

@property (nonatomic, readonly) NSArray *allItems;

// class method
+ (instancetype)sharedStore;

- (BKItem *)createItem;
- (void)removeItem:(BKItem *)item;
- (void)moveItemAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;


@end
