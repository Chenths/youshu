//
//  HTNewVipHeadCell.h
//  有术
//
//  Created by mac on 2017/11/3.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//
//#import "HTSingleVipDataModel.h"
#import "HTCustomerReprotSaleMsgModel.h"
#import <UIKit/UIKit.h>
typedef void(^headDidSelected)(void);
@interface HTNewVipHeadCell : UITableViewCell

@property (nonatomic,strong) HTCustomerReprotSaleMsgModel *model;

@property (nonatomic,strong) NSString *modelId;

@property (nonatomic,strong) NSString *openid;

@property (weak, nonatomic) IBOutlet UIButton *chatBt;

@property (nonatomic,copy) headDidSelected headSelected;

@end
