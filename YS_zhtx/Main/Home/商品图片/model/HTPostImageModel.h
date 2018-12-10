//
//  HTPostImageModel.h
//  有术
//
//  Created by mac on 2017/5/18.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//
#import  <AssetsLibrary/AssetsLibrary.h>
#import <Foundation/Foundation.h>

@interface HTPostImageModel : NSObject

@property (nonatomic,strong) UIImage *image;
//描述
@property (nonatomic,strong) NSString  *desc;
//服务器地址
@property (nonatomic,strong) NSString  *imageSeverUrl;

@property (nonatomic,strong) NSString  *holdImageSeverUrl;
//path
@property (nonatomic,strong) NSString *pathUrl;


@property (nonatomic,assign) BOOL isFullImg;

@property (nonatomic,assign) BOOL isSeleted;


@end
