//
//  HTVipLevelSectionModel.h
//  有术
//
//  Created by mac on 2017/7/12.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//



#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HTSECTIONSTATE) {
    HTSECTIONSTATEEDIT,
    HTSECTIONSTATENOMALE,
};

@interface HTVipLevelSectionModel : NSObject


@property (nonatomic,strong) NSString *titleStr;

@property (nonatomic,strong) NSString *imgName;

@property (nonatomic,strong) NSString *sectionKey;

@property (nonatomic,assign) HTSECTIONSTATE state;

@end
