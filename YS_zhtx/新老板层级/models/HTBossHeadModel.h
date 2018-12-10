//
//  HTBossHeadModel.h
//  有术
//
//  Created by mac on 2018/4/26.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,HTCompareHeadType ) {
    HTCompareHeadTime  = 0,
    HTCompareHeadShop     = 1,
};
@interface HTBossHeadModel : NSObject

@property (nonatomic,strong) NSString *selecetedTime;
@property (nonatomic,strong) NSString *selecetedCompany;
@property (nonatomic,strong) NSArray *companys;
@property (nonatomic,strong) NSArray *dates;
@property (nonatomic,strong) NSString *selectedCompanyId;
@property (nonatomic,strong) NSString *selectedBeginTime;
@property (nonatomic,strong) NSString *selectedEndTime;
@property (nonatomic,assign) HTCompareHeadType headType;



@end
