//
//  HTNewPayYHQTableViewCell.h
//  YS_zhtx
//
//  Created by mac on 2019/8/7.
//  Copyright © 2019 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface HTNewPayYHQTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *chooseImv;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellWidth;
@property (weak, nonatomic) IBOutlet UIImageView *yhqBG;
@property (weak, nonatomic) IBOutlet UILabel *kindLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lineImv;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *maskImv;
@end

NS_ASSUME_NONNULL_END
