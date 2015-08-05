//
//  BKReminderViewController.m
//  HypoNerd
//
//  Created by vivi 卫 on 15-7-9.
//  Copyright (c) 2015年 Colin. All rights reserved.
//

#import "BKReminderViewController.h"

@interface BKReminderViewController()

@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;

@end

@implementation BKReminderViewController

- (IBAction)addReminder:(id)sender{
    NSDate *date = self.datePicker.date;
    NSLog(@"Setting a reminder for %@", date);
}

@end
