//
//  HTBossMulitCompareModel.m
//  有术
//
//  Created by mac on 2018/4/25.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTBossMulitCompareModel.h"

@implementation HTBossMulitCompareModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end
