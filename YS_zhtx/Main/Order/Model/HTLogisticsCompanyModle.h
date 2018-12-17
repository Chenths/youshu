//
//  HTLogisticsCompanyModle.h
//  有术
//
//  Created by mac on 2016/12/12.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTLogisticsCompanyModle : NSObject

//店铺名
@property (nonatomic,strong) NSString *companyName;
//店铺图片
@property (nonatomic,strong) NSString *companyImgUrl;
//是否选择
@property (nonatomic,assign) BOOL isSelected;
//店铺编码
@property (nonatomic,strong) NSString *companyCode;





@end
