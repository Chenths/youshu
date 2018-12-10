//
//  HTNewVipBaseInfoCell.h
//  有术
//
//  Created by mac on 2017/11/2.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTCustomerReprotSaleMsgModel.h"
//#import "HTSingleVipDataModel.h"

@interface HTNewVipBaseInfoCell : UITableViewCell

//@property (nonatomic,strong) HTSingleVipDataModel *model;

@property (nonatomic,assign) BOOL isPush;

@property (nonatomic,strong) HTCustomerReprotSaleMsgModel *model;

@end
