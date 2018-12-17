//
//  HTManyBarGraphModel.m
//  YS_zhtx
//
//  Created by mac on 2018/7/10.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTManyBarGraphModel.h"

@implementation HTManyBarGraphModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"data" : [HTBarItemModel class],
             @"title" : [HTBarTitleItemModel class],
             };
}
-(CGFloat)getItemsMaxValue{
    CGFloat max = 0.0;
    for (HTBarItemModel *mmm in self.data) {
        if ([mmm getMaxVale] > max) {
            max = [mmm getMaxVale];
        }
    }
    return max;
}

@end
