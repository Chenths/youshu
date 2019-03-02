//
//  HTPrinterTool.m
//  24小助理
//
//  Created by mac on 16/9/1.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#define FeieBaseUrl @"http://api.feieyun.cn/Api/Open/"
#define bangdingPrinterUrl @"http://api.aykj0577.com/WS/CealData.ashx"
#define PrintUrl @"http://api.aykj0577.com/WS/DealData.ashx"
#define APIKey @"jdn8zt6jth8d2fnt"
#import "HTPrinterTool.h"
#import "NSString+md5.h"
#import "NSString+font.h"
#import "NSString+Json.h"
#import "SecurityUtil.h"
#import "HTAccountTool.h"
#import "HTPrinterViewController.h"
#import "NSString+Json.h"
#import "HLPrinter.h"
#import "HTChangePrinterBrandController.h"
#import "HTBlueToothPrinterController.h"
#import "HTLoginDataPersonModel.h"

@interface HTPrinterTool()<SelectPrinterBrandDelegate>

@property (nonatomic,strong) NSString  *version;

@property (nonatomic,assign) BOOL isBig;

@end;


@implementation HTPrinterTool

- (void)printOrderReceiptWithOrder:(NSString *)orderId{
    [MBProgressHUD showMessage:@""];
    NSDictionary *dic = @{
                          @"orderId":orderId,
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleOrder,queryOrderPrintInfo4App] params:dic success:^(id json) {
        [MBProgressHUD  hideHUD];
        NSDictionary *dataDic = [json getDictionArrayWithKey:@"data"];
        if (dataDic) {
            NSString *isNul = [dataDic getStringWithKey:@"isNull"];
            if ([isNul isEqualToString:@"1"]) {
                [MBProgressHUD showError:@"当前订单不支持打印"];
            }else if ([isNul isEqualToString:@"0"]){
                if ([dataDic getDictionArrayWithKey:@"printInfo"]) {
                    [[HTShareClass shareClass].printerModel setValuesForKeysWithDictionary:[dataDic getDictionArrayWithKey:@"printInfo"]];
                    [HTShareClass shareClass].printerModel.salerName = [[dataDic getDictionArrayWithKey:@"printInfo"] objectForKey:@"seller"];
                    self->isReceipt = YES;
                    
                    NSString *payType = [[dataDic objectForKey:@"printInfo"] objectForKey:@"payType"];
                    if ([self IsChinese:payType]) {
                        
                        if ([payType isEqualToString:@"现金支付"]) {
                            [HTShareClass shareClass].printerModel.paytype = cashType;
                        }else if ([payType isEqualToString:@"刷卡支付"]) {
                            [HTShareClass shareClass].printerModel.paytype = posType;
                        }else if ([payType isEqualToString:@"现金支付"]) {
                            [HTShareClass shareClass].printerModel.paytype = cashType;
                        }else if ([payType isEqualToString:@"储值支付"]) {
                            [HTShareClass shareClass].printerModel.paytype = storedType;
                        }else if ([payType isEqualToString:@"储赠支付"]) {
                            [HTShareClass shareClass].printerModel.paytype = storedSendType;
                        }else if ([payType isEqualToString:@"支付宝支付"]) {
                            [HTShareClass shareClass].printerModel.paytype = alipayType;
                        }else if ([payType isEqualToString:@"微信支付"]) {
                            [HTShareClass shareClass].printerModel.paytype = wetchatType;
                        }else{
                            [HTShareClass shareClass].printerModel.paytype = mixType;
                        }
                    }
                    
                    [self print];
                }
            }
        }
    } error:^{
        [MBProgressHUD  hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD  hideHUD];
        [MBProgressHUD showError:@"网络请求失败，请检查你的网络"];
    }];
}

-(BOOL)IsChinese:(NSString *)str {
    if (![str isKindOfClass:[NSString class]]) {
        return NO;
    }
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
        
    }
    return NO;
    
}


