//
//  HTSaleItemDetailTableViewCell.h
//  YS_zhtx
//
//  Created by mac on 2019/2/26.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTSaleItemMode.h"
@interface HTSaleItemDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImv;
@property (weak, nonatomic) IBOutlet UIImageView *rightImv;
@property (weak, nonatomic) IBOutlet UILabel *leftTitle;
@property (weak, nonatomic) IBOutlet UILabel *rightTitle;
@property (weak, nonatomic) IBOutlet UILabel *leftDetail;
@property (weak, nonatomic) IBOutlet UILabel *rightDetail;
@property (weak, nonatomic) IBOutlet UIButton *leftRedBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightRedBtn;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) HTSaleItemMode *leftModel;
@property (nonatomic, strong) HTSaleItemMode *rightModel;
@property (nonatomic, assign) BOOL hideRedPoint;
@end
