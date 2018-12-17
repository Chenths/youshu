//
//  HTMessgeTableViewCell.h
//  24小助理
//
//  Created by mac on 16/9/13.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//
#import "HTMessgeModel.h"
#import <UIKit/UIKit.h>

@interface HTMessgeTableViewCell : UITableViewCell

@property (nonatomic,strong) HTMessgeModel *model;

@property (weak, nonatomic) IBOutlet UIView *readView;

@end
