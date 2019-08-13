//
//  HTBossGoodsDetailHeadTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2019/7/31.
//  Copyright © 2019 有术-新零售. All rights reserved.
//

#import "HTBossGoodsDetailHeadTableViewCell.h"

@implementation HTBossGoodsDetailHeadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _isShowDetail = 0;
    _secondViewHeight.constant = 0;
    _secondView.hidden = YES;
    _bottomLabel.text = @"查看更多";
    _bottomImv.image = [UIImage imageNamed:@"boss-down"];
    _imageViewHeight.constant = HMSCREENWIDTH;
    // Initialization code
}
- (IBAction)touchBottomAction:(id)sender {
    NSLog(@"点击收起或展开");
    if (_isShowDetail == 0) {
        _isShowDetail = 1;
        _secondViewHeight.constant = 260;
        _secondView.hidden = NO;
        _bottomLabel.text = @"向上收起";
        _bottomImv.image = [UIImage imageNamed:@"boss-up"];
    }else{
        _isShowDetail = 0;
        _secondViewHeight.constant = 0;
        _secondView.hidden = YES;
        _bottomLabel.text = @"查看更多";
        _bottomImv.image = [UIImage imageNamed:@"boss-down"];
    }
    if (self.delegate) {
        [self.delegate bossGoodRefreshDelegateAction];
    }
}

- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:dataDic];
    NSArray *keyArr = [tempDic allKeys];
    for (NSString *tempKey in keyArr) {
        id tempValue = [tempDic objectForKey:tempKey];
        if (tempValue == nil || [tempValue isEqualToString:@""]) {
            [tempDic setObject:@"--" forKey:tempKey];
        }else if ([tempValue isKindOfClass:[NSNumber class]]){
            [tempDic setObject:[tempValue stringValue] forKey:tempKey];
        }else{
            
        }
    }
    _dataDic = [NSDictionary dictionaryWithDictionary:tempDic];
    [_headImv sd_setImageWithURL:[NSURL URLWithString:[_dataDic objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"clothesPlaceHolder"]];
    _name.text = [_dataDic objectForKey:@"productname"];
    _price.text = [NSString stringWithFormat:@"¥%@", [_dataDic objectForKey:@"price"]];
    _kuanhao.text = [_dataDic objectForKey:@"stylecode"];
    _gongyingshang.text = [_dataDic objectForKey:@"suppliername"];
    _pinpai.text = [_dataDic objectForKey:@"brandname"];
    _nianfen.text = [_dataDic objectForKey:@"year"];
    _jijie.text = [_dataDic objectForKey:@"season"];
    _mingcheng.text = [_dataDic objectForKey:@"productname"];
    _mianliao.text = [_dataDic objectForKey:@"fabric"];
    _liliao.text = [_dataDic objectForKey:@"lining"];
    _peiliao.text = [_dataDic objectForKey:@"accessory"];
    _dengji.text = [_dataDic objectForKey:@"level"];
    _jianyanyuan.text = [_dataDic objectForKey:@"iqc"];
    _biaozhun.text = [_dataDic objectForKey:@"standard"];
    _danjia.text = [NSString stringWithFormat:@"¥%@", [_dataDic objectForKey:@"price"]];
    _tongyilingshou.text = [NSString stringWithFormat:@"¥%@", [_dataDic objectForKey:@"unityprice"]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
