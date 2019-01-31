//
//  HTChargeProductInfoModel.m
//  YS_zhtx
//
//  Created by mac on 2018/7/25.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTChargeProductInfoModel.h"
#import "SecurityUtil.h"
@implementation HTChargeProductInfoModel
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"productId" : @"id",
             };
}

-(NSString *)encodePrice{
    if (!_encodePrice) {
        return  _encodePrice = [SecurityUtil decryptAESData:self.price];
    }
    return _encodePrice;
}
-(NSString *)encodeFinialPrice{
    if (!_encodeFinialPrice) {
        return  _encodeFinialPrice = [SecurityUtil decryptAESData:self.finalprice];
    }
    return _encodeFinialPrice;
}

@end
