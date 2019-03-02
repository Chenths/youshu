//
//  HTNewPieCellTableViewCell.h
//  有术
//
//  Created by mac on 2018/4/16.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTPiesModel.h"
#import <UIKit/UIKit.h>
@class HTNewPieCellTableViewCell;
@protocol HTNewPieCellTableViewCellDelegate <NSObject>

-(void)seemoreClickedWithCell:(HTNewPieCellTableViewCell *)cell;

@end
@interface HTNewPieCellTableViewCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,strong) NSArray *dataArr;

@property (nonatomic,assign) BOOL isBoos;

@property (nonatomic,strong) HTPiesModel *model;

@property (nonatomic,strong) NSString *companyId;

@property (nonatomic,strong) NSString *userId;

@property (nonatomic,strong) NSString *beginTime;

@property (nonatomic,strong) NSString *endTime;
//如果是库存页面 老板层级 不可点击
@property (nonatomic, assign) BOOL isFromInventoryInfo;

@property (nonatomic,weak) id <HTNewPieCellTableViewCellDelegate> delegate;

@end
