//
//  HTBossSaleBasicInfoCell.m
//  有术
//
//  Created by mac on 2018/4/16.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTWarningHoldManager.h"
#import "HTBossSaleBasicInfoCell.h"
@interface HTBossSaleBasicInfoCell()
@property (weak, nonatomic) IBOutlet UIImageView *holdImg;
@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *value1;
@property (weak, nonatomic) IBOutlet UILabel *title2;
@property (weak, nonatomic) IBOutlet UILabel *value2;
@property (weak, nonatomic) IBOutlet UILabel *title3;
@property (weak, nonatomic) IBOutlet UILabel *value3;


@property (weak, nonatomic) IBOutlet UIButton *wbt1;
@property (weak, nonatomic) IBOutlet UIButton *wbt2;
@property (weak, nonatomic) IBOutlet UIButton *wbt3;


@end
@implementation HTBossSaleBasicInfoCell

- (void)setModel:(HTBossReportBasciModel *)model{
    _model = model;
    self.title1.text = model.title1;
    self.title2.text = [NSString stringWithFormat:@"%@:", model.title2];
    self.title3.text = [NSString stringWithFormat:@"%@:", model.title3];
    self.value1.text =[NSString stringWithFormat:@"%@%@%@",model.prefix1,model.value1,model.suffix1
                       ];
    self.value2.text =[NSString stringWithFormat:@"%@%@%@",model.prefix2,model.value2,model.suffix2
                       ];
    self.value3.text =[NSString stringWithFormat:@"%@%@%@",model.prefix3,model.value3,model.suffix3
                       ];
    self.holdImg.image = [UIImage imageNamed:model.imgName];
    self.wbt1.hidden = YES;
    self.wbt2.hidden = YES;
    self.wbt3.hidden = YES;
    [self holdBt:self.wbt1 value:model.value1 andTitle:model.title1];
    [self holdBt:self.wbt2 value:model.value2 andTitle:model.title2];
    [self holdBt:self.wbt3 value:model.value3 andTitle:model.title3];
}
- (IBAction)warnClicked:(UIButton *)sender {
    if (sender == self.wbt1) {
        [HTWarningHoldManager holdWarningWithTitle:self.model.title1 andWarningValue:self.model.value1];
    }else if (sender == self.wbt2){
        [HTWarningHoldManager holdWarningWithTitle:self.model.title2 andWarningValue:self.model.value2];
    }else if (sender == self.wbt3){
        [HTWarningHoldManager holdWarningWithTitle:self.model.title3 andWarningValue:self.model.value3];
    }
}
-(void)holdBt:(UIButton *)bt  value:(NSString *)value andTitle:(NSString *)title{
    if ([title isEqualToString:@"折扣"] && value.floatValue < [HTShareClass shareClass].reportWarnStandard.zkl.floatValue) {
        bt.hidden = NO;
    }else if ([title isEqualToString:@"连带率"] && value.floatValue < [HTShareClass shareClass].reportWarnStandard.ldl.floatValue){
        bt.hidden = NO;
    }else if ([title isEqualToString:@"换货率"] && value.floatValue > [HTShareClass shareClass].reportWarnStandard.hhl.floatValue){
        bt.hidden = NO;
    }else if ([title isEqualToString:@"退货率"] && value.floatValue > [HTShareClass shareClass].reportWarnStandard.thl.floatValue){
        bt.hidden = NO;
    }else if ([title isEqualToString:@"VIP销售占比"] && value.floatValue < [HTShareClass shareClass].reportWarnStandard.vipgxl.floatValue){
        bt.hidden = NO;
    }
}



@end