- (void)savePrintDataWithOrderId:(NSString *) orderId{
    NSMutableDictionary *printDic = [[[NSUserDefaults standardUserDefaults] objectForKey:PRINGDICKEY] mutableCopy];
    if (!printDic) {
        printDic = [NSMutableDictionary dictionary];
    }
    NSString * jsonStr = [self getPrintJsonStrWithModel:[HTShareClass shareClass].printerModel];
    printDic[orderId] = jsonStr;
    if ([HTShareClass shareClass].printerModel.exchangeGoodsList.count > 0) {
    }
    [[NSUserDefaults standardUserDefaults] setObject:printDic forKey:PRINGDICKEY];
    [self sendPrintData];
}
- (void)sendPrintData{
    
    NSDictionary *printDic = [[NSUserDefaults standardUserDefaults] objectForKey:PRINGDICKEY];
    NSArray *keyArr = [printDic allKeys];
    for (NSString *key in keyArr) {
        NSString *jsonStr = [printDic objectForKey:key];
        [self postJsonPrintStrWithJsonStr:jsonStr andOrderId:key];
    }
}
- (void) postJsonPrintStrWithJsonStr:(NSString *) jsonStr andOrderId: (NSString *) orderId{
    NSDictionary *dic = @{
                          @"orderId": orderId,
                          @"printInfo" : jsonStr,
                          @"companyId" : [HTShareClass shareClass].loginModel.companyId
                          };
    
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleOrder,createOrderPrintInfo4App] params:dic success:^(id json) {
        NSMutableDictionary *printDic = [[[NSUserDefaults standardUserDefaults] objectForKey:PRINGDICKEY] mutableCopy];
        if ([printDic getStringWithKey:orderId]) {
            [printDic removeObjectForKey:orderId];
        }
        [[NSUserDefaults standardUserDefaults] setObject:printDic forKey:PRINGDICKEY];
    } error:^{
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf postJsonPrintStrWithJsonStr:jsonStr andOrderId:orderId];
        });
        
    } failure:^(NSError *error) {
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf postJsonPrintStrWithJsonStr:jsonStr andOrderId:orderId];
        });
    }];
}
- (void)print{
    if (!isReceipt) {
        [self savePrintDataWithOrderId:[HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].printerModel.orderId]];
    }
    
    switch ([HTShareClass shareClass].loginModel.printers.count) {
        case 0:
        {
            if ([[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@%@",[HTShareClass shareClass].loginModel.companyId,@"blueTooth"]]) {
                self.version = [NSString stringWithFormat:@"%d",3];
                HTBlueToothPrinterController *vc = [[HTBlueToothPrinterController alloc] init];
                vc.bigPrinter = [self getPrintArrayWithSize:YES];
                vc.pushNext = self.pushNext;
                vc.smallPrinter = [self getPrintArrayWithSize:NO];
                [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
                return;
            }
            
            NSString *lastVerson = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastVersion"];
            NSString *versionKey = (__bridge NSString *)kCFBundleVersionKey;
            NSString *currentVersion =  [NSBundle mainBundle].infoDictionary[versionKey];
            if ([lastVerson isEqualToString:currentVersion]) {
                if (self.pushNext) {
                    self.pushNext();
                }
                [MBProgressHUD showError:@"如需要打印小票,请至打印设备管理去添加打印机"];
                
            }else{
                [self addPrinter];
            }
            
        }
            break;
        case 1:{
            NSDictionary *dic = [[HTShareClass shareClass].loginModel.printers firstObject];
            _number = dic[@"name"];
            [self doPrintWithNum:dic[@"name"]];
            if (self.pushNext) {
                self.pushNext();
            }
        }
            break;
        default:{
            for (NSDictionary *dic in [HTShareClass shareClass].loginModel.printers) {
                NSDictionary *dict = [dic[@"config"] dictionaryWithJsonString];
                if ([dict[@"default"] isEqualToString:@"1"]) {
                    [self doPrintWithNum:dic[@"name"]];
                    if (self.pushNext) {
                        self.pushNext();
                    }
                    _number = dic[@"name"];
                    return;
                }
            }
            HTPrinterViewController *vc = [[HTPrinterViewController alloc] init];
            __weak typeof(self) weakSelf = self;
            vc.selectWhich = ^(NSString *num){
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (num.length > 0) {
                 [strongSelf doPrintWithNum:num];
                }
                if (strongSelf.pushNext) {
                    strongSelf.pushNext();
                }
            };
            vc.title = @"请选择打印机";
            [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];;
            
        }
            break;
    }
}
- (void) doPrintWithNum:(NSString *) num{
    if (self.version.length > 0) {
        if ([self.version isEqualToString:@"2"]) {
            [self printReceiptWithNum:num andpage:2];
        }else if ([self.version isEqualToString:@"1"]){
            for (int i = 0; i < 2; i++) {
                [self printReceiptWithNum:num andpage:1];
            }
        }
    }
    
    for (NSDictionary *dic in [HTShareClass shareClass].loginModel.printers) {
        NSDictionary *dict = [dic[@"config"] dictionaryWithJsonString];
        if ([dic[@"name"] isEqualToString:num]) {
            NSInteger pages = [dict[@"printCount"] integerValue];
            if (pages < 2 ) {
                pages = 2;
            }
#ifdef DEBUG
            pages = 1;
#else
#endif
            if (self.version.length == 0) {
                self.version = [dict getStringWithKey:@"version"].length == 0 ? @"1" : [dict getStringWithKey:@"version"];
            }
            //这里判断
            if ([self.version isEqualToString:@"2"]) {
                [self printReceiptWithNum:num andpage:pages];
            }else if ([self.version isEqualToString:@"1"]){
                for (int i = 0; i < pages; i++) {
                    [self printReceiptWithNum:num andpage:1];
                }
            }
        }
    }
}
- (void) addPrinter{
    if (self.version.length == 0) {
        HTChangePrinterBrandController *vc = [[HTChangePrinterBrandController alloc] init];
        vc.delegate = self;
        [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
    }else{
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"请输入打印机编号" message:nil delegate:  self  cancelButtonTitle:@"取消" otherButtonTitles:@"确定",_isNoPrint ? nil : @"不再提醒", nil];
        av.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        av.tag = 800;
        av.delegate = self;
        [av textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
        [av textFieldAtIndex:0].placeholder = @"请输入打印机编码";
        [av textFieldAtIndex:1].keyboardType = 1;
        [av textFieldAtIndex:1].placeholder = @"打印机注册密码，第一次为注册密码";
        [av textFieldAtIndex:1].autocorrectionType = UITextAutocorrectionTypeNo;
        [av show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (alertView.tag) {
        case 800:
        {
            if (buttonIndex == 1) {
                UITextField *text = [alertView textFieldAtIndex:0];
                password = [alertView textFieldAtIndex:1].text;
                if (text.text.length < 9 ) {
                    [MBProgressHUD showError:@"设备号为9位"];
                    [self addPrinter];
                    return;
                }
                if (password.length == 0 ) {
                    [MBProgressHUD showError:@"密码不能为空"];
                    [self addPrinter];
                    return;
                }
                [MBProgressHUD showMessage:@""];
                [self  registPrinterWithNum:text.text];
            }else if (buttonIndex == 2){
                NSString *versionKey = (__bridge NSString *)kCFBundleVersionKey;
                [[NSUserDefaults standardUserDefaults] setObject:[NSBundle mainBundle].infoDictionary[versionKey] forKey:@"lastVersion"];
                if (self.pushNext) {
                    self.pushNext();
                }
            }else if(buttonIndex == 0 ){
                self.version = @"";
                if (self.pushNext) {
                    self.pushNext();
                }
            }
        }
            break;
        case 801:
            if (buttonIndex == 1) {
                [self printReceiptWithNum:_number andpage:1];
            }
            break;
            
        default:
            break;
    }
    
}
//- (void) saveChildPrinterToSever


- (void) addPrinterToSeverWithNum:(NSString *) num passWord:(NSString *) password1{
    
    NSDictionary *dic = @{
                          @"companyId" : [HTShareClass shareClass].loginModel.companyId,
                          @"deviceCode" : num,
                          @"password" : password1,
                          @"version": self.version
                          };
    
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleDevice,savePrinter4App] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        if ([json[@"state"] intValue] == 1) {
            
            if (self->_dosucces) {
                self->_dosucces();
            }else{
                //绑定成功   //已经绑定
                [self doPrintWithNum:num];
                [HTAccountTool loginWillEnterForeground:^{
                } Succes:^(id json){
                }];
            }
            if (self.pushNext) {
                self.pushNext();
            }
        }else if([json[@"state"] intValue] == 0){
            [MBProgressHUD showError:@"密码错误"];
            [self addPrinter];
        }
    } error:^{
        [MBProgressHUD hideHUD];
        [self addPrinter];
        [ MBProgressHUD showError:@"网络繁忙，添加失败"];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [self addPrinter];
        [MBProgressHUD showError:@"添加失败，请检查网络"];
    }];
}





- (void)registPrinterWithNum:(NSString *) num{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //申明返回的结果是json类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.f;
//    [manager setSecurityPolicy:[self customSecurityPolicy]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    if ([self.version isEqualToString:@"1"]) {
        NSString *key = [NSString stringWithFormat:@"%@%@%@",num,APIKey,@"printer"];
        NSDictionary *dict = @{
                               @"op" : @"add",
                               @"unm": @"zhtxzw",
                               @"dno": num,
                               @"key": [key md5:key],
                               };
        [manager POST:bangdingPrinterUrl parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            
            NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            if ([string isEqualToString:@"0"] ||[string isEqualToString:@"-150"] ) {
                [self addPrinterToSeverWithNum:num passWord:self->password];
            }else{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"添加失败，请检查打印机编号是否正确"];
                [self addPrinter];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUD];
            [self addPrinter];
        }];
    }else if([self.version isEqualToString:@"2"]){
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a= [dat timeIntervalSince1970];
        NSString *stime = [[NSString stringWithFormat:@"%f",a] substringWithRange:NSMakeRange(0, 10)];
        NSDictionary *dict = @{
                               @"user": @"zhtxzw@sina.com",
                               @"stime":stime,
                               @"sig":[[NSString stringWithFormat:@"%@%@%@",@"zhtxzw@sina.com",@"HGAFArqL3myKxYFG",stime] sha1],
                               @"apiname" : @"Open_printerAddlist",
                               //订单编号
                               @"printerContent":[NSString stringWithFormat:@"%@#%@",num,password],
                               };
        [manager POST:FeieBaseUrl parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([[dic getStringWithKey:@"ret"] isEqualToString:@"0"] && [[dic getDictionArrayWithKey:@"data"] getArrayWithKey:@"no"].count == 0) {
                [self addPrinterToSeverWithNum:num passWord:self->password];
            }else{
                BOOL isOK = NO;
                if ([[dic getDictionArrayWithKey:@"data"] getArrayWithKey:@"no"].count == 1) {
                    NSString *str = [[[dic getDictionArrayWithKey:@"data"] getArrayWithKey:@"no"] firstObject];
                    NSRange range = [str rangeOfString:@"添加过"];
                    if (range.length > 0) {
                        [self addPrinterToSeverWithNum:num passWord:self->password];
                    }else{
                        [MBProgressHUD hideHUD];
                        [self addPrinter];
                    }
                }else{
                    [MBProgressHUD hideHUD];
                    [self addPrinter];
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUD];
            [self addPrinter];
        }];
    }
}

