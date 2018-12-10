//
//  HTCustomerTitleView.m
//  有术
//
//  Created by mac on 2017/11/7.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import "HTCashierCustomerTitleView.h"
@interface HTCashierCustomerTitleView()


@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@end

@implementation HTCashierCustomerTitleView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self.headImg changeCornerRadiusWithRadius:self.headImg.height / 2];
}
-(void)setModel:(HTCustModel *)model{
    _model = model;
    self.nameLable.text = [HTHoldNullObj getValueWithUnCheakValue:model.nickname];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:PRODUCTHOLDIMG]];
}
//- (void)setModel:(HTSingleVipDataModel *)model{
//    _model = model;
//    NSDictionary *baseDic = model.baseMessage;
//    self.nameLable.text = [baseDic getStringWithKey:@"name"];
//     self.sexImg.image = [[baseDic getStringWithKey:@"sex"] isEqualToString:@"1"] ? [UIImage imageNamed:@"man"] : [UIImage imageNamed:@"nv"];
//    self.vipLevel.text = [baseDic getStringWithKey:@"customertype"];
//}




@end
