//
//  KDInputToolView.h
//  KedeInputView
//
//  Created by llj on 2017/1/20.
//  Copyright © 2017年 Kede. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KDAutoTextView;

@interface KDInputToolView : UIView

/// 推荐商品按钮
@property (strong, nonatomic) UIButton *recommendGoodsButton;

/// emoji按钮
@property (strong, nonatomic) UIButton *emojiButton;

/// 悬浮按钮
@property (strong, nonatomic) UIButton *suspendButton;

@property (strong, nonatomic) KDAutoTextView *textView;


@end
