//
//  HTNewCustomCustomerCell.h
//  有术
//
//  Created by mac on 2017/12/19.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "HTPieCustModel.h"
#import "HTCustomerListModel.h"
@class HTNewCustomCustomerCell;
@protocol HTNewCustomCustomerCellDelegate <NSObject>

- (void)moreClickedOrderWithCell:(HTNewCustomCustomerCell *)cell;

@end
@interface HTNewCustomCustomerCell : UITableViewCell


@property (nonatomic,strong) NSDictionary *dataDic;

//@property (nonatomic,strong) HTPieCustModel *model;

@property (nonatomic,strong) HTCustomerListModel *model;

@property (nonatomic,weak) id <HTNewCustomCustomerCellDelegate> delegate;

@end
