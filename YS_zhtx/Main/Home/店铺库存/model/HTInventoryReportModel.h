//
//  HTInventoryReportModel.h
//  YS_zhtx
//
//  Created by mac on 2018/9/14.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTPiesModel.h"
#import <Foundation/Foundation.h>

@interface HTInventoryReportModel : NSObject

@property (nonatomic,strong) HTPiesModel *categorieModel;

@property (nonatomic,strong) HTPiesModel *colorModel;

@property (nonatomic,assign) BOOL isboos;
@property (nonatomic,strong) HTPiesModel *customTypeModel;
@property (nonatomic,strong) HTPiesModel *seasonModel;
@property (nonatomic,strong) HTPiesModel *sizeModel;
@property (nonatomic,strong) HTPiesModel *yearModel;
@property (nonatomic,strong) HTPiesModel *supplierModel;


@property (nonatomic,strong) NSString *companyName;
@property (nonatomic,strong) NSString *goodMarket;
@property (nonatomic,strong) NSString *totalPrice;
@property (nonatomic,strong) NSString *costPrice;

@property (nonatomic,strong) NSString *totalStock;
@property (nonatomic,strong) NSString *unsalable;

@end
