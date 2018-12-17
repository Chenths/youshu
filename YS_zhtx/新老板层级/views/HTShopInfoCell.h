//
//  HTShopInfoCell.h
//  有术
//
//  Created by mac on 2018/4/10.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTSingleShopDataModel.h"
#import <UIKit/UIKit.h>

@interface HTShopInfoCell : UITableViewCell

@property (nonatomic,strong) HTSingleShopDataModel *model;

-(void)createCircleWithIp:(int) upOrDow;

@end
