//
//  HTHoldChargeManager.h
//  YS_zhtx
//
//  Created by mac on 2018/7/25.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//  负责管理收银页面的网络请求及数据处理
#import "HTCahargeProductModel.h"
#import <Foundation/Foundation.h>

typedef void(^Succes)(id json);

typedef void(^Erro)(void);


typedef void(^GETModel)(HTCahargeProductModel *model);
@interface HTHoldChargeManager : NSObject


+(void)getProductDataFromBarcode:(NSString *)barcode andPhone:(NSString *)phone andId:(NSString *)customerId WithSucces:(Succes) succes;

+(void)getProductModelWithJsonData:(id) json withModel:(GETModel) getModel andSearchStr:(NSString *)searchStr;

+(NSString *)getProductIdsFormArray:(NSArray *) products;

+(NSString *)getReturnProductIdsFormArray:(NSArray *) products;

+(NSString *)getbcProductJsonStrFormArray:(NSArray *) products;

+(void)createOrderWithProductJsonStr:(NSString *)productJsonStr andCustId:(NSString *)custid WithSucces:(Succes) succes error:(Erro) error;
+(NSArray *)cheakIsLockPruductsFormLockArray:(NSArray*) pruductsArray andDatas:(NSMutableArray *)datas;
@end
