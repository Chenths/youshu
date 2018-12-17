//
//  HTAgeAndeSexInfoReportCell.h
//  YS_zhtx
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTPiesModel.h"
#import <UIKit/UIKit.h>

@interface HTAgeAndeSexInfoReportCell : UITableViewCell

@property (nonatomic,strong) HTPiesModel *sexModel;

@property (nonatomic,strong) HTPiesModel *ageModel;

@property (nonatomic,strong) NSString *companyId;

@property (nonatomic,strong) NSString *userId;

-(void)createSubWithAgelist:(NSArray *)agelist andSexList:(NSArray *)sexList;

@end
