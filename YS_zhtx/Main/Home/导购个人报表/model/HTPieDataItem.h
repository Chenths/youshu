//
//  HTPieDataItem.h
//  YS_zhtx
//
//  Created by mac on 2018/7/5.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTPieDataItem : NSObject
//百分比
@property (nonatomic,strong) NSString *data;
//图例
@property (nonatomic,strong) NSString *label;
//名称
@property (nonatomic,strong) NSString *name;
//对应的值
@property (nonatomic,strong) NSString *total;

@property (nonatomic,strong) UIColor *color;

@property (nonatomic,strong) NSString *suffix;

@property (nonatomic,strong) NSString *finalprice;

@property (nonatomic,strong) NSString *finalPrice;

@property (nonatomic,strong) NSString *costPrice;

@property (nonatomic,strong) NSString *price;

@property (nonatomic,strong) NSString *ralt;

@property (nonatomic,strong) NSString *start;

@property (nonatomic,strong) NSString *end;

@property (nonatomic,strong) NSString *itemId;

@property (nonatomic,assign) BOOL isFirst;


@end
