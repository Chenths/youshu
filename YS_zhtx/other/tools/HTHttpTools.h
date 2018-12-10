//
//  HTHttpTools.h
//  shengyijing
//
//  Created by mac on 16/3/9.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//
#import "AFNetworking.h"
#import <Foundation/Foundation.h>

typedef void (^XMGRequestSuccess)(id json);
typedef void (^XMGRequestFailure)(NSError *error);
typedef void (^formData)(id <AFMultipartFormData> formData);

typedef void(^HTRequestError)(void);
@interface HTHttpTools : NSObject

+ (NSURLSessionDataTask *)GET:(NSString *)url params:(NSDictionary *)params success:(XMGRequestSuccess)success error:(HTRequestError) error failure:(XMGRequestFailure)failure;

+ (void)POST:(NSString *)url params:(NSDictionary *)params success:(XMGRequestSuccess)success error:(HTRequestError) error failure:(XMGRequestFailure)failure;

+(void)POSTData:(NSString *)url params:(NSDictionary *)params formData:(formData) formData success:(XMGRequestSuccess)success error:(HTRequestError) error failure:(XMGRequestFailure)failure;

+(void)downLoadUrl:(NSString *)url success:(XMGRequestSuccess)success error:(HTRequestError)error failure:(XMGRequestFailure)failure WithlastName:(NSString *)lastName;

+ (void)XMLPOST:(NSString *)url params:(NSDictionary *)params success:(XMGRequestSuccess)success error:(HTRequestError) error failure:(XMGRequestFailure)failure;

+ (void)SOAPData:(NSString *)url soapBody:(NSString *)soapBody success:(void (^)(id responseObject))success failure:(void(^)(NSError *error))failure ;

@end
