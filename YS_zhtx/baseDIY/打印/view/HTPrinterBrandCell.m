//
//  HTPrinterBrandCell.m
//  有术
//
//  Created by mac on 2017/5/2.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import "HTPrinterBrandCell.h"
@interface HTPrinterBrandCell()

@property (weak, nonatomic) IBOutlet UIImageView *brandImg;
@property (weak, nonatomic) IBOutlet UIImageView *seltctedImg;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end;

@implementation HTPrinterBrandCell

- (void)setModel:(HTPrinterBrandModel *)model{
    _model = model;
    self.brandImg.image = [UIImage imageNamed:model.imgName];
    self.brandImg.contentMode = UIViewContentModeScaleAspectFit;
    self.seltctedImg.image = model.isSelected ? [UIImage imageNamed:@"singleSelected"] : [UIImage imageNamed:@"singleUnselected"];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.title];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
