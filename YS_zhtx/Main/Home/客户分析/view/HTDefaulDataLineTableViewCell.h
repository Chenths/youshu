//
//  HTDefaulDataLineTableViewCell.h
//  YS_zhtx
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTCustomerBarGraphModel.h"
#import <UIKit/UIKit.h>

@interface HTDefaulDataLineTableViewCell : UITableViewCell
@property (nonatomic,strong) UIColor *selectedColor;

@property (nonatomic,strong) UIColor *color;

@property (nonatomic,strong) HTCustomerBarGraphModel *model;

@end
