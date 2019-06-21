//
//  PhoneNumberTools.m
//  shengyijing
//
//  Created by mac on 16/3/10.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//
#import "HTTHeader.pch"
#import "PhoneNumberTools.h"

@implementation PhoneNumberTools


//检测是否是手机号码
+(BOOL)isMobileNumber:(NSString *)mobileNum
{
    if (mobileNum.length != 11) {
        return NO;
    }
    
//        NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|6[6]|7[05-8]|8[0-9]|9[89])\\d{8}$";
    NSString *MOBILE =  @"^(13[0-9]|14[5-9]|15[012356789]|166|17[0-8]|18[0-9]|19[8-9])[0-9]{8}$"; //最新手机号码校验规则
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
        if(([regextestmobile evaluateWithObject:mobileNum] == YES)) {
            return YES;
        } else {
            return NO;
        }
    
//    /**
//     * 手机号码:
//     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 16[6], 17[5, 6, 7, 8], 18[0-9], 170[0-9], 19[89]
//     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705,198
//     * 联通号段: 130,131,132,155,156,185,186,145,175,176,1709,166
//     * 电信号段: 133,153,180,181,189,177,1700,199
//     */
//    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|6[6]|7[05-8]|8[0-9]|9[89])\\d{8}$";
//
//    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478]|9[8])\\d{8}$)|(^1705\\d{7}$)";
//
//    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|66|7[56]|8[56])\\d{8}$)|(^1709\\d{7}$)";
//
//    NSString *CT = @"(^1(33|53|77|8[019]|99)\\d{8}$)|(^1700\\d{7}$)";
//
//    /**
//     * 大陆地区固话及小灵通
//     * 区号：010,020,021,022,023,024,025,027,028,029
//     * 号码：七位或八位
//     */
//    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    // NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
//
//    if(([regextestmobile evaluateWithObject:mobileNum] == YES)
//       || ([regextestcm evaluateWithObject:mobileNum] == YES)
//       || ([regextestct evaluateWithObject:mobileNum] == YES)
//       || ([regextestcu evaluateWithObject:mobileNum] == YES)) {
//        return YES;
//    } else {
//        return NO;
//    }
    
    
    
//    /**
//     * 手机号码
//     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,183,187,188,184
//     * 联通：130,131,132,152,155,156,185,186
//     * 电信：133,1349,153,180,189
//     新增：176，177，178,181
//
//     */
//    NSString * MOBILE = @"^1[0-9]{10}$";
//    /**
//     10         * 中国移动：China Mobile
//     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,183
//     12         */
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[23478])\\d)\\d{7}$";
//    /**
//     15         * 中国联通：China Unicom
//     16         * 130,131,132,152,155,156,185,186
//     17         */
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    /**
//     20         * 中国电信：China Telecom
//     21         * 133,1349,153,180,181,189，171，177
//     22         */
//    NSString * CT = @"^1((|33|53|8[019]|7[678])[0-9]|349)\\d{7}$";
//    /**
//     25         * 大陆地区固话及小灵通
//     26         * 区号：010,020,021,022,023,024,025,027,028,029
//     27         * 号码：七位或八位
//     28         */
//    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//
//    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
//        || ([regextestcm evaluateWithObject:mobileNum] == YES)
//        || ([regextestct evaluateWithObject:mobileNum] == YES)
//        || ([regextestcu evaluateWithObject:mobileNum] == YES))
//    {
//        return YES;
//    }
//    else if([[HTShareClass shareClass].storeStr isEqualToString:@"zhtx"] && mobileNum.length > 0){
//        return YES;
//
//    } else if([[baseUrl substringWithRange:NSMakeRange(7, 3)] isEqualToString:@"110"]&& mobileNum.length > 0){
//        return YES;
//    }
//    else {
//        return NO;
//    }

}


@end
