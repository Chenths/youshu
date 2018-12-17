//
//  HTBossDayRankListCell.m
//  有术
//
//  Created by mac on 2018/4/16.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTBossDayRankListCell.h"
@interface HTBossDayRankListCell()

@property (weak, nonatomic) IBOutlet UIImageView *titileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *finallPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;


@end

@implementation HTBossDayRankListCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setModel:(HTDaySaleRankModel *)model{
    _model = model;
    self.dateLabel.text = [HTHoldNullObj getValueWithUnCheakValue: model.time];
    self.finallPriceLabel.text = [NSString stringWithFormat:@"￥%@", [HTHoldNullObj getValueWithUnCheakValue:model.totalprice]];
    
    self.originalPriceLabel.text =  [NSString stringWithFormat:@"￥%@",[HTHoldNullObj getValueWithUnCheakValue:model.finalprice]];
    self.nameLabel.text =  [HTHoldNullObj getValueWithUnCheakValue:model.pname];
    self.indexLabel.text = [NSString stringWithFormat:@"%ld",model.index];
    switch (model.index) {
        case 0:
            {
            self.indexLabel.hidden = YES;
            self.titileImageView.hidden = NO;
            self.titileImageView.image = [UIImage imageNamed:@"rankFirst"];
            }
            break;
        case 1:
        {
            self.indexLabel.hidden = YES;
            self.titileImageView.hidden = NO;
            self.titileImageView.image = [UIImage imageNamed:@"rankSecond"];
        }
            break;
        case 2:
        {
            self.indexLabel.hidden = YES;
            self.titileImageView.hidden = NO;
            self.titileImageView.image = [UIImage imageNamed:@"rankThird"];
        }
            break;
        default:
        {
            self.indexLabel.hidden = NO;
            self.titileImageView.hidden = YES;
            self.indexLabel.text = [NSString stringWithFormat:@"%ld",model.index + 1];
        }
            break;
    }
}

@end
