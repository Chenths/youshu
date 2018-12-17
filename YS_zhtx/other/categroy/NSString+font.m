//
//  NSString+font.m
//  24小助理
//
//  Created by mac on 16/9/1.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import "NSString+font.h"

@implementation NSString (font)

- (NSString *)string18{
    
    return [NSString stringWithFormat:@"|4%@",self];
}

- (NSString *)string24WithVersion:(NSString *)version{
    
    switch (version.intValue) {
        case 1:
        {
            return  [NSString stringWithFormat:@"|5%@",self];
        }
            break;
        case 2:
        {
            return [NSString stringWithFormat:@"%@<BR>",self];
        }
            break;
        case 3:
        {
            return  [NSString stringWithFormat:@"%@",self];
        }
            break;
            
        default:{
            return nil;
        }
            break;
    }
//    return  [version isEqualToString:@"2"] ? [NSString stringWithFormat:@"%@<BR>",self] :[NSString stringWithFormat:@"|5%@",self];
}

- (NSString *)string32WithVersion:(NSString *)version{
    switch (version.intValue) {
        case 1:
        {
            return  [NSString stringWithFormat:@"|6%@",self];
        }
            break;
        case 2:
        {
            return [NSString stringWithFormat:@"%@<BR>",self];
        }
            break;
        case 3:
        {
            return  [NSString stringWithFormat:@"%@",self];
        }
            break;
            
        default:{
            return nil;
        }
            break;
    }
//    return [version isEqualToString:@"2"] ? [NSString stringWithFormat:@"%@<BR>",self] :[NSString stringWithFormat:@"|6%@",self];
}

- (NSString *)string48{
    
    return [NSString stringWithFormat:@"|7%@",self];
}

- (NSString *)string64{
    
    return [NSString stringWithFormat:@"|8%@",self];
}

- (NSString *) QRWithVersion:(NSString *)version{
    switch (version.intValue) {
        case 1:
        {
            return [NSString stringWithFormat:@"|2%@",self];
        }
            break;
        case 2:
        {
            return [NSString stringWithFormat:@"<QR>%@</QR>",self];
        }
            break;
        case 3:
        {
            return  [NSString stringWithFormat:@"%@",self];
        }
            break;
            
        default:{
            return nil;
        }
            break;
    }
//    return [version isEqualToString:@"2"] ? [NSString stringWithFormat:@"<QR>%@</QR>",self] : [NSString stringWithFormat:@"|2%@",self];
}

@end
