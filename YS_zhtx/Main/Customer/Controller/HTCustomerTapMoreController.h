//
//  HTCustomerTapMoreController.h
//  有术
//
//  Created by mac on 2017/12/20.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import "HTCustomerListModel.h"
#import "HTCommonViewController.h"

@protocol HTCustomerTapMoreControllerDelegate

- (void) didTapWithString:(NSString *)tapKey andIndex:(NSInteger) index;


@end


@interface HTCustomerTapMoreController : HTCommonViewController

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,strong)  HTCustomerListModel *model;

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,weak) id <HTCustomerTapMoreControllerDelegate> delegate;

@end
