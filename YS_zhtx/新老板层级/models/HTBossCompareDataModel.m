//
//  HTBossCompareDataModel.m
//  有术
//
//  Created by mac on 2018/4/24.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTBossCompareDataModel.h"

@implementation HTBossCompareDataModel
- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"modelId"];
    }else{
        [super setValue:value forKey:key];
    }
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
