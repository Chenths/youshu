//
//  HTChargeProductInfoModel.h
//  YS_zhtx
//
//  Created by mac on 2018/7/25.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTChargeProductInfoModel : NSObject

@property (nonatomic,strong) NSString *barcode;

@property (nonatomic,strong) NSString *color;

@property (nonatomic,strong) NSString *colorcode;

@property (nonatomic,strong) NSString *size;

@property (nonatomic,strong) NSString *sizecode;

@property (nonatomic,strong) NSString *year;

@property (nonatomic,strong) NSString *season;

@property (nonatomic,strong) NSString *finalprice;

@property (nonatomic,strong) NSString *price;

@property (nonatomic,strong) NSString *productimage;

@property (nonatomic,strong) NSString *discount;

@property (nonatomic,strong) NSString *customtype;

@property (nonatomic,strong) NSString *stylecode;

@property (nonatomic,strong) NSString *inventory;

@property (nonatomic,strong) NSString *productId;

@property (nonatomic,strong) NSString *primaryKey;

@property (nonatomic,strong) NSString *sizegroup;

@property (nonatomic,assign) BOOL isSelected;

@end
