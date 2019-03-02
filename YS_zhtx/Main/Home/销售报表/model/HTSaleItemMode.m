//
//  HTSaleItemMode.m
//  YS_zhtx
//
//  Created by mac on 2019/2/27.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import "HTSaleItemMode.h"

@implementation HTSaleItemMode
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (void)setDescribeStr:(NSString *)describeStr
{
    if ([describeStr isEqualToString:@"****"]) {
        _describeStr = describeStr;
    }else{
        _describeStr = [NSString stringWithFormat:@"%.2f", [describeStr floatValue]];
    }
}

@end
