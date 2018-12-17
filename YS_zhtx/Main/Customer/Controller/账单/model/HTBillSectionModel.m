//
//  HTBillSectionModel.m
//  YS_zhtx
//
//  Created by mac on 2018/9/6.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTBillSectionModel.h"

@implementation HTBillSectionModel


-(NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
@end
