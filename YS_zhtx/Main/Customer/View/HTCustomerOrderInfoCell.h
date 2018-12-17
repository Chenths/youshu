//
//  HTCustomerOrderInfoCell.h
//  YS_zhtx
//
//  Created by mac on 2018/6/20.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTOrderListModel.h"
#import <UIKit/UIKit.h>
@class  HTCustomerOrderInfoCell;
@protocol HTCustomerOrderInfoCellDelegate <NSObject>

-(void)moreClickedWithCell:(HTCustomerOrderInfoCell *)cell;

-(void)timeClickedWithCell:(HTCustomerOrderInfoCell *)cell;

-(void)exchangeClickedWithCell:(HTCustomerOrderInfoCell *)cell;

-(void)printClickedWithCell:(HTCustomerOrderInfoCell *)cell;

@end
@interface HTCustomerOrderInfoCell : UITableViewCell

@property (nonatomic,strong) HTOrderListModel *model;

@property (nonatomic,weak) id <HTCustomerOrderInfoCellDelegate> delegate;

@end
