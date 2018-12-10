//
//  HTCahargeProductModel.h
//  YS_zhtx
//
//  Created by mac on 2018/7/25.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTChargeProductInfoModel.h"
#import <Foundation/Foundation.h>

@interface HTCahargeProductModel : NSObject

@property (nonatomic,strong) NSArray *product;

@property (nonatomic,strong) HTChargeProductInfoModel *selectedModel;

@property (nonatomic,strong) NSArray *sizeGrop;

@property (nonatomic,strong) NSArray *colorGrop;

@property (nonatomic,strong) NSString *selecedSizeCode;

@property (nonatomic,strong) NSString *selecedColorCode;
//判断是否被选择
@property (nonatomic,assign) BOOL isChoose;

//判断改价中是否修改
@property (nonatomic,assign) BOOL isChange;
//判断改价是否选中
@property (nonatomic,assign) BOOL isSelected;
//判断是否改价
@property (nonatomic,assign) BOOL isChangePrice;
//是否赠送积分
@property (nonatomic,strong) NSString  *hasGivePoint;
//调入库存件数
@property (nonatomic,strong) NSString  *turnInNums;

@end
