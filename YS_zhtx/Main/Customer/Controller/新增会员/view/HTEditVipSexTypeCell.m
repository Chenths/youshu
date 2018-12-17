//
//  HTEditVipSexTypeCell.m
//  YS_zhtx
//
//  Created by mac on 2018/8/27.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "LPActionSheet.h"
#import "HTEditVipSexTypeCell.h"
@interface HTEditVipSexTypeCell()

@property (weak, nonatomic) IBOutlet UILabel *titileLabel;

@property (weak, nonatomic) IBOutlet UILabel *valueLable;

@end
@implementation HTEditVipSexTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCellClicked)];
    [self.contentView addGestureRecognizer:tap];
    // Initialization code
}
-(void)tapCellClicked{
    if (self.superview.superview) {
        [self.superview.superview endEditing:YES];
    }
    [LPActionSheet showActionSheetWithTitle:@"" cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@[@"男",@"女"] handler:^(LPActionSheet *actionSheet, NSInteger index) {
        if (index == 1) {
            [self.requestDic setObject:@"1" forKey:self.model.SearchKey];
            self.model.SearchValue = @"男";
            self.valueLable.text = @"男";
        }
        if (index == 2) {
            [self.requestDic setObject:@"0" forKey:self.model.SearchKey];
            self.model.SearchValue = @"女";
            self.valueLable.text = @"女";
        }
    }];
}

-(void)setModel:(HTCustEditConfigModel *)model{
    _model = model;
    self.titileLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.title];
    self.titileLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    self.valueLable.textColor = [UIColor colorWithHexString:@"#666666"];
    if (model.readOnly) {
        self.titileLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        self.valueLable.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    if (model.require) {
        self.titileLabel.textColor = [UIColor colorWithHexString:@"#FC5C7D"];
    }
}
-(void)setRequestDic:(NSMutableDictionary *)requestDic{
    _requestDic = requestDic;
    if ([[requestDic getStringWithKey:self.model.SearchKey] isEqualToString:@"1"]) {
        self.model.SearchValue = @"男";
    }else{
        self.model.SearchValue = @"女";
    }
    if ([requestDic getStringWithKey:self.model.SearchKey].length == 0) {
        self.valueLable.text = @"未添加";
    }else{
        self.valueLable.text = [HTHoldNullObj getValueWithUnCheakValue:self.model.SearchValue];
    }
}


@end
