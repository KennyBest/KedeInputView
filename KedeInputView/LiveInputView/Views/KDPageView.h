//
//  KDPageView.h
//  KedeInputView
//
//  Created by llj on 2017/1/22.
//  Copyright © 2017年 Kede. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KDPageView;

@protocol KDPageViewDataSource <NSObject>
- (NSInteger)numberOfPages:(KDPageView *)pageView;
- (UIView *)pageView:(KDPageView *)pageView viewInPage:(NSInteger)index;
@end

@protocol KDPageViewDelegate <NSObject>
- (void)pageViewScrollEnd:(KDPageView *)pageView currentIndex:(NSInteger)index totolPages:(NSInteger)pages;
- (void)pageViewDidScroll:(KDPageView *)pageView;
- (BOOL)needScrollAnimation;
@end

@interface KDPageView : UIView<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) id<KDPageViewDelegate> delegate;
@property (weak, nonatomic) id<KDPageViewDataSource> dataSource;

- (void)scrollToPage:(NSInteger)page;
- (void)reloadData;
- (UIView *)viewAtIndex:(NSInteger)index;
- (NSInteger)currentPage;

@end
