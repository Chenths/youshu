//
//  HTOrderProductInfoCollectionCell.m
//  YS_zhtx
//
//  Created by mac on 2018/7/2.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTOrderOrProductState.h"
#import "HTOrderProductInfoCollectionCell.h"

@interface HTOrderProductInfoCollectionCell()

@property (weak, nonatomic) IBOutlet UIImageView *productImg;
@property (weak, nonatomic) IBOutlet UIImageView *stateImg;

@end

@implementation HTOrderProductInfoCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setModel:(HTOrderListProductModel *)model{
    _model = model;
    [self.productImg sd_setImageWithURL:[NSURL URLWithString:model.productImage] placeholderImage:[UIImage imageNamed:@"g-goodsHoldImg"]];
    if ([[HTOrderOrProductState getProductStateFormOrderString:model.state] isEqualToString:@"NORMAL"]) {
        self.stateImg.hidden = YES;
    }else{
      self.stateImg.hidden = NO;
      self.stateImg.image = [UIImage imageNamed:[HTOrderOrProductState getProductStateFormOrderString:model.state]];
    }
    
}
@end
