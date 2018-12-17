//
//  HTTurnInNumbersCell.h
//  YS_zhtx
//
//  Created by mac on 2018/6/11.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTTuneOutorInModel.h"
#import "HTTuneOutOrInController.h"
#import <UIKit/UIKit.h>

@interface HTTurnInNumbersCell : UITableViewCell

@property (nonatomic,assign) HTTurnOutOrInType type;

@property (nonatomic,strong) HTTuneOutorInModel *model;

@end
