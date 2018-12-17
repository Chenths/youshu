//
//  NSString+font.h
//  24小助理
//
//  Created by mac on 16/9/1.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (font)

- (NSString *)string18;
- (NSString *)string24WithVersion:(NSString *)version;
- (NSString *)string32WithVersion:(NSString *)version;
- (NSString *)string48;
- (NSString *)string64;


- (NSString *) QRWithVersion:(NSString *)version;

@end
