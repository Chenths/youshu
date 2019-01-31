//
//  HTNewPayPayNormalKindTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2019/1/11.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import "HTNewPayPayNormalKindTableViewCell.h"
@interface HTNewPayPayNormalKindTableViewCell(){
    NSMutableArray *btnArr;
}

@end
@implementation HTNewPayPayNormalKindTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)chuzhiAction:(id)sender {
    if (_type == 3) {
        [MBProgressHUD showError:@"非会员不可使用"];
        return;
    }
    
    [_chuzhiBtn setImage:[UIImage imageNamed:@"npzhifu1"] forState:UIControlStateNormal];
    [_chuzengBtn setImage:[UIImage imageNamed:@"npzhifu2n"] forState:UIControlStateNormal];
    [_weixinBtn setImage:[UIImage imageNamed:@"npzhifu3n"] forState:UIControlStateNormal];
    [_zhifubaoBtn setImage:[UIImage imageNamed:@"npzhifu4n"] forState:UIControlStateNormal];
    [_xianjinBtn setImage:[UIImage imageNamed:@"npzhifu5n"] forState:UIControlStateNormal];
    [_shuakaBtn setImage:[UIImage imageNamed:@"npzhifu6n"] forState:UIControlStateNormal];
    if (self.delegate) {
        [self.delegate clickBtn:@"1"];
    }
}

- (IBAction)chuzengAction:(id)sender {
    if (_type == 3) {
        [MBProgressHUD showError:@"非会员不可使用"];
        return;
    }else if (_type == 2){
        [MBProgressHUD showError:@"当前店铺不可使用"];
        return;
    }
    [_chuzhiBtn setImage:[UIImage imageNamed:@"npzhifu1n"] forState:UIControlStateNormal];
    [_chuzengBtn setImage:[UIImage imageNamed:@"npzhifu2"] forState:UIControlStateNormal];
    [_weixinBtn setImage:[UIImage imageNamed:@"npzhifu3n"] forState:UIControlStateNormal];
    [_zhifubaoBtn setImage:[UIImage imageNamed:@"npzhifu4n"] forState:UIControlStateNormal];
    [_xianjinBtn setImage:[UIImage imageNamed:@"npzhifu5n"] forState:UIControlStateNormal];
    [_shuakaBtn setImage:[UIImage imageNamed:@"npzhifu6n"] forState:UIControlStateNormal];
    if (self.delegate) {
        [self.delegate clickBtn:@"2"];
    }
}

- (IBAction)weixinAction:(id)sender {
    [_chuzhiBtn setImage:[UIImage imageNamed:@"npzhifu1n"] forState:UIControlStateNormal];
    [_chuzengBtn setImage:[UIImage imageNamed:@"npzhifu2n"] forState:UIControlStateNormal];
    [_weixinBtn setImage:[UIImage imageNamed:@"npzhifu3"] forState:UIControlStateNormal];
    [_zhifubaoBtn setImage:[UIImage imageNamed:@"npzhifu4n"] forState:UIControlStateNormal];
    [_xianjinBtn setImage:[UIImage imageNamed:@"npzhifu5n"] forState:UIControlStateNormal];
    [_shuakaBtn setImage:[UIImage imageNamed:@"npzhifu6n"] forState:UIControlStateNormal];
    if (self.delegate) {
        [self.delegate clickBtn:@"3"];
    }
}

- (IBAction)zhifubaoAction:(id)sender {
    [_chuzhiBtn setImage:[UIImage imageNamed:@"npzhifu1n"] forState:UIControlStateNormal];
    [_chuzengBtn setImage:[UIImage imageNamed:@"npzhifu2n"] forState:UIControlStateNormal];
    [_weixinBtn setImage:[UIImage imageNamed:@"npzhifu3n"] forState:UIControlStateNormal];
    [_zhifubaoBtn setImage:[UIImage imageNamed:@"npzhifu4"] forState:UIControlStateNormal];
    [_xianjinBtn setImage:[UIImage imageNamed:@"npzhifu5n"] forState:UIControlStateNormal];
    [_shuakaBtn setImage:[UIImage imageNamed:@"npzhifu6n"] forState:UIControlStateNormal];
    if (self.delegate) {
        [self.delegate clickBtn:@"4"];
    }
}

- (IBAction)xianjinAction:(id)sender {
    [_chuzhiBtn setImage:[UIImage imageNamed:@"npzhifu1n"] forState:UIControlStateNormal];
    [_chuzengBtn setImage:[UIImage imageNamed:@"npzhifu2n"] forState:UIControlStateNormal];
    [_weixinBtn setImage:[UIImage imageNamed:@"npzhifu3n"] forState:UIControlStateNormal];
    [_zhifubaoBtn setImage:[UIImage imageNamed:@"npzhifu4n"] forState:UIControlStateNormal];
    [_xianjinBtn setImage:[UIImage imageNamed:@"npzhifu5"] forState:UIControlStateNormal];
    [_shuakaBtn setImage:[UIImage imageNamed:@"npzhifu6n"] forState:UIControlStateNormal];
    if (self.delegate) {
        [self.delegate clickBtn:@"5"];
    }
}
- (IBAction)shuakaAction:(id)sender {
    [_chuzhiBtn setImage:[UIImage imageNamed:@"npzhifu1n"] forState:UIControlStateNormal];
    [_chuzengBtn setImage:[UIImage imageNamed:@"npzhifu2n"] forState:UIControlStateNormal];
    [_weixinBtn setImage:[UIImage imageNamed:@"npzhifu3n"] forState:UIControlStateNormal];
    [_zhifubaoBtn setImage:[UIImage imageNamed:@"npzhifu4n"] forState:UIControlStateNormal];
    [_xianjinBtn setImage:[UIImage imageNamed:@"npzhifu5n"] forState:UIControlStateNormal];
    [_shuakaBtn setImage:[UIImage imageNamed:@"npzhifu6"] forState:UIControlStateNormal];
    if (self.delegate) {
        [self.delegate clickBtn:@"6"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
