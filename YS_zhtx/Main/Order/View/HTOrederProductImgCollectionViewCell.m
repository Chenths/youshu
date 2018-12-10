//
//  HTOrederProductImgCollectionViewCell.m
//  有术
//
//  Created by mac on 2018/5/22.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTOrederProductImgCollectionViewCell.h"
@interface HTOrederProductImgCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *productImg;


@end
@implementation HTOrederProductImgCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setImgPath:(NSString *)imgPath{
    _imgPath = imgPath;
    [self.productImg sd_setImageWithURL:[NSURL URLWithString:imgPath] placeholderImage:[UIImage imageNamed:@"g-goodsHoldImg"]];
}
@end
