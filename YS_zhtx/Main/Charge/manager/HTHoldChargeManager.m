//
//  HTHoldChargeManager.m
//  YS_zhtx
//
//  Created by mac on 2018/7/25.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTCustomDefualAlertView.h"
#import "HTSelectedProductStyleAlert.h"
#import "HTHoldChargeManager.h"
#import "HTChargeProductInfoModel.h"
#import "HTOrderDetailProductModel.h"
#import "HTBatchTurnInController.h"
#import "HTCahargeProductModel.h"
@implementation HTHoldChargeManager
//创建订单

/**
 创建订单

 @param productJsonStr 产品的数据构造的json字符串
 @param custid 用户id
 @param succes 成功操作
 @param error1 失败的操作
 */
+(void)createOrderWithProductJsonStr:(NSString *)productJsonStr andCustId:(NSString *)custid WithSucces:(Succes)succes error:(Erro) error1{
    NSDictionary *dic = @{
                          @"bcProductJsonStr":productJsonStr,
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"customerId":[HTHoldNullObj getValueWithUnCheakValue:custid]
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleOrder,createOrder4App] params:dic success:^(id json) {
        if (succes) {
            succes(json);
        }
        [MBProgressHUD hideHUD];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
        if (error1) {
            error1();
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
        if (error1) {
            error1();
        }
    }];
}


/**
 根据搜索的条码和用户电话获取产品数据

 @param barcode 搜索的条码
 @param phone 用户电话
 @param succes 成功的操作
 */
+(void)getProductDataFromBarcode:(NSString *)barcode andPhone:(NSString *)phone andId:(NSString *)customerId WithSucces:(Succes)succes{
    NSDictionary *dic = @{
                          @"barcode": [self holdBarcode:barcode],
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"scanType":@"BC",
                          @"id":[HTHoldNullObj getValueWithUnCheakValue:customerId]
                          };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleProduct,searchByBarcode] params:dic success:^(id json) {
        if ([[json[@"data"] getStringWithKey:@"inventoryState"] isEqualToString:@"1"] && [HTShareClass shareClass].isProductStockActive) {
            [MBProgressHUD hideHUD];
            HTCustomDefualAlertView *alert =  [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"该商品库存不足，是否调入" btsArray:@[@"取消",@"去调入"] okBtclicked:^{
//                去调入页面
                [HTHoldChargeManager getProductModelWithJsonData:json withModel:^(HTCahargeProductModel *model) {
                    HTBatchTurnInController *vc = [[HTBatchTurnInController alloc] init];
                    vc.dataArray = [@[model] mutableCopy];
                    vc.reloadList = ^{
                        [HTHoldChargeManager getProductDataFromBarcode:barcode andPhone:phone andId:customerId WithSucces:succes];
                    };
                    [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
                } andSearchStr:barcode];
            } cancelClicked:^{
            }];
            [alert notTochShow];
            return ;
        }
        if ([json[@"data"] getArrayWithKey: @"product"].count == 0) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"查无此商品信息，请重新输入"];
            return ;
        }
        if (succes) {
            succes(json);
        }
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
    
}

/**
 
 根据返回的json处理 并获取到产品

 @param json 返回的json数据
 @param getModel 获取模型的block
 @param searchStr 搜索的产品码
 */
