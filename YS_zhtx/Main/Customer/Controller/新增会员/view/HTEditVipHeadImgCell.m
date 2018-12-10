//
//  HTEditVipHeadImgCell.m
//  YS_zhtx
//
//  Created by mac on 2018/8/27.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTEditVipHeadImgCell.h"
@interface HTEditVipHeadImgCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

@end
@implementation HTEditVipHeadImgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.headImgView changeCornerRadiusWithRadius:self.headImgView.height / 2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setHeadImg:(UIImage *)headImg{
    _headImg = headImg;
    self.headImgView.image = headImg;
}
-(void)setImgPath:(NSString *)imgPath{
    _imgPath = imgPath;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:imgPath] placeholderImage:[UIImage imageNamed:CUSTOMERHOLDIMG]];
}

@end
