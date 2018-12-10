//
//  HTHttpTools.m
//  shengyijing
//
//  Created by mac on 16/3/9.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import "HTHttpTools.h"
#import "SecurityUtil.h"
#import "GDataXMLNode.h"
@implementation HTHttpTools

+ (NSURLSessionDataTask *)GET:(NSString *)url params:(NSDictionary *)params success:(XMGRequestSuccess)success error:(HTRequestError) error  failure:(XMGRequestFailure)failure
{
    NSMutableDictionary *dict = [params mutableCopy];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    [dict setObject:[SecurityUtil encryptAESData:[NSString stringWithFormat:@"%.0f",a]] forKey:@"token"];
    
    if ([[HTShareClass shareClass].loginId length] > 0 && [dict getStringWithKey:@"loginId"].length == 0) {
        [dict setObject:[HTShareClass shareClass].loginId forKey:@"loginId"];
    }    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    if ([HTShareClass shareClass].isShowAliCode) {
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        manager.securityPolicy.allowInvalidCertificates = YES;
        [manager.securityPolicy setValidatesDomainName:NO];
    }else{
      [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    
    
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
   
    //申明请求的数据是json类型
    manager.requestSerializer  = [AFJSONRequestSerializer new];
    [manager.requestSerializer setValue:@"APPRequest-IOS" forHTTPHeaderField:@"X-Requested-With"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",
                                      [HTShareClass shareClass].loginId.length > 0  ?
                                      [HTShareClass shareClass].loginId  : @"-1"]
                                      forHTTPHeaderField:@"App-Login-Id"];
    
#ifndef __OPTIMIZE__
    manager.requestSerializer.timeoutInterval = 200.f;
#else
    //这里执行的是release模式下
    manager.requestSerializer.timeoutInterval = 20.f;
#endif
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    NSMutableString *testString = [NSMutableString stringWithString:url];
    if ([HTShareClass shareClass].selectedBaseUrl.length > 0 ) {
        [testString replaceCharactersInRange:NSMakeRange(0,baseUrl.length ) withString:[HTShareClass shareClass].selectedBaseUrl];
    }
    
    
    NSURLSessionDataTask *task =   [manager GET:( [HTShareClass shareClass].selectedBaseUrl.length > 0 ? testString : url) parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"isSuccess"] isKindOfClass:[NSString class]]) {
            !error ? : error();
            [MBProgressHUD hideHUD];
            if ([MBProgressHUD allHUDsForView:nil].count == 0) {
                [MBProgressHUD showError:@"服务器繁忙"];
                NSLog(@"SEVERerrorUrl:%@",url);
            }
            return ;
        }
        if (![responseObject[@"isSuccess"] intValue]) {
          
            !error ? : error();
            [MBProgressHUD hideHUD];
            if ([MBProgressHUD allHUDsForView:[[UIApplication sharedApplication].delegate window]].count == 0) {
                [MBProgressHUD showError:@"服务器繁忙"];
            }
            return ;
        }
         !success ? : success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         !failure ? : failure(error);
        [MBProgressHUD hideHUD];
        NSLog(@"NETerrorUrl:%@",url);
        if ([MBProgressHUD allHUDsForView:[[UIApplication sharedApplication].delegate window]].count == 0) {
            [MBProgressHUD showError:@"请检查你的网络"];
        }
        
    }];
    return task;
}

+ (void)POST:(NSString *)url params:(NSDictionary *)params success:(XMGRequestSuccess)success error:(HTRequestError) error failure:(XMGRequestFailure)failure
{
    NSMutableDictionary *dict = [params mutableCopy];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *holdToke = @"";
    if ([params getStringWithKey:@"token"].length > 0) {
        holdToke = [params getStringWithKey:@"token"];
    }
    [dict setObject:[SecurityUtil encryptAESData:[NSString stringWithFormat:@"%.0f",a]] forKey:@"token"];
    
    if ([[HTShareClass shareClass].loginId length] > 0 && [dict getStringWithKey:@"loginId"].length == 0) {
        [dict setObject:[HTShareClass shareClass].loginId forKey:@"loginId"];
    }
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if ([HTShareClass shareClass].isShowAliCode) {
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        manager.securityPolicy.allowInvalidCertificates = YES;
        [manager.securityPolicy setValidatesDomainName:NO];
    }else{
//        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
  
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer  = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"APPRequest-IOS" forHTTPHeaderField:@"X-Requested-With"];
//    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    if (holdToke.length > 0) {
        [manager.requestSerializer setValue:holdToke forHTTPHeaderField:@"token"];
    }
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",
                                         [HTShareClass shareClass].loginId.length > 0  ?
                                         [HTShareClass shareClass].loginId  : @"-1"]
                     forHTTPHeaderField:@"App-Login-Id"];
    
    
    #ifndef __OPTIMIZE__
    manager.requestSerializer.timeoutInterval = 200.f;
    #else
    //这里执行的是release模式下
    manager.requestSerializer.timeoutInterval = 20.f;
   #endif
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    
    NSDictionary *param = [NSDictionary dictionaryWithDictionary:dict];
    NSMutableString *testString = [NSMutableString stringWithString:url];
    if ([HTShareClass shareClass].selectedBaseUrl.length > 0 ) {
        
        [testString replaceCharactersInRange:NSMakeRange(0,baseUrl.length ) withString:[HTShareClass shareClass].selectedBaseUrl];
    }
    [manager POST:( [HTShareClass shareClass].selectedBaseUrl.length > 0 ? testString : url) parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"isSuccess"] isKindOfClass:[NSString class]]) {
            !error ? : error();
            return ;
        }
        if (![responseObject[@"isSuccess"] intValue]) {
            !error ? : error();
            NSLog(@"SEVERerrorUrl:%@",url);
            return ;
        }
         !success ? : success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         !failure ? : failure(error);
        NSLog(@"NETerrorUrl:%@",url);
    }];
    
}
+ (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"ip" ofType:@"cer"];//证书的路径
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
    return nil;
}
+ (void)POSTData:(NSString *)url params:(NSDictionary *)params formData:(formData)formDATA success:(XMGRequestSuccess)success error:(HTRequestError)error failure:(XMGRequestFailure)failure
{
    NSMutableDictionary *dict = [params mutableCopy];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    [dict setObject:[SecurityUtil encryptAESData:[NSString stringWithFormat:@"%.0f",a]] forKey:@"token"];
    
    if ([[HTShareClass shareClass].loginId length] > 0) {
        [dict setObject:[HTShareClass shareClass].loginId forKey:@"loginId"];
    }
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if ([HTShareClass shareClass].isShowAliCode) {
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        manager.securityPolicy.allowInvalidCertificates = YES;
        [manager.securityPolicy setValidatesDomainName:NO];
    }else{
//        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer  = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"APPRequest-IOS" forHTTPHeaderField:@"X-Requested-With"];
    //    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",
                                         [HTShareClass shareClass].loginId.length > 0  ?
                                         [HTShareClass shareClass].loginId  : @"-1"]
                     forHTTPHeaderField:@"App-Login-Id"];
    
    
