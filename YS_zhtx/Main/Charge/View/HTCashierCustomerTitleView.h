//
//  HTCustomerTitleView.h
//  有术
//
//  Created by mac on 2017/11/7.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//
#import "HTCustModel.h"
#import <UIKit/UIKit.h>
//#import "HTSingleVipDataModel.h"
@interface HTCashierCustomerTitleView : UIView

@property (nonatomic,strong) HTCustModel *model;

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@end
