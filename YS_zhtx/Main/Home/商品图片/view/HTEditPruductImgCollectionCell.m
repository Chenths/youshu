//
//  HTEditPruductImgCollectionCell.m
//  有术
//
//  Created by mac on 2018/6/27.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTEditPruductImgCollectionCell.h"

@interface HTEditPruductImgCollectionCell()

@property (weak, nonatomic) IBOutlet UIImageView *productImg;

@property (weak, nonatomic) IBOutlet UIButton *selectedBt;


@end
@implementation HTEditPruductImgCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.productImg.contentMode = UIViewContentModeScaleAspectFit;
}

-(void)setIsEdit:(BOOL)isEdit{
    _isEdit = isEdit;
    self.selectedBt.hidden = !isEdit;
}
-(void)setModel:(HTPostImageModel *)model{
    _model = model;
    
    [self.productImg sd_setImageWithURL:[NSURL URLWithString:model.imageSeverUrl] placeholderImage:[UIImage imageNamed:@"g-goodsHoldImg"]];
    if (model.isSeleted) {
        self.productImg.layer.borderColor = [UIColor colorWithHexString:@"#222222"].CGColor;
        self.productImg.layer.borderWidth = 1;
        [self.selectedBt setBackgroundImage:[UIImage imageNamed:@"单选-选中"] forState:UIControlStateNormal];
    }else{
        self.productImg.layer.borderColor = [UIColor clearColor].CGColor;
        self.productImg.layer.borderWidth = 1;
        [self.selectedBt setBackgroundImage:[UIImage imageNamed:@"单选-未选中"] forState:UIControlStateNormal];
    }
}

@end
