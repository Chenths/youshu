//
//  HTReportWarnStandard.m
//  有术
//
//  Created by mac on 2017/2/10.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import "HTReportWarnStandard.h"

@implementation HTReportWarnStandard

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"hygxl"]) {
        [self setValue:value forKey:@"vipgxl"];
    }else{
        [super setValue:value forKey:key];
    }
}

@end
