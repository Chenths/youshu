//
//  HTSearchPriceBetwenCell.m
//  YS_zhtx
//
//  Created by mac on 2018/8/9.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTSearchPriceBetwenCell.h"

@implementation HTSearchPriceBetwenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setSearchDic:(NSMutableDictionary *)searchDic{
    _searchDic = searchDic;
    self.beginField.text = [HTHoldNullObj getValueWithUnCheakValue:searchDic[@"model.finalprice_from"]];
    self.endField.text = [HTHoldNullObj getValueWithUnCheakValue:searchDic[@"model.finalprice_to"]];
}

@end
