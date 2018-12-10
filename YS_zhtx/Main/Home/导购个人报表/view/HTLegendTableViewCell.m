//
//  HTLegendTableViewCell.m
//  有术
//
//  Created by mac on 2018/4/16.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTWarningHoldManager.h"
#import "HTLegendTableViewCell.h"
@interface HTLegendTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *warningBt;

@property (weak, nonatomic) IBOutlet UIView *colorView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UILabel *presentLabel;

@end

@implementation HTLegendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.colorView.layer.masksToBounds = YES;
    self.colorView.layer.cornerRadius = 8;
}
- (void)setModel:(HTPieDataItem *)model{
    _model = model;
    self.colorView.backgroundColor = model.color;
   
    self.nameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.name];
    self.countLabel.text = [NSString stringWithFormat:@"%@%@",[HTHoldNullObj getValueWithBigDecmalObj:model.total],model.suffix];
    self.presentLabel.text = [NSString stringWithFormat:@"%@%@",[HTHoldNullObj getValueWithBigDecmalObj:model.data],@"%"];
   
    if ( [[HTHoldNullObj getValueWithUnCheakValue:model.name] rangeOfString:@"活跃会员"].length != 0) {
        if (model.data.floatValue < [HTShareClass shareClass].reportWarnStandard.hyhy.floatValue) {
            self.warningBt.hidden = NO;
        }else{
            self.warningBt.hidden = YES;
        }
    }
    
}
- (IBAction)warnClickeD:(id)sender {
    [HTWarningHoldManager holdWarningWithTitle:@"活跃会员" andWarningValue:self.model.data];
}

@end
