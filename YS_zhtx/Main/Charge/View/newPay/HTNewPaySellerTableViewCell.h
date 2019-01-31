//
//  HTNewPaySellerTableViewCell.h
//  YS_zhtx
//
//  Created by mac on 2019/1/11.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTNewPaySellerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *selectImv;
@property (weak, nonatomic) IBOutlet UIImageView *headerImv;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *priceTF;
@property (weak, nonatomic) IBOutlet UITextField *biliTF;
@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UIView *biliView;
@property (weak, nonatomic) IBOutlet UILabel *zhiweiLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImvLeft;

@end
