//
//  NSString+md5.h
//  24小助理
//
//  Created by mac on 16/3/25.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (md5)

- (NSString *) md5;

- (NSString *)md5:(NSString *)str;
- (NSString*) sha1;

@end
