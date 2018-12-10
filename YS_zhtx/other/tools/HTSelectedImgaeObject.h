//
//  HTSelectedImgaeObject.h
//  有术
//
//  Created by mac on 2018/5/18.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
typedef void(^SELECTEDIMGS)(NSArray *imgs);
#import <Foundation/Foundation.h>

@interface HTSelectedImgaeObject : NSObject
-(void )showSelectedImgWithController;
@property (nonatomic,copy) SELECTEDIMGS selectedImgs;

@end
