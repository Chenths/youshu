//
//  HTNewTagsModel.h
//  有术
//
//  Created by mac on 2017/11/7.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, HTTagsState) {
    HTTAGStateNOMAL,
    HTTAGStateADD,
    HTTAGStateDEATL,
    HTTAGStateEDIT,
};
typedef NS_ENUM(NSInteger, HTTagType) {
    HTTAGsNOMAL,
    HTTAGTop,
    HTTAGShop,
    HTTAGPlatform,
};
@interface HTNewTagsModel : NSObject

@property (nonatomic,strong) NSArray *tagsArray;
@property (nonatomic,assign) BOOL isSeemore;
@property (nonatomic,assign) CGFloat lessHeight;
@property (nonatomic,assign) CGFloat totleHeight;

@property (nonatomic,assign) HTTagType tageType;

@property (nonatomic,assign) HTTagsState tageState;

@end
