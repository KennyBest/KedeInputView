//
//  KDPageView.m
//  KedeInputView
//
//  Created by llj on 2017/1/22.
//  Copyright © 2017年 Kede. All rights reserved.
//

#import "KDPageView.h"

@interface KDPageView () {
    NSInteger _currentPage;
    NSInteger _currentPageForRotation;
}

@property (nonatomic, strong) NSMutableArray *pages;

- (void)setupControls;

- (void)calculatePageNumbers;
- (void)reloadPage;
- (void)raisePageIndexChangedDelegate;

@end

@implementation KDPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupControls];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setupControls];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    CGFloat originalWidth = self.frame.size.width;
    [super setFrame:frame];
    
    if (originalWidth != frame.size.width) {
        [self reloadData];
    }
}

- (void)dealloc {
    _scrollView.delegate = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_scrollView setFrame:self.bounds];
    
    CGSize size = self.bounds.size;
    [self.scrollView setContentSize:CGSizeMake(size.width * _pages.count, size.height)];
    for (NSInteger i = 0; i < _pages.count; i++) {
        id obj = [self.pages objectAtIndex:i];
        if ([obj isKindOfClass:[UIView class]]) {
            [(UIView *)obj setFrame:CGRectMake(size.width * i, 0, size.width, size.height)];
        }
    }
    
    BOOL isNeedAnimation = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(needScrollAnimation)]) {
        isNeedAnimation = [self.delegate needScrollAnimation];
    }
    [self.scrollView scrollRectToVisible:CGRectMake(_currentPage * size.width, 0, size.width, size.height) animated:isNeedAnimation];
}

- (void)setupControls {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_scrollView];
        
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
    }
}

//MARK: - Public Methods

- (void)scrollToPage:(NSInteger)page {
    if (_currentPage != page || page == 0) {
        _currentPage = page;
        [self reloadData];
    }
}

- (void)reloadData {
    [self calculatePageNumbers];
    [self reloadPage];
}

- (UIView *)viewAtIndex:(NSInteger)index {
    UIView *view = nil;
    if (index >= 0 && index < [_pages count]) {
        id obj = [_pages objectAtIndex:index];
        if ([obj isKindOfClass:[UIView class]]) {
            view = obj;
        }
    }
    return view;
}

- (NSInteger)currentPage {
    return _currentPage;
}

- (NSInteger)pageInBound:(NSInteger)value min:(NSInteger)min max:(NSInteger)max {
    if (max < min) {
        NSInteger tmp = max;
        max = min;
        min = tmp;
    }
    
    NSInteger bounded = value;
    if (bounded > max) {
        bounded = max;
    }
    if (bounded < min) {
        bounded = min;
    }
    return bounded;
}

#pragma mark - page载入和销毁

- (void)loadPageForCurrentPage:(NSInteger)currentPage {
    NSUInteger count = [_pages count];
    if (count == 0) {
        return;
    }
    
    NSInteger first = [self pageInBound:currentPage - 1 min:0 max:count - 1];
    NSInteger last = [self pageInBound:currentPage + 1 min:0 max:count - 1];
    NSRange range = NSMakeRange(first, last - first + 1);
    
    for (NSUInteger index = 0; index < count; index++) {
        if (NSLocationInRange(index, range)) {
            id obj = [_pages objectAtIndex:index];
            if (![obj isKindOfClass:[UIView class]]) {
                if (self.dataSource && [self.dataSource respondsToSelector:@selector(pageView:viewInPage:)]) {
                    UIView *view = [_dataSource pageView:self viewInPage:index];
                    [_pages replaceObjectAtIndex:index withObject:view];
                    [self.scrollView addSubview:view];
                    CGSize size = self.bounds.size;
                    [view setFrame:CGRectMake(size.width * index, 0, size.width, size.height)];
                } else {
                    assert(0);
                }
            } else {
                id obj = [_pages objectAtIndex:index];
                if ([obj isKindOfClass:[UIView class]]) {
                    [obj removeFromSuperview];
                    [_pages replaceObjectAtIndex:index withObject:[NSNull null]];
                }
            }
        }
    }
    
}

- (void)calculatePageNumbers {
    NSInteger numberOfPages = 0;
    for (id obj in _pages) {
        if ([obj isKindOfClass:[UIView class]]) {
            [(UIView *)obj removeFromSuperview];
        }
    }
    if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfPages:)]) {
        numberOfPages = [_dataSource numberOfPages:self];
    }
    self.pages = [NSMutableArray arrayWithCapacity:numberOfPages];
    for (NSInteger i = 0; i < numberOfPages; i++) {
        [_pages addObject:[NSNull null]];
    }
    
    self.scrollView.delegate = nil;
    CGSize size = self.bounds.size;
    [self.scrollView setContentSize:CGSizeMake(size.width * numberOfPages, size.height)];
    self.scrollView.delegate = self;
}

- (void)reloadPage {
    if (_currentPage >= [_pages count]) {
        _currentPage = [_pages count] - 1;
    }
    if (_currentPage < 0) {
        _currentPage = 0;
    }
    
    [self loadPageForCurrentPage:_currentPage];
    [self raisePageIndexChangedDelegate];
    [self setNeedsLayout];
}


//MARK: UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = scrollView.bounds.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger page = (NSInteger)(fabs(offsetX / width));
    
    if (page >= 0 && page < [_pages count]) {
        if (_currentPage == page) {
            return;
        }
        _currentPage = page;
        [self loadPageForCurrentPage:_currentPage];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(pageViewDidScroll:)]) {
        [_delegate pageViewDidScroll:self];
    }
}

//MARK: --

- (void)raisePageIndexChangedDelegate {
    if (_delegate && [_delegate respondsToSelector:@selector(pageViewScrollEnd:currentIndex:totolPages:)]) {
        [_delegate pageViewScrollEnd:self currentIndex:_currentPage totolPages:[_pages count]];
    }
}


@end
