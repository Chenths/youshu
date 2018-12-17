//
//  HTEditVipBirthTypeCell.m
//  YS_zhtx
//
//  Created by mac on 2018/8/27.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HcdDateTimePickerView.h"
#import "HTEditVipBirthTypeCell.h"
@interface HTEditVipBirthTypeCell()
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@end
@implementation HTEditVipBirthTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCellClicked)];
    [self.contentView addGestureRecognizer:tap];
}
-(void)tapCellClicked{
    if (self.superview.superview) {
        [self.superview.superview endEditing:YES];
    }
    HcdDateTimePickerView* dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000] WithIsBeteewn:NO];
    dateTimePickerView.topViewColor = [UIColor colorWithHexString:@"F8F8F8"];
    __weak typeof(self) weakSelf = self;
    dateTimePickerView.clickedOkBtn = ^(NSString *dateTimeStr) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.requestDic setObject:dateTimeStr forKey:self.model.SearchKey];
        strongSelf.valueLabel.text = dateTimeStr;
    };
    
    [[[UIApplication sharedApplication].delegate window] addSubview:dateTimePickerView];
    [dateTimePickerView showHcdDateTimePicker];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setModel:(HTCustEditConfigModel *)model{
    _model = model;
    self.titleLable.text = [HTHoldNullObj getValueWithUnCheakValue:model.title];
    self.titleLable.textColor = [UIColor colorWithHexString:@"#222222"];
    self.valueLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    if (model.readOnly) {
        self.titleLable.textColor = [UIColor colorWithHexString:@"#999999"];
        self.valueLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    if (model.require) {
        self.titleLable.textColor = [UIColor colorWithHexString:@"#FC5C7D"];
    }
}
-(void)setRequestDic:(NSMutableDictionary *)requestDic{
    _requestDic = requestDic;
    if ([requestDic getStringWithKey:self.model.SearchKey].length == 0) {
        self.valueLabel.text = @"未添加";
    }else{
        self.valueLabel.text = [requestDic getStringWithKey:self.model.SearchKey];
    }
}
@end
