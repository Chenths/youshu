//
//  HTNewTagsModel.m
//  有术
//
//  Created by mac on 2017/11/7.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import "HTNewTagsModel.h"

@implementation HTNewTagsModel

- (NSArray *)tagsArray{
    if (!_tagsArray) {
        _tagsArray = [NSMutableArray array];
    }
    return _tagsArray;
}


@end
