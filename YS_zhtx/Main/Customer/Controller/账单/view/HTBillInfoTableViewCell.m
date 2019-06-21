//
//  HTBillInfoTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2018/9/6.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "NSString+Atribute.h"
#import "HTBillInfoTableViewCell.h"
@interface HTBillInfoTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *typeImg;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLAbel;

@property (nonatomic,strong) NSArray *flowtypes;

@property (nonatomic,strong) NSArray *accounttypes;
@property (weak, nonatomic) IBOutlet UILabel *belongStore;

@end
@implementation HTBillInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.accounttypes = @[@"",@"储值",@"积分",@"储值赠送"];

    self.flowtypes = @[@"",@"充值",@"赠送",@"转入",@"转出",@"消费",@"扣除",@"批量充值",@"批量扣除",@"退款",@"批量赠送"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setModel:(HTBillInfoModel *)model{
    _model = model;
    self.typeLabel.text = [NSString stringWithFormat:@"%@ - (%@)",self.accounttypes[model.accounttype.integerValue],self.flowtypes[model.flowtype.integerValue]];
    self.dateLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.createdate];
    self.valueLAbel.text = [HTHoldNullObj getValueWithBigDecmalObj:model.amount];
    if (model.amount.floatValue > 0) {
        self.valueLAbel.textColor = [UIColor colorWithHexString:@"#222222"];
    }else{
        self.valueLAbel.textColor = [UIColor colorWithHexString:@"#F53434"];
    }
    self.typeImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_bill",self.accounttypes[model.accounttype.integerValue]]];
    self.belongStore.text = model.belongstore.length > 0 ? model.belongstore : @"暂无数据";
}

@end
