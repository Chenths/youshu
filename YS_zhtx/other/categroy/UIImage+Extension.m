//
//  UIImage+Extension.m
//  大大财经
//
//  Created by yuanmc on 15-5-23.
//  Copyright (c) 2015年 dada. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
+ (UIImage *)imageWithName:(NSString *)name
{
    UIImage *image = nil;
//    if (iOS7) { // 处理iOS7的情况
//        NSString *newName = [name stringByAppendingString:@""];
//        image = [UIImage imageNamed:newName];
//    }
    
    if (image == nil) {
        image = [UIImage imageNamed:name];
    }
    return image;
}

+ (UIImage *)resizedImage:(NSString *)name
{
    UIImage *image = [UIImage imageWithName:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

- (NSData *) changeImageDataWithImage{
    float j = 1.0;
    NSData * data = [NSData data];
    for (int i = 0; i < 10; i ++) {
        NSData  * imageData     = UIImageJPEGRepresentation(self, j);
        float f = imageData.length / 1024;
        if (f < 500) {
            data = imageData;
            break;
        }
        j = j - 0.1;
    }
    return data;
    
}
-(NSString *)getBase64Img{
   return  [[self changeImageDataWithImage] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];;
}

@end
