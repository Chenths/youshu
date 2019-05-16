//
//  HTBossInfoHeaderCell.h
//  有术
//
//  Created by mac on 2018/4/10.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTAgencyMainDataModel.h"
#import <UIKit/UIKit.h>

@interface HTBossInfoHeaderCell : UITableViewCell

@property (nonatomic,strong) HTAgencyMainDataModel *model;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (nonatomic, assign) NSInteger timeType;
@property (weak, nonatomic) IBOutlet UIImageView *whiteArrowImv;
@end
