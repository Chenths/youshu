//
//  HTNewVipBaseInfoCell.m
//  有术
//
//  Created by mac on 2017/11/2.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import "HTNewVipBaseInfoCell.h"
@interface HTNewVipBaseInfoCell()

@property (weak, nonatomic) IBOutlet UILabel *totleBuyMoney;

@property (weak, nonatomic) IBOutlet UILabel *storeMonye;

@property (weak, nonatomic) IBOutlet UILabel *integralLabel;

@property (weak, nonatomic) IBOutlet UILabel *storeSendmoney;

@property (weak, nonatomic) IBOutlet UILabel *title1;

@property (weak, nonatomic) IBOutlet UILabel *title2;

@property (weak, nonatomic) IBOutlet UILabel *title3;

@property (weak, nonatomic) IBOutlet UIView *backView1;

@property (weak, nonatomic) IBOutlet UIView *back2;
@property (weak, nonatomic) IBOutlet UIView *line2;

@property (weak, nonatomic) IBOutlet UIView *back3;
@property (weak, nonatomic) IBOutlet UIView *line1;

@end

@implementation HTNewVipBaseInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
//- (void)setModel:(HTSingleVipDataModel *)model{
//    _model = model;
//    NSDictionary *baseDic = model.baseMessage;
//    NSDictionary *saleDic = model.saleMessage;
//    self.storeMonye.text = [baseDic getStringWithKey:@"store"];
//    self.integralLabel.text = [baseDic getStringWithKey:@"points"].length == 0 ?  @"0" :[baseDic getStringWithKey:@"points"] ;
//     self.totleBuyMoney.text = [saleDic getStringWithKey:@"finalprice"].length == 0 ? @"暂无数据" : [saleDic getStringWithKey:@"finalprice"];
//}
-(void)setModel:(HTCustomerReprotSaleMsgModel *)model{
    _model = model;
    self.storeMonye.text = [HTHoldNullObj getValueWithUnCheakValue:model.store];
    self.integralLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.points];
    self.storeSendmoney.text = [HTHoldNullObj getValueWithUnCheakValue:model.givestore];
    self.totleBuyMoney.text = [HTHoldNullObj getValueWithUnCheakValue:model.finalprice];
}
-(void)changeStyleWithBool:(BOOL) isol{
    if (isol) {
        self.totleBuyMoney.textColor = [UIColor colorWithHexString:@"333333"];
        self.storeMonye.textColor = [UIColor colorWithHexString:@"333333"];
        self.integralLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.title1.textColor = [UIColor colorWithHexString:@"999999"];
        self.title2.textColor = [UIColor colorWithHexString:@"999999"];
        self.title3.textColor = [UIColor colorWithHexString:@"999999"];
        
        self.back2.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
        self.backView1.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
        self.back3.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
        
        self.line1.backgroundColor = [UIColor colorWithHexString:@"E96E50"];
        self.line1.backgroundColor = [UIColor colorWithHexString:@"E96E50"];
        self.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
        
    }else{
        self.totleBuyMoney.textColor = [UIColor colorWithHexString:@"f1f1f1"];
        self.storeMonye.textColor = [UIColor colorWithHexString:@"f1f1f1"];
        self.integralLabel.textColor = [UIColor colorWithHexString:@"f1f1f1"];
        self.title1.textColor = [UIColor colorWithHexString:@"#FFCFC3"];
        self.title2.textColor = [UIColor colorWithHexString:@"#FFCFC3"];
        self.title3.textColor = [UIColor colorWithHexString:@"#FFCFC3"];
        
        self.back2.backgroundColor = [UIColor colorWithHexString:@"#DD5938"];
        self.backView1.backgroundColor = [UIColor colorWithHexString:@"#DD5938"];
        self.back3.backgroundColor = [UIColor colorWithHexString:@"#DD5938"];
        
        self.line1.backgroundColor = [UIColor colorWithHexString:@"#E96F50"];
        self.line1.backgroundColor = [UIColor colorWithHexString:@"#E96F50"];
        self.backgroundColor = [UIColor colorWithHexString:@"#DD5938"];
    }
}

-(void)setIsPush:(BOOL)isPush{
    _isPush = isPush;
    [self changeStyleWithBool:isPush];
}
@end
