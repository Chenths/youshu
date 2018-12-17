//
//  NSNumber+FourGoFiveIn.m
//  有术
//
//  Created by mac on 2016/11/21.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import "NSNumber+FourGoFiveIn.h"

@implementation NSNumber (FourGoFiveIn)


-(NSNumber *)setDiscountWithCount:(NSString *)discount1{

    
    NSArray *discountArr = [discount1 componentsSeparatedByString:@"."];
    
    CGFloat f = [discountArr[0] intValue] * 10 + [discountArr[1] intValue];
    NSString *str = [NSString stringWithFormat:@"%lf",f  / 100 * self.floatValue];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       
                                       decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                       
                                       scale:0
                                       
                                       raiseOnExactness:NO
                                       
                                       raiseOnOverflow:NO
                                       
                                       raiseOnUnderflow:NO
                                       
                                       raiseOnDivideByZero:YES];
    NSDecimalNumber *subtotal = [NSDecimalNumber decimalNumberWithString:str];
    
    NSDecimalNumber *discount = [NSDecimalNumber decimalNumberWithString:@"0.00"];
    NSDecimalNumber *total = [subtotal decimalNumberByAdding:discount withBehavior:roundUp];
    return total;
    
}
@end
