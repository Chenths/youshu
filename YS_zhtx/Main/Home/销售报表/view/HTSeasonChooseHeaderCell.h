//
//  HTSeasonChooseHeaderCell.h
//  YS_zhtx
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTShopSaleReportModel.h"
#import <UIKit/UIKit.h>

@protocol HTSeasonChooseHeaderCellDelegate <NSObject>

-(void)selectedSeasonWithIndex:(NSInteger)index;

@end
@interface HTSeasonChooseHeaderCell : UITableViewCell

@property (nonatomic,weak) id <HTSeasonChooseHeaderCellDelegate> delegate;

@property (nonatomic,strong) HTShopSaleReportModel *model;

@end
