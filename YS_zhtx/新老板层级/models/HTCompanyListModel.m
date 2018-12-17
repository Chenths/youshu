//
//  HTCompanyListModel.m
//  有术
//
//  Created by mac on 2018/4/20.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTCompanyListModel.h"

@implementation HTCompanyListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"companyId"];
    }else{
        [super setValue:value forKey:key];
    }
}
@end
