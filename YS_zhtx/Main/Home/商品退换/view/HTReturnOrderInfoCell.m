//
//  HTReturnOrderInfoCell.m
//  有术
//
//  Created by mac on 2018/5/16.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTReturnOrderInfoCell.h"

@interface HTReturnOrderInfoCell()
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *gudeName;

@end
@implementation HTReturnOrderInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    self.orderNumLabel.text = [dataDic getStringWithKey:@"ordernum"];
    self.createTime.text = [dataDic getStringWithKey:@"create_date"];
    self.gudeName.text = [dataDic getStringWithKey:@"creator"];
}
-(void)setModel:(HTOrderDetailModel *)model{
    _model = model;
    self.orderNumLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.ordernum];
    self.createTime.text = [HTHoldNullObj getValueWithUnCheakValue:model.createdate];
    self.gudeName.text = [HTHoldNullObj getValueWithUnCheakValue:model.creator];
}
@end
