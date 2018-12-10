//
//  NSArray+TOJSONSTR.m
//  有术
//
//  Created by mac on 2016/12/1.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import "NSArray+TOJSONSTR.h"

@implementation NSArray (TOJSONSTR)

- (NSString *) arrayToJsonString{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] != 0 ){
        return  [[NSString alloc] initWithData:jsonData
                                      encoding:NSUTF8StringEncoding];
    }else{
        return @"";
    }
}

@end
