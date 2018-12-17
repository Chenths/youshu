//
//  HTFiltrateCollectionStyleCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTFiltrateCollectionStyleCell.h"

@interface HTFiltrateCollectionStyleCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *titleBackView;

@end
@implementation HTFiltrateCollectionStyleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.titleBackView changeCornerRadiusWithRadius:5];
}

- (void)setModel:(HTFiltrateNodeModel *)model{
    _model = model;
    self.titleLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.title];
    if (!model.isSelected) {
        self.titleBackView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
         [self.titleBackView changeBorderStyleColor:[UIColor colorWithHexString:@"#f8f8f8"] withWidth:1];
    }else{
        self.titleBackView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        [self.titleBackView changeBorderStyleColor:[UIColor colorWithHexString:@"#000000"] withWidth:1];
    }
}

@end
