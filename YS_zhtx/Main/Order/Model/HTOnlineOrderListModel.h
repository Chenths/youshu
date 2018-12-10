//
//  HTOnlineOrderListModel.h
//  有术
//
//  Created by mac on 2018/10/11.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTOnlineOrderListModel : NSObject
//    订单号
@property (nonatomic,strong) NSString  *name;
//客服称呼
@property (nonatomic,strong) NSString  *custname;
//头像URL
@property (nonatomic,strong) NSString  *headimg;
//    订单状态
@property (nonatomic,strong) NSString  *orderstatus;
//    会员等级
@property (nonatomic,strong) NSString  *custlevel;
//    创建时间
@property (nonatomic,strong) NSString  *createdate;
//    原价
@property (nonatomic,strong) NSString  *totalprice;
//    结算价
@property (nonatomic,strong) NSString  *finalprice;
//    商品件数
@property (nonatomic,strong) NSString  *productcount;
//发货时间
@property (nonatomic,strong) NSString  *send_date;
//取消时间
@property (nonatomic,strong) NSString  *sign_date;
//物流单号
@property (nonatomic,strong) NSString  *logistics_no;
//物流公司
@property (nonatomic,strong) NSString  *logistics_company;

@property (nonatomic,strong) NSString *orderId;

@end
