//
//  HTCompanyListModel.h
//  有术
//
//  Created by mac on 2018/4/20.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTCompanyListModel : NSObject
@property (nonatomic,strong) NSString *companyId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) BOOL isSelected;

@end
