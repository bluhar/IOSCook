//
//  BKQuizViewController.m
//  Quiz
//
//  Created by vivi 卫 on 15-7-5.
//  Copyright (c) 2015年 Colin. All rights reserved.
//

#import "BKQuizViewController.h"

@interface BKQuizViewController ()

@property (nonatomic) int currentQuestionIndex;
@property (nonatomic, copy) NSArray *questions;
@property (nonatomic, copy) NSArray *answers;

//IB 是interface builder的缩写
@property (nonatomic, weak) IBOutlet UILabel *questionLabel;
@property (nonatomic, weak) IBOutlet UILabel *answerLabel;


@end

@implementation BKQuizViewController


- (IBAction)showQuestion:(id)sender{
    self.currentQuestionIndex++;
    if(self.currentQuestionIndex == [self.questions count]){
        self.currentQuestionIndex=0;
    }
    
    NSLog(@"questions count is %d, and current index is %d", [self.questions count], self.currentQuestionIndex);
    NSString *question = self.questions[self.currentQuestionIndex];
    self.questionLabel.text=question;
    self.answerLabel.text=@"???";
    
}

- (IBAction)showAnswer:(id)sender{
    NSString *answer = self.answers[self.currentQuestionIndex];
    self.answerLabel.text=answer;
}


//ViewController被创建时 调用此方法，有点像android中activity的onCreate()方法
//这种xib方式才会在初始化时调用nib的方法
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"Execute initWithNibName method");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"init arrays");
        // Custom initialization
        self.questions = @[@"From what is cognac made?",
                           @"What is 7+7?",
                           @"What is the capital of Vermont?"];
    
        self.answers = @[@"Grapes",@"14",@"Montpelier"];
        
        NSLog(@"1. questions count is %d, answers count is %d", [self.questions count], [self.answers count]);
    }
        NSLog(@"2. questions count is %d, answers count is %d", [self.questions count], [self.answers count]);
    return self;
}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

@end
