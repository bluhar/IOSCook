//
//  BKItem.h
//  RandomItems
//
//  Created by vivi 卫 on 15-7-6.
//  Copyright (c) 2015年 Colin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BKItem : NSObject
//{
//    NSString *_itemName; //*号说明变量是个指针
//    NSString *_serialNumber;
//    int _valueInDollars;
//    NSDate *_dateCreated;
//    BKItem *_containedItem;
//    BKItem *_container;
//}
+ (instancetype)randomItem;
//- (instancetype)initWithItemName:(NSString *)name valueInDollars:(int) value serialNumber:(NSString *)sNumber;
//- (instancetype)initWithItemName:(NSString *)name;
////在头文件中声明set get方法，像是java中声明接口的抽象方法
//- (void)setItemName:(NSString *)str;
//- (NSString *)itemName;
//- (void)setSerialNumber:(NSString *)str;
//- (NSString *)serialNumber;
//- (void)setValueInDollars:(int)v;
//- (int)valueInDollars;
//- (NSDate *)dateCreated; //只有get方法
//- (void)setContainedItem:(BKItem *)item;
//- (BKItem *)containedItem;
//- (void)setContainer:(BKItem *)item;
//- (BKItem *)container;

// 使用@property来声明实例变量
//@property BKItem *containedItem;
//@property BKItem *container;

@property NSString *itemName;
@property NSString *serialNumber;
@property int valueInDollars;
@property NSDate *dateCreated;
@property (nonatomic, copy) NSString *itemKey;


@end
