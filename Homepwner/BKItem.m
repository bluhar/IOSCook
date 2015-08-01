//
//  BKItem.m
//  RandomItems
//
//  Created by vivi 卫 on 15-7-6.
//  Copyright (c) 2015年 Colin. All rights reserved.
//

#import "BKItem.h"

@implementation BKItem

+ (instancetype)randomItem
{
    // Create an immutable array of three adjectives
    NSArray *randomAdjectiveList = @[@"Fluffy", @"Rusty", @"Shiny"];
    // Create an immutable array of three nouns
    NSArray *randomNounList = @[@"Bear", @"Spork", @"Mac"];
    // Get the index of a random adjective/noun from the lists
    // Note: The % operator, called the modulo operator, gives
    // you the remainder. So adjectiveIndex is a random number
    // from 0 to 2 inclusive.
    NSInteger adjectiveIndex = arc4random() % [randomAdjectiveList count];
    NSInteger nounIndex = arc4random() % [randomNounList count];
    // Note that NSInteger is not an object, but a type definition
    // for "long"
    NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                            [randomAdjectiveList objectAtIndex:adjectiveIndex],
                            [randomNounList objectAtIndex:nounIndex]];
    int randomValue = arc4random() % 100;
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0' + arc4random() % 10,
                                    'A' + arc4random() % 26,
                                    '0' + arc4random() % 10,
                                    'A' + arc4random() % 26,
                                    '0' + arc4random() % 10];
    BKItem *newItem = [[self alloc] initWithItemName:randomName
                                       valueInDollars:randomValue
                                         serialNumber:randomSerialNumber];
    return newItem;
}

// Designated initializer (指定的构造器，通常是参数最多的那个init方法)
- (instancetype)initWithItemName:(NSString *)name valueInDollars:(int) value serialNumber:(NSString *)sNumber{
    // Call the superclass's designated initializer
    self = [super init];
    // Did the superclass's designated initializer succeed?
    if (self) {
        // Give the instance variables initial values
        _itemName = name;
        _serialNumber = sNumber;
        _valueInDollars = value;
        // Set _dateCreated to the current date and time
        _dateCreated = [[NSDate alloc] init];
    }
    // Return the address of the newly initialized object
    return self;
}
- (instancetype)initWithItemName:(NSString *)name{
    return [self initWithItemName:name
                   valueInDollars:0
                     serialNumber:@""];
}




//- (void)setItemName:(NSString *)str{
//    _itemName = str;
//}
//- (NSString *)itemName
//{
//    return _itemName;
//}
//
//- (void)setSerialNumber:(NSString *)str
//{
//    _serialNumber = str;
//}
//- (NSString *)serialNumber
//{
//    return _serialNumber;
//}
//
//- (void)setValueInDollars:(int)v
//{
//    _valueInDollars = v;
//}
//- (int)valueInDollars
//{
//    return _valueInDollars;
//}
//- (NSDate *)dateCreated
//{
//    return _dateCreated;
//}
//- (NSString *)description
//{
//    NSString *descriptionString =
//    [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, recorded on %@",
//     self.itemName,
//     self.serialNumber,
//     self.valueInDollars,
//     self.dateCreated];
//    return descriptionString;
//}
//- (void)setContainedItem:(BKItem *)item
//{
//    _containedItem = item;
//    // When given an item to contain, the contained
//    // item will be given a pointer to its container
//    item.container = self;
//}
//- (BKItem *)containedItem
//{
//    return _containedItem;
//}
//- (void)setContainer:(BKItem *)item
//{
//    _container = item;
//}
//- (BKItem *)container
//{
//    return _container;
//}

//重写NSObject的dealloc方法，当对象内存被回收时会调用此方法
- (void)dealloc
{
    NSLog(@"Destroyed: %@", self);

}
@end
