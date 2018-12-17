//
//  HTBossSaleCompareDataInfoCell.m
//  有术
//
//  Created by mac on 2018/5/18.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTBossSaleCompareDataInfoCell.h"
@interface HTBossSaleCompareDataInfoCell()

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;


@end
@implementation HTBossSaleCompareDataInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%@",[dataDic getStringWithKey:@"price"]];
    self.countLabel.text = [NSString stringWithFormat:@"%@单%@件",[dataDic getStringWithKey:@"ordercount"],[dataDic getStringWithKey:@"salevolunme"]];
    
}

@end
