//
//  HTChooseCustomerViewController.h
//  YS_zhtx
//
//  Created by mac on 2019/1/10.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import "HTCommonViewController.h"
#import "HTCustomerListModel.h"
@protocol HTChooseCustomerDelegate <NSObject>
- (void)sendDic:(NSDictionary *)dic WithModel:(HTCustomerListModel *)model; //声明协议方法
@end
@interface HTChooseCustomerViewController : HTCommonViewController
@property (nonatomic, weak) id<HTChooseCustomerDelegate> delegate;
@end