#ifndef __OPTIMIZE__
    manager.requestSerializer.timeoutInterval = 200.f;
#else
    //这里执行的是release模式下
    manager.requestSerializer.timeoutInterval = 20.f;
#endif
    
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    
    NSDictionary *param = [NSDictionary dictionaryWithDictionary:dict];
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        formDATA(formData);
    }  progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"isSuccess"] isKindOfClass:[NSString class]]) {
            //            [MBProgressHUD showError:@"服务器繁忙"];
            !error ? : error();
            return ;
        }
        if (![responseObject[@"isSuccess"] intValue]) {
            //            [MBProgressHUD showError:@"服务器繁忙"];
            !error ? : error();
            NSLog(@"SEVERerrorUrl:%@",url);
            return ;
        }
        !success ? : success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !failure ? : failure(error);
        NSLog(@"NETerrorUrl:%@",url);
    }];
    
}
+(void)downLoadUrl:(NSString *)url success:(XMGRequestSuccess)success error:(HTRequestError)error failure:(XMGRequestFailure)failure WithlastName:(NSString *)lastName{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //下载文件
    /*
     第一个参数:请求对象
     第二个参数:progress 进度回调
     第三个参数:destination 回调(目标位置)
     有返回值
     targetPath:临时文件路径
     response:响应头信息
     第四个参数:completionHandler 下载完成后的回调
     filePath:最终的文件路径
     */
    NSURLSessionDownloadTask *download = [manager downloadTaskWithRequest:request
                                                                 progress:^(NSProgress * _Nonnull downloadProgress) {
                                                                     //下载进度
                                                                     NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
                                                                 }
                                                              destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                                                  //保存的文件路径
                                                                  NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:lastName];
                                                                  
                                                                  return [NSURL fileURLWithPath:fullPath];
                                                                  
                                                              }
                                                        completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                                            if (response) {
                                                                if (success) {
                                                                    success(@{
                                                                              @"file":filePath
                                                                              });
                                                                }
                                                            }
                                                            if (error) {
                                                                failure(error);
                                                            }
                                                            
                                                            NSLog(@"%@",filePath);
                                                        }];
    
    //执行Task
    [download resume];
}


+ (void)SOAPData:(NSString *)url soapBody:(NSString *)soapBody success:(void (^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    
    GDataXMLElement *rootElement = [GDataXMLNode elementWithName:@"api"];
    
    GDataXMLElement *codeElement = [GDataXMLNode elementWithName:@"code" stringValue:@"1"];
    
    GDataXMLElement *parmsElement = [GDataXMLNode elementWithName:@"params"];
    
    GDataXMLElement *nameElement = [GDataXMLNode elementWithName:@"name" stringValue:@"颜家东"];
    GDataXMLElement *ageElement = [GDataXMLNode elementWithName:@"age" stringValue:@"18"];
    GDataXMLElement *birElement = [GDataXMLNode elementWithName:@"birthday" stringValue:@"2018-5-8"];
    [parmsElement addChild:nameElement];
    [parmsElement addChild:ageElement];
    [parmsElement addChild:birElement];
    
    [rootElement addChild:codeElement];
    [rootElement addChild:parmsElement];
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithRootElement:rootElement];
    NSData *data1 = [xmlDoc XMLData];
    NSString *xmlString = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
//    NSData *xmlData = [NSPropertyListSerialization dataFromPropertyList:@{
//                                                                          @"api":@{
//                                                                                  @"code":@"1",
//                                                                                  @"params":@{
//                                                                                          @"name":@"颜家东",
//                                                                                          @"age":@"18",
//                                                                                          @"birthday":@"2018-5-8"
//                                                                                          }
//                                                                                  },
//
//                                                                          }
//                                                                 format:NSPropertyListXMLFormat_v1_0
//                                                       errorDescription:NULL];
//
//    //Data转换为NSString输出 编码为UTF-8
//
//    NSString *soapStr = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // 设置请求超时时间
    manager.requestSerializer.timeoutInterval = 30;
    
    // 返回NSData
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 设置请求头，也可以不设置
    [manager.requestSerializer setValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%zd", xmlString.length] forHTTPHeaderField:@"Content-Length"];
    // 设置HTTPBody
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return xmlString;
    }];
    [manager POST:url parameters:xmlString progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
  
}
@end
