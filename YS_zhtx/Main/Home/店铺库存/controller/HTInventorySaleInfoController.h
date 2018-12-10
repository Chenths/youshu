//
//  HTInventorySaleInfoController.h
//  YS_zhtx
//
//  Created by mac on 2018/6/12.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
typedef NS_ENUM(NSInteger, HTSaleGoodOrBadType) {
    HTSaleGood,
    HTSaleBad,
};
#import "HTCommonViewController.h"

@interface HTInventorySaleInfoController : HTCommonViewController

@property (nonatomic,strong) NSString *companyId;

@property (nonatomic,assign) HTSaleGoodOrBadType saletype;

@end
