//
//  HTNewPaySellerHeaderTableViewCell.h
//  YS_zhtx
//
//  Created by mac on 2019/1/11.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTNewPaySellerHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sellerNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sellerImv1;
@property (weak, nonatomic) IBOutlet UIImageView *sellerImv2;
@property (weak, nonatomic) IBOutlet UIImageView *sellerImv3;
@property (weak, nonatomic) IBOutlet UIImageView *sellerImv4;
@property (weak, nonatomic) IBOutlet UIImageView *sellerImv5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sellerNameLabelWidth;

@end
