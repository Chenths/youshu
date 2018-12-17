//
//  HTNotAddImgProductCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/14.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTNotAddImgProductCell.h"
@interface HTNotAddImgProductCell()

@property (weak, nonatomic) IBOutlet UILabel *styleCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *categeryLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabe;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end
@implementation HTNotAddImgProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(HTProductStyleModel *)model{
    _model = model;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.topimg] placeholderImage:[UIImage imageNamed:@"g-goodsHoldImg"]];
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    self.styleCodeLabel.text = [NSString stringWithFormat:@"%@", [HTHoldNullObj getValueWithUnCheakValue:model.stylecode]];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithUnCheakValue:model.price]];
    if (model.category.allKeys.count > 0) {
        self.categeryLabel.text = [NSString stringWithFormat:@"%@",[HTHoldNullObj getValueWithUnCheakValue:[model.category getStringWithKey:@"name"]]];
    }else{
        self.categeryLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.categoryname];
    }
   
    self.timeLabe.text = [NSString stringWithFormat:@"%@  %@",[HTHoldNullObj getValueWithUnCheakValue:model.year], ![model.season isNull] ? [HTHoldNullObj getValueWithUnCheakValue:[model.season  getStringWithKey:@"name"]]: @""];
}
@end
