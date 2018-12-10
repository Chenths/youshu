//
//  HTBirthdayCustomerCell.h
//  有术
//
//  Created by mac on 2018/1/26.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTBirthdayCustomerListController.h"
#import <UIKit/UIKit.h>

@interface HTBirthdayCustomerCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,assign) HTBirthTodayOrNear htbirthType;

@end
