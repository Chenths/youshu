//
//  HTReturnOrderInfoCell.h
//  有术
//
//  Created by mac on 2018/5/16.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTOrderDetailModel.h"
#import <UIKit/UIKit.h>

@interface HTReturnOrderInfoCell : UITableViewCell
@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,strong) HTOrderDetailModel *model;
@end
