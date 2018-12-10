//
//  HTGuiderSaleListItemCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTGuiderSaleListItemCell.h"

@interface HTGuiderSaleListItemCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *rankImg;

@property (weak, nonatomic) IBOutlet UILabel *rankLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderAndProductCount;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;


@end

@implementation HTGuiderSaleListItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(HTGuiderListModel *)model{
    _model = model;
    NSArray *imgs = @[@"rankFirst",@"rankSecond",@"rankThird"];
    if (model.index < 3) {
        self.rankImg.hidden = NO;
        self.rankLabel.hidden = YES;
        self.rankImg.image = [UIImage imageNamed:imgs[model.index]];
    }else{
        self.rankImg.hidden = YES;
        self.rankLabel.hidden = NO;
        self.rankLabel.text = [NSString stringWithFormat:@"%d",model.index + 1];
    }
    self.nameLabel.text  = [HTHoldNullObj getValueWithUnCheakValue:model.name];
    self.totalLabel.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.price]];
    self.orderAndProductCount.text = [NSString stringWithFormat:@"完成%@单 销售%@件",model.ordercount,model.salevolume];
}
@end
