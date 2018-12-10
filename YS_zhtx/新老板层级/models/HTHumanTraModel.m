//
//  HTHumanTraModel.m
//  24小助理
//
//  Created by mac on 16/7/22.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import "HTHumanTraModel.h"

@implementation HTHumanTraModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        
        [self  setValue:value forKey:@"humanId"];
        
    }
}


@end
