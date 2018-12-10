//
//  HTMultierContrastHistoryCell.h
//  有术
//
//  Created by mac on 2018/4/16.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTBossCompareDataModel.h"
#import <UIKit/UIKit.h>
@class HTMultierContrastHistoryCell;
@protocol  HTMultierContrastHistoryCellDelegate<NSObject>
-(void) deleteClicked:(HTMultierContrastHistoryCell *)cell;
@end

@interface HTMultierContrastHistoryCell : UITableViewCell

@property (nonatomic,strong) HTBossCompareDataModel *model;
@property (nonatomic,weak) id <HTMultierContrastHistoryCellDelegate> delegate;

@end
