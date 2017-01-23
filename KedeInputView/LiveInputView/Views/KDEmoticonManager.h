//
//  KDEmoticonManager.h
//  KedeInputView
//
//  Created by llj on 2017/1/22.
//  Copyright © 2017年 Kede. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface KDEmoticon : NSObject

@property (nonatomic, strong) NSString *emoticonID;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSString *filename;

@end

@interface KDEmoticonLayout : NSObject

@property (nonatomic, assign) NSInteger rows;
@property (nonatomic, assign) NSInteger columes;
@property (nonatomic, assign) NSInteger itemCountInPage;
@property (nonatomic, assign) CGFloat   cellWidth;
@property (nonatomic, assign) CGFloat   cellHeight;
@property (nonatomic, assign) CGFloat   imageWidth;
@property (nonatomic, assign) CGFloat   imageHeight;
@property (nonatomic, assign) BOOL      emoji;

- (id)initEmojiLayout:(CGFloat)width;

- (id)initCharletLayout:(CGFloat)width;

@end

@interface KDEmoticonCatalog : NSObject

@property (nonatomic, strong) KDEmoticonLayout *layout;
@property (nonatomic, strong) NSString *catalogID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDictionary *id2Emoticons;
@property (nonatomic, strong) NSDictionary *tag2Emoticons;
@property (nonatomic, strong) NSArray *emoticons;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *iconPressed;
@property (nonatomic, assign) NSInteger pageCount;

@end

@interface KDEmoticonManager : NSObject

+ (instancetype)sharedManager;

- (KDEmoticonCatalog *)emoticonCatalog:(NSString *)catalogID;
- (KDEmoticon *)emoticonByTag:(NSString *)tag;
- (KDEmoticon *)emoticonByID:(NSString *)emoticonID;
- (KDEmoticon *)emoticonByCatalogID:(NSString *)catalogID emoticonID:(NSString *)emoticonID;

- (NSArray *)loadChartletEmoticonCatalog;

@end
