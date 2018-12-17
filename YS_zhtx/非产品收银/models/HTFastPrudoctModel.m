//
//  HTFastPrudoctModel.m
//  有术
//
//  Created by mac on 2018/5/14.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTFastPrudoctModel.h"

@implementation HTFastPrudoctModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
-(NSString *)getFinallPriceWithPrice:(NSString *)price andDiscount:(NSString *)discount{
    if (discount.length == 0) {
        return  price;
    }
    CGFloat f = discount.floatValue;
    NSString *str = [NSString stringWithFormat:@"%lf",f  / 10 * price.floatValue];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       
                                       decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                       
                                       scale:0
                                       
                                       raiseOnExactness:NO
                                       
                                       raiseOnOverflow:NO
                                       
                                       raiseOnUnderflow:NO
                                       
                                       raiseOnDivideByZero:YES];
    NSDecimalNumber *subtotal = [NSDecimalNumber decimalNumberWithString:str];
    
    NSDecimalNumber *discount1 = [NSDecimalNumber decimalNumberWithString:@"0.00"];
    NSDecimalNumber *total = [subtotal decimalNumberByAdding:discount1 withBehavior:roundUp];
    return [NSString stringWithFormat:@"%@",total];
}
@end
