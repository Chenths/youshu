//
//  HTOrderImgsCollectionCell.h
//  有术
//
//  Created by mac on 2018/5/22.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTOrderDetailModel.h"
#import <UIKit/UIKit.h>

@interface HTOrderImgsCollectionCell : UITableViewCell

@property (nonatomic,strong) NSArray *dataArr;

@property (nonatomic,strong) HTOrderDetailModel *model;

@end
