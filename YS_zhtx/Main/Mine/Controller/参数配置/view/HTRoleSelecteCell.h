//
//  HTRoleSelecteCell.h
//  有术
//
//  Created by mac on 2017/7/12.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTNoticpushSeterModel.h"
#import "HTNoticePushSetionModel.h"
@class HTRoleSelecteCell;
@protocol HTRoleSelecteCellDelegate <NSObject>

-(void)topBtClicked;

-(void) okBtClickedWithCell:(HTRoleSelecteCell *)cell;

@end

@interface HTRoleSelecteCell : UITableViewCell

@property (nonatomic,strong) HTNoticpushSeterModel *model;

@property (nonatomic,strong) HTNoticePushSetionModel *sectionModel;

@property (nonatomic,weak) id <HTRoleSelecteCellDelegate> delegate;

@end
