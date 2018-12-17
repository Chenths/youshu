//
//  HTPostProductDescInfoCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/14.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTPostProductDescInfoCell.h"

@interface HTPostProductDescInfoCell()

@property (weak, nonatomic) IBOutlet UIButton *productImg;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *categreLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *seasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *holdImg;


@end
@implementation HTPostProductDescInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(HTProductStyleModel *)model{
    _model = model;
//    [self.productImg sd_setImageWithURL:[NSURL URLWithString:model.topimg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"g-goodsHoldImg"]];
    [self.productImg sd_setBackgroundImageWithURL:[NSURL URLWithString:model.topimg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"g-goodsHoldImg"]];
    self.productImg.contentMode = UIViewContentModeScaleAspectFit;
    self.categreLabel.text = [HTHoldNullObj getValueWithUnCheakValue: [model.category getStringWithKey:@"name"] ];
    self.priceLabel.text = [HTHoldNullObj getValueWithUnCheakValue:[NSString stringWithFormat:@"¥%@",model.price]];
    
    self.yearLabel.attributedText = [self getAttFormBehindStr:@"年份 " behindColor:[UIColor colorWithHexString:@"#999999"] andEndStr:model.year endColor:[UIColor colorWithHexString:@"#222222"]];
    
    self.codeLabel.attributedText = [self getAttFormBehindStr:@"款号 " behindColor:[UIColor colorWithHexString:@"#999999"] andEndStr:model.stylecode endColor:[UIColor colorWithHexString:@"#222222"]];
    self.seasonLabel.attributedText = [self getAttFormBehindStr:@"季节 " behindColor:[UIColor colorWithHexString:@"#999999"] andEndStr:[model.season getStringWithKey:@"name"] endColor:[UIColor colorWithHexString:@"#222222"]];
    self.sizeLabel.text = [HTHoldNullObj getValueWithUnCheakValue:self.model.sizegroup];
}
-(NSMutableAttributedString *)getAttFormBehindStr:(NSString *)behind behindColor:(UIColor *)behindColor andEndStr:(NSString *)end endColor:(UIColor *)endColor{
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",behind,end]];
    [str2 addAttribute:NSForegroundColorAttributeName value:behindColor range:NSMakeRange(0, behind.length)];
    return str2;
}
-(void)setControllerType:(ControllerType)controllerType{
    _controllerType = controllerType;
    if (_controllerType == ControllerCoverEdit) {
        self.productImg.enabled = NO;
        self.holdImg.hidden = YES;
    }else{
        self.productImg.enabled = YES;
        self.holdImg.hidden = NO;
    }
}
- (IBAction)topImgClicked:(id)sender {
    if (self.delegate) {
        [self.delegate topBtClick];
    }
}

@end