- (void)printReceiptWithNum:(NSString *) num  andpage:(NSInteger)page
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.f;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json",@"text/json", @"text/plain", @"text/html", nil];
//    [manager setSecurityPolicy:[self customSecurityPolicy]];
    NSString *key = [NSString stringWithFormat:@"%@%@%@",APIKey,num,@"aykj"];
    
    NSString *shortName = [[HTShareClass shareClass].loginModel.company[@"shortName"] length] > 0 ? [HTShareClass shareClass].loginModel.company[@"shortName"] : @"";
    NSMutableDictionary *printDic = [NSMutableDictionary dictionary];
    [printDic setObject:[SecurityUtil encryptAESData:[HTShareClass shareClass].printerModel.orderId] forKey:@"modelId"];
    [printDic setObject:[SecurityUtil encryptAESData:[NSString stringWithFormat:@"%@",[HTShareClass shareClass].loginModel.companyId]]  forKey:@"companyId"];
    
    NSMutableString *content = [NSMutableString string];
    
    if ([HTShareClass shareClass].printerModel.goodsList.count > 0) {
        NSArray *arr = [HTShareClass shareClass].printerModel.goodsList;
        [content appendString:[self getHeaderWithString:shortName]];
        [content appendString:[self getShopName]];
        [content appendString:[self newLine]];
        [content appendString:[self salerTextWith:[HTShareClass shareClass].printerModel.salerName]];
        [content appendString:[self saleNumber:[HTShareClass shareClass].printerModel.orderNo]];
        [content appendString:[self getAddress]];
        [content appendString:[self getLine]];
        [content appendString:[self getGoodsWithDic:arr]];
        [content appendString:[self getLine]];
        [content appendString:[self getTotleWithSth:[HTShareClass shareClass].printerModel.orderTotalPrize]];
        [content appendString:[self finallTextWith:[HTShareClass shareClass].printerModel.orderFinalPrize]];
        [content appendString:[self getIsPos]];
        [content appendString:[self integralNumWithNum:[HTShareClass shareClass].printerModel.points]];
        [content appendString:[self discountMoney:[HTShareClass shareClass].printerModel.coupons]];
        [content appendString: [self storedNumWithNum:[HTShareClass shareClass].printerModel.storeValue]];
        [content appendString: [self storedsendNumWithNum:[HTShareClass shareClass].printerModel.freeStoreValue]];
        [content appendString: [self customerPhoneTextWith:[HTShareClass shareClass].printerModel.telPhone]];
        [content appendString:[self orderDesc:[HTShareClass shareClass].printerModel.orderDesc]];
        [content appendString:[[NSString stringWithFormat:@"%@",[HTShareClass shareClass].printerModel.date] string24WithVersion:self.version]];
        [content appendString:[self tipsText]];
        [content appendString:[self newLine]];
//#ifdef DEBUG
//        [content appendString: [[NSString stringWithFormat:@"%@",
//                                 [self jsonStringWithDic:printDic]] string24WithVersion:self.version]];
//#else
//#endif
//        [content appendString: [[NSString stringWithFormat:@"%@",
//                                 [self jsonStringWithDic:printDic]]  QRWithVersion:self.version]];
        [content appendString:[self newLine]];
        [content appendString: [self newLine]];
        [content appendString:[self addExeplan]];
        if ([HTShareClass shareClass].printerModel.afterSalesList.count > 0 ){
            for (NSDictionary *afterDic in [HTShareClass shareClass].printerModel.afterSalesList) {
                HTPrinterModel *model = [[HTPrinterModel alloc] init];
                [model setValuesForKeysWithDictionary:afterDic];
                
                if (model.returnGoodsList.count > 0){
                    
                    [content appendString:[self newLine]];
                    [content appendString: [self newLine]];
                    [content appendString:[self newLine]];
                    [content appendString: [self newLine]];
                    
                    NSMutableDictionary *printDic1 = [NSMutableDictionary dictionary];
                    [printDic1 setObject:[SecurityUtil encryptAESData:model.returnOrderId] forKey:@"modelId"];
                    [printDic1 setObject:[SecurityUtil encryptAESData:[NSString stringWithFormat:@"%@",[HTShareClass shareClass].loginModel.companyId]]  forKey:@"companyId"];
                    
                    
                    [content appendString:[self getHeaderWithString:@"退换货小票"]];
                    [content appendString:[self newLine]];
                    [content appendString:[self salerTextWith:model.returnGuider]];
                    [content appendString:[self saleNumber:model.returnOrderNo]];
                    [content appendString:[self getAddress]];
                    [content appendString:[self getLine]];
                    [content appendString:[@"退换货商品" string24WithVersion:self.version]];
                    [content appendString:[self getGoodsWithDic:model.returnGoodsList]];
                    [content appendString:[self getLine]];
                    if (model.exchangeGoodsList.count > 0) {
                        [content appendString:[@"新商品" string24WithVersion:self.version]];
                        [content appendString:[self getGoodsWithDic:model.exchangeGoodsList]];
                        [content appendString:[self getLine]];
                    }
                    [content appendString:[self getReturnTotleWithSth:model]];
                    [content appendString:[self getReturnIsPosWithModel:model]];
                    [content appendString:[self integralNumWithNum:model.returnPoints]];
                    [content appendString:[self discountMoney:model.returnCoupons]];
                    [content appendString: [self storedNumWithNum:model.returnStoreValue]];
                      [content appendString: [self storedsendNumWithNum:model.returnFreeStoreValue]];
                    [content appendString: [self customerPhoneTextWith:model.telPhone]];
                    [content appendString:[self orderDesc:[HTShareClass shareClass].printerModel.orderDesc]];
                    [content appendString:[[NSString stringWithFormat:@"%@",model.returnTime]  string24WithVersion:self.version]];
                    [content appendString:[self tipsText]];
                    [content appendString:[self newLine]];
//#ifdef DEBUG
//                    [content appendString: [[NSString stringWithFormat:@"%@",
//                                             [self jsonStringWithDic:printDic1]] string24WithVersion:self.version]];
//
//#else
//#endif
//                    [content appendString: [[NSString stringWithFormat:@"%@",
//                                             [self jsonStringWithDic:printDic1]] QRWithVersion:self.version]];
                    [content appendString:[self newLine]];
                    [content appendString: [self newLine]];
                    [content appendString:[self addExeplan]];
                }
            }
            
        }
    }
    else   if ([HTShareClass shareClass].printerModel.returnGoodsList.count > 0){
        
        NSMutableDictionary *printDic1 = [NSMutableDictionary dictionary];
        [printDic1 setObject:[SecurityUtil encryptAESData:[HTShareClass shareClass].printerModel.orderId] forKey:@"modelId"];
        [printDic1 setObject:[SecurityUtil encryptAESData:[NSString stringWithFormat:@"%@",[HTShareClass shareClass].loginModel.companyId]]  forKey:@"companyId"];
        
        
        if ([HTShareClass shareClass].printerModel.goodsList.count > 0) {
            [content appendString:[self newLine]];
            [content appendString: [self newLine]];
            [content appendString:[self newLine]];
            [content appendString: [self newLine]];
        }
        [content appendString:[self getHeaderWithString:@"退换货小票"]];
        [content appendString:[self newLine]];
        [content appendString:[self salerTextWith:[HTShareClass shareClass].printerModel.returnGuider]];
        [content appendString:[self saleNumber:[HTShareClass shareClass].printerModel.returnOrderNo]];
        [content appendString:[self getAddress]];
        [content appendString:[self getLine]];
        [content appendString:[@"退换货商品" string24WithVersion:self.version]];
        [content appendString:[self getGoodsWithDic:[HTShareClass shareClass].printerModel.returnGoodsList]];
        [content appendString:[self getLine]];
        if ([HTShareClass shareClass].printerModel.exchangeGoodsList.count > 0) {
            [content appendString:[@"新商品" string24WithVersion:self.version]];
            [content appendString:[self getGoodsWithDic:[HTShareClass shareClass].printerModel.exchangeGoodsList]];
            [content appendString:[self getLine]];
        }
        [content appendString:[self getReturnTotleWithSth:[HTShareClass shareClass].printerModel]];
        [content appendString:[self getReturnIsPosWithModel:[HTShareClass shareClass].printerModel]];
        [content appendString:[self integralNumWithNum:[HTShareClass shareClass].printerModel.returnPoints]];
        [content appendString:[self discountMoney:[HTShareClass shareClass].printerModel.returnCoupons]];
        [content appendString: [self storedNumWithNum:[HTShareClass shareClass].printerModel.returnStoreValue]];
        [content appendString: [self storedsendNumWithNum:[HTShareClass shareClass].printerModel.returnFreeStoreValue]];
        [content appendString: [self customerPhoneTextWith:[HTShareClass shareClass].printerModel.telPhone]];
        [content appendString:[self orderDesc:[HTShareClass shareClass].printerModel.orderDesc]];
        [content appendString:[[NSString stringWithFormat:@"%@",[HTShareClass shareClass].printerModel.returnTime]  string24WithVersion:self.version]];
        [content appendString:[self tipsText]];
        [content appendString:[self newLine]];
//#ifdef DEBUG
//        [content appendString: [[NSString stringWithFormat:@"%@",
//                                 [self jsonStringWithDic:printDic1]] string24WithVersion:self.version]];
//
//#else
//#endif
//        [content appendString: [[NSString stringWithFormat:@"%@",
//                                 [self jsonStringWithDic:printDic1]] QRWithVersion:self.version]];
        [content appendString:[self newLine]];
        [content appendString: [self newLine]];
        [content appendString:[self addExeplan]];
    }
    
    if ([self.version isEqualToString:@"2"]) {
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a= [dat timeIntervalSince1970];
        NSString *stime = [[NSString stringWithFormat:@"%f",a] substringWithRange:NSMakeRange(0, 10)];
        
        
        NSDictionary *dict = @{
                               @"user": @"zhtxzw@sina.com",
                               @"stime":stime,
                               @"sig":[[NSString stringWithFormat:@"%@%@%@",@"zhtxzw@sina.com",@"HGAFArqL3myKxYFG",stime] sha1],
                               @"apiname" : @"Open_printMsg",
                               //                           订单编号
                               @"sn":num,
                               @"content" : content,
                               @"times" : @(page)
                               };
        
        [manager POST:FeieBaseUrl parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([[dic getStringWithKey:@"ret"] isEqualToString:@"0"]){
                //打印成功
                [HTShareClass shareClass].printerModel = nil;
                [MBProgressHUD showSuccess:@"发送打印任务成功"];
            }else{
                [self showAlert];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self showAlert];
        }];
        
    }else{
        NSDictionary *dict = @{
                               @"op" : @"pf",
                               @"unm": @"zhtxzw",
                               @"dno": num,
                               @"mode" : @"|0",
                               @"key": [key md5:key],
                               //                           订单编号
                               @"msgno":@"",
                               @"content" : content
                               };
        [manager POST:PrintUrl parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"%@",string);
            if ([string isEqualToString:@"0"]) {
                //打印成功
                [HTShareClass shareClass].printerModel = nil;
                [MBProgressHUD showSuccess:@"发送打印任务成功"];
            }else{
                [self showAlert];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self showAlert];
        }];
    }
}


