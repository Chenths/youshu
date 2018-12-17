//
//  HTProductInfoTableCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/11.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "NSString+Atribute.h"
#import "HTProductInfoTableCell.h"
@interface HTProductInfoTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *yearCode;
@property (weak, nonatomic) IBOutlet UILabel *seasonCode;
@property (weak, nonatomic) IBOutlet UILabel *finallPrice;
@property (weak, nonatomic) IBOutlet UILabel *styleCode;
@property (weak, nonatomic) IBOutlet UIImageView *productImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;

@end
@implementation HTProductInfoTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(HTStyleInventoryModel *)model{
    _model = model;
   
    self.yearCode.attributedText =  [[NSString stringWithFormat:@"年份 %@",[HTHoldNullObj getValueWithUnCheakValue:model.year]] getAttFormBehindStr:@"年份" behindColor:[UIColor colorWithHexString:@"#999999"]];
    self.seasonCode.attributedText = [[NSString stringWithFormat:@"季节 %@",[HTHoldNullObj getValueWithUnCheakValue:model.season]] getAttFormBehindStr:@"季节" behindColor:[UIColor colorWithHexString:@"#999999"]];
     self.styleCode.attributedText = [[NSString stringWithFormat:@"款号 %@",[HTHoldNullObj getValueWithUnCheakValue:model.styleCode]] getAttFormBehindStr:@"款号" behindColor:[UIColor colorWithHexString:@"#999999"]];
    self.nameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.productName];
    self.finallPrice.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.price]];
    [self.productImg sd_setImageWithURL:[NSURL URLWithString:model.productImg] placeholderImage:[UIImage imageNamed:PRODUCTHOLDIMG]];
    self.colorLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.color];
}

@end
