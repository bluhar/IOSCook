//
//  BKDrawView.m
//  TouchTracker
//
//  Created by vivi 卫 on 15-8-3.
//  Copyright (c) 2015年 bk. All rights reserved.
//

#import "BKDrawView.h"
#import "BKLine.h"

@interface BKDrawView () <UIGestureRecognizerDelegate>

//@property (nonatomic, strong) BKLine *currentLine;
// 保存当前的多个line
@property (nonatomic, strong) NSMutableDictionary *linesInProgress;
@property (nonatomic, strong) NSMutableArray *finishedLines;

@property (nonatomic, weak) BKLine *selectedLine;
@property (nonatomic, strong) UIPanGestureRecognizer *moveRecognizer;

@end

@implementation BKDrawView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.linesInProgress = [[NSMutableDictionary alloc] init];
        self.finishedLines = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor grayColor];
        // 启用multiple touches
        self.multipleTouchEnabled = YES;
        
        // 创建监听双击的gesture recognizer
        UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTapRecognizer.numberOfTapsRequired = 2;
        // 当touch不再可能被识别为double tap gesture了，再发送touches began
        doubleTapRecognizer.delaysTouchesBegan = YES;
        // 将gesture recognizer关联到view上
        [self addGestureRecognizer:doubleTapRecognizer];
        
        // 添加监听单击的gesture recognizer
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tapRecognizer.delaysTouchesBegan = YES;
        // 单击gesture recognizer要等待双击gesture recognizer失败再触发
        [tapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
        [self addGestureRecognizer:tapRecognizer];
        
        // 添加监听长按的geture recognizer
        UILongPressGestureRecognizer *pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:pressRecognizer];
        
        // pan gesture recognizer
        self.moveRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveLine:)];
        self.moveRecognizer.delegate = self;
        self.moveRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:self.moveRecognizer];
        
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if (gestureRecognizer == self.moveRecognizer) {
        return YES;
    }
    return NO;
}

- (void)longPress:(UIGestureRecognizer *)gr{
    
    if(gr.state == UIGestureRecognizerStateBegan){
        
        CGPoint point = [gr locationInView:self];
        self.selectedLine = [self lineAtPoint:point];
        
        if (self.selectedLine) {
            [self.linesInProgress removeAllObjects];
        }
    }else if(gr.state == UIGestureRecognizerStateEnded){
        self.selectedLine = nil;
    }
    
    [self setNeedsDisplay];
}
- (void)doubleTap:(UIGestureRecognizer *)gr{
    NSLog(@"Recognized Double Tap");
    
    [self.linesInProgress removeAllObjects];
    [self.finishedLines removeAllObjects];
    [self setNeedsDisplay];
}
- (void)tap:(UIGestureRecognizer *)gr{
    NSLog(@"Recognized tap");
    
    // 找到当前手势在view中的坐标
    CGPoint point = [gr locationInView:self];
    self.selectedLine = [self lineAtPoint:point];
    
    if (self.selectedLine) {
        // 将view本身设置为window的first responder
        [self becomeFirstResponder];
        
        // 获得menu controller单例
        UIMenuController *menu = [UIMenuController sharedMenuController];
        // 创建menu item，并指定title和action
        UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteLine:)];
        // 为menu controller 设置menu items
        menu.menuItems = @[deleteItem];
        // 为menu controller指定距形
        [menu setTargetRect:CGRectMake(point.x, point.y, 2, 2) inView:self];
        // 将menu controlelr设置为可见
        [menu setMenuVisible:YES animated:YES];
    }else{
        // 隐藏menu controller
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
    
    [self setNeedsDisplay];
}
- (void)deleteLine:(id)sender{
    [self.finishedLines removeObject:self.selectedLine];
    // Redraw everything
    [self setNeedsDisplay];
}

// 重写canBecomeFirstResponder方法，并返回YES，使得当前VIEW可以成为first responder
- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (BKLine *)lineAtPoint:(CGPoint)p{
    
    // Find a line close to p
    for (BKLine *l in self.finishedLines) {
        CGPoint start = l.begin;
        CGPoint end = l.end;
        
        for (float t = 0.0; t <= 1.0; t += 0.05) {
            float x = start.x + t * (end.x - start.x);
            float y = start.y + t * (end.y - start.y);
            
            // If the tapped point is within 20 points, let's return this line
            if(hypot(x - p.x, y -p.y) < 20.0){
                return l;
            }
        }
    }
    return nil;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        CGPoint location = [t locationInView:self];
        
        BKLine *line = [[BKLine alloc] init];
        line.begin = location;
        line.end = location;
        
        // key为UITouch对象的内存地址
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        self.linesInProgress[key] = line;
        
    }
    
    
//    UITouch *t = [touches anyObject];
//    CGPoint location = [t locationInView:self];
//    
//    self.currentLine = [[BKLine alloc] init];
//    self.currentLine.begin = location;
//    self.currentLine.end = location;
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        BKLine *line = self.linesInProgress[key];
        line.end = [t locationInView:self];
    }
    
//    UITouch *t = [touches anyObject];
//    
//    CGPoint location = [t locationInView:self];
//    self.currentLine.end = location;
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        BKLine *line = self.linesInProgress[key];
        
        [self.finishedLines addObject:line];
        [self.linesInProgress removeObjectForKey:key];
    }
    
//    [self.finishedLines addObject:self.currentLine];
//    self.currentLine = nil;
    
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"%@", NSStringFromSelector(_cmd));

    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [self.linesInProgress removeObjectForKey:key];
    }
    [self setNeedsDisplay];
}


- (void)strokeLine:(BKLine *)line{
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth = 10;
    bp.lineCapStyle = kCGLineCapRound;
    
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    [bp stroke];
}

- (void)drawRect:(CGRect)rect{
    [[UIColor blackColor] set];
    for (BKLine *line in self.finishedLines){
        [self strokeLine:line];
    }
    
    [[UIColor redColor] set];
    for (NSValue *key in self.linesInProgress) {
        [self strokeLine:self.linesInProgress[key]];
    }
    
    if (self.selectedLine) {
        [[UIColor greenColor] set];
        [self strokeLine:self.selectedLine];
    }
    
//    if(self.currentLine){
//        [[UIColor redColor] set];
//        [self strokeLine:self.currentLine];
//    }
}

@end
