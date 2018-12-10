//
//  HTProductImgCollectionViewCell.h
//  YS_zhtx
//
//  Created by mac on 2018/6/19.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTOrderDetailProductModel.h"
#import "HTChargeProductInfoModel.h"
#import <UIKit/UIKit.h>

@interface HTProductImgCollectionViewCell : UICollectionViewCell


@property (nonatomic,assign) BOOL isReturn;
@property (nonatomic,strong) HTOrderDetailProductModel *model;
@property (nonatomic,strong) HTChargeProductInfoModel *productModel;
@end
