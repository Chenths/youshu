//
//  HTGuiderDateSaleSurveyCell.h
//  YS_zhtx
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTDateSaleDescModel.h"
#import "HTGuiderReportModel.h"
#import <UIKit/UIKit.h>

@interface HTGuiderDateSaleSurveyCell : UITableViewCell

@property (nonatomic,strong) HTDateSaleDescModel *model;

@property (nonatomic,strong) HTGuiderReportModel *guideModel;

@end
