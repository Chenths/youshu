//
//  HTChooseHeadImgCell.m
//  有术
//
//  Created by mac on 2017/11/3.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import "HTChooseHeadImgCell.h"

@interface HTChooseHeadImgCell()
@property (weak, nonatomic) IBOutlet UIImageView *backImg;

@property (weak, nonatomic) IBOutlet UIImageView *seletedImg;

//@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *decsLabel;

@end
@implementation HTChooseHeadImgCell

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)setModel:(HTFaceImgListModel *)model{
    _model = model;
  
    self.backImg.hidden = NO;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[HTHoldNullObj getValueWithUnCheakValue:model.path]] placeholderImage:[UIImage imageNamed:CUSTOMERHOLDIMG]];
    self.decsLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.create_time];
    if (model.isSelected) {
        self.seletedImg.hidden = NO;
        self.seletedImg.image = [UIImage imageNamed:@"singleSelected"];
    }else{
        self.seletedImg.hidden = YES;
    }
}
-(void)setChangeModel:(HTChangeHeadsModel *)changeModel{
    _changeModel = changeModel;
    if (changeModel.path.length == 0 && changeModel.create_time.length == 0) {
        self.backImg.hidden = YES;
        self.headImg.image = [UIImage imageNamed:@"加号 (1)"];
        self.decsLabel.text = @"添加";
        return;
    }
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[HTHoldNullObj getValueWithUnCheakValue:changeModel.path]] placeholderImage:[UIImage imageNamed:CUSTOMERHOLDIMG]];
    self.decsLabel.text = [HTHoldNullObj getValueWithUnCheakValue:changeModel.create_time];
    if (changeModel.isSelected) {
        self.seletedImg.hidden = NO;
        self.seletedImg.image = [UIImage imageNamed:@"singleSelected"];
    }else{
        self.seletedImg.hidden = YES;
    }
}

@end
