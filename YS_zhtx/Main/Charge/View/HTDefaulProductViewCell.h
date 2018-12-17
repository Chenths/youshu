//
//  HTFastProductViewCell.h
//  有术
//
//  Created by mac on 2018/5/15.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
#import "HTOrderDetailProductModel.h"
#import "HTCahargeProductModel.h"
#import <UIKit/UIKit.h>

@interface HTDefaulProductViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *selectedImg;

@property (nonatomic,strong) HTOrderDetailProductModel *orderProductModel;

@property (nonatomic,strong) HTCahargeProductModel *chargeModel;


@property (nonatomic,strong) HTOrderDetailProductModel *excOrReProductModel;

@end
