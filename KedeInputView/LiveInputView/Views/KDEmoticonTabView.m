//
//  KDEmoticonTabView.m
//  KedeInputView
//
//  Created by llj on 2017/1/22.
//  Copyright © 2017年 Kede. All rights reserved.
//

#import "KDEmoticonTabView.h"

const CGFloat KDEmoticonTabViewHeight = 35;
const CGFloat KDEmoticonSendButtonWidth = 50;

const CGFloat InputLineBoarderHeight = .5f;

@interface KDEmoticonTabView ()

@property (nonatomic, strong) NSMutableArray *tabs;
@property (nonatomic, strong) NSMutableArray *seps;

@end

@implementation KDEmoticonTabView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, 0, frame.size.width, KDEmoticonTabViewHeight)];
    if (self) {
        _tabs = @[].mutableCopy;
        _seps = @[].mutableCopy;
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_sendButton setBackgroundColor:[UIColor blueColor]];
        _sendButton.frame = CGRectMake(self.bounds.size.width - KDEmoticonSendButtonWidth, 0, KDEmoticonSendButtonWidth, KDEmoticonTabViewHeight);
        [self addSubview:_sendButton];
        
        UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, InputLineBoarderHeight)];
        sepView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:sepView];
    }
    return self;
}

@end
