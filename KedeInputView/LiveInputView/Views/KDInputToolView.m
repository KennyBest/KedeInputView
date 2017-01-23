//
//  KDInputToolView.m
//  KedeInputView
//
//  Created by llj on 2017/1/20.
//  Copyright © 2017年 Kede. All rights reserved.
//

#import "KDInputToolView.h"
#import "KDAutoTextView.h"

CGFloat const kPadding = 10.0f;
CGFloat const kTextViewHeight = 34.0f;

@implementation KDInputToolView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    _recommendGoodsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_recommendGoodsButton setBackgroundImage:[UIImage imageNamed:@"test"] forState:UIControlStateNormal];
    [self addSubview:_recommendGoodsButton];
    [_recommendGoodsButton sizeToFit];

    _textView = [[KDAutoTextView alloc] initWithFrame:CGRectZero];
    _textView.placeHolder = @"请输入内容";
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textView.layer.borderWidth = .5f;
    _textView.layer.cornerRadius = 2.0f;
    _textView.layer.masksToBounds = YES;

    [self addSubview:_textView];
    
    _emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_emojiButton setBackgroundImage:[UIImage imageNamed:@"test"] forState:UIControlStateNormal];
    [_emojiButton setBackgroundImage:[UIImage imageNamed:@"test"] forState:UIControlStateHighlighted];
    [self addSubview:_emojiButton];
    [_emojiButton sizeToFit];
    
    _suspendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_suspendButton setBackgroundImage:[UIImage imageNamed:@"test"] forState:UIControlStateNormal];
    [self addSubview:_suspendButton];
    [_suspendButton sizeToFit];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat textViewWidth = self.frame.size.width - kPadding * (self.subviews.count + 1) - _recommendGoodsButton.frame.size.width * (self.subviews.count - 1);
    _textView.frame = CGRectMake(0, 0, textViewWidth, self.frame.size.height - 12);
    
    CGFloat left = 0.0f;
    
    for (UIView *view in self.subviews) {
        CGRect frame = view.frame;
        view.frame = CGRectMake(left + kPadding, self.frame.size.height * 0.5 - frame.size.height * 0.5, frame.size.width, frame.size.height);
        left = CGRectGetMaxX(view.frame);
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat height = 46.0f;
    return CGSizeMake(size.width, height);
}

@end
