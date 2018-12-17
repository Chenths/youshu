//
//  HTBirthdayCustomerCell.m
//  有术
//
//  Created by mac on 2018/1/26.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTBirthdayCustomerCell.h"
@interface HTBirthdayCustomerCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLAbel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImg;

@property (weak, nonatomic) IBOutlet UILabel *birthLabel;
@property (weak, nonatomic) IBOutlet UILabel *custLevelBt;
@property (weak, nonatomic) IBOutlet UIView *custLevelBack;

@property (weak, nonatomic) IBOutlet UILabel *diffDay;

@property (weak, nonatomic) IBOutlet UILabel *labellabel;


@end
@implementation HTBirthdayCustomerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.custLevelBack.layer.masksToBounds = YES;
    self.custLevelBack.layer.cornerRadius = self.custLevelBack.height / 2;
    self.custLevelBack.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    self.custLevelBack.layer.borderWidth = 1;
}

- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    self.birthLabel.text = [dataDic getStringWithKey:@"birthday"].length == 0 ? @"暂无数据":[dataDic getStringWithKey:@"birthday"];
    self.diffDay.text = [dataDic getStringWithKey:@"diffday"].length == 0 ? @"暂无数据":[dataDic getStringWithKey:@"diffday"];
    self.sexImg.image = [[dataDic getStringWithKey:@"sex"] isEqualToString:@"1"] ? [UIImage imageNamed:@"g-man"] : [UIImage imageNamed:@"g-woman"];
    self.nameLAbel.text = [dataDic getStringWithKey:@"name"].length == 0 ? @"暂无数据":[dataDic getStringWithKey:@"name"];
    self.custLevelBt.text = [dataDic getStringWithKey:@"level"].length == 0 ? @"暂无数据":[dataDic getStringWithKey:@"level"];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[dataDic getStringWithKey:@"header"]] placeholderImage:[UIImage imageNamed:@"g-customerholdImg"]];
    
}
- (void)setHtbirthType:(HTBirthTodayOrNear)htbirthType{
    _htbirthType = htbirthType;
    if (htbirthType == HTBirthToday) {
        self.diffDay.hidden = YES;
        self.labellabel.hidden = YES;
    }else{
        self.diffDay.hidden = NO;
        self.labellabel.hidden = NO;
    }
}
@end
