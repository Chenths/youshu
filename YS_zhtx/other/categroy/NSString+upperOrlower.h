//
//  NSString+upperOrlower.h
//  24小助理
//
//  Created by mac on 16/4/18.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (upperOrlower)
/**
 *  字符串转小写
 *
 *  @param str 被转字符串
 *
 *  @return   已转字符串
 */
-(NSString *)toLower:(NSString *)str;

/**
 *  转大写
 *
 *  @param str string
 *
 *  @return 大写
 */
-(NSString *)toUpper:(NSString *)str;



- (NSString *) fourGoFiveCome:(NSString *)str afterPoint:(int) position;

@end
