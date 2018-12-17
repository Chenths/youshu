//
//  HTFastPrudoctModel.h
//  有术
//
//  Created by mac on 2018/5/14.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTFastPrudoctModel : NSObject

@property (nonatomic,strong) NSString *barcode;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *finalprice;
@property (nonatomic,strong) NSString *discount;
@property (nonatomic,strong) NSString *numbers;
@property (nonatomic,strong) NSString *categoryName;
@property (nonatomic,strong) NSString *categoryId;
@property (nonatomic,strong) NSDictionary *state;

-(NSString *)getFinallPriceWithPrice:(NSString *)price andDiscount:(NSString *)discount;

@end
