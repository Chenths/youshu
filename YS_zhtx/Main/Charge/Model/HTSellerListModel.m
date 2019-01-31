//
//  HTSellerListModel.m
//  YS_zhtx
//
//  Created by mac on 2019/1/18.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import "HTSellerListModel.h"

@implementation HTSellerListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.sellerId = value;
    }
}
@end
