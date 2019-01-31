//
//  HTNewPayGoodsTableViewCell.h
//  YS_zhtx
//
//  Created by mac on 2019/1/11.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTNewPayGoodsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsHeaderImv;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsDetail;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *oldPrice;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImv;
@property (weak, nonatomic) IBOutlet UILabel *chooseLabel;

@end
