//
//  UIImage+Extension.h
//  大大财经
//
//  Created by yuanmc on 15-5-23.
//  Copyright (c) 2015年 大大. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/**
 *  根据图片名自动加载适配iOS6\7的图片
 */
+ (UIImage *)imageWithName:(NSString *)name;

/**
 *  根据图片名返回一张能够自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)name;

- (NSData *) changeImageDataWithImage;

- (NSString *) getBase64Img;



@end
