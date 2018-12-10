//
//  HTNoticpushSeterModel.m
//  有术
//
//  Created by mac on 2017/7/12.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import "HTNoticpushSeterModel.h"

@implementation HTNoticpushSeterModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
-(NSMutableArray *)selectedRoles{
    if (!_selectedRoles) {
        _selectedRoles = [NSMutableArray array];
    }
    return _selectedRoles;
}

@end
