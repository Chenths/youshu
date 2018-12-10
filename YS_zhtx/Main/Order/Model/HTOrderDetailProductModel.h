//
//  HTOrderDetailProductModel.h
//  YS_zhtx
//
//  Created by mac on 2018/7/3.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, HTProductState) {
    HTProductNormal = 0,
    HTProductStateReturn,
    HTProductStateChange,

};

@interface HTOrderDetailProductModel : NSObject

@property (nonatomic,strong) NSString *barcode;
@property (nonatomic,strong) NSString *color;
@property (nonatomic,strong) NSString *createdate;
@property (nonatomic,strong) NSString *customtype;
@property (nonatomic,strong) NSString *discount;
@property (nonatomic,strong) NSString *finalprice;
@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSString *season;
@property (nonatomic,strong) NSString *size;
@property (nonatomic,strong) NSString *state;
@property (nonatomic,strong) NSString *totalprice;
@property (nonatomic,strong) NSString *year;
@property (nonatomic,strong) NSString *month;

@property (nonatomic,strong) NSString *productId;

@property (nonatomic,strong) NSString *primaryKey;

@property (nonatomic,assign) HTProductState productState;


@property (nonatomic,assign) BOOL isCheak;


@property (nonatomic,assign) BOOL isSelected;

@end
