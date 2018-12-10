//
//  HTCustomerTitleView.m
//  有术
//
//  Created by mac on 2017/11/7.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import "HTCustomerTitleView.h"
@interface HTCustomerTitleView()
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UIImageView *sexImg;
@property (weak, nonatomic) IBOutlet UILabel *vipLevel;
@property (weak, nonatomic) IBOutlet UIView *levelView;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@end

@implementation HTCustomerTitleView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self.headImg changeCornerRadiusWithRadius:self.headImg.height / 2];
    [self.levelView changeCornerRadiusWithRadius:self.levelView.height *0.5];
    [self.levelView changeBorderStyleColor:[UIColor colorWithHexString:@"#999999"] withWidth:1];
}
- (void)setModel:(HTCustomerReportModel *)model{
    _model = model;
    self.nameLable.text = [HTHoldNullObj getValueWithUnCheakValue:model.baseMessage.name];
    self.sexImg.image = [[HTHoldNullObj getValueWithUnCheakValue:model.baseMessage.sex ] isEqualToString:@"1"] ? [UIImage imageNamed:@"g-man"] : [UIImage imageNamed:@"g-woman"];
    self.vipLevel.text = [HTHoldNullObj getValueWithUnCheakValue:model.baseMessage.custlevel];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.baseMessage.headimg] placeholderImage:[UIImage imageNamed:PRODUCTHOLDIMG]];
}




@end
