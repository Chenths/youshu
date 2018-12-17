//
//  HTSaleGoodOrBadDetailController.h
//  YS_zhtx
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTStackSaleProductModel.h"
#import "HTCommonViewController.h"

@interface HTSaleGoodOrBadDetailController : HTCommonViewController

@property (nonatomic,strong) NSString *productId;

@property (nonatomic,strong) NSString *companyId;

@property (nonatomic,strong) HTStackSaleProductModel *model;

@property (nonatomic,strong) NSString *barcode;   

@end
