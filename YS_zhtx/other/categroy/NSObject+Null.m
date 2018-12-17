//
//  NSObject+Null.m
//  24小助理
//
//  Created by mac on 16/4/19.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import "NSObject+Null.h"
#define IsNullString(x) [@[@"null",@"<null>",@"(null)"] containsObject:x]
@implementation NSObject (Null)

- (BOOL) isNull {
    
    if (!self) {
        return YES;
    }else{
        if ([self isKindOfClass:[NSString class]]) {
            NSString *str = (id)self;
            if ([str rangeOfString:@"null"].length > 0 && str.length < 7) {
                return YES;
            }else if(str.length == 0 ){
                return YES;
            }else{
                return NO;
            }
        }else{
            if ([self isKindOfClass:[NSNumber class]]) {
                
                if ([NSString stringWithFormat:@"%@",self].length > 0 ) {
                    return NO;
                }else{
                    return YES;
                }
            }else{
             return [self isEqual:[NSNull null]];
            }
            
        }

    }
    
}


@end
