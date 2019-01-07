//
//  HTNew1SingVipSaleBaceInfoCell.m
//  有术
//
//  Created by mac on 2017/11/6.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import "HTNew1SingVipSaleBaceInfoCell.h"

@interface HTNew1SingVipSaleBaceInfoCell()

/**
 件单价
 */
@property (weak, nonatomic) IBOutlet UILabel *jiandanjiaLabel;

/**
 客单价
 */
@property (weak, nonatomic) IBOutlet UILabel *kedanjiaLabel;

/**
 折扣率
 */
@property (weak, nonatomic) IBOutlet UILabel *discount;

/**
 连带率
 */
@property (weak, nonatomic) IBOutlet UILabel *serauilLabel;

/**
 消费次数
 */
@property (weak, nonatomic) IBOutlet UILabel *buyTimesLabel;
/**
 共计件数
 */
@property (weak, nonatomic) IBOutlet UILabel *totleNumsLabel;


@property (weak, nonatomic) IBOutlet UIView *buyNumsView;

@property (weak, nonatomic) IBOutlet UIView *saleProductNumsView;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *buyPurchaseLabel;


@property (unsafe_unretained, nonatomic) IBOutlet UILabel *birthLabel;

/**
 加入时间
 */
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
/**
 几天未消费
 */
@property (weak, nonatomic) IBOutlet UILabel *notComeTimeLabe;

//爱好
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *hobbyLabel;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet UITextView *tipTextView;



@end

@implementation HTNew1SingVipSaleBaceInfoCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.buyNumsView.userInteractionEnabled = YES;
    self.saleProductNumsView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buyNumsClicked:)];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buyProductNumsClicked:)];
    [self.buyNumsView addGestureRecognizer:tap];
    [self.saleProductNumsView addGestureRecognizer:tap1];
}
-(void)setModel:(HTCustomerReprotSaleMsgModel *)model{
    _model = model;
    self.jiandanjiaLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.unitprice].length == 0 ? @"暂无数据" : [HTHoldNullObj getValueWithUnCheakValue:model.unitprice];
    self.kedanjiaLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.avgprice].length == 0 ? @"暂无数据" : [HTHoldNullObj getValueWithUnCheakValue:model.avgprice];
    self.discount.text  = [HTHoldNullObj getValueWithUnCheakValue:model.avgdiscount].length == 0 ? @"/" : [HTHoldNullObj getValueWithUnCheakValue:model.avgdiscount];
    self.serauilLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.ralt].length == 0 ? @"暂无数据" :  [HTHoldNullObj getValueWithUnCheakValue:model.ralt];
    self.buyTimesLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.ordercount].length == 0 ? @"暂无数据" : [HTHoldNullObj getValueWithUnCheakValue:model.ordercount];
    self.totleNumsLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.salevolume].length == 0 ? @"暂无数据" : [HTHoldNullObj getValueWithUnCheakValue:model.salevolume];
    self.birthLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.birthday].length == 0 ? @"暂无数据" : [HTHoldNullObj getValueWithUnCheakValue:model.birthday];
    self.createTimeLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.createdate].length == 0 ? @"暂无数据" : [HTHoldNullObj getValueWithUnCheakValue:model.createdate];
    self.buyPurchaseLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.buyralt].length == 0 ?  @"暂无数据" : [HTHoldNullObj getValueWithUnCheakValue:model.buyralt];
    self.notComeTimeLabe.text = [HTHoldNullObj getValueWithUnCheakValue:model.day].length == 0 ? @"暂无数据" : [HTHoldNullObj getValueWithUnCheakValue:model.day];
    self.hobbyLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.hobby].length == 0 ? @"暂无数据" : [HTHoldNullObj getValueWithUnCheakValue:model.hobby];
    self.heightLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.height].length == 0 ? @"暂无数据" : [HTHoldNullObj getValueWithUnCheakValue:model.height];
    self.heightLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.height].length == 0 ? @"暂无数据" : [HTHoldNullObj getValueWithUnCheakValue:model.height];
    self.tipTextView.text = [HTHoldNullObj getValueWithUnCheakValue:model.remark].length == 0 ? @"暂无数据" : [HTHoldNullObj getValueWithUnCheakValue:model.remark];
}

//- (void)setModel:(HTSingleVipDataModel *)model{
//    _model = model;
//    NSDictionary *saleDic =  model.saleMessage;
//    NSDictionary *baseDic = model.baseMessage;
//    self.jiandanjiaLabel.text =  [saleDic getStringWithKey:@"unitprice"].length == 0 ? @"暂无数据 ":[saleDic getStringWithKey:@"unitprice"];
//    self.kedanjiaLabel.text = [saleDic getStringWithKey:@"avgprice"].length == 0 ? @"暂无数据" :[saleDic getStringWithKey:@"avgprice"];
//    self.discount.text = [saleDic getStringWithKey:@"avgdiscount"].length == 0 ? @"/" :[saleDic getStringWithKey:@"avgdiscount"];
//    self.serauilLabel.text = [saleDic getStringWithKey:@"ralt"].length == 0 ? @"/" :[saleDic getStringWithKey:@"ralt"];
//    self.buyTimesLabel.text = [saleDic getStringWithKey:@"ordercount"].length == 0 ? @"暂无数据" : [saleDic getStringWithKey:@"ordercount"];
//    self.totleNumsLabel.text = [saleDic getStringWithKey:@"salevolume"].length == 0 ? @"暂无数据":[saleDic getStringWithKey:@"salevolume"];
//    self.birthLabel.text = [baseDic getStringWithKey:@"birthday"];
//    self.heightLabel.text = [baseDic getStringWithKey:@"creator"].length == 0 ? @"暂无数据" : [baseDic getStringWithKey:@"creator"];
//    self.hobbyLabel.text = [baseDic getStringWithKey:@"hobby"].length == 0 ? @"暂无数据" :[baseDic getStringWithKey:@"hobby"];
//    self.createTimeLabel.text = [baseDic getStringWithKey:@"createdate"];
//    self.notComeTimeLabe.text = [saleDic getStringWithKey:@"day"].length == 0 ? @"暂无数据" : [saleDic getStringWithKey:@"day"] ;
//    self.buyPurchaseLabel.text = @"暂无数据";
//}
- (void)buyNumsClicked:(UITapGestureRecognizer *)tap{
    if (self.delegate && ([self.delegate respondsToSelector:@selector(buyNumsClicked)])) {
        [self.delegate buyNumsClicked];
    }
    
}
- (void)buyProductNumsClicked:(UITapGestureRecognizer *)tap{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(buyProductNumsClicked)]) {
        [self.delegate buyProductNumsClicked];
    }
}

@end
