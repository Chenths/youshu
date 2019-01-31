//
//  HTNewPayMixPayKindTableViewCell.h
//  YS_zhtx
//
//  Created by mac on 2019/1/11.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTNewPayMixPayKindTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImv;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//1 全部   2 不可储赠  3  不可储赠储值
@property (nonatomic, assign) NSInteger type;
@end
