//
//  HTFastProductViewCell.h
//  有术
//
//  Created by mac on 2018/5/15.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTFastPrudoctModel.h"
#import "HTCahargeProductModel.h"
#import <UIKit/UIKit.h>

@interface HTFastProductViewCell : UITableViewCell
@property (nonatomic,strong) HTFastPrudoctModel *model;
@property (nonatomic,strong) NSIndexPath *index;

@property (nonatomic,strong) HTCahargeProductModel *productModel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImg;
@end
