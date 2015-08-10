//
//  BKDetailViewController.m
//  Homepwner
//
//  Created by vivi 卫 on 15-7-31.
//  Copyright (c) 2015年 Colin. All rights reserved.
//

#import "BKDetailViewController.h"
#import "BKItem.h"
#import "BKImageStore.h"

@interface BKDetailViewController () <UINavigationBarDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation BKDetailViewController

// 当点击return键 隐藏键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"Enter textFieldShouldReturn method;");

    [textField resignFirstResponder];
    return YES;
    NSLog(@"Exit textFieldShouldReturn method;");

}

- (IBAction)backgroundTapped:(id)sender {
    NSLog(@"Enter backgroundTapped method;");
    // 隐藏键盘
    [self.view endEditing:YES];
    NSLog(@"Exit backgroundTapped method;");

}




- (IBAction)takePicture:(id)sender {
    NSLog(@"Enter takePicture method");
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // 判断设备是否支持相机拍摄
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    // 设置代理
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
    NSLog(@"Exit takePicture method");
}

// image picker选中图片后，其代理收到此消息
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    // 获得图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // 保存图片到dictionary
    [[BKImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    
    self.imageView.image = image;
    
    // 移除image picker
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:nil];
    
    iv.contentMode = UIViewContentModeScaleAspectFit;
    
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:iv];
    
    self.imageView = iv;
    
    // 创建水平和垂直方向约束
    NSDictionary *nameMap = @{@"imageView": self.imageView,
                              @"dateLabel": self.dateLabel,
                              @"toolbar": self.toolbar};
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|" options:0 metrics:nil views:nameMap];
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel]-[imageView]-[toolbar]" options:0 metrics:nil views:nameMap];
}



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
    
    // 根据BKItem中的key查找图片
    NSString *imageKey = self.item.itemKey;
    UIImage *imageToDisplay = [[BKImageStore sharedStore] imageForKey:imageKey];
    // 当imageToDisplay为nil，UIImageView不会显示图片
    self.imageView.image = imageToDisplay;
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
