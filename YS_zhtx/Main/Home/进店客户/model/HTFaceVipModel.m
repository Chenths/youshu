//
//  HTFaceVipModel.m
//  有术
//
//  Created by mac on 2017/11/8.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import "HTFaceVipModel.h"

@implementation HTFaceVipModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
- (NSMutableArray *)imgs{
    if (!_imgs) {
        _imgs = [NSMutableArray array];
    }
    return _imgs;
}
@end
