//
//  HTChangePriceCustomerInfoCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/15.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTChangePriceCustomerInfoCell.h"
@interface HTChangePriceCustomerInfoCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImg;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UIView *levelBack;


@end
@implementation HTChangePriceCustomerInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.levelBack changeCornerRadiusWithRadius:self.levelBack.height / 2];
    [self.levelBack changeBorderStyleColor:[UIColor colorWithHexString:@"#999999"] withWidth:1];
    [self.headImg changeCornerRadiusWithRadius:self.headImg.height / 2];
}
-(void)setCust:(HTCustModel *)cust{
    _cust = cust;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:cust.headImg] placeholderImage:[UIImage imageNamed:@"g-customerholdImg"]];
    self.nameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:cust.nickname];
    self.sexImg.image = [UIImage imageNamed:[[HTHoldNullObj getValueWithUnCheakValue:cust.sex] isEqualToString:@"1"] ? @"g-man" :@"g-woman"];
    self.levelLabel.text = [HTHoldNullObj getValueWithUnCheakValue:cust.custlevel];
    self.phoneLabel.text = [HTHoldNullObj getValueWithUnCheakValue:cust.phone];
    self.discountLabel.text = [NSString stringWithFormat:@"%@" ,cust.discount.floatValue == 0 ? @"0折" : cust.discount.floatValue < 0 ? @"／折" : [NSString stringWithFormat:@"%.1lf折",[HTHoldNullObj getValueWithUnCheakValue:cust.discount].floatValue * 10]];
}

@end
