//
//  HTPiesModel.h
//  YS_zhtx
//
//  Created by mac on 2018/7/9.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTPieDataItem.h"
#import <Foundation/Foundation.h>

@interface HTPiesModel : NSObject

@property (nonatomic,strong) NSArray *data;

@property (nonatomic,strong) NSString *title;

@property (nonatomic,assign) BOOL isSeemore;

@property (nonatomic,strong) NSString *searchKey;


@end
