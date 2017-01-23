//
//  KDInputView.m
//  KedeInputView
//
//  Created by llj on 2017/1/20.
//  Copyright © 2017年 Kede. All rights reserved.
//

#import "KDInputView.h"
#import "KDInputToolView.h"
#import "KDAutoTextView.h"

@interface KDInputView ()<UITextViewDelegate>

@property (nonatomic, assign) CGFloat inputViewHeight;

@property (nonatomic, strong) KDInputToolView *toolView;

@end

@implementation KDInputView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupUI];
        
        [self registerObserver];
    }
    
    return self;
}

- (void)dealloc {
    [self removeObserver];
}

- (void)setupUI {
    
    _inputViewHeight = self.bounds.size.height;
    
    _toolView = [[KDInputToolView alloc] initWithFrame:self.bounds];
    [self addSubview:_toolView];
    
    [_toolView.recommendGoodsButton addTarget:self action:@selector(toggleRecommendGoods:) forControlEvents:UIControlEventTouchUpInside];
    
    _toolView.textView.delegate = self;
}

// MARK: - 按钮响应

- (void)toggleRecommendGoods:(UIButton *)button {
    [_toolView.textView resignFirstResponder];
}


//MARK: - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    
    CGFloat height = textView.contentSize.height;
    CGRect oldFrame = textView.frame;
    _toolView.textView.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, height);
    [_toolView.textView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    CGFloat changedHeight = height + 12;
    _inputViewHeight = changedHeight;
    
    CGRect beginFrame = self.frame;
    
    if (changedHeight != beginFrame.size.height) {
        // 键盘弹起
        self.frame = CGRectMake(beginFrame.origin.x, beginFrame.origin.y - (changedHeight - beginFrame.size.height), beginFrame.size.width, changedHeight);
        
        _toolView.frame = self.bounds;
        [_toolView setNeedsDisplay];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSInteger currentLength = textView.text.length + text.length;
    
    if (self.limitedLength && currentLength > self.limitedLength) {
        return NO;
    }
    
    return YES;
}

// MARK: - Notificaiton

- (void)registerObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleKeyboardWillChangeFrameNotification:(NSNotification *)notification {
    if (!self.window) {
        return;
    }
    
    NSDictionary *userInfo = notification.userInfo;
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = (UIViewAnimationCurve)[userInfo[UIKeyboardAnimationDurationUserInfoKey] integerValue];
    void(^animations)() = ^{
        [self willShowKeyboardFromFrame:beginFrame toFrmae:endFrame];
    };
    
    [UIView animateWithDuration:duration delay:0 options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:nil];
}

- (void)willShowKeyboardFromFrame:(CGRect)beginFrame toFrmae:(CGRect)toFrame {
    
    if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height) {
        [self willShowBottomHeight:0];
    } else {
        [self willShowBottomHeight:toFrame.size.height];
    }
}

- (void)willShowBottomHeight:(CGFloat)bottomHeight {
    CGRect fromFrame = self.frame;
    CGFloat toHeight = bottomHeight == 0 ? ([[UIScreen mainScreen] bounds].size.height - fromFrame.size.height) : fromFrame.origin.y - bottomHeight;
    CGRect toFrame = CGRectMake(fromFrame.origin.x, toHeight, fromFrame.size.width, _inputViewHeight);
    self.frame = toFrame;
    
    // 外界关联高度变化为self.frame.size.height + bottomHeight
}



@end
