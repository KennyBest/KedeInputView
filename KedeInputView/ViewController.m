//
//  ViewController.m
//  KedeInputView
//
//  Created by llj on 2017/1/20.
//  Copyright © 2017年 Kede. All rights reserved.
//

#import "ViewController.h"
#import "KDInputView.h"
#import "KDAutoTextView.h"

@interface ViewController ()<UITextViewDelegate>
@property (nonatomic, strong) KDAutoTextView *autoTextView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self testInputView];
//    [self testAutoTextView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)testInputView {
    KDInputView *inputView = [[KDInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 46, self.view.frame.size.width, 46)];
    inputView.limitedLength = 0;
    [self.view addSubview:inputView];
}

- (void)testAutoTextView {
    KDAutoTextView *textView = [[KDAutoTextView alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width - 20, 34)];
    textView.placeHolderColor = [UIColor redColor];
    textView.placeHolder = [KDAutoTextView description];
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textView.layer.borderWidth = .5f;
    textView.layer.cornerRadius = 2.0f;
    textView.layer.masksToBounds = YES;
    textView.delegate = self;
    
    [self.view addSubview:textView];
    
    self.autoTextView = textView;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    CGFloat height = textView.contentSize.height;
    CGRect oldFrame = textView.frame;
    textView.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, height);
    [textView setContentOffset:CGPointMake(0, height - textView.frame.size.height) animated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
//    NSInteger length = range.length + text.length;
//    
//    if (length > 15) {
//        return NO;
//    }
    
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    return YES;
}
@end
