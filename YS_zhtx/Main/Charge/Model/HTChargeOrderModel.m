//
//  HTChargeOrderModel.m
//  YS_zhtx
//
//  Created by mac on 2018/8/14.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "SecurityUtil.h"
#import "HTChargeOrderModel.h"

@implementation HTChargeOrderModel
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"orderId" : @"id",
             };
}
-(NSString *)encodeFinal{
    if (!_encodeFinal) {
      return   [SecurityUtil decryptAESData:self.finalprice];
    }
    return _encodeFinal;
}
-(NSString *)encodeTotal{
    if (!_encodeTotal) {
     return  _encodeTotal = [SecurityUtil decryptAESData:self.totalprice];
    }
    return _encodeTotal;
}
@end
