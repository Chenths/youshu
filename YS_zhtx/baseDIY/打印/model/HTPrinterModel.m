//
//  HTPrinterModel.m
//  24小助理
//
//  Created by mac on 16/9/2.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import "HTPrinterModel.h"

@implementation HTPrinterModel

- (NSString *)date{
    if (!_date) {
        NSDateFormatter * yearF1 = [[NSDateFormatter alloc] init];
        [yearF1 setDateFormat:@"YYYY-MM-dd HH:mm"];
        NSString *today    = [yearF1 stringFromDate:[NSDate date]];
        return today;
    }
   return   _date;
}
- (NSString *)returnTime{
    if (!_returnTime) {
        NSDateFormatter * yearF1 = [[NSDateFormatter alloc] init];
        [yearF1 setDateFormat:@"YYYY-MM-dd HH:mm"];
        NSString *today    = [yearF1 stringFromDate:[NSDate date]];
        return today;
    }
    return _returnTime;
}
- (NSString *)points{
    if ([HTHoldNullObj getValueWithUnCheakValue:_points].length == 0 ) {
        return @"0";
    }
    return _points;
}
- (NSString *)returnPoints{
    if ([HTHoldNullObj getValueWithUnCheakValue:_returnPoints].length == 0 ) {
        return @"0";
    }
    return _returnPoints;
}
- (NSString *)returnCoupons{
    if ([HTHoldNullObj getValueWithUnCheakValue:_returnCoupons].length == 0 ) {
        return @"0";
    }
    return _returnCoupons;
}
- (NSString *)coupons{
    if ([HTHoldNullObj getValueWithUnCheakValue:_coupons].length == 0 ) {
        return @"0";
    }
    return _coupons;
}
- (NSString *)storeValue{
    if ([HTHoldNullObj getValueWithUnCheakValue:_storeValue].length == 0) {
        return @"0";
    }
    
    return _storeValue;
}
- (NSString *)returnStoreValue{
    if ([HTHoldNullObj getValueWithUnCheakValue:_returnStoreValue].length == 0) {
        return @"0";
    }
    return _returnStoreValue;
}
- (NSString *)freeStoreValue{
    if ([HTHoldNullObj getValueWithUnCheakValue:_freeStoreValue].length == 0) {
        return  @"0";
    }
    return _freeStoreValue;
}
- (NSString *)returnFreeStoreValue{
    if ([HTHoldNullObj getValueWithUnCheakValue:_returnFreeStoreValue].length == 0) {
        return @"0";
    }
    return _returnFreeStoreValue;
}

- (NSMutableArray *)goodsList{
    if (!_goodsList) {
        _goodsList = [NSMutableArray array];
    }
    return _goodsList;
}
- (NSMutableArray *)returnGoodsList{
    if (!_returnGoodsList) {
        _returnGoodsList = [NSMutableArray array];
    }
    return _returnGoodsList;
}
- (NSMutableArray *)exchangeGoodsList{
    if (!_exchangeGoodsList) {
        _exchangeGoodsList = [NSMutableArray array];
    }
    return _exchangeGoodsList;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"payType"]) {
        [self setValue:value forKey:@"paytype"];
    }
    if ([key isEqualToString:@"date"]) {
        [self  setValue:value forKey:@"time"];
    }
    if ([key isEqualToString:@"orderPayPrice"]) {
        [self setValue:value forKey:@"orderFinalPrize"];
    }
    if ([key isEqualToString:@"orderTotalPrice"]) {
        [self setValue:value forKey:@"orderTotalPrize"];
    }
  
}
- (NSMutableDictionary *)lastOrderPrintDic{
    if (!_lastOrderPrintDic) {
        _lastOrderPrintDic = [NSMutableDictionary dictionary];
    }
    return _lastOrderPrintDic;
}
- (NSString *) getCompanyName{
    NSString *shortName = [[HTShareClass shareClass].loginModel.company[@"shortName"] length] > 0 ? [HTShareClass shareClass].loginModel.company[@"shortName"] : @"";
    NSString *fullName =  [[HTShareClass shareClass].loginModel.company[@"fullname"] length] > 0 ? [HTShareClass shareClass].loginModel.company[@"fullname"] : @"";
    
    if ([fullName rangeOfString:shortName].length != 0) {
        NSRange range = [fullName rangeOfString:shortName];
        
        if (range.location == 0 && range.length == shortName.length) {
            return [fullName substringFromIndex:range.length] ;
        }else{
            return fullName ;
        }
    }
    return fullName ;
    
}
- (NSMutableArray *)afterSalesList{
    if (!_afterSalesList) {
        _afterSalesList = [NSMutableArray array];
    }
    return _afterSalesList;
}

-(BOOL)IsChinese:(NSString *)str {
    if (![str isKindOfClass:[NSString class]]) {
        return NO;
    }
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
        
    }
    return NO;
    
}

- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"returnPayType"]) {
        if ([self IsChinese:value]) {
            
            if ([value isEqualToString:@"现金支付"]) {
                self.returnPayType = cashType;
            }else if ([value isEqualToString:@"刷卡支付"]) {
                self.returnPayType = posType;
            }else if ([value isEqualToString:@"储值支付"]) {
                self.returnPayType = storedType;
            }else if ([value isEqualToString:@"储赠支付"]) {
                self.returnPayType = storedSendType;
            }else if ([value isEqualToString:@"支付宝支付"]) {
                self.returnPayType = alipayType;
            }else if ([value isEqualToString:@"微信支付"]) {
                self.returnPayType = wetchatType;
            }else{
                self.returnPayType = mixType;
            }
        }else{
            [super setValue:value forKey:key];
        }
    }else if([key isEqualToString:@"paytype"]){
        if ([self IsChinese:value]) {
            
            if ([value isEqualToString:@"现金支付"]) {
                self.paytype = cashType;
            }else if ([value isEqualToString:@"刷卡支付"]) {
                self.paytype = posType;
            }else if ([value isEqualToString:@"储值支付"]) {
                self.paytype = storedType;
            }else if ([value isEqualToString:@"储赠支付"]) {
                self.paytype = storedSendType;
            }else if ([value isEqualToString:@"支付宝支付"]) {
                self.paytype = alipayType;
            }else if ([value isEqualToString:@"微信支付"]) {
                self.paytype = wetchatType;
            }else{
                self.paytype = mixType;
            }
        }else{
            [super setValue:value forKey:key];
        }
    }else{
        [super setValue:value forKey:key];
    }
}

@end
