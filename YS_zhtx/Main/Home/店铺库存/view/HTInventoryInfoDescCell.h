//
//  HTBossSaleBasicContrastCell.h
//  有术
//
//  Created by mac on 2018/4/16.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTPieDataItem.h"
#import "HTInventoryInfoDescCell.h"
#import <UIKit/UIKit.h>

@interface HTInventoryInfoDescCell : UITableViewCell

@property (nonatomic,strong) HTPieDataItem *model;

@property (nonatomic,assign) BOOL isBoss;

@end
