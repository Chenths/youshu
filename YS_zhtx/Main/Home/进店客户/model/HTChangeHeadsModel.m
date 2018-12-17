//
//  HTChangeHeadsModel.m
//  有术
//
//  Created by mac on 2017/11/14.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import "HTChangeHeadsModel.h"

@implementation HTChangeHeadsModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"HTChangeHeadsModelId"];
    }else{
        [super setValue:value forKey:key];
    }
}

@end
