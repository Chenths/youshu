//
//  NSDictionary+getValue.h
//  24小助理
//
//  Created by mac on 16/9/23.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (getValue)

-(NSString *)getStringWithKey:(NSString *) key;

- (NSArray *) getArrayWithKey:(NSString *) key;

- (NSDictionary *) getDictionArrayWithKey:(NSString *)key;

- (CGFloat) getFloatWithKey:(NSString *)key;

- (NSString *)jsonStringWithDic;

- (NSString *) getDateWithNumbelDateKey:(NSString *) key;
@end
