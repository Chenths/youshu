//
//  DBManager.h
//  GiftComeGiftGo
//
//  Created by 成都千锋 on 15/10/22.
//  Copyright (c) 2015年 HX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTLogisticsCompanyModle.h"
@interface DBManager : NSObject
+ (DBManager *)shareManager;



-(HTLogisticsCompanyModle *)SeclectComanyNameWithString:(NSString *) companyCode;


@end
