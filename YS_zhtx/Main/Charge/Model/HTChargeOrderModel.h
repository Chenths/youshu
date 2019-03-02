//
//  HTChargeOrderModel.h
//  YS_zhtx
//
//  Created by mac on 2018/8/14.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTChargeOrderModel : NSObject

@property (nonatomic,strong) NSString *ordernum;

@property (nonatomic,strong) NSString *orderId;

@property (nonatomic,strong) NSString *orderstatus;

@property (nonatomic,strong) NSString *name;

@property (nonatomic,strong) NSString *totalprice;

@property (nonatomic,strong) NSString *finalprice;

@property (nonatomic,strong) NSString *hasmodifiedprice;

@property (nonatomic,strong) NSString *encodeFinal;

@property (nonatomic,strong) NSString *encodeTotal;

//退换货时新增数据

@property (nonatomic,strong) NSString *alipayorderid;
//pay
@property (nonatomic,strong) NSString *paytype;
//ispos
@property (nonatomic,strong) NSString *ispos;
//mpayType
@property (nonatomic,strong) NSString *mpaymenttype;
@property (nonatomic, strong) NSString *salername;
@end

