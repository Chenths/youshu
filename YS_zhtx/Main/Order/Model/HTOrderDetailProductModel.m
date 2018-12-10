//
//  HTOrderDetailProductModel.m
//  YS_zhtx
//
//  Created by mac on 2018/7/3.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTOrderDetailProductModel.h"

@implementation HTOrderDetailProductModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"primaryKey" : @"id",
             @"productId" : @"id",
             };
}
@end
