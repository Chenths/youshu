//
//  HTNewCustomCustomerCell.m
//  有术
//
//  Created by mac on 2017/12/19.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import "HTNewCustomCustomerCell.h"
@interface HTNewCustomCustomerCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLAbel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImg;
@property (weak, nonatomic) IBOutlet UILabel *phoneLable;
@property (weak, nonatomic) IBOutlet UILabel *birthLabel;
@property (weak, nonatomic) IBOutlet UILabel *custLevelBt;
@property (weak, nonatomic) IBOutlet UIView *custLevelBack;

@end
@implementation HTNewCustomCustomerCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.custLevelBack.layer.masksToBounds = YES;
    self.custLevelBack.layer.cornerRadius = self.custLevelBack.height / 2;
    self.custLevelBack.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    self.custLevelBack.layer.borderWidth = 1;
    
    [self.headImg changeCornerRadiusWithRadius:self.headImg.height / 2];
    
}
- (void)setDataDic:(NSDictionary *)dataDic{
    
    _dataDic = dataDic;
    NSDictionary *headers = [dataDic getDictionArrayWithKey:@"header"];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[headers getStringWithKey:@"fullPath"]] placeholderImage:[UIImage imageNamed:@"g-customerholdImg"]];
    NSString *phone = [dataDic getStringWithKey:@"phone_cust"];
    self.phoneLable.text = [NSString stringWithFormat:@"%@",phone];
    NSString *name = [dataDic getStringWithKey:@"nickname_cust"];
    self.nameLAbel.text =  [NSString stringWithFormat:@"%@",name].length == 0 ? @"未录入称呼" : [NSString stringWithFormat:@"%@",name];
    
    NSString *sex = [dataDic getStringWithKey:@"sex_cust"].length == 0 ? @"nv" :[[dataDic getStringWithKey:@"sex_cust"] isEqualToString:@"女"] ? @"nv" : @"man";
    
    self.sexImg.image = [UIImage imageNamed:sex];
    
    if ([dataDic getStringWithKey:@"birthday_cust"].length >= 10) {
        NSString *birth = [[dataDic getStringWithKey:@"birthday_cust"] substringWithRange:NSMakeRange(0, 10  )];
        NSString* date;
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY"];
        
        date = [formatter stringFromDate:[NSDate date]];
        
        NSString *birthDate = [birth substringWithRange:NSMakeRange(0, 4)];
        
        NSString *m = [birth substringWithRange:NSMakeRange(5, 2)];
        
        NSString *d =  [birth substringWithRange:NSMakeRange(8, 2)];
        self.birthLabel.text = [NSString stringWithFormat:@"%ld岁(%@月%@)",(date.integerValue - birthDate.integerValue),m,d];
    }else{
        self.birthLabel.text = @"暂无数据";
    }
   
    NSDictionary *levelDic = [dataDic getDictionArrayWithKey:@"custlevel"];
    
    self.custLevelBt.text = [NSString stringWithFormat:@"%@", [levelDic getStringWithKey:@"name"].length == 0 ? @"普通会员" : [levelDic getStringWithKey:@"name"]];
    
}
-(void)setModel:(HTCustomerListModel *)model{
    _model = model;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:[UIImage imageNamed:@"g-customerholdImg"]];
    self.custLevelBt.text = [HTHoldNullObj getValueWithUnCheakValue:model.custlevel];
    self.nameLAbel.text = [HTHoldNullObj getValueWithUnCheakValue:model.name].length == 0 ? @"未录入称呼" :  [HTHoldNullObj getValueWithUnCheakValue:model.name];
    self.sexImg.image = [[HTHoldNullObj getValueWithUnCheakValue:model.sex_cust] isEqualToString:@"1"] ? [UIImage imageNamed:@"g-man"] :[UIImage imageNamed:@"g-woman"];
    self.phoneLable.text = [HTHoldNullObj getValueWithUnCheakValue:model.phone_cust];
    self.birthLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.birthday_cust];
}
- (IBAction)moreClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(moreClickedOrderWithCell:)]) {
        [self.delegate moreClickedOrderWithCell:self];
    }
}

@end
