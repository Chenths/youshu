//
//  HTDateSaleDescModel.h
//  YS_zhtx
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, HTSaleDataDescType) {
    HTSelectedGoalsTypeNomal ,
    HTSaleDataDescTypeDay  ,
    HTSaleDataDescTypeMonth  ,
    HTSaleDataDescTypeYear,
};

@interface HTDateSaleDescModel : NSObject


@property (nonatomic,assign) HTSaleDataDescType  dataType;

@end
