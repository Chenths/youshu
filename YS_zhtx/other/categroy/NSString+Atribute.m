//
//  NSString+Atribute.m
//  YS_zhtx
//
//  Created by mac on 2018/8/16.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "NSString+Atribute.h"

@implementation NSString (Atribute)

-(NSMutableAttributedString *)getAttFormBehindStr:(NSString *)behind behindColor:(UIColor *)behindColor  {
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self]];
    [str2 addAttribute:NSForegroundColorAttributeName value:behindColor range:NSMakeRange(0, behind.length)];
    return str2;
}

@end
