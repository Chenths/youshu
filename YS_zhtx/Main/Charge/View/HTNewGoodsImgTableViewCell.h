//
//  HTNewGoodsImgTableViewCell.h
//  有术
//
//  Created by mac on 2018/5/24.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
//#import "HTProductsData.h"
#import "HTOrderDetailProductModel.h"
#import "HTCahargeProductModel.h"
#import <UIKit/UIKit.h>

@interface HTNewGoodsImgTableViewCell : UITableViewCell

@property (nonatomic,strong) HTCahargeProductModel *model;

@property (nonatomic,strong) HTOrderDetailProductModel *productModel;
//@property (nonatomic,strong) HTProductsData *goodsModel;

@end
