//
//  HTStyleInventoryModel.h
//  YS_zhtx
//
//  Created by mac on 2018/9/14.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTStockInfoModel.h"
#import <Foundation/Foundation.h>

@interface HTStyleInventoryModel : NSObject

@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *productName;
@property (nonatomic,strong) NSString *season;
@property (nonatomic,strong) NSString *styleCode;
@property (nonatomic,strong) NSString *year;
@property (nonatomic,strong) NSArray *stock;
@property (nonatomic,strong) NSString *productImg;

@property (nonatomic,strong) NSString *color;

@property (nonatomic,strong) NSString *colorCode;


@end
