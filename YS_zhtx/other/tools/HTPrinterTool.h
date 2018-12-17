//
//  HTPrinterTool.h
//  24小助理
//
//  Created by mac on 16/9/1.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//
typedef void(^DoSucces)();
typedef void(^PushNext)();
typedef void(^PRESENT)(UIViewController *vc);
#import <Foundation/Foundation.h>

@interface HTPrinterTool : NSObject<UIAlertViewDelegate>{
    NSString *password;
    BOOL isReceipt;//是否为二次打印
}

@property (nonatomic,strong) UIViewController *delgate;

@property (nonatomic,copy)  NSString *number;

@property (nonatomic,assign) BOOL isNoPrint;

- (void) print;

- (void) addPrinter;

- (void)registPrinterWithNum:(NSString *) num;

- (void)printReceiptWithNum:(NSString *) num andpage:(NSInteger ) page;

@property (nonatomic,copy) DoSucces dosucces;

@property (nonatomic,copy) PushNext pushNext;

@property (nonatomic,copy) PRESENT presentNext;
- (void)sendPrintData;

- (void)printOrderReceiptWithOrder:(NSString *) orderId;

@end
