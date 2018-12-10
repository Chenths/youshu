//
//  HTPrintTableViewCell.h
//  24小助理
//
//  Created by mac on 16/8/31.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//
typedef void(^Reload)();
#import <UIKit/UIKit.h>

@interface HTPrintTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *printLabel;

@property (weak, nonatomic) IBOutlet UIButton *deleltBt;


@property (weak, nonatomic) IBOutlet UIButton *setBt;

@property (nonatomic,strong) NSDictionary * dataDic;

@property (nonatomic,copy) Reload reload;



@end
