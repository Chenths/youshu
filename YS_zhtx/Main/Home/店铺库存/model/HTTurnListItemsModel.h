//
//  HTTurnListItemsModel.h
//  YS_zhtx
//
//  Created by mac on 2018/9/18.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTurnListItemsModel : NSObject
//出货公司
@property (nonatomic,strong) NSString *swapCompanyName;
//签收人
@property (nonatomic,strong) NSString *signUserName;
//操作日期
@property (nonatomic,strong) NSString *swapDate;
//调货单号
@property (nonatomic,strong) NSString *swapProductOrderNo;
//发起人
@property (nonatomic,strong) NSString *swapUserName;
//总件数
@property (nonatomic,strong) NSString *swapTotalCount;

//noticeId
@property (nonatomic,strong) NSString *noticeId;
//
@property (nonatomic,strong) NSString *barcode;


@end
