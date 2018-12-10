//
//  HTOrderInfoViewCell.h
//  YS_zhtx
//
//  Created by mac on 2018/6/4.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTOrderListModel.h"
#import "HTOnlineOrderListModel.h"
#import <UIKit/UIKit.h>
@class HTOnlineOrderInfoViewCell;
@protocol HTOnlineOrderInfoViewCellDelegate <NSObject>

-(void)cancelOrderClick:(HTOnlineOrderInfoViewCell *)cell;

-(void)startSendOrderClick:(HTOnlineOrderInfoViewCell *)cell;

@end

@interface HTOnlineOrderInfoViewCell : UITableViewCell

@property (nonatomic,assign) BOOL showImg;

@property (nonatomic,strong)  NSString *orderState;

@property (nonatomic,strong) HTOrderListModel *model;

@property (nonatomic,strong) HTOnlineOrderListModel *onlineModel;

@property (nonatomic,weak) id <HTOnlineOrderInfoViewCellDelegate> delegate;

@end
