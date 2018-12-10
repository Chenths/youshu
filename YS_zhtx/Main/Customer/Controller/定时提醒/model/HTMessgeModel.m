//
//  HTMessgeModel.m
//  24小助理
//
//  Created by mac on 16/9/13.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import "HTMessgeModel.h"

@implementation HTMessgeModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"messgeId"];
    } else {
    }
}

@end
