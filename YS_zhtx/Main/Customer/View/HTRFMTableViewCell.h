//
//  HTRFMTableViewCell.h
//  YS_zhtx
//
//  Created by mac on 2019/1/28.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTCustRFMMeaasge.h"
@interface HTRFMTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *left1;
@property (weak, nonatomic) IBOutlet UILabel *left2;
@property (weak, nonatomic) IBOutlet UILabel *left3;
@property (weak, nonatomic) IBOutlet UILabel *right1;
@property (weak, nonatomic) IBOutlet UILabel *right2;
@property (weak, nonatomic) IBOutlet UILabel *right3;
@property (nonatomic, strong) HTCustRFMMeaasge *model;
@end
