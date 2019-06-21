//
//  HTCustomerProductInfoNewCell.h
//  YS_zhtx
//
//  Created by mac on 2019/6/18.
//  Copyright © 2019 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTCustomerPrudcutInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface HTCustomerProductInfoNewCell : UITableViewCell
@property (nonatomic,strong) HTCustomerPrudcutInfo *model;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *nowPrice;
@property (weak, nonatomic) IBOutlet UILabel *oldPrice;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyTime;
@property (weak, nonatomic) IBOutlet UILabel *buyStore;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@end

NS_ASSUME_NONNULL_END
