//
//  HTProductStyleModel.h
//  有术
//
//  Created by mac on 2017/5/16.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTProductStyleModel : NSObject
//上货年份
@property (nonatomic,strong) NSString *year;
//大类
@property (nonatomic,strong) NSString *categoryname;

@property (nonatomic,strong) NSString *name;

@property (nonatomic,strong) NSString *stylecode;

@property (nonatomic,strong) NSString *barcode;

@property (nonatomic,strong) NSString *price;

@property (nonatomic,strong) NSString *colorgroup;

@property (nonatomic,strong) NSString *sizegroup;

@property (nonatomic,strong) NSDictionary *season;

@property (nonatomic,strong) NSDictionary *category;

@property (nonatomic,strong) NSDictionary *productStyleDic;

@property (nonatomic,strong) NSString *imgs;

@property  (nonatomic,strong) NSString *topimg;

@property (nonatomic,strong) NSString *brandimgs;

@end
