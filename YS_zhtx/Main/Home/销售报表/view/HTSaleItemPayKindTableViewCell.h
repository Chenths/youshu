//
//  HTSaleItemPayKindTableViewCell.h
//  YS_zhtx
//
//  Created by mac on 2019/2/26.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTSaleItemMode.h"
@interface HTSaleItemPayKindTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *wechatPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *aliPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *rmbPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *posPayLabel;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) HTSaleItemMode *wechatModel;
@property (nonatomic, strong) HTSaleItemMode *aliPayModel;
@property (nonatomic, strong) HTSaleItemMode *RMBModel;
@property (nonatomic, strong) HTSaleItemMode *posModel;
@end
