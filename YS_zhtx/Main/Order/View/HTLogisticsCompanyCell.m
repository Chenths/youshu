//
//  HTLogisticsCompanyCell.m
//  有术
//
//  Created by mac on 2016/12/12.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//
//#import "UIImageView+WebCache.h"
#import "HTLogisticsCompanyCell.h"
@interface  HTLogisticsCompanyCell()

@property (weak, nonatomic) IBOutlet UIImageView *companyImage;

@property (weak, nonatomic) IBOutlet UILabel *campanyName;

@property (weak, nonatomic) IBOutlet UIImageView *isSelectedImage;

@end
@implementation HTLogisticsCompanyCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setModel:(HTLogisticsCompanyModle *)model{
    _model = model;
    NSURL *imageUrl = [NSURL URLWithString:model.companyImgUrl];
    [self.companyImage sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"express_img"]];
    self.campanyName.text = model.companyName;
    if (model.isSelected) {
        self.isSelectedImage.image = [UIImage imageNamed:@"singleSelected"];
    }else{
         self.isSelectedImage.image = [UIImage imageNamed:@"singleUnselected"];
    }
    
    
}


@end
