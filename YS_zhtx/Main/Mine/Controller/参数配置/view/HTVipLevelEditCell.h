//
//  HTVipLevelEditCell.h
//  有术
//
//  Created by mac on 2017/7/12.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

@class HTVipLevelEditCell;
@protocol HTVipLevelEditCellDelegate <NSObject>


- (void)heightValueChangeWithText:(NSString *) vlaue andCell:(HTVipLevelEditCell *)cell;

@end
#import <UIKit/UIKit.h>



#import "HTVipLevelSeterModel.h"


@interface HTVipLevelEditCell : UITableViewCell

@property (nonatomic,weak)  id <HTVipLevelEditCellDelegate > delegate;

@property (nonatomic,strong) HTVipLevelSeterModel *model;

@property (nonatomic,assign) BOOL isEdit;

@property (nonatomic,assign) BOOL isLatst;

@end
