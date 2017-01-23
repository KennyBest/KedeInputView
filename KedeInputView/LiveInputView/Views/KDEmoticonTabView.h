//
//  KDEmoticonTabView.h
//  KedeInputView
//
//  Created by llj on 2017/1/22.
//  Copyright © 2017年 Kede. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KDEmoticonTabView;

@protocol KDEmoticonTabViewDelegate <NSObject>

- (void)emoticonTabView:(KDEmoticonTabView *)view didSelectTabIndex:(NSInteger)index;

@end

@interface KDEmoticonTabView : UIView

@property (strong, nonatomic) UIButton *sendButton;

@property (weak, nonatomic) id<KDEmoticonTabViewDelegate> delegate;

- (void)selectTabIndex:(NSInteger)index;

- (void)loadCatalogs:(NSArray *)emoticonCatalogs;

@end
