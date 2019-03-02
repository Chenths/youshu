//
//  HTShowImg.m
//  YS_zhtx
//
//  Created by mac on 2019/3/1.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import "HTShowImg.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
@implementation HTShowImg
+(void)showSingleBigImvWithImg:(UIImage *)img WithUrlStr:(NSString *)str
{
    NSMutableArray *photos = [NSMutableArray array];
    
    MJPhoto *photo = [[MJPhoto alloc] init];
    if (img) {
        photo.image = img;
    }else{
        if (str.length > 0 ) {
            photo.url = [NSURL URLWithString:str];
        }else{
            photo.image = [UIImage imageNamed:@"相机"];
        }
    }
    
    [photos addObject:photo];
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}
@end
