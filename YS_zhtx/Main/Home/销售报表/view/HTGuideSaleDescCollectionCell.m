//
//  HTGuideSaleDescCollectionCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/22.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTGuideSaleDescCollectionCell.h"
@interface HTGuideSaleDescCollectionCell()

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end
@implementation HTGuideSaleDescCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setDataModel:(HTGuideSaleInfoModel *)dataModel{
    _dataModel = dataModel;
    self.valueLabel.text = [HTHoldNullObj getValueWithUnCheakValue:[dataModel valueForKey:self.model.key]];
}
@end
