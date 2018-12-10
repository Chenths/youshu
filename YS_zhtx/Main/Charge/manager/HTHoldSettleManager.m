//
//  HTHoldSettleManager.m
//  YS_zhtx
//
//  Created by mac on 2018/8/16.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTHoldSettleManager.h"

@implementation HTHoldSettleManager


/**
 *  生成二维码
 *
 *  @param value 二维码图片中包含信息
 *
 *  @return 二维码图片
 */
+ (UIImage *)createCodeImageWithValue:(NSString *) value{
    if ([value isNull]) {
        return  nil;
    }
    //    创建滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //    还原滤镜的默认属性
    [filter setDefaults];
    //    设置需要生成二维码的数据
    [filter setValue:[value dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    //    从滤镜中取出生成好的图片
    CIImage *ciImage = [filter outputImage];
    
    UIImage *aliImage = [UIImage imageNamed:@"icon"];
    //合成图片
    UIImage *newImage = [self createImageBgImage:[self createNonInterpolatedUIImageFormCIImage:ciImage WithSize:300] withSmallImage:aliImage];
    return newImage;
}
// 创建带阿里图标的二维码
+ (UIImage *) createImageBgImage :(UIImage *) bgImg withSmallImage:(UIImage *) smallImage{
    //开启图文上下文
    UIGraphicsBeginImageContext(bgImg.size);
    //绘制背景图片
    [bgImg drawInRect:CGRectMake(0, 0, bgImg.size.width, bgImg.size.height)];
    //绘制头像
    CGFloat width  = 50;
    CGFloat height = width;
    CGFloat x = (bgImg.size.width - width) * 0.5;
    CGFloat y = (bgImg.size.height - width) * 0.5;
    [smallImage drawInRect:CGRectMake(x, y, width, height)];
    //取出绘制好的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图文上下文呢
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  根据ciimage生成高清图片
 *
 *  @param image 不清晰的二维码图片
 *  @param size  图片大小
 *
 *  @return 高清二维码图片
 */
+ (UIImage *) createNonInterpolatedUIImageFormCIImage:(CIImage *) image WithSize:(CGFloat ) size{
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    //    创建bitmap
    CGFloat width  = CGRectGetWidth(extent) *scale;
    CGFloat height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef sc = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, sc, 0);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    CGImageRef scaleImage = CGBitmapContextCreateImage(bitmapRef);
    return  [UIImage  imageWithCGImage:scaleImage];
}
+(void)storedPayWithPosDic:(NSDictionary *)posDic andSucces:(Succes)succes severError:(Erro)severError andError:(Erro)error1{
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleOrder,payByStoredValue4App] params:posDic success:^(id json) {
        [MBProgressHUD hideHUD];
        if (succes) {
            succes(json);
        }
    } error:^{
        [MBProgressHUD hideHUD];
        if (severError) {
            severError();
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        if (error1) {
            error1();
        }
    }];
}
+(void)caishPayWithPosDic:(NSDictionary *)posDic andSucces:(Succes)succes severError:(Erro)severError andError:(Erro)error1{
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleOrder,modifyOrderState4App] params:posDic success:^(id json) {
        [MBProgressHUD hideHUD];
        if (succes) {
            succes(json);
        }
    } error:^{
        [MBProgressHUD hideHUD];
        if (severError) {
            severError();
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        if (error1) {
            error1();
        }
    }];
}
+(void)shopAliOrWechatPayWithPosDic:(NSDictionary *)posDic Succes:(Succes)succes severError:(Erro)severError andError:(Erro)error1{
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleOrder,modifyCompayOnlinePayOrder] params:posDic success:^(id json) {
        [MBProgressHUD hideHUD];
        if (succes) {
            succes(json);
        }
    } error:^{
        [MBProgressHUD hideHUD];
        if (severError) {
            severError();
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        if (error1) {
            error1();
        }
    }];
}
+ (void)refreshAliOrWechatPayWithPosDic:(NSDictionary *)posDic Succes:(Succes)succes severError:(Erro)severError andError:(Erro)error1{
    
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleOrder,queryPayState] params:posDic success:^(id json) {
        [MBProgressHUD hideHUD];
        if (succes) {
            succes(json);
        }
    } error:^{
        [MBProgressHUD hideHUD];
        if (severError) {
            severError();
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        if (error1) {
            error1();
        }
    }];
}
+(void)cancelOrCloseOrderWithPosDic:(NSDictionary *)posDic Succes:(Succes)succes severError:(Erro)severError andError:(Erro)error1{
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleOrder,modifyOrderState4App] params:posDic success:^(id json) {
        [MBProgressHUD hideHUD];
        if (succes) {
            succes(json);
        }
    } error:^{
        [MBProgressHUD hideHUD];
        if (severError) {
            severError();
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        if (error1) {
            error1();
        }
    }];
}

@end