- (void) showAlert{
    __weak typeof(self) weakSelf = self;
    HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"发送打印信息失败，是否重发" btsArray:@[@"取消",@"确定"] okBtclicked:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf printReceiptWithNum:strongSelf.number andpage:1];
    } cancelClicked:^{
    }];
    [alert show];
}

- (NSString *) getHeaderWithString:(NSString *) str{
    
    switch (self.version.intValue) {
        case 1:
        {
            return    [str string48];
        }
            break;
        case 2:
        {
            return [NSString stringWithFormat:@"<CB>%@</CB><BR>",str];
        }
            break;
        case 3:
        {
            return  str;
        }
            break;
        default:{
            return nil;
        }
            break;
    }
    //    return [self.version isEqualToString:@"2"] ? [NSString stringWithFormat:@"<CB>%@</CB><BR>",str] : [str string48];
}

- (NSString *) getLine{
    
    switch (self.version.intValue) {
        case 1:
        {
            return   [@"－－－－－－－－－－－－－－－\n" string24WithVersion:self.version];;
        }
            break;
        case 2:
        {
            return @"－－－－－－－－－－－－－－－－－－－－－－－<BR>";
        }
            break;
        case 3:
        {
            return  self.isBig ?  @"－－－－－－－－－－－－－－－－－－－－－－－" : @"－－－－－－－－－－－－－－－" ;
        }
            break;
            
        default:{
            return nil;
        }
            break;
    }
    //    return [self.version isEqualToString:@"2"] ?  @"－－－－－－－－－－－－－－－－－－－－－－－<BR>": [@"－－－－－－－－－－－－－－－\n" string24WithVersion:self.version];
}
- (NSString *) getAddress{
    NSString *address = [[HTShareClass shareClass].loginModel.company[@"address"] length] > 0  ? [[NSString stringWithFormat:@"地址: %@" , [HTShareClass shareClass].loginModel.company[@"address"]]  string24WithVersion:self.version] : [@"" string24WithVersion:self.version];
    return address ;
}
- (NSString *) getShopName{
    
    NSString *shortName = [[HTShareClass shareClass].loginModel.company[@"shortName"] length] > 0 ? [HTShareClass shareClass].loginModel.company[@"shortName"] : @"";
    NSString *fullName =  [[HTShareClass shareClass].loginModel.company[@"fullname"] length] > 0 ? [HTShareClass shareClass].loginModel.company[@"fullname"] : @"";
    
    if ([fullName rangeOfString:shortName].length != 0) {
        NSRange range = [fullName rangeOfString:shortName];
        
        if (range.location == 0 && range.length == shortName.length) {
            return [[fullName substringFromIndex:range.length] string32WithVersion:self.version];;
        }else{
            return [fullName string32WithVersion:self.version];
        }
    }
    return [fullName string32WithVersion:self.version];
}
- (NSString *) getCompanyName{
    NSString *shortName = [[HTShareClass shareClass].loginModel.company[@"shortName"] length] > 0 ? [HTShareClass shareClass].loginModel.company[@"shortName"] : @"";
    NSString *fullName =  [[HTShareClass shareClass].loginModel.company[@"fullname"] length] > 0 ? [HTShareClass shareClass].loginModel.company[@"fullname"] : @"";
    
    if ([fullName rangeOfString:shortName].length != 0) {
        NSRange range = [fullName rangeOfString:shortName];
        
        if (range.location == 0 && range.length == shortName.length) {
            return [fullName substringFromIndex:range.length] ;
        }else{
            return fullName ;
        }
    }
    return fullName ;
    
}

