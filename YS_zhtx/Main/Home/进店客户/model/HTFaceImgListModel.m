//
//  HTFaceImgListModel.m
//  有术
//
//  Created by mac on 2017/11/9.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import "HTFaceImgListModel.h"

@implementation HTFaceImgListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"HTFaceImgListModelid"];
    }else{
        [super setValue:value forKey:key];
    }
}


@end
