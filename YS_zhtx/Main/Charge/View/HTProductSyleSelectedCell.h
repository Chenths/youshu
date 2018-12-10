//
//  HTProductSyleSelectedCell.h
//  YS_zhtx
//
//  Created by mac on 2018/6/14.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTCahargeProductModel.h"
#import <UIKit/UIKit.h>
typedef void(^chooseStyleClick)(void);
@interface HTProductSyleSelectedCell : UITableViewCell

@property (nonatomic,strong) HTCahargeProductModel *model;

@property (nonatomic,strong) NSString *key;

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,copy) chooseStyleClick choose;

@end