- (NSString *) getGoodsWithDic:(NSArray  *) dataArr {
    if ([self.version isEqualToString:@"2"]) {
        NSString *productCode = [NSString stringWithFormat:@"条码             "];
        NSString *colorNum =  @"色号   " ;
        NSString *size = @"尺寸 ";
        NSString *singlePrize = @"原价   " ;
        NSString *salePrize = @"售价";
        NSString *discount = @"折扣  ";
        NSDictionary *headsDic = @{
                                   @"productCode" : productCode,
                                   @"colorNum"  : colorNum,
                                   @"size" : size,
                                   @"singlePrice" : singlePrize,
                                   @"discount" : discount,
                                   @"salePrice" : salePrize,
                                   };
        NSString *titleStr =  [NSString stringWithFormat:@"%@%@%@%@%@%@",productCode,colorNum,size,singlePrize,discount,salePrize];
        NSMutableString * dataStr = [NSMutableString string];
        for (NSDictionary *dic in dataArr) {
            NSArray *keyArr = @[@"productCode",@"colorNum",@"size",@"singlePrice",@"discount",@"salePrice"];
            NSMutableString *lineStr = [NSMutableString string];
            for (NSString *str  in keyArr) {
                NSMutableString *value =   [str isEqualToString:@"discount"] ? ( [dic[str] floatValue] == 0.0f || [dic[str] floatValue] == 1.0f ) ? [@"1" mutableCopy] : [dic[str] floatValue] < 0 ? [@"/" mutableCopy]:  [[dic getStringWithKey:str ] mutableCopy] : [[dic getStringWithKey:str ] mutableCopy];
                if ([str isEqualToString:@"discount"]) {
                    value = [[NSString stringWithFormat:@"%.2f", [value floatValue] * 10] mutableCopy];
                }
                NSString *typeStr = headsDic[str];
                CGFloat width1 = [self toGbk:typeStr];
                for (int i = 0 ; i < 22; i ++) {
                    CGFloat width = [self toGbk:value] ;
                    if (width >= width1) {
                        if (i == 0) {
                            [value appendString:@" "];
                        }
                        break;
                    }
                    [value appendString:@" "];
                }
                [lineStr appendString:value];
            }
            NSString *str1 = lineStr;
            [dataStr appendString:@"\n"];
            [dataStr appendString:[str1  string24WithVersion:self.version]];
        }
        return  [NSString stringWithFormat:@"%@\n%@",titleStr,dataStr];
    }else{
        NSString *productCode = [NSString stringWithFormat:@"款号"];
        NSString *colorNum =  @"色号   " ;
        NSString *size = @"尺寸 ";
        NSString *singlePrize = @"原价   " ;
        NSString *salePrize = @"售价";
        NSString *discount = @"折扣  ";
        NSDictionary *headsDic = @{
                                   @"productCode" : productCode,
                                   @"colorNum"  : colorNum,
                                   @"size" : size,
                                   @"singlePrice" : singlePrize,
                                   @"discount" : discount,
                                   @"salePrice" : salePrize,
                                   };
        NSString *titleStr =  [NSString stringWithFormat:@"%@|5%@%@%@%@%@",[productCode string24WithVersion:self.version],colorNum,size,singlePrize,discount,salePrize];
        NSMutableString * dataStr = [NSMutableString string];
        for (NSDictionary *dic in dataArr) {
            
            NSArray *keyArr = @[@"productCode",@"colorNum",@"size",@"singlePrice",@"discount",@"salePrice"];
            NSMutableString *lineStr = [NSMutableString string];
            for (NSString *str  in keyArr) {
                NSMutableString *value =   [str isEqualToString:@"discount"] ? ( [dic[str] floatValue] == 0.0f || [dic[str] floatValue] == 1.0f ) ? [@"1" mutableCopy] : [dic[str] floatValue] < 0 ? [@"/" mutableCopy]:  [[dic getStringWithKey:str ] mutableCopy] : [[dic getStringWithKey:str ] mutableCopy];
                if ([str isEqualToString:@"discount"]) {
                    value = [[NSString stringWithFormat:@"%.2f", [value floatValue] * 10] mutableCopy];
                }
                NSString *typeStr = headsDic[str];
                CGFloat width1 = [self toGbk:typeStr];
                for (int i = 0 ; i < 22; i ++) {
                    CGFloat width = [self toGbk:value] ;
                    if (width >= width1) {
                        if (i == 0) {
                            [value appendString:@" "];
                        }
                        break;
                    }
                    [value appendString:@" "];
                }
                if ([str isEqualToString:@"productCode"]) {
                    [value string24WithVersion:self.version];
                    [value appendString:@"\n"];
                    [value appendString:@"|5"];
                }
                [lineStr appendString:value];
            }
            NSString *str1 = lineStr;
            [dataStr appendString:@"\n"];
            [dataStr appendString:[str1  string24WithVersion:self.version]];
        }
        
        NSLog(@"%@",[NSString stringWithFormat:@"%@\n%@",titleStr,dataStr]);
        
        return  [NSString stringWithFormat:@"%@\n%@",titleStr,dataStr];
        
    }
}
- (NSString *) getTotleWithSth:(NSString *)totle{
    return [[NSString stringWithFormat:@"总计: %ld 件 共 %@ 元",[HTShareClass shareClass].printerModel.goodsList.count,totle] string24WithVersion:self.version];
}
- (NSString *) getReturnTotleWithSth:(HTPrinterModel *)model{
    
    return [[NSString stringWithFormat:@"总计: 共退 %ld 件共换 %ld 件  收 %@ 元",model.returnGoodsList.count,model.exchangeGoodsList.count,model.returnOrderFinalPrice] string24WithVersion:self.version];
}
- (NSString *) newLine{
    return [@" "  string24WithVersion:self.version];
}
- (NSString *) getIsPos{
    NSString *type = [NSString string];
    
    switch ([HTShareClass shareClass].printerModel.paytype) {
        case cashType:
        {
            type = @"现金支付";
        }
            break;
        case posType:
        {
            type = @"刷卡支付";
        }
            break;
        case storedType:
        {
            type = @"储值支付";
        }
            break;
        case storedSendType:
        {
            type = @"储赠支付";
        }
            break;
       case aliType:
        {
            type = @"扫码支付";
        }
        case
        alipayType:
        {
            type = @"支付宝支付";
        }
            break;
        case
        wetchatType:
        {
            type = @"微信支付";
        }
            break;
            
            case mixType:
        {
            type = @"组合支付";
        }
            break;
        default:
            break;
    }
    return [[NSString stringWithFormat:@"支付方式： %@",type]  string24WithVersion:self.version];
}
- (NSString *) getReturnIsPosWithModel:(HTPrinterModel *)model{
    NSString *type = [NSString string];
    if (model.returnOrderFinalPrice.floatValue < 0) {
        return [[NSString stringWithFormat:@"支付方式"]  string24WithVersion:self.version];
    }
    switch (model.returnPayType) {
        case cashType:
        {
            type = @"现金支付";
        }
            break;
        case posType:
        {
            type = @"刷卡支付";
        }
            break;
        case storedType:
        {
            type = @"储值支付";
        }
            break;
        case storedSendType:
        {
            type = @"储赠支付";
        }
            break;
        case
        aliType:
        {
            type = @"扫码支付";
        }
            break;
        case
        alipayType:
        {
            type = @"支付宝支付";
        }
            break;
        case
        wetchatType:
        {
            type = @"微信支付";
        }
            break;
        case mixType:
        {
            type = @"组合支付";
        }
            break;
        default:
            break;
    }
    return [[NSString stringWithFormat:@"支付方式： %@",type]  string24WithVersion:self.version];
    
}
- (NSString *)integralNumWithNum:(NSString *) num{
    return [[NSString stringWithFormat:@"积分抵用: %@",num] string24WithVersion:self.version];
}
- (NSString *)storedNumWithNum:(NSString *) num{
    return [[NSString stringWithFormat:@"储值消费: %@",num] string24WithVersion:self.version];
}

