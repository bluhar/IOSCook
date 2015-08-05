//
//  BKDrawView.m
//  TouchTracker
//
//  Created by vivi 卫 on 15-8-3.
//  Copyright (c) 2015年 bk. All rights reserved.
//

#import "BKDrawView.h"
#import "BKLine.h"

@interface BKDrawView ()

//@property (nonatomic, strong) BKLine *currentLine;
// 保存当前的多个line
@property (nonatomic, strong) NSMutableDictionary *linesInProgress;
@property (nonatomic, strong) NSMutableArray *finishedLines;

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
    }
    return self;
}
- (void)doubleTap:(UIGestureRecognizer *)gr{
    NSLog(@"Recognized Double Tap");
    
    [self.linesInProgress removeAllObjects];
    [self.finishedLines removeAllObjects];
    [self setNeedsDisplay];
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
    
//    if(self.currentLine){
//        [[UIColor redColor] set];
//        [self strokeLine:self.currentLine];
//    }
}

@end
