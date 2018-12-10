//
//  HTCahargeProductModel.m
//  YS_zhtx
//
//  Created by mac on 2018/7/25.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTCahargeProductModel.h"

@implementation HTCahargeProductModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"product" : [HTChargeProductInfoModel class],
             };
}
-(HTChargeProductInfoModel *)selectedModel{
    if (!_selectedModel) {
        if (self.product.count == 1) {
            return [self.product firstObject];
        }
    }
    return _selectedModel;
}
-(NSString *)hasGivePoint{
    if (!_hasGivePoint) {
        return @"1";
    }
    return _hasGivePoint;
}
@end
