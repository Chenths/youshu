//
//  HTOrderHeadTableCell.m
//  YS_zhtx
//
//  Created by mac on 2018/10/15.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTOrderHeadTableCell.h"
@interface HTOrderHeadTableCell()

@property (weak, nonatomic) IBOutlet UILabel *orderNum;

@end
@implementation HTOrderHeadTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setModel:(HTOrderDetailModel *)model{
    _model = model;
    
    self.orderNum.text = [HTHoldNullObj getValueWithUnCheakValue:model.ordernum];
}



@end