- (NSString *)returnStoredNumWithNum:(NSString *) num{
    
    return [[NSString stringWithFormat:@"储值账户: %.0lf", ( 0 - num.floatValue)] string24WithVersion:self.version];
}
- (NSString *)storedsendNumWithNum:(NSString *) num{
    return [[NSString stringWithFormat:@"储值赠送消费: %@",num] string24WithVersion:self.version];
}
- (NSString *)returnStoredsendNumWithNum:(NSString *) num{
    
    return [[NSString stringWithFormat:@"储值赠送账户: %.0lf", ( 0 - num.floatValue)] string24WithVersion:self.version];
}
- (NSString *) discountMoney:(NSString *) money{
    return [[NSString stringWithFormat:@"优惠券: %@",money] string24WithVersion:self.version];
}
- (NSString *) tipsText{
    return [@"请保管好收银小票以作退换货凭证,出售商品无质量问题不予退换,最终解释权归本店所有! \n谢谢惠顾!" string24WithVersion:self.version];
//            请保管好收银小票以作退换货凭证！\n谢谢惠顾
            
}
- (NSString *) salerTextWith:(NSString *) saler{
    return [[NSString stringWithFormat:@"导购: %@",saler] string24WithVersion:self.version];
}
- (NSString *) customerPhoneTextWith:(NSString *) tel{
    return [[NSString stringWithFormat:@"顾客电话: %@",[HTHoldNullObj getValueWithUnCheakValue:tel]] string24WithVersion:self.version];
}
- (NSString *) finallTextWith:(NSString *) prize{
    return [[NSString stringWithFormat:@"结算价: %@ 元",prize] string24WithVersion:self.version];
}
- (NSString *) saleNumber:(NSString *) number{
    return [[NSString stringWithFormat:@"订单号: %@",number] string24WithVersion:self.version];
}
- (NSString *) orderDesc:(NSString *) number{
    
    return [[NSString stringWithFormat:@"订单备注: %@",[HTHoldNullObj getValueWithUnCheakValue:number]] string24WithVersion:self.version];
}
- (NSString *) addExeplan{
    return [self.version isEqualToString:@"1"] ?  [[NSString stringWithFormat:@"            由此撕下"]  string24WithVersion:self.version] : @"";
}
- (NSString *) setPage:(NSInteger) page {
    return [[NSString stringWithFormat:@"..............................."]  string24WithVersion:self.version];
}

- (CGFloat ) toGbk:(NSString *) str{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [str dataUsingEncoding:enc];
    return [data length];
}
- (NSString *)jsonStringWithDic:(NSDictionary *)jsonDic{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
- (NSString *)getPrintJsonStrWithModel:(HTPrinterModel *)model{
    
    if (model.returnGoodsList.count > 0 ) {
        
        NSMutableDictionary *lastOrdDic = model.lastOrderPrintDic;
        
        if (!lastOrdDic) {
            lastOrdDic = [NSMutableDictionary dictionary];
        }
        
        NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
        
        [postDic setObject:model.returnGuider  forKey:@"returnGuider" ];
        [postDic setObject:model.returnGoodsList  forKey: @"returnGoodsList"];
        [postDic setObject: model.exchangeGoodsList forKey:@"exchangeGoodsList"];
        [postDic setObject:model.returnOrderFinalPrice  forKey:@"returnOrderFinalPrice"];
        [postDic setObject:@(model.returnPayType ) forKey:@"returnPayType"];
        [postDic setObject:model.returnCoupons  forKey:@"returnCoupons"];
        [postDic setObject:model.returnStoreValue  forKey:@"returnStoreValue"];
         [postDic setObject:model.returnFreeStoreValue  forKey:@"returnFreeStoreValue"];
        [postDic setObject:model.returnTime  forKey:@"returnTime"];
        [postDic setObject:model.returnPoints  forKey:@"returnPoints"];
        [postDic setObject:model.returnOrderNo  forKey:@"returnOrderNo"];
        [postDic setObject:[HTHoldNullObj getValueWithUnCheakValue:model.telPhone]  forKey:@"telPhone"];
        [postDic setObject:[HTHoldNullObj getValueWithUnCheakValue:model.orderDesc] forKey:@"orderDesc"];
        NSMutableArray *afterlistArray = [lastOrdDic[@"afterSalesList"] mutableCopy];
        if (!afterlistArray) {
            afterlistArray = [NSMutableArray array];
        }
        BOOL isIn = NO;
        
        if (!isIn) {
            [afterlistArray addObject:postDic];
        }
        
        [lastOrdDic setObject:afterlistArray forKey:@"afterSalesList"];
        
        NSString *printJsonStr = [self jsonStringWithDic:lastOrdDic];
        return printJsonStr;
        
    }else{
        NSDictionary *dic = @{
                              @"brand":[[HTShareClass shareClass].loginModel.company[@"shortName"] length] > 0 ? [HTShareClass shareClass].loginModel.company[@"shortName"] : @"",
                              @"company":[self getCompanyName],
                              @"address":[[HTShareClass shareClass].loginModel.company[@"address"] length] > 0  ? [HTShareClass shareClass].loginModel.company[@"address"] : @"" ,
                              @"seller":[HTShareClass shareClass].printerModel.salerName,
                              @"orderId":[HTHoldNullObj getValueWithUnCheakValue: model.orderId],
                              @"orderNo":[HTHoldNullObj getValueWithUnCheakValue:model.orderNo],
                              @"productCount": @(model.goodsList.count) ,
                              @"goodsList":model.goodsList,
                              @"orderTotalPrice":model.orderTotalPrize,
                              @"orderPayPrice":model.orderFinalPrize,
                              @"payType":@(model.paytype),
                              @"points":model.points,
                              @"coupons":model.coupons,
                              @"storeValue":model.storeValue,
                              @"freeStoreValue":model.freeStoreValue,
                              @"date":model.date,
                              @"telPhone":[HTHoldNullObj getValueWithUnCheakValue:model.telPhone],
                              @"orderDesc":[HTHoldNullObj getValueWithUnCheakValue:model.orderDesc],
                              @"modifyPrice":@(model.modifyPrice),
                              };
        NSString *printJsonStr =  [self jsonStringWithDic:dic];
        
        return printJsonStr;
    }
}



//- (AFSecurityPolicy*)customSecurityPolicy
//{
    // /先导入证书
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"c.aykj0577.com" ofType:@"cer"];//证书的路径
//    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
//
//    // AFSSLPinningModeCertificate 使用证书验证模式
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//
//    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
//    // 如果是需要验证自建证书，需要设置为YES
//    securityPolicy.allowInvalidCertificates = YES;
//
//    //validatesDomainName 是否需要验证域名，默认为YES；
//    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
//    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
//    //如置为NO，建议自己添加对应域名的校验逻辑。
//    securityPolicy.validatesDomainName = NO;
//
//    securityPolicy.pinnedCertificates = [NSSet setWithObject:certData];
//
//    return securityPolicy;
//}
#pragma mark -SelectPrinterBrandDelegate
- (void)selectedPrinterBrandWithVerison:(int)versions{
    
    if (versions == 3) {
        self.version = [NSString stringWithFormat:@"%d",versions];
        HTBlueToothPrinterController *vc = [[HTBlueToothPrinterController alloc] init];
        vc.bigPrinter = [self getPrintArrayWithSize:YES];
        vc.pushNext = self.pushNext;
        vc.smallPrinter = [self getPrintArrayWithSize:NO];
        [[[HTShareClass shareClass] getCurrentNavController] pushViewController:vc animated:YES];
    }else{
        self.version = [NSString stringWithFormat:@"%d",versions];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"请输入打印机编号" message:nil delegate:  self  cancelButtonTitle:@"取消" otherButtonTitles:@"确定",_isNoPrint ? nil : @"不再提醒", nil];
        av.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        av.tag = 800;
        av.delegate = self;
        [av textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
        [av textFieldAtIndex:0].placeholder = @"请输入打印机编码";
        [av textFieldAtIndex:1].keyboardType = 1;
        [av textFieldAtIndex:1].placeholder = @"打印机注册密码，第一次为注册密码";
        [av textFieldAtIndex:1].autocorrectionType = UITextAutocorrectionTypeNo;
        [av show];
    }
    
    
}
- (void)cancelSelectedBrand{
    self.version = @"";
    if (self.pushNext) {
        self.pushNext();
    }
}

