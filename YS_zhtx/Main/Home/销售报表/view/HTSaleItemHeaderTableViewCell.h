//
//  HTSaleItemHeaderTableViewCell.h
//  YS_zhtx
//
//  Created by mac on 2019/2/26.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTSaleItemMode.h"
@interface HTSaleItemHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImv;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *redPointBtn;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) HTSaleItemMode *model;
@property (nonatomic, assign) BOOL hideRedPoint;
@end
