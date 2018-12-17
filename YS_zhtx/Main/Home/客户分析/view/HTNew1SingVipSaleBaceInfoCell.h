//
//  HTNew1SingVipSaleBaceInfoCell.h
//  有术
//
//  Created by mac on 2017/11/6.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//
//#import "HTSingleVipDataModel.h"
#import "HTCustomerReprotSaleMsgModel.h"
#import <UIKit/UIKit.h>

@protocol HTNewSingVipSaleBaceInfoCellDelegate <NSObject>

- (void)buyNumsClicked;

- (void)buyProductNumsClicked;

@end
@interface HTNew1SingVipSaleBaceInfoCell : UITableViewCell

@property (nonatomic,strong) HTCustomerReprotSaleMsgModel *model;

@property (nonatomic,weak) id <HTNewSingVipSaleBaceInfoCellDelegate> delegate;



@end
