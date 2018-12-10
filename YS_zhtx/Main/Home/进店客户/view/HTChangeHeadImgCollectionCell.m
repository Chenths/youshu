//
//  HTChangeHeadImgCollectionCell.m
//  有术
//
//  Created by mac on 2018/1/30.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "UIButton+WebCache.h"
#import "HTChangeHeadImgCollectionCell.h"

@interface HTChangeHeadImgCollectionCell()

@property (weak, nonatomic) IBOutlet UIButton *imgBt;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *holdImg;

@end


@implementation HTChangeHeadImgCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgBt.userInteractionEnabled = NO;
    // Initialization code
}

-(void)setModel:(HTChangeHeadsModel *)model{
    _model = model;
    [self.imgBt sd_setBackgroundImageWithURL:[NSURL URLWithString:model.path] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:CUSTOMERHOLDIMG]];
    self.dateLabel.text = model.create_time;
   // self.holdImg.hidden = !model.isOldHead;
    if (model.isOldHead) {
        self.holdImg.image = [UIImage imageNamed:@"删除_custome"];
    }else{
        self.holdImg.image = [UIImage imageNamed:@"editHead"];
    }
}

@end
