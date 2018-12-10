//
//  HTBossSelectedTimeModel.h
//  有术
//
//  Created by mac on 2018/4/24.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTBossSelectedTimeModel : NSObject

@property (nonatomic,strong) NSString *title;

@property (nonatomic,strong) NSString *beginTime;

@property (nonatomic,strong) NSString *endTime;

@property (nonatomic,strong) NSString *companyName;

@property (nonatomic,strong) NSString *companyId;

@property (nonatomic,assign) BOOL isCompany;

@end
