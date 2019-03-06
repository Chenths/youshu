//
//  HTCustomerOrderInfoCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/20.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#define imgWidth 48
#define space 8
#import "HTCustomerOrderInfoCell.h"
#import "HTOrderOrProductState.h"
#import "HTShowImg.h"
@interface HTCustomerOrderInfoCell()

@property (weak, nonatomic) IBOutlet UIButton *printBt;

@property (weak, nonatomic) IBOutlet UIButton *exchangeBt;

@property (weak, nonatomic) IBOutlet UIButton *noticeBt;
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *orderType;
@property (weak, nonatomic) IBOutlet UILabel *orderState;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *editTime;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *productCount;
@property (weak, nonatomic) IBOutlet UILabel *guiderName;
@property (weak, nonatomic) IBOutlet UILabel *points;
@property (weak, nonatomic) IBOutlet UILabel *ischange;
@property (weak, nonatomic) IBOutlet UILabel *payType;
@property (weak, nonatomic) IBOutlet UIScrollView *productBack;

@end

@implementation HTCustomerOrderInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.printBt changeCornerRadiusWithRadius:3];
    [self.exchangeBt changeCornerRadiusWithRadius:3];
    [self.noticeBt changeCornerRadiusWithRadius:3];
    [self.noticeBt changeBorderStyleColor:[UIColor colorWithHexString:@"222222"] withWidth:1];
    [self.exchangeBt changeBorderStyleColor:[UIColor colorWithHexString:@"222222"] withWidth:1];
    [self.printBt changeBorderStyleColor:[UIColor colorWithHexString:@"222222"] withWidth:1];
}
-(void)setModel:(HTOrderListModel *)model{
    if (model == _model) {
        return;
    }
    _model = model;
    for (UIView *vvv in self.productBack.subviews) {
        [vvv removeFromSuperview];
    }
    self.orderNum.text = [NSString stringWithFormat:@"订单号:%@",[HTHoldNullObj getValueWithUnCheakValue:model.name]];
    self.orderState.text = [HTHoldNullObj getValueWithUnCheakValue:model.orderStatus];
    self.orderType.text = [HTHoldNullObj getValueWithUnCheakValue:model.ordertype];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.finalPrice]];
    self.totalPrice.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.totalPrice]];
    self.createTime.text = [HTHoldNullObj getValueWithUnCheakValue:model.createDate];
    self.editTime.text = [HTHoldNullObj getValueWithUnCheakValue:model.edit_date];
    self.productCount.text = [NSString stringWithFormat:@"%ld件",model.orderDetails.count];
    self.guiderName.text = [HTHoldNullObj getValueWithUnCheakValue:model.creator];
    self.points.text = @"0";
    self.ischange.text = [HTHoldNullObj getValueWithUnCheakValue:model.hasmodifiedprice];
    self.payType.text = [HTHoldNullObj getValueWithUnCheakValue:model.paytype];
    CGFloat btx = 0;
    for (int i = 0 ; i < model.orderDetails.count;i++) {
        HTOrderListProductModel *mmm = model.orderDetails[i];
         UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(btx, 0, imgWidth, imgWidth)];
         [image sd_setImageWithURL:[NSURL URLWithString:mmm.productImage] placeholderImage:[UIImage imageNamed:PRODUCTHOLDIMG]];
        image.userInteractionEnabled = YES;
        image.tag = 20000 + i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [image addGestureRecognizer:tap];
    
         [self.productBack addSubview:image];
         btx = btx + imgWidth + space;
        if ([[HTOrderOrProductState getProductStateFormOrderString:mmm
              .state] isEqualToString:@"NORMAL"]) {
        }else{
            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[HTOrderOrProductState getProductStateFormOrderString:mmm.state]]];
            [image addSubview:img];
            [img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(image.mas_bottom);
                make.trailing.mas_equalTo(image.mas_trailing);
            }];
            
        }
    }
    if ([[HTOrderOrProductState getOrderStateFormOrderString:model.orderStatus] isEqualToString:@"PAID"]) {
        [self.exchangeBt changeBorderStyleColor:[UIColor colorWithHexString:@"#222222"] withWidth:1];
        self.exchangeBt.backgroundColor = [UIColor whiteColor];
        self.exchangeBt.enabled = YES;
    }else{
        [self.exchangeBt changeBorderStyleColor:[UIColor colorWithHexString:@"#eeeeee"] withWidth:1];
        self.exchangeBt.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        self.exchangeBt.enabled = NO;
    }
    self.productBack.contentSize = CGSizeMake(btx + imgWidth, imgWidth);
}

- (void)tapAction:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    NSInteger index = tap.view.tag - 20000;
    HTOrderListProductModel *mmm = _model.orderDetails[index];
    [HTShowImg showSingleBigImvWithImg:nil WithUrlStr:mmm.productImage];
}

- (IBAction)printClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(printClickedWithCell:)]) {
        [self.delegate printClickedWithCell:self];
    }
}

- (IBAction)moreClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(moreClickedWithCell:)]) {
        [self.delegate moreClickedWithCell:self];
    }
}
- (IBAction)timeClicked:(id)sender {
    if (self.delegate  && [self.delegate respondsToSelector:@selector(timeClickedWithCell:)]) {
        [self.delegate timeClickedWithCell:self];
    }
}
- (IBAction)exchangeClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(exchangeClickedWithCell:)]) {
        [self.delegate exchangeClickedWithCell:self];
    }
}


@end
