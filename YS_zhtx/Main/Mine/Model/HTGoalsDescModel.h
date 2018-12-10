//
//  HTGoalsDescModel.h
//  YS_zhtx
//
//  Created by mac on 2018/6/4.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, HTSelectedGoalsType) {
    HTSelectedGoalsTypeNomal ,
    HTSelectedGoalsTypeToday  ,
    HTSelectedGoalsTypeMonth  ,
    HTSelectedGoalsTypeYear,
};

@interface HTGoalsDescModel : NSObject

@property (nonatomic,assign) BOOL isOpen;

@property (nonatomic,assign) HTSelectedGoalsType selectedGoalstype;

@end
