//
//  HTPieDataItem.m
//  YS_zhtx
//
//  Created by mac on 2018/7/5.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTPieDataItem.h"

@implementation HTPieDataItem

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"itemId" : @"id",
             };
}
@end
