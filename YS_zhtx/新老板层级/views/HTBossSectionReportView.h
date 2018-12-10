//
//  HTBossSectionReportView.h
//  有术
//
//  Created by mac on 2018/4/18.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTSectionOpenModel.h"
@interface HTBossSectionReportView : UIView

- (instancetype)initWithSectionFrame:(CGRect)frame;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *openImg;
@property (weak, nonatomic) IBOutlet UIButton *sectionOpenBt;
@property (nonatomic,strong) HTSectionOpenModel *model;
@end
