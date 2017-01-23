//
//  KDAutoTextView.m
//  KedeInputView
//
//  Created by llj on 2017/1/20.
//  Copyright © 2017年 Kede. All rights reserved.
//

#import "KDAutoTextView.h"

@implementation KDAutoTextView

// MARK: - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self configureUI];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveTextDidChangeNotification:) name:UITextViewTextDidChangeNotification
                                                   object:self];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

- (void)configureUI {
    self.contentInset = UIEdgeInsetsZero;
    self.scrollEnabled = YES;
    self.scrollsToTop = NO;
    self.userInteractionEnabled = YES;
    self.font = [UIFont systemFontOfSize:15.0f];
    self.textColor = [UIColor blackColor];
    self.backgroundColor = [UIColor clearColor];
    self.keyboardAppearance = UIKeyboardAppearanceDefault;
    self.keyboardType = UIKeyboardTypeDefault;
    self.returnKeyType = UIReturnKeySend;
    self.textAlignment = NSTextAlignmentLeft;
}

// MARK: - 重写 setter

- (void)setText:(NSString *)text {
    [super setText:text];
    
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    
    [self setNeedsDisplay];
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    if ([placeHolder isEqualToString:_placeHolder]) {
        return;
    }
    _placeHolder = placeHolder;
    [self setNeedsDisplay];
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor {
    if (placeHolderColor == _placeHolderColor) {
        return;
    }
    _placeHolderColor = placeHolderColor;
    [self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame {
    if (self.frame.size.width != frame.size.width) {
        [self setNeedsDisplay];
    }
    [super setFrame:frame];
}

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    if ((self.text.length == 0) && self.placeHolder && self.placeHolder.length) {
        
        CGRect placeHolderRect = CGRectMake(5.0f,
                                            7.0f,
                                            rect.size.width,
                                            rect.size.height);
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = self.textAlignment;
        
        [self.placeHolder drawInRect:placeHolderRect
                      withAttributes:@{ NSFontAttributeName : self.font ?: [UIFont systemFontOfSize:15.0f],
                                        NSForegroundColorAttributeName : self.placeHolderColor ?: [UIColor lightGrayColor],
                                        NSParagraphStyleAttributeName : paragraphStyle
                                        }];
    }
    
}

// MARK: - 通知处理

- (void)didReceiveTextDidChangeNotification:(NSNotification *)notification {
    [self setNeedsDisplay];
}

@end
