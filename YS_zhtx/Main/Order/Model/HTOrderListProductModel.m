//
//  HTOrderListProductModel.m
//  YS_zhtx
//
//  Created by mac on 2018/7/2.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTOrderListProductModel.h"

@implementation HTOrderListProductModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"productImage" : @"productimage",
             };
}
@end
