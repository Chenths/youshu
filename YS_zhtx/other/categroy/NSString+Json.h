//
//  NSString+Json.h
//  24小助理
//
//  Created by mac on 16/5/3.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Json)
/**
 *  json字符串转字典
 *
 *  @return 字典
 */
- (NSDictionary *)dictionaryWithJsonString;
/**
 *  json字符串转数组
 *
 *  @return 数组
 */
- (NSArray *)ArrayWithJsonString;

- (NSString *) jsonStringWithDic:(NSDictionary *) jsonDic;

-(CGFloat)getStringWidhtWithHeight:(CGFloat) height andFont:(int)font;


@end
