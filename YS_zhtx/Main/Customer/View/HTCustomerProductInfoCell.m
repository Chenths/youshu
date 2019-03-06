//
//  HTCustomerProductInfoCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/20.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTCustomerProductInfoCell.h"
#import "HTShowImg.h"
@interface  HTCustomerProductInfoCell()
@property (weak, nonatomic) IBOutlet UILabel *barcode;
@property (weak, nonatomic) IBOutlet UILabel *finallPrice;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizelabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sizeWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorWidth;
@property (weak, nonatomic) IBOutlet UIImageView *productig;

@end
@implementation HTCustomerProductInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(HTCustomerPrudcutInfo *)model{
    _model = model;
    self.barcode.text = [HTHoldNullObj getValueWithUnCheakValue:model.barcode];
    self.finallPrice.text = [NSString stringWithFormat:@"¥%@", [HTHoldNullObj getValueWithBigDecmalObj: model.finalprice]];
    self.categoryLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.name];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", [HTHoldNullObj getValueWithBigDecmalObj: model.price]];
    self.sizelabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.size];
    self.sizeWidth.constant = [[HTHoldNullObj getValueWithUnCheakValue:model.size] getStringWidhtWithHeight:16 andFont:14] + 15;
    self.colorLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.color];
    self.colorWidth.constant = [[HTHoldNullObj getValueWithUnCheakValue:model.color] getStringWidhtWithHeight:16 andFont:14] + 15;
    self.discountLabel.text = [NSString stringWithFormat:@"%@" ,model.discount.floatValue == 0 ? @"0折" : _model.discount.floatValue < 0 ? @"／折" : [NSString stringWithFormat:@"%.1lf折",[HTHoldNullObj getValueWithUnCheakValue:model.discount].floatValue * 10]];
    self.dateLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.buytime];
    
    [self.productig sd_setImageWithURL:[NSURL URLWithString:model.productimage] placeholderImage:[UIImage imageNamed:PRODUCTHOLDIMG]];
    
    self.productig.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.productig addGestureRecognizer:tap];
}

- (void)tapAction{
    [HTShowImg showSingleBigImvWithImg:nil WithUrlStr:_model.productimage];
}

@end
