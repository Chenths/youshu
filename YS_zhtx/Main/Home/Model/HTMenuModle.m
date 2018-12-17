//
//  HTMenuModle.m
//  24小助理
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import "HTMenuModle.h"

@implementation HTMenuModle


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"HTMenuId"];
    }else{
        
    }
}


@end
