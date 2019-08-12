//
//  HTNewCustomerBaceInfoCell.m
//  有术
//
//  Created by mac on 2018/5/16.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
//#import "HTDataCustBasetInfo.h"
//#import "HTCustCustLevel.h"
#import "HTNewCustomerBaceInfoCell.h"
@interface HTNewCustomerBaceInfoCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImg;
@property (weak, nonatomic) IBOutlet UILabel *custLevel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIView *levelBackView;
@end
@implementation HTNewCustomerBaceInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.levelBackView.layer.masksToBounds = YES;
    self.levelBackView.layer.cornerRadius = self.levelBackView.height  * 0.5;
    self.levelBackView.layer.borderWidth = 0.5;
    self.levelBackView.layer.borderColor = [UIColor colorWithHexString:@"F58F12"].CGColor;
}

//-(void)setModel:(HTDataCust *)model{
//    _model = model;
//    HTDataCustBasetInfo *info = model.custInfo;
//    self.nameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:info.nickname];
//    self.phoneLabel.text = [HTHoldNullObj getValueWithUnCheakValue:info.phone];
//    self.sexImg.image = [UIImage imageNamed: [[HTHoldNullObj getValueWithUnCheakValue:info.sex] isEqualToString:@"0"] ? @"man" : @"nv"];
//    if ([NSString stringWithFormat:@"%@",model.custlevel].length == 0) {
//    }else{
//        HTCustCustLevel *custLevel = model.custLevel;
//        self.custLevel.text = [NSString stringWithFormat:@"%@",custLevel.name ? custLevel.name : @"无"];
//    }
//}
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    self.nameLabel.text = [dataDic getStringWithKey:@"nickname_cust"];
    self.phoneLabel.text =  [dataDic getStringWithKey:@"phone_cust"];
    self.sexImg.image = [UIImage imageNamed: [[dataDic getStringWithKey:@"sex_cust"] isEqualToString:@"0"] ? @"man" : @"nv"];
    if ([[dataDic getDictionArrayWithKey:@"levelname"] getStringWithKey:@"name"].length == 0) {
    }else{
        self.custLevel.text = [[[dataDic getDictionArrayWithKey:@"levelname"] getStringWithKey:@"name"] length ] == 0 ? @"无" :[[dataDic getDictionArrayWithKey:@"levelname"] getStringWithKey:@"name"];
    }
}

- (void)setModel:(HTOrderDetailModel *)model{
    _model = model;
    HTOrderCustomerModel *customer = model.customer;
    self.nameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:customer.name].length == 0 ? @"未录入称呼":[HTHoldNullObj getValueWithUnCheakValue:customer.name] ;
    self.phoneLabel.text = [HTHoldNullObj getValueWithUnCheakValue:customer.phone];
    self.sexImg.image = [[HTHoldNullObj getValueWithUnCheakValue:customer.sex] isEqualToString:@"1"] ?  [UIImage imageNamed:@"g-man" ] : [UIImage imageNamed:@"g-woman" ] ;
    self.custLevel.text = customer.custlevel.length == 0 ? @"" : [HTHoldNullObj getValueWithUnCheakValue:customer.custlevel];
}

@end
