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

@interface BKDetailViewController () <UINavigationBarDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate, UIPopoverControllerDelegate>
@property (strong, nonatomic) UIPopoverController *imagePickerPopover;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;

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
    
    if ([self.imagePickerPopover isPopoverVisible]) {
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // 判断设备是否支持相机拍摄
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    // 设置代理
    imagePicker.delegate = self;
    
    
    // 通过popover controller显示image picker controller
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        // 创建popover controller
        self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        self.imagePickerPopover.delegate = self;
        
        [self.imagePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
    } else {
        // 如果不是ipad设备，直接显示
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
    NSLog(@"Exit takePicture method");
}

// image picker选中图片后，其代理收到此消息
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    // 获得图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // 保存图片到dictionary
    [[BKImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    
    self.imageView.image = image;
    

    // 如果image picker是在popover controller中显示的，则调用dismissPopoverAnimated隐藏popover controller
    // 不过通过此方法移除popover controller，popover controller不会再发送popoverControllerDidDismissPopover消息给其代理
    if (self.imagePickerPopover) {
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
    } else {
        // 移除image picker
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

// 当点击屏幕其他地方时，popover controller被移除，此时会发送此消息到其代理
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    NSLog(@"User dismissed popover");
    self.imagePickerPopover = nil;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:nil];
    
    iv.contentMode = UIViewContentModeScaleAspectFit;
    
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:iv];
    
    self.imageView = iv;
    
    [self.imageView setContentHuggingPriority:200 forAxis:UILayoutConstraintAxisVertical];
    [self.imageView setContentCompressionResistancePriority:700 forAxis:UILayoutConstraintAxisVertical];
    
    // 创建水平和垂直方向约束
    NSDictionary *nameMap = @{@"imageView": self.imageView,
                              @"dateLabel": self.dateLabel,
                              @"toolbar": self.toolbar};
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|" options:0 metrics:nil views:nameMap];
    // V:[dateLabel]-[imageView]-[toolbar]
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel]-[imageView]-[toolbar]" options:0 metrics:nil views:nameMap];
    
//    NSLayoutConstraint * aspectConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeHeight multiplier:1.5 constant:0.0];
    
    
    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraints:verticalConstraints];
    
    [self.view layoutIfNeeded];
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIInterfaceOrientation io = [[UIApplication sharedApplication] statusBarOrientation];
    [self prepareViewsForOrientation:io];
    
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

// 当interface orientation成功改变，view controller会调用此方法。
// toInterfaceOrientation参数是新的interface orientation
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self prepareViewsForOrientation:toInterfaceOrientation];
}

//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
//    [self prepareViewsForOrientation:toInterfaceOrientation];
//}

- (void)prepareViewsForOrientation:(UIInterfaceOrientation)orientation{
    // 如果设备是ipad直接返回
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return;
    }
    
    // 如果interface orientation是水平的，则隐藏图片并禁用camera button
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.imageView.hidden = YES;
        self.cameraButton.enabled = NO;
    } else {
        self.imageView.hidden = NO;
        self.cameraButton.enabled = YES;
    }
    [ self interfaceOrientation];
}



//- (NSUInteger)supportedInterfaceOrientations{
//    // 如果设备是iPad，则支持所有orientation
////    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
////        return UIInterfaceOrientationMaskAll;
////    }else{
////        return UIInterfaceOrientationMaskAllButUpsideDown;
////    }
//    
//    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
//}

@end
