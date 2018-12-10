//
//  HTProductInfoTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/12.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTProductInfoTableViewCell.h"
@interface HTProductInfoTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *barcode;
@property (weak, nonatomic) IBOutlet UIImageView *productImg;
@property (weak, nonatomic) IBOutlet UILabel *category;
@property (weak, nonatomic) IBOutlet UILabel *yearAndSeason;
@property (weak, nonatomic) IBOutlet UILabel *color;
@property (weak, nonatomic) IBOutlet UILabel *size;

@end
@implementation HTProductInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(HTTurnListDetailProductModel *)model{
    _model = model;
    self.number.text = [NSString stringWithFormat:@"X%@",model.count];
    self.barcode.text = [HTHoldNullObj getValueWithUnCheakValue:model.styleCode];
    [self.productImg sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:PRODUCTHOLDIMG]];
    self.category.text = [HTHoldNullObj getValueWithUnCheakValue:model.categories];
    self.yearAndSeason.text = [HTHoldNullObj getValueWithUnCheakValue:model.year];
    self.color.text = [HTHoldNullObj getValueWithUnCheakValue:model.color];
    self.size.text = [HTHoldNullObj getValueWithUnCheakValue:model.size];
}
@end
