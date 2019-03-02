//
//  HTSaleOtherDetailTableViewCell.h
//  YS_zhtx
//
//  Created by mac on 2019/2/26.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTSaleItemMode.h"
@interface HTSaleOtherDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImv;
@property (weak, nonatomic) IBOutlet UIImageView *rightImv;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftRedBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightRedBtn;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) HTSaleItemMode *leftModel;
@property (nonatomic, strong) HTSaleItemMode *rightModel;
@property (nonatomic, assign) BOOL hideRedPoint;
@end
