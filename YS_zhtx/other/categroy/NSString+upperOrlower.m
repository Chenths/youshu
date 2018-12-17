//
//  NSString+upperOrlower.m
//  24小助理
//
//  Created by mac on 16/4/18.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import "NSString+upperOrlower.h"

@implementation NSString (upperOrlower)

-(NSString *)toLower:(NSString *)str{
    for (NSInteger i=0; i<str.length; i++) {
        if ([str characterAtIndex:i]>='A'&[str characterAtIndex:i]<='Z') {
            //A  65  a  97
            char  temp=[str characterAtIndex:i]+32;
            NSRange range=NSMakeRange(i, 1);
            str=[str stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"%c",temp]];
        }
    }
    return str;
}

-(NSString *)toUpper:(NSString *)str{
    for (NSInteger i=0; i<str.length; i++) {
        if ([str characterAtIndex:i]>='a'&[str characterAtIndex:i]<='z') {
            //A  65  a  97
            char  temp=[str characterAtIndex:i]-32;
            NSRange range=NSMakeRange(i, 1);
            str=[str stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"%c",temp]];
        }
    }
    return str;
}

- (NSString *)fourGoFiveCome:(NSString *)str afterPoint:(int) position{
    
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       
                                       decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                       
                                       scale:position
                                       
                                       raiseOnExactness:NO
                                       
                                       raiseOnOverflow:NO
                                       
                                       raiseOnUnderflow:NO
                                       
                                       raiseOnDivideByZero:YES];
    NSDecimalNumber *subtotal = [NSDecimalNumber decimalNumberWithString:str];
    
    NSDecimalNumber *discount = [NSDecimalNumber decimalNumberWithString:@"0.00"];
    
    NSDecimalNumber *total = [subtotal decimalNumberByAdding:discount withBehavior:roundUp];
    
    
    return  [NSString stringWithFormat:@"%@",total];

}

@end
