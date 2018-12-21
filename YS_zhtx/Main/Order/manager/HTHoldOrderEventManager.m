//
//  HTHoldOrderEventManager.m
//  YS_zhtx
//
//  Created by mac on 2018/9/10.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTOrderDetailViewController.h"
#import "HTNoticeCenterViewController.h"
#import "HTMenuModle.h"
#import "HTHoldOrderEventManager.h"
#import "HTPrinterTool.h"
#import "HTChangeOrderProductController.h"
@implementation HTHoldOrderEventManager

+(void)printOrderInfoWithOrderId:(NSString *)orderId{
    HTPrinterTool  *printTool = [[HTPrinterTool alloc] init];
    printTool.presentNext = ^(UIViewController *vc){
        [[HTShareClass shareClass].getCurrentNavController presentViewController:vc animated:YES completion:nil];
    };
    [printTool printOrderReceiptWithOrder:[HTHoldNullObj getValueWithUnCheakValue:orderId]];
}
+(void)addTimerForOrderWithOrderId:(NSString *)orderId{
    HTNoticeCenterViewController *vc = [[HTNoticeCenterViewController alloc] init];
    for (HTMenuModle *mode in [HTShareClass shareClass].menuArray) {
        if ([mode.moduleName isEqualToString:@"order"]) {
            vc.moduleId = [mode.moduleId stringValue];
            break;
        }
    }
    vc.modelId = [HTHoldNullObj getValueWithUnCheakValue:orderId];
    [[HTShareClass shareClass].getCurrentNavController  pushViewController:vc animated:YES];
}
+(void)exchangeOrReturnOrderWithOrderId:(NSString *)orderId{
    HTChangeOrderProductController *vc = [[HTChangeOrderProductController alloc] init];
    vc.orderId = orderId;
    [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
}
+(void)postImgsForOrderWithOrderId:(NSString *)orderId{
    
    [[HTShareClass shareClass].selectdImg showSelectedImgWithController];
    [HTShareClass shareClass].selectdImg.selectedImgs = ^(NSArray *imgs) {
        [self postImageWithImgs:imgs andOrderId:orderId];
    };
}
+(void)seeOrderDetailWithOrderId:(NSString *)orderId{
    HTOrderDetailViewController *vc = [[HTOrderDetailViewController alloc] init];
    vc.orderId = orderId;
    [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
}
+ (void) postImageWithImgs:(NSArray *)imgs andOrderId:(NSString *)orderId{
    
    NSDictionary *dic = @{
                          @"orderId":[HTHoldNullObj getValueWithUnCheakValue:orderId],
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    [MBProgressHUD showMessage:@"正在上传"];
    [HTHttpTools POSTData:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleFilerSource,uploadOrderFile] params:dic formData:^(id<AFMultipartFormData> formData) {
        // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        // 这里的_photoArr是你存放图片的数组
        for (int i = 0; i < imgs.count; i++) {
            UIImage *image = imgs[i];
            NSData *imageData = [self changeImageDataWithImageWithImage:image];
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@%@%d.jpg", dateString,[HTHoldNullObj getValueWithUnCheakValue:orderId],i];
            /*
             *该方法的参数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"upload%d",i] fileName:fileName mimeType:@"image/jpeg"]; //
        }
        
    } success:^(id json) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"上传成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderDetailNotifi" object:nil];
        
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络繁忙,图片上传失败"];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"图片上传失败,检查你的网络"];
    }];
}

/**
 *  压缩图片格式
 *
 */
+ (NSData *) changeImageDataWithImageWithImage:(UIImage *) image{
    float j = 1.0;
    NSData * data = [NSData data];
    for (int i = 0; i < 10; i ++) {
        NSData  * imageData     = UIImageJPEGRepresentation(image, j);
        float f = imageData.length / 1024;
        if (f < 500) {
            data = imageData;
            break;
        }
        j = j - 0.1;
    }
    return data;
    
}
@end
