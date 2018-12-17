//
//  HTEditVipContinueBackListCell.h
//  YS_zhtx
//
//  Created by mac on 2018/8/28.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTContinueBackModel.h"
#import <UIKit/UIKit.h>
@class HTEditVipContinueBackListCell;
@protocol HTEditVipContinueBackListCellDelegate <NSObject>

-(void)deleteContinueBackWithCell:(HTEditVipContinueBackListCell *)cell;

@end

@interface HTEditVipContinueBackListCell : UITableViewCell

@property (nonatomic,strong) HTContinueBackModel *model;

@property (nonatomic,weak) id <HTEditVipContinueBackListCellDelegate> delegate;

@end
