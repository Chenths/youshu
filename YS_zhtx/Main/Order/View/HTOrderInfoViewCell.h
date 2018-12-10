//
//  HTOrderInfoViewCell.h
//  YS_zhtx
//
//  Created by mac on 2018/6/4.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTOrderListModel.h"
#import <UIKit/UIKit.h>
@class HTOrderInfoViewCell;
@protocol  HTOrderInfoViewCellDelegate<NSObject>

-(void)moreClickedWithCell:(HTOrderInfoViewCell *)cell;

-(void)timeClickedWithCell:(HTOrderInfoViewCell *)cell;

-(void)exchangeClickedWithCell:(HTOrderInfoViewCell *)cell;

-(void)printClickedWithCell:(HTOrderInfoViewCell *)cell;


@end
@interface HTOrderInfoViewCell : UITableViewCell

@property (nonatomic,assign) BOOL showImg;

@property (nonatomic,strong) HTOrderListModel *model;

@property (nonatomic,weak) id <HTOrderInfoViewCellDelegate> delegate;

@end
