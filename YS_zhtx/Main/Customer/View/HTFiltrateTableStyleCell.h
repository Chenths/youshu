//
//  HTFiltrateTableStyleCell.h
//  YS_zhtx
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTFiltrateNodeModel.h"
#import "HTIndexsModel.h"
#import <UIKit/UIKit.h>

@interface HTFiltrateTableStyleCell : UITableViewCell

@property (nonatomic,strong) HTFiltrateNodeModel *model;

@property (nonatomic,strong) HTIndexsModel *indexModel;

@end
