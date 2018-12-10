//
//  HTTurnListDetailModel.m
//  YS_zhtx
//
//  Created by mac on 2018/9/19.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTTurnListDetailModel.h"

@implementation HTTurnListDetailModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"product" : [HTTurnListDetailProductModel class],
             };
}
//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{
//             @"targetCompanyName" : @"signCompanyName",
//             };
//}
@end
