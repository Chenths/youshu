//
//  HTLineDataReportTableViewCell.h
//  YS_zhtx
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTCustomersInfoReprotModel.h"
#import <UIKit/UIKit.h>
@protocol HTLineDataReportTableViewCellDelegate <NSObject>

-(void)dateClicked;


@end

@interface HTLineDataReportTableViewCell : UITableViewCell

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,weak) id <HTLineDataReportTableViewCellDelegate>delegate;

@property (nonatomic,strong) HTCustomersInfoReprotModel *model;

@property (nonatomic,assign) BOOL isDefual;

@end
