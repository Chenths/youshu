//
//  HTScanLogistiscViewController.h
//  YS_zhtx
//
//  Created by mac on 2018/10/11.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
typedef void(^SCANRESULT)(NSString *result);
#import "HTCommonViewController.h"

@interface HTScanLogistiscViewController : HTCommonViewController

@property (nonatomic,copy) SCANRESULT scanResult;
@end
