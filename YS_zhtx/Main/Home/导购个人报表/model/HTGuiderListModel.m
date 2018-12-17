//
//  HTGuiderListModel.m
//  YS_zhtx
//
//  Created by mac on 2018/7/4.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTGuiderListModel.h"

@implementation HTGuiderListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"guiderId" : @"id",
             };
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
