//
//  HTFastOrderStaueDetailCell.m
//  有术
//
//  Created by mac on 2018/5/22.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTFastOrderStaueDetailCell.h"
@interface HTFastOrderStaueDetailCell()

@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;



@end
@implementation HTFastOrderStaueDetailCell

- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    self.orderNum.text = [dataDic getStringWithKey:@"ordernum"];
    self.orderStateLabel.text = [[dataDic getDictionArrayWithKey:@"orderstatus"] getStringWithKey:@"name"];
}
-(void)setModel:(HTOrderDetailModel *)model{
    _model = model;
    self.orderNum.text = [HTHoldNullObj getValueWithUnCheakValue:model.ordernum];
    self.orderStateLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.orderstatus];
}


@end
