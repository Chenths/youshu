//
//  YHHomePageViewController.h
//  YouShu
//
//  Created by FengYiHao on 2018/3/14.
//  Copyright © 2018年 成都志汇天下网络科技有限公司 版权所有. All rights reserved.
//

#import "HTCommonViewController.h"

@interface HTHomePageViewController : HTCommonViewController

@property (nonatomic,assign) BOOL isBoss;

@property (nonatomic,strong) NSString *companyId;

@property (nonatomic,strong) NSString *companyName;


-(void)loadWarning;

@end
