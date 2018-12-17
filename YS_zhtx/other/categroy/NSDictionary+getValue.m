//
//  NSDictionary+getValue.m
//  24小助理
//
//  Created by mac on 16/9/23.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import "NSDictionary+getValue.h"

@implementation NSDictionary (getValue)

-(NSString *)getStringWithKey:(NSString *)key{
    
    if ([self isKindOfClass:[NSString class]]) {
        return @"";
    }
    if ([[self valueForKey:key] isNull] || ![self valueForKey:key]) {
        return @"";
    }else{
        return
        [[self valueForKey:key] isKindOfClass:[NSString class]] ?
        [self valueForKey:key]  :
        [NSString stringWithFormat:@"%@",[self valueForKey:key]] ;
    }
}
- (NSArray *)getArrayWithKey:(NSString *)key{
    if ([self isKindOfClass:[NSString class]]) {
        return [NSArray array];
    }
    if ([[self valueForKey:key] isNull]) {
        return [[NSArray alloc] init];
    }else{
        return [[self valueForKey:key] isKindOfClass:[NSArray class]] ? [self valueForKey:key] : [[NSArray alloc] init];
    }
}
- (NSDictionary *)getDictionArrayWithKey:(NSString *)key{
    if ([self isKindOfClass:[NSString class]]) {
        return [NSDictionary dictionary];
    }
    if ([[self valueForKey:key] isNull]) {
        return [[NSDictionary alloc] init];
    }else{
        return [[self valueForKey:key] isKindOfClass:[NSDictionary class]] ? [self valueForKey:key] : [[NSDictionary alloc] init];
    }
}

- (CGFloat)getFloatWithKey:(NSString *)key{
    if ([self isKindOfClass:[NSString class]]) {
        return 0;
    }
    if ([[self valueForKey:key] isNull]) {
        return 0;
    }else{
        return [[self valueForKey:key] floatValue];
//        return [[self valueForKey:key] isKindOfClass:[NSNumber class]] ? [[self valueForKey:key] floatValue]: 0;
    }

}
- (NSString *)jsonStringWithDic{
  
        NSError *parseError = nil;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
        
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

}
- (NSString *)getDateWithNumbelDateKey:(NSString *)key{
    NSTimeInterval interval=[[self objectForKey:key] doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * timeStr = [NSString stringWithFormat:@"%@",[objDateformat stringFromDate:date]];
    return timeStr;
}
@end