- (void)neverNoticeSelectedBrand{
    NSString *versionKey = (__bridge NSString *)kCFBundleVersionKey;
    [[NSUserDefaults standardUserDefaults] setObject:[NSBundle mainBundle].infoDictionary[versionKey] forKey:@"lastVersion"];
    if (self.pushNext) {
        self.pushNext();
    }
}
- (HLPrinter *)getPrintArrayWithSize:(BOOL) isBig{
    
    self.isBig = isBig;
    HLPrinter *content = [[HLPrinter alloc] init];
    
    NSString *shortName = [[HTShareClass shareClass].loginModel.company[@"shortName"] length] > 0 ? [HTShareClass shareClass].loginModel.company[@"shortName"] : @"";
    NSMutableDictionary *printDic = [NSMutableDictionary dictionary];
    [printDic setObject:[SecurityUtil encryptAESData:[HTShareClass shareClass].printerModel.orderId] forKey:@"modelId"];
    [printDic setObject:[SecurityUtil encryptAESData:[NSString stringWithFormat:@"%@",[HTShareClass shareClass].loginModel.companyId]]  forKey:@"companyId"];
    
    if ([HTShareClass shareClass].printerModel.goodsList.count > 0) {
        
        NSArray *arr = [HTShareClass shareClass].printerModel.goodsList;
        [content appendText:[self getHeaderWithString:shortName] alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleBig];
        [content appendText:[self getShopName] alignment:HLTextAlignmentLeft fontSize:HLFontSizeTitleMiddle];
        [content appendNewLine];
        [content appendText:[self salerTextWith:[HTShareClass shareClass].printerModel.salerName] alignment:HLTextAlignmentLeft];
        [content appendText:[self saleNumber:[HTShareClass shareClass].printerModel.orderNo] alignment:HLTextAlignmentLeft];
        [content appendText:[self getAddress] alignment:HLTextAlignmentLeft];
        [content appendSeperatorLine];
        [self appdendProduct:content andDataArr:arr];
        [content appendSeperatorLine];
        [content appendString:[self getTotleWithSth:[HTShareClass shareClass].printerModel.orderTotalPrize]];
        [content appendString:[self finallTextWith:[HTShareClass shareClass].printerModel.orderFinalPrize]];
        [content appendString:[self getIsPos]];
        [content appendString:[self integralNumWithNum:[HTShareClass shareClass].printerModel.points]];
        [content appendString:[self discountMoney:[HTShareClass shareClass].printerModel.coupons]];
        [content appendString: [self storedNumWithNum:[HTShareClass shareClass].printerModel.storeValue]];
        [content appendString: [self storedsendNumWithNum:[HTShareClass shareClass].printerModel.freeStoreValue]];
        [content appendString: [self customerPhoneTextWith:[HTShareClass shareClass].printerModel.telPhone]];
        [content appendString:[[NSString stringWithFormat:@"%@",[HTShareClass shareClass].printerModel.date] string24WithVersion:self.version]];
        [content appendString:[self tipsText]];
        [content appendNewLine];
//        [content appendImage:[self createCodeImageWithValue:[self jsonStringWithDic:printDic]] alignment:HLTextAlignmentCenter maxWidth:250];
        [content appendNewLine];
        [content appendNewLine];
        [content appendSeperatorLine];
        if ([HTShareClass shareClass].printerModel.afterSalesList.count > 0 ){
            for (NSDictionary *afterDic in [HTShareClass shareClass].printerModel.afterSalesList) {
                HTPrinterModel *model = [[HTPrinterModel alloc] init];
                [model setValuesForKeysWithDictionary:afterDic];
                if (model.returnGoodsList.count > 0){
                    [content appendString:[self newLine]];
                    [content appendString: [self newLine]];
                    [content appendString:[self newLine]];
                    [content appendString: [self newLine]];
                    NSMutableDictionary *printDic1 = [NSMutableDictionary dictionary];
                    [printDic1 setObject:[SecurityUtil encryptAESData:model.orderId] forKey:@"modelId"];
                    [printDic1 setObject:[SecurityUtil encryptAESData:[NSString stringWithFormat:@"%@",[HTShareClass shareClass].loginModel.companyId]]  forKey:@"companyId"];
                    [content appendText:[self getHeaderWithString:@"退换货小票"] alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleBig];
                    [content appendString:[self newLine]];
                    [content appendString:[self salerTextWith:model.returnGuider]];
                    [content appendString:[self saleNumber:model.returnOrderNo]];
                    [content appendString:[self getAddress]];
                    [content appendString:[self getLine]];
                    [content appendString:[@"退换货商品" string24WithVersion:self.version]];
                    [self appdendProduct:content andDataArr:model.returnGoodsList];
                    [content appendString:[self getLine]];
                    if (model.exchangeGoodsList.count > 0) {
                        [content appendString:[@"新商品" string24WithVersion:self.version]];
                        [self appdendProduct:content andDataArr:model.exchangeGoodsList];
                        [content appendString:[self getLine]];
                    }
                    [content appendString:[self getReturnTotleWithSth:model]];
                    [content appendString:[self getReturnIsPosWithModel:model]];
                    [content appendString:[self integralNumWithNum:model.returnPoints]];
                    [content appendString:[self discountMoney:model.returnCoupons]];
                    [content appendString: [self storedNumWithNum:model.returnStoreValue]];
                    [content appendString:[self storedsendNumWithNum:model.returnFreeStoreValue]];
                    [content appendString:[self customerPhoneTextWith:model.telPhone]];
                    [content appendString:[[NSString stringWithFormat:@"%@",model.returnTime]  string24WithVersion:self.version]];
                    [content appendString:[self tipsText]];
                    [content appendString:[self newLine]];
                    [content appendNewLine];
//                     [content appendImage:[self createCodeImageWithValue:[self jsonStringWithDic:printDic]] alignment:HLTextAlignmentCenter maxWidth:250];
                    [content appendSeperatorLine];
                }
            }
        }
    }
    else   if ([HTShareClass shareClass].printerModel.returnGoodsList.count > 0){
        NSMutableDictionary *printDic1 = [NSMutableDictionary dictionary];
        [printDic1 setObject:[SecurityUtil encryptAESData:[HTShareClass shareClass].printerModel.orderId] forKey:@"modelId"];
        [printDic1 setObject:[SecurityUtil encryptAESData:[NSString stringWithFormat:@"%@",[HTShareClass shareClass].loginModel.companyId]]  forKey:@"companyId"];
        if ([HTShareClass shareClass].printerModel.goodsList.count > 0) {
            [content appendString:[self newLine]];
            [content appendString: [self newLine]];
            [content appendString:[self newLine]];
            [content appendString: [self newLine]];
        }
        [content appendText:[self getHeaderWithString:@"退换货小票"] alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleBig];
        [content appendString:[self newLine]];
        [content appendString:[self salerTextWith:[HTShareClass shareClass].printerModel.returnGuider]];
        [content appendString:[self saleNumber:[HTShareClass shareClass].printerModel.returnOrderNo]];
        [content appendString:[self getAddress]];
        [content appendString:[self getLine]];
        [content appendString:[@"退换货商品" string24WithVersion:self.version]];
        [self appdendProduct:content andDataArr:[HTShareClass shareClass].printerModel.returnGoodsList];
        [content appendString:[self getLine]];
        if ([HTShareClass shareClass].printerModel.exchangeGoodsList.count > 0) {
            [content appendString:[@"新商品" string24WithVersion:self.version]];
            [self appdendProduct:content andDataArr:[HTShareClass shareClass].printerModel.exchangeGoodsList];
            [content appendString:[self getLine]];
        }
        [content appendString:[self getReturnTotleWithSth:[HTShareClass shareClass].printerModel]];
        [content appendString:[self getReturnIsPosWithModel:[HTShareClass shareClass].printerModel]];
        [content appendString:[self integralNumWithNum:[HTShareClass shareClass].printerModel.returnPoints]];
        [content appendString:[self discountMoney:[HTShareClass shareClass].printerModel.returnCoupons]];
        [content appendString: [self storedNumWithNum:[HTShareClass shareClass].printerModel.returnStoreValue]];
        [content appendString: [self storedsendNumWithNum:[HTShareClass shareClass].printerModel.returnFreeStoreValue]];
        [content appendString: [self customerPhoneTextWith:[HTShareClass shareClass].printerModel.telPhone]];
        [content appendString:[[NSString stringWithFormat:@"%@",[HTShareClass shareClass].printerModel.returnTime]  string24WithVersion:self.version]];
        [content appendString:[self tipsText]];
        [content appendString:[self newLine]];
        [content appendNewLine];
//         [content appendImage:[self createCodeImageWithValue:[self jsonStringWithDic:printDic]] alignment:HLTextAlignmentCenter maxWidth:250];
        [content appendSeperatorLine];
    }
    return content;
}
- (void) appdendProduct:(HLPrinter *)printer andDataArr:(NSArray *)dataArr{
    if (self.isBig) {
        NSString *productCode = [NSString stringWithFormat:@"款号             "];
        NSString *colorNum =  @"色号   " ;
        NSString *size = @"尺寸 ";
        NSString *singlePrize = @"原价   " ;
        NSString *salePrize = @"售价";
        NSString *discount = @"折扣  ";
        NSDictionary *headsDic = @{
                                   @"productCode" : productCode,
                                   @"colorNum"  : colorNum,
                                   @"size" : size,
                                   @"singlePrice" : singlePrize,
                                   @"discount" : discount,
                                   @"salePrice" : salePrize,
                                   };
        NSString *titleStr =  [NSString stringWithFormat:@"%@%@%@%@%@%@",productCode,colorNum,size,singlePrize,discount,salePrize];
        
        [printer appendString:titleStr];
        for (NSDictionary *dic in dataArr) {
            
            NSArray *keyArr = @[@"productCode",@"colorNum",@"size",@"singlePrice",@"discount",@"salePrice"];
            
            NSMutableString *lineStr = [NSMutableString string];
            
            for (NSString *str  in keyArr) {
                
                NSMutableString *value =   [str isEqualToString:@"discount"] ? ( [dic[str] floatValue] == 0.0f || [dic[str] floatValue] == 1.0f ) ? [@"1" mutableCopy] : [dic[str] floatValue] < 0 ? [@"/" mutableCopy]:  [[dic getStringWithKey:str ] mutableCopy] : [[dic getStringWithKey:str ] mutableCopy];
                if ([str isEqualToString:@"discount"]) {
                    value = [[NSString stringWithFormat:@"%.2f", [value floatValue] * 10] mutableCopy];
                }
                NSString *typeStr = headsDic[str];
                CGFloat width1 = [self toGbk:typeStr];
                for (int i = 0 ; i < 22; i ++) {
                    CGFloat width = [self toGbk:value] ;
                    if (width >= width1) {
                        if (i == 0) {
                            [value appendString:@" "];
                        }
                        break;
                    }
                    [value appendString:@" "];
                }
                
                [lineStr appendString:value];
            }
            NSString *str1 = lineStr;
            [printer appendNewLine];
            [printer appendString:[str1  string24WithVersion:self.version]];
        }
        
    }else{
        NSString *productCode = [NSString stringWithFormat:@"条码"];
        
        NSString *colorNum =  @"色号   " ;
        
        NSString *size = @"尺寸 ";
        
        NSString *singlePrize = @"原价   " ;
        
        NSString *salePrize = @"售价";
        
        NSString *discount = @"折扣  ";
        
        
        
        NSDictionary *headsDic = @{
                                   @"productCode" : productCode,
                                   @"colorNum"  : colorNum,
                                   @"size" : size,
                                   @"singlePrice" : singlePrize,
                                   @"discount" : discount,
                                   @"salePrice" : salePrize,
                                   };
        [printer appendString:productCode];
        [printer appendString:[NSString stringWithFormat:@"%@%@%@%@%@",colorNum,size,singlePrize,discount,salePrize]];
        
        for (NSDictionary *dic in dataArr) {
            
            NSArray *keyArr = @[@"productCode",@"colorNum",@"size",@"singlePrice",@"discount",@"salePrice"];
            
            NSMutableString *lineStr = [NSMutableString string];
            
            for (NSString *str  in keyArr) {
                
                NSMutableString *value =   [str isEqualToString:@"discount"] ? ( [dic[str] floatValue] == 0.0f || [dic[str] floatValue] == 1.0f ) ? [@"1" mutableCopy] : [dic[str] floatValue] < 0 ? [@"/" mutableCopy]:  [[dic getStringWithKey:str ] mutableCopy] : [[dic getStringWithKey:str ] mutableCopy];
                if ([str isEqualToString:@"discount"]) {
                    value = [[NSString stringWithFormat:@"%.2f", [value floatValue] * 10] mutableCopy];
                }
                NSString *typeStr = headsDic[str];
                CGFloat width1 = [self toGbk:typeStr];
                for (int i = 0 ; i < 22; i ++) {
                    CGFloat width = [self toGbk:value] ;
                    if (width >= width1) {
                        if (i == 0) {
                            [value appendString:@" "];
                        }
                        break;
                    }
                    [value appendString:@" "];
                }
                if ([str isEqualToString:@"productCode"]) {

                    [printer appendString:[value string24WithVersion:self.version]];
                }else{
                    [lineStr appendString:value];
                }
            }
            NSString *str1 = lineStr;
            [printer appendString:[str1  string24WithVersion:self.version]];
        }
    }
}
- (UIImage *)createCodeImageWithValue:(NSString *) value{
    return nil;
    if ([value isNull]) {
        return  nil;
    }
    //    创建滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //    还原滤镜的默认属性
    [filter setDefaults];
    //    设置需要生成二维码的数据
    [filter setValue:[value dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    //    从滤镜中取出生成好的图片
    CIImage *ciImage = [filter outputImage];
   return  [self createImageBgImage:nil withSmallImage:[self createNonInterpolatedUIImageFormCIImage:ciImage WithSize:250]];
    //合成图片
}

/**
 *  根据ciimage生成高清图片
 *
 *  @param image 不清晰的二维码图片
 *  @param size  图片大小
 *
 *  @return 高清二维码图片
 */
- (UIImage *) createNonInterpolatedUIImageFormCIImage:(CIImage *) image WithSize:(CGFloat ) size{
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    //    创建bitmap
    CGFloat width  = CGRectGetWidth(extent) *scale;
    CGFloat height = CGRectGetHeight(extent) * scale ;
    CGColorSpaceRef sc = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, sc, 0);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    CGImageRef scaleImage = CGBitmapContextCreateImage(bitmapRef);
    return  [UIImage  imageWithCGImage:scaleImage];
}
// 创建带阿里图标的二维码
- (UIImage *) createImageBgImage :(UIImage *) bgImg withSmallImage:(UIImage *) smallImage{
    //开启图文上下文
    UIGraphicsBeginImageContext(CGSizeMake(250, 300));
    //绘制背景图片

//    [bgImg drawInRect:CGRectMake(0, 0, bgImg.size.width, bgImg.size.height)];
    //绘制头像

    [smallImage drawInRect:CGRectMake(0,0 , 250 , 250)];
    //取出绘制好的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图文上下文呢
    
    UIGraphicsEndImageContext();
    return newImage;
}
@end
