//
//  NSString+Json.m
//  24小助理
//
//  Created by mac on 16/5/3.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import "NSString+Json.h"

@implementation NSString (Json)


-(NSDictionary *)dictionaryWithJsonString{
    if (self == nil) {
        return nil;
    }
    
    NSString *responseString = self;
//    responseString = [responseString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
//    responseString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];

//    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                   options:NSJSONReadingMutableContainers
                                                     error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
    
}

- (NSArray *)ArrayWithJsonString{
    if (self == nil) {
        return nil;
        
    }
    NSString *responseString = self;
//    responseString = [responseString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
//    responseString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                   options:NSJSONReadingMutableContainers
                                                     error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
    
}

- (NSString *)jsonStringWithDic:(NSDictionary *)jsonDic{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
-(CGFloat)getStringWidhtWithHeight:(CGFloat)height andFont:(int)font{
    CGFloat width = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:0 attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:font]} context:nil].size.width;
    return width;
}

@end
