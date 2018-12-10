//
//  HTCreatorListViewController.h
//  YS_zhtx
//
//  Created by mac on 2018/8/8.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
typedef void(^DIDSELECTEDITME)(NSDictionary *dic);
#import "HTCommonViewController.h"


@interface HTCreatorListViewController : HTCommonViewController

@property (nonatomic,copy) DIDSELECTEDITME selecedItme;

@end
