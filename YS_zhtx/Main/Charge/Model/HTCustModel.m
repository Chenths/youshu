//
//  HTCustModel.m
//  YS_zhtx
//
//  Created by mac on 2018/8/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTCustModel.h"

@implementation HTCustModel
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"custId" : @"id",
             @"headImg":@"headimg"
             };
}
@end
