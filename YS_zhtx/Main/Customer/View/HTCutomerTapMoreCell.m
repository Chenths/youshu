//
//  HTCutomerTapMoreCell.m
//  有术
//
//  Created by mac on 2017/12/20.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import "HTCutomerTapMoreCell.h"

@interface  HTCutomerTapMoreCell()


@property (weak, nonatomic) IBOutlet UIImageView *handImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end


@implementation HTCutomerTapMoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
    
    self.handImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_custome",title ]];
}
@end
