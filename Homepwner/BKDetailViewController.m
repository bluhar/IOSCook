//
//  BKDetailViewController.m
//  Homepwner
//
//  Created by vivi 卫 on 15-7-31.
//  Copyright (c) 2015年 Colin. All rights reserved.
//

#import "BKDetailViewController.h"
#import "BKItem.h"

@interface BKDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation BKDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    BKItem *item = self.item;
    
    self.nameField.text = item.itemName;
    self.serialField.text = item.serialNumber;
    self.valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
    static NSDateFormatter *dateFormatter = nil;
    if(!dateFormatter){
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    self.dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];
}

// 在视图要消失前，更新BKItem
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
   
    [self.view endEditing:YES];
    
    BKItem *item = self.item;
    item.itemName = self.nameField.text;
    item.serialNumber = self.serialField.text;
    item.valueInDollars = [self.valueField.text intValue];
}

- (void)setItem:(BKItem *)item{
    _item = item;
    self.navigationItem.title = _item.itemName;
}

@end
