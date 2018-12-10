//
//  HTOrderInfoViewCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/4.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTOrderOrProductState.h"
#import "HTOnlineOrderInfoViewCell.h"
#import "HTOrderProductInfoCollectionCell.h"
@interface HTOnlineOrderInfoViewCell()

@property (weak, nonatomic) IBOutlet UIButton *printBt;

@property (weak, nonatomic) IBOutlet UIButton *exchangeBt;

@property (weak, nonatomic) IBOutlet UIButton *noticeBt;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colloctionHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCollectionheight;

@property (weak, nonatomic) IBOutlet UICollectionView *col;


@property (weak, nonatomic) IBOutlet UILabel *orderNum;

@property (weak, nonatomic) IBOutlet UIImageView *orderStateImg;

@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *finallPrice;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *guideLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCount;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colLeading;


@property (weak, nonatomic) IBOutlet UIButton *startSendBt;

@property (weak, nonatomic) IBOutlet UIButton *cancelSendBt;

@property (weak, nonatomic) IBOutlet UILabel *holdTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *expressLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *holdTimeHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *holdTimeBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *holdTimeTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expressLabelHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startSendHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btBottom;


@end

@implementation HTOnlineOrderInfoViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.startSendBt changeCornerRadiusWithRadius:3];
    [self.cancelSendBt changeCornerRadiusWithRadius:3];
    [self.cancelSendBt changeBorderStyleColor:[UIColor colorWithHexString:@"222222"] withWidth:1];
    [self.startSendBt changeBorderStyleColor:[UIColor colorWithHexString:@"222222"] withWidth:1];
    [self.levelLabel changeCornerRadiusWithRadius:7.5];
    [self.levelLabel changeBorderStyleColor:[UIColor colorWithHexString:@"#999999"] withWidth:1];
    self.backgroundColor = [UIColor colorWithHexString:@"#F9F9FA"];
}

-(void)setShowImg:(BOOL)showImg{
    _showImg = showImg;
    if (showImg) {
        self.colloctionHeight.constant = 53.0f;
        self.topCollectionheight.constant = 18.0f;
    }else{
        self.colloctionHeight.constant = 0.0f;
        self.topCollectionheight.constant = 0.0f;
    }
}
-(void)setOnlineModel:(HTOnlineOrderListModel *)model{
    if ([model isKindOfClass:[HTOnlineOrderListModel class]]) {
        _onlineModel = model;
        self.orderNum.text = [HTHoldNullObj getValueWithUnCheakValue:model.name];
        self.nameLabel.text = model.custname.length == 0 ? @"散客" : [HTHoldNullObj getValueWithUnCheakValue:model.custname];
        self.levelLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.custlevel];
        if ([HTHoldNullObj getValueWithUnCheakValue:model.custlevel].length == 0) {
            self.levelLabel.hidden = YES;
        }else{
            self.levelLabel.hidden = NO;
        }
        self.finallPrice.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.finalprice]];
        self.totalPrice.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.totalprice]];
        self.productCount.text = [NSString stringWithFormat:@"共 %ld 件商品",model.productcount.integerValue];
        self.createTime.text = [NSString stringWithFormat:@"创建时间：%@",[HTHoldNullObj getValueWithUnCheakValue:model.createdate]];
        self.orderStateLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.orderstatus];
        self.orderStateImg.hidden = YES;
        if ([[HTHoldNullObj getValueWithUnCheakValue:model.orderstatus] isEqualToString:@"已支付"]) {
            self.orderStateLabel.textColor = [UIColor colorWithHexString:@"#F53434"];
        }else{
            self.orderStateLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        }
        if ([self.orderState isEqualToString:@"0"]) {
            self.holdTimeTop.constant = 0.0f;
            self.holdTimeBottom.constant = 0.0f;
            self.holdTimeHeight.constant = 0.0f;
            self.expressLabelHeight.constant = 0.0f;
            self.startSendHeight.constant = 30.0f;
            self.btBottom.constant = 10;
            self.startSendBt.hidden = NO;
            self.cancelSendBt.hidden = NO;
        }else if ([self.orderState isEqualToString:@"3"]){
            self.holdTimeTop.constant = 8.0f;
            self.holdTimeBottom.constant = 0.0f;
            self.holdTimeHeight.constant = 16.0f;
            self.expressLabelHeight.constant = 0.0f;
            self.startSendHeight.constant = 0.0f;
            self.btBottom.constant = 0.0f;
            self.startSendBt.hidden = YES;
            self.cancelSendBt.hidden = YES;
            self.holdTimeLabel.text = [NSString stringWithFormat:@"取消时间:%@",[HTHoldNullObj getValueWithUnCheakValue:model.sign_date]];
        }else if ([self.orderState isEqualToString:@"1"]){
            self.holdTimeTop.constant = 8.0f;
            self.holdTimeBottom.constant = 8.0f;
            self.holdTimeHeight.constant = 16.0f;
            self.expressLabelHeight.constant = 16.0f;
            self.startSendHeight.constant = 0.0f;
            self.btBottom.constant = 0.0f;
            self.startSendBt.hidden = YES;
            self.cancelSendBt.hidden = YES;
            self.holdTimeLabel.text = [NSString stringWithFormat:@"发货时间:%@",[HTHoldNullObj getValueWithUnCheakValue:model.send_date]];
            self.expressLabel.text = [NSString stringWithFormat:@"%@:%@",[HTHoldNullObj getValueWithUnCheakValue:model.logistics_company],[HTHoldNullObj getValueWithUnCheakValue:model.logistics_no]];
        }
    }
}
-(void)setModel:(HTOrderListModel *)model{
    if ([model isKindOfClass:[HTOrderListModel class]]) {
        _model = model;
        self.orderNum.text = [HTHoldNullObj getValueWithUnCheakValue:model.name];
        self.nameLabel.text = model.customer.length == 0 ? @"散客" : [HTHoldNullObj getValueWithUnCheakValue:model.customer];
        self.levelLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.custLevel];
        if ([HTHoldNullObj getValueWithUnCheakValue:model.custLevel].length == 0) {
            self.levelLabel.hidden = YES;
        }else{
            self.levelLabel.hidden = NO;
        }
        self.finallPrice.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.finalPrice]];
        self.totalPrice.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.totalPrice]];
        self.productCount.text = [NSString stringWithFormat:@"共 %ld 件商品",model.orderDetails.count];
        self.createTime.text = [NSString stringWithFormat:@"创建时间：%@",[HTHoldNullObj getValueWithUnCheakValue:model.createDate]];
        if ([[HTOrderOrProductState getOrderStateFormOrderString:model.orderStatus] isEqualToString:@"UNPAID"] || [[HTOrderOrProductState getOrderStateFormOrderString:model.orderStatus] isEqualToString:@"PAID"] ) {
            self.orderStateImg.hidden = YES;
            self.orderStateLabel.hidden = NO;
            self.orderStateLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.orderStatus];
        }else{
            self.orderStateImg.hidden = NO;
            self.orderStateLabel.hidden = YES;
            self.orderStateImg.image = [UIImage imageNamed:[HTOrderOrProductState getOrderStateFormOrderString:model.orderStatus]];
        }
    }
}

#pragma -mark event

- (IBAction)cancelClicekd:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelOrderClick:)]) {
        [self.delegate cancelOrderClick:self];
    }
}


- (IBAction)startSendClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(startSendOrderClick:)]) {
        [self.delegate startSendOrderClick:self];
    }
}



@end
