//
//  HTRolsModel.m
//  有术
//
//  Created by mac on 2017/7/12.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import "HTRolsModel.h"

@implementation HTRolsModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"HTRolsModelId"];
    }else{
        [super setValue:value forKey:key];
    }
}

@end
