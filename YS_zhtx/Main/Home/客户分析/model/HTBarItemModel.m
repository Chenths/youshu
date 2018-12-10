//
//  HTBarItemModel.m
//  YS_zhtx
//
//  Created by mac on 2018/7/10.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTBarItemModel.h"

@implementation HTBarItemModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
-(CGFloat)getMaxVale{
    CGFloat max = 0.0f;
    for (NSString *value in self.data) {
        if (value.floatValue > max) {
            max = value.floatValue;
        }
    }
    return max;
}


@end
