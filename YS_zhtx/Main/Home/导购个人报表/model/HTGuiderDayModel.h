//
//  HTGuiderDayModel.h
//  YS_zhtx
//
//  Created by mac on 2018/10/9.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTGuiderDayItmeModel.h"
#import <Foundation/Foundation.h>

@interface HTGuiderDayModel : NSObject

@property (nonatomic,strong) NSString *count;
@property (nonatomic,strong) NSString *salesAmount;
@property (nonatomic,strong) NSString *salesPrice;
@property (nonatomic,strong) NSString *salesVolume;

@property (nonatomic,strong) NSArray *Model;

@end
