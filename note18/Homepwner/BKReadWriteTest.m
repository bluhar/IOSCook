//
//  BKReadWriteTest.m
//  Homepwner
//
//  Created by vivi 卫 on 15-8-22.
//  Copyright (c) 2015年 Colin. All rights reserved.
//

#import "BKReadWriteTest.h"

@implementation BKReadWriteTest

- (void)test{
    NSError *err;
    
    NSString *someString = @"Text Data";
    BOOL success = [someString writeToFile:@"/some/path/file" atomically:YES encoding:NSUTF8StringEncoding error:&err];
    
    if (success) {
        NSLog(@"Error writing file: %@", [err localizedDescription]);
    }
    
    NSString *myEssay = [[NSString alloc] initWithContentsOfFile:@"/some/path/file" encoding:NSUTF8StringEncoding error:&err];
    
    if (!myEssay) {
        NSLog(@"Error reading file %@", [err localizedDescription]);
    }
    
    UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Error" message:[err localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [a show];
}

@end
