//
//  HTMeGoalsTableViewCell.h
//  YS_zhtx
//
//  Created by mac on 2018/6/4.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTMineModel.h"
#import <UIKit/UIKit.h>
#import "HTGoalsDescModel.h"
@protocol HTMeGoalsTableViewCellDelegate<NSObject>

-(void)yaerGoalClicked;
-(void)monthGoalClicked;
-(void)todayGoalClicked;

@end

@interface HTMeGoalsTableViewCell : UITableViewCell

@property (nonatomic,weak) id <HTMeGoalsTableViewCellDelegate> delegate;

@property (nonatomic,strong) HTMineModel *model;

@property (nonatomic,strong) HTGoalsDescModel *descM;

@end
