//
//  HTOrderHeadTableCell.m
//  YS_zhtx
//
//  Created by mac on 2018/10/15.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTOrderHeadTableCell.h"
#import "HTOrderDetailProductModel.h"
@interface HTOrderHeadTableCell()

@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *guideLabel;

@end
@implementation HTOrderHeadTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setModel:(HTOrderDetailModel *)model{
    _model = model;
    
    self.orderNum.text = [NSString stringWithFormat:@"订单号:%@", [HTHoldNullObj getValueWithUnCheakValue:model.ordernum]];
    HTOrderDetailProductModel *productModel = model.product.firstObject;
    self.guideLabel.text = [NSString stringWithFormat:@"导购:%@", [HTHoldNullObj getValueWithUnCheakValue:productModel.guidename]];
}



@end
