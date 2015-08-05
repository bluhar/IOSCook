//
//  BKHypnosisView.m
//  Hypnosister
//
//  Created by vivi 卫 on 15-7-8.
//  Copyright (c) 2015年 Colin. All rights reserved.
//

#import "BKHypnosisView.h"

@interface BKHypnosisView()

@property (nonatomic, strong) UIColor *circleColor;

@end

@implementation BKHypnosisView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.circleColor = [UIColor lightGrayColor];
    }
    return self;
}

// 执行自定义的绘制动作
- (void)drawRect:(CGRect)rect
{
    // 找到屏幕中心，self是当前view，由于当前view设置了全屏，可以直接用当前view的bounds
    CGRect bounds = self.bounds;
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2;
    center.y = bounds.origin.y + bounds.size.height / 2;
    
    // 屏幕宽或高的最小值的一半
//    float maxRadius = MIN(bounds.size.width, bounds.size.height) / 2;
    // 屏幕对角线长度的一半
    float maxRadius = hypot(bounds.size.width, bounds.size.height) / 2;

    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    for (float currentRadius=maxRadius; currentRadius>0; currentRadius-=20) {
        // 移动画笔
        [path moveToPoint:CGPointMake(center.x + currentRadius, center.y)];
        // 画圆
        [path addArcWithCenter:center
                        radius:currentRadius
                    startAngle:0.0
                      endAngle:M_PI * 2.0
                     clockwise:YES];
    }
    
    // 设置画笔的宽度
    path.lineWidth=10;
    // 设置pen的颜色
    //[[UIColor purpleColor] setStroke];
    [self.circleColor setStroke];
    // 开始绘图
    [path stroke];
    
    CGRect logoFrame = CGRectMake(center.x/2, center.y/2, bounds.size.width/2, bounds.size.height/2);
    UIImage *logoImage = [UIImage imageNamed:@"logo.png"];
    // 将图片绘制到指定位置
    [logoImage drawInRect:logoFrame];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"%@ was touched", self);
    
    NSLog(@"%d", arc4random());
    
    float red = (arc4random() % 100) / 100;
    float green = (arc4random() % 100) / 100;
    float blue = (arc4random() % 100) / 100;
    
    UIColor *randomColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    self.circleColor = randomColor;
}

- (void)setCircleColor:(UIColor *)circleColor{
    _circleColor = circleColor;
    // 当一个视图需要重绘时，调用setNeedsDisplay方法
    [self setNeedsDisplay];
}

@end
