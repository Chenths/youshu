//
//  HTNewFaceVipModel.h
//  YS_zhtx
//
//  Created by mac on 2019/1/4.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTNewFaceVipModel : NSObject
@property (nonatomic, copy) NSString * customerId;
@property (nonatomic, copy) NSString * customerName;
@property (nonatomic, copy) NSString * enterTime;
@property (nonatomic, copy) NSString * level;
@property (nonatomic, copy) NSString *headImg;
//老图
@property (nonatomic, copy) NSString * libPath;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * sex;
//新图
@property (nonatomic, copy) NSString * snapPath;
@end
