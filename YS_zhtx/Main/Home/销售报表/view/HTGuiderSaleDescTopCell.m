//
//  HTGuiderSaleDescTopCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/22.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTGuiderSaleDescTopCell.h"
@interface HTGuiderSaleDescTopCell()

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end
@implementation HTGuiderSaleDescTopCell

-(void)setModel:(HTGuideDescModel *)model{
    _model = model;
    self.valueLabel.text = model.value;
}
@end