+(void)getProductModelWithJsonData:(id)json withModel:(GETModel)getModel andSearchStr:(NSString *)searchStr{
//    获取当前条码获取的产品资料  获取返回值的 多个款
    NSArray *styles = [self getStyleProductsWithArray:json[@"data"][@"product"]];
    if (styles.count > 1) {
//     如果返回值有多个款 用户先选择具体款号
        [HTSelectedProductStyleAlert showSelectedProductStyleData:styles withSearchStr:searchStr andSeleced:^(NSInteger index) {
            NSArray *producs = styles[index];
            NSMutableArray *product = [NSMutableArray array];
            for (NSDictionary *dic in producs) {
                HTChargeProductInfoModel *model = [HTChargeProductInfoModel yy_modelWithJSON:dic];
                [product addObject:model];
            }
            HTCahargeProductModel *model = [[HTCahargeProductModel alloc] init];
            model.product = product;
            [self configModel:model];
            if (getModel) {
                getModel(model);
            }
        }];
        }else{
//       返回的产品 只有一个款 返回数据
        NSMutableArray *product = [NSMutableArray array];
        for (NSDictionary *dic in [styles firstObject]) {
            HTChargeProductInfoModel *model = [HTChargeProductInfoModel yy_modelWithJSON:dic];
            [product addObject:model];
        }
        HTCahargeProductModel *model = [[HTCahargeProductModel alloc] init];
        model.product = product;
        [self configModel:model];
        if (getModel) {
          getModel(model);
        }
    }

}
//获取产品款列表
+(NSArray *)getStyleProductsWithArray:(NSArray *)products{
    
    NSMutableArray *styleCodeArr = [NSMutableArray array];
    NSMutableArray *styleProducts = [NSMutableArray array];
    for (NSDictionary *dic in products) {
        if (styleCodeArr.count == 0) {
            [styleCodeArr addObject:[dic getStringWithKey:@"stylecode"]];
            NSMutableArray *productArrs = [NSMutableArray array];
            for (NSDictionary *dict in products) {
                if ([[dic getStringWithKey:@"stylecode"] isEqualToString:[dict getStringWithKey:@"stylecode"]]) {
                    [productArrs addObject:dict];
                }
            }
            [styleProducts addObject:productArrs];
        }else{
            if (![styleCodeArr containsObject:[dic getStringWithKey:@"stylecode"]]) {
                [styleCodeArr addObject:[dic getStringWithKey:@"stylecode"]];
                NSMutableArray *productArrs = [NSMutableArray array];
                for (NSDictionary *dict in products) {
                    if ([[dic getStringWithKey:@"stylecode"] isEqualToString:[dict getStringWithKey:@"stylecode"]]) {
                        [productArrs addObject:dict];
                    }
                }
                [styleProducts addObject:productArrs];
            }
        }
    }
    return styleProducts;
}
//处理产品条码
+(NSString *)holdBarcode:(NSString *)barcode{
    
    NSString *length = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@-%@",[HTShareClass shareClass].loginModel.companyId,@"BarcodeLength"]];
    NSString *code = @"";
    if (length.length == 0) {
        code = barcode;
    }else{
        NSInteger len = [length integerValue];
        if (barcode.length <= len) {
            code = barcode;
        }else if (len == 0){
            code = barcode;
        }else{
            code = [barcode substringWithRange:NSMakeRange(0, len)];
        }
    }
    return code;
}
//配置产品模型参数
+(void)configModel:(HTCahargeProductModel *)model{
    NSMutableArray *colors = [NSMutableArray array];
    NSMutableArray *sizes = [NSMutableArray array];
    for (HTChargeProductInfoModel *mmm in model.product) {
     [colors addObject:[NSString stringWithFormat:@"%@(####)%@",mmm.color,mmm.colorcode]];
     [sizes addObject:[NSString stringWithFormat:@"%@(####)%@",mmm.size,mmm.sizecode]];
    }
//    去重
    NSSet *colorset = [NSSet setWithArray:colors];
    NSSet *sizeset = [NSSet setWithArray:sizes];
    NSArray *cccc = [colorset allObjects];
    NSArray *ssss = [sizeset allObjects];
    NSMutableArray *colorGoup = [NSMutableArray array];
    for (NSString *color in cccc) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSArray *sss = [color componentsSeparatedByString:@"(####)"];
        if (sss.count >= 2) {
        [dic setObject:sss[0] forKey:@"color"];
        [dic setObject:sss[1] forKey:@"colorcode"];
        }
        [colorGoup addObject:dic];
    }
    NSMutableArray *sizeGroup = [NSMutableArray array];
    for (NSString *size in ssss) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSArray *sss = [size componentsSeparatedByString:@"(####)"];
        if (sss.count >= 2) {
            [dic setObject:sss[0] forKey:@"size"];
            [dic setObject:sss[1] forKey:@"sizecode"];
        }
        [sizeGroup addObject:dic];
    }
//    获取到当前款的所有颜色 尺码
    model.sizeGrop = sizeGroup;
    model.colorGrop = colorGoup;
}
//获取产品ID字符串，用”,”号隔开
+(NSString *)getProductIdsFormArray:(NSArray *)products{
    NSMutableArray *ids = [NSMutableArray array];
    for (HTCahargeProductModel *mm in products) {
        if (!mm.selectedModel) {
            HTChargeProductInfoModel *mode = [mm.product firstObject];
            if (mode.stylecode.length > 0) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@ 商品资料不全",mode.stylecode]];
            }
            return @"";
        }
        if (mm.selectedModel.productId.length == 0) {
            HTChargeProductInfoModel *mode = [mm.product firstObject];
            if (mode.stylecode.length > 0) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@ 商品资料不全",mode.stylecode]];
            }
            return @"";
        }
        [ids addObject:mm.selectedModel.productId];
    }
    return ids.count > 0 ? [ids componentsJoinedByString:@","] : @"";
}
//获取产品的唯一id  用","隔开的字符串
+ (NSString *)getReturnProductIdsFormArray:(NSArray *)products{
     NSMutableArray *ids = [NSMutableArray array];
    for (HTOrderDetailProductModel *mm in products) {
     [ids addObject:mm.primaryKey];
    }
     return ids.count > 0 ? [ids componentsJoinedByString:@","] : @"";
}
//获取产品id 用","隔开的字符串
+(NSString *)getbcProductJsonStrFormArray:(NSArray *)products{
    NSMutableArray *ids = [NSMutableArray array];
    for (HTCahargeProductModel *mm in products) {
        if (!mm.selectedModel) {
            HTChargeProductInfoModel *mode = [mm.product firstObject];
            if (mode.stylecode.length > 0) {
              [MBProgressHUD showError:[NSString stringWithFormat:@"%@ 商品资料不全",mode.stylecode]];
            }
            return @"";
        }
        if (mm.selectedModel.productId.length == 0) {
            HTChargeProductInfoModel *mode = [mm.product firstObject];
            if (mode.stylecode.length > 0) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@ 商品资料不全",mode.stylecode]];
            }
            return @"";
        }
        [ids addObject:@{@"productId": mm.selectedModel.productId,@"dicount":mm.selectedModel.discount}];
    }
    return [ids arrayToJsonString];
}
//获取库存异常的产品
+(NSArray *)cheakIsLockPruductsFormLockArray:(NSArray *)pruductsArray andDatas:(NSMutableArray *)datas  {
    NSMutableArray *notproductModels = [NSMutableArray array];
    for (NSString *productid in pruductsArray) {
        for (HTCahargeProductModel *obj in datas) {
            HTChargeProductInfoModel *mmm = obj.selectedModel;
            if ([[HTHoldNullObj getValueWithUnCheakValue:mmm.productId] isEqualToString:productid]) {
                if (![notproductModels containsObject:obj]) {
                    [notproductModels addObject:obj];
                    break;
                }
            }
        }
    }
    return notproductModels;
}
@end
