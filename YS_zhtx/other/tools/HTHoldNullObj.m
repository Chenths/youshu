//
//  HTHoldNullObj.m
//  24小助理
//
//  Created by mac on 16/9/22.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import "HTHoldNullObj.h"

@implementation HTHoldNullObj
+ (NSString *)getValueWithUnCheakValue:(NSObject *)value{
    
    if (value) {
        if (![value isNull] ) {
            return [NSString stringWithFormat:@"%@", value];
        }else{
            return @"";
        }
    }else{
        return @"";
    }
    

}
+ (NSString *)getValueWithBigDecmalObj:(NSString *)value{
    double testDouble = [value doubleValue];
    NSString *doubleString = [NSString stringWithFormat:@"%lf", testDouble];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return decNumber.stringValue;
}

@end
