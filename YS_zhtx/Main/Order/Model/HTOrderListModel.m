//
//  HTOrderListModel.m
//  YS_zhtx
//
//  Created by mac on 2018/7/2.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTOrderListModel.h"

@implementation HTOrderListModel
/*
 
 */
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"orderId" : @"id",
             @"createDate":@"createdate",
             @"custLevel":@"custlevel",
             @"finalPrice":@"finalprice",
             @"headImg":@"headimg",
             @"orderDetails":@"orderdetails",
             @"orderStatus":@"orderstatus",
             @"totalPrice":@"totalprice"
           };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"orderDetails" : [HTOrderListProductModel class],
           };
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([value isKindOfClass:[NSString class]]) {
        if ([value isNull] || [value isEqualToString:@"<null>"]) {
            value = @"--";
        }
    }
    [super setValue:value forKey:key];
    
}
@end
