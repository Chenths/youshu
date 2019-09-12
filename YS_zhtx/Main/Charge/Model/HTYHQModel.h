//
//  HTYHQModel.h
//  YS_zhtx
//
//  Created by mac on 2019/8/23.
//  Copyright © 2019 有术-新零售. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTYHQModel : NSObject
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) double discount;
@property (nonatomic, assign) double cashTicketAmt;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *detail;
//@property (nonatomic, strong) NSString *startDate;
//@property (nonatomic, strong) NSString *expireDate;
@property (nonatomic, strong) NSString *expireDateString;
@property (nonatomic, assign) NSInteger cardTemplateId;

@end

NS_ASSUME_NONNULL_END
